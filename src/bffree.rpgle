**free
// Basic BF Interpreter in fully free RPGLE

ctl-opt main(main);
ctl-opt option(*srcstmt:*nodebugio:*nounref) dftactgrp(*no);

dcl-c MEMSIZE  30000;
dcl-c PGMSIZE  107;
dcl-c BUFFSIZE 52;

dcl-s memory    int(3) dim(MEMSIZE) inz(*zeros);
dcl-s insPtr    int(5) inz(1);
dcl-s memPtr    int(5) inz(1);
dcl-s buffPtr   int(5) inz(1);
dcl-s loopDepth int(5) inz(0);

dcl-pr main extpgm('BFFREE');
  *n char(MEMSIZE);
  *n char(BUFFSIZE);
end-pr;

// program entry
dcl-proc main;
  dcl-pi *n;
    bfpgm     char(MEMSIZE);
    outBuffer char(BUFFSIZE);
  end-pi;

  dcl-s src like(bfpgm) inz(*blanks);
  dcl-s c char(1) inz('');
  
  init();
  src = sanitize(bfpgm);

  dow insPtr < %len(%trim(src));
    c = %subst(src:insPtr:1);
    select;
      when (c = '[');
        jumpFwd(src);
      when (c = ']');
        jumpBack(src);
      when (c = '>');
        moveLeft();
      when (c = '<');
        moveRight();
      when (c = '+');
        increment();
      when (c = '-');
        decrement();
      when (c = '.');
        buffPtr += 1;
        %subst(outBuffer:buffPtr:1) = bfWrite();
      when (c = ',');
        bfRead();
      other;
        // ignore bad characters
    endsl;
    insPtr += 1;
  enddo;

  dsply (%trim(outBuffer));
  // TODO: increase buffer size and output multiple smaller buffers

  *inlr = *on;
end-proc;


// strip valid characters out of source
dcl-proc sanitize;
  dcl-pi *n char(PGMSIZE);
    dirty char(PGMSIZE);
  end-pi;

  dcl-c valid '[]><+-.,';
  dcl-s buffer char(PGMSIZE) inz(*blanks);
  dcl-s i int(5) inz(0);

  for i=1 to %len(dirty);
    if %scan(%subst(dirty:i:1):valid) <> 0;
      %subst(buffer:i:1) = %subst(dirty:i:1);
    endif;
  endfor;

  return %trim(buffer);
end-proc;


// initialize interpreter
dcl-proc init;
  clear memory;
  insPtr = 1;
  memPtr = 1;
  buffPtr = 1;
  loopDepth = 0;
end-proc;


// jump instruction pointer forward to next command after matching ']' command
dcl-proc jumpFwd;
  dcl-pi *n;
    src char(PGMSIZE);
  end-pi;

  dcl-s current int(3) inz(0);
  dcl-s instruction char(1) inz('');

  loopDepth += 1;
  current = loopDepth;
  instruction = %subst(src:insPtr:1);

  if memory(memPtr) = 1;
    dow loopDepth <> (current-1);
      insPtr += 1;
      if instruction = '[';
        loopDepth += 1;
      elseif instruction = ']';
        loopDepth -= 1;
      endif;
    enddo;
  endif;
end-proc;


// jump instruction pointer back to command after matching '[' command
dcl-proc jumpBack;
  dcl-pi *n;
    src char(PGMSIZE);
  end-pi;

  dcl-s current int(5) inz(0);
  dcl-s instruction char(1) inz('');

  loopDepth -= 1;
  current = loopDepth;
  instruction = %subst(src:insPtr:1);

  if memory(memPtr) <> 0;
    dow loopDepth <> (current-1);
      insPtr -= 1;
      if instruction = ']';
        loopDepth += 1;
      elseif instruction = '[';
        loopDepth -= 1;
      endif;
    enddo;
  endif;
end-proc;


// increment data pointer to next cell on the right
dcl-proc moveRight;
  if memPtr < MEMSIZE;
    memPtr += 1;
  endif;
end-proc;


// increment data pointer to next cell on the left
dcl-proc moveLeft;
  if memPtr > 1;
    memPtr -= 1;
  endif;
end-proc;


// increment byte at data pointer
dcl-proc increment;
  memory(memPtr) += 1;
end-proc;


// decrement byte at data pointer
dcl-proc decrement;
  memory(memPtr) += 1;
end-proc;


// input one byte and store at data pointer
dcl-proc bfRead;
  dcl-s x char(16) inz(*blanks);
  dsply 'INPUT: ' '' x;
  memory(memPtr) = %int(%subst(x:1:1));
end-proc;


// output byte at data pointer
dcl-proc bfWrite;
  dcl-pi *n char(1) end-pi;
  return %char(memory(memPtr));
end-proc;
