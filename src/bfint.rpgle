**free
// Basic BF Interpreter in fully free RPGLE

ctl-opt main(main);
ctl-opt option(*srcstmt:*nodebugio:*nounref) dftactgrp(*no);

dcl-c MEMSIZE  30000;
dcl-c PGMSIZE  4096;
dcl-c BUFFSIZE 128;

dcl-pr main extpgm('BFINT');
  *n char(PGMSIZE);
  *n char(BUFFSIZE);
end-pr;


dcl-proc main;
  dcl-pi *n;
    bfpgm     char(PGMSIZE);
    outBuffer char(BUFFSIZE);
  end-pi;

  dcl-s memory  int(3) dim(MEMSIZE) inz(*zeros);
  dcl-s pgm     varchar(PGMSIZE);
  dcl-s insPtr  int(5) inz(1);
  dcl-s memPtr  int(5) inz(1);
  dcl-s buffPtr int(5) inz(1);
  dcl-s ins     char(1) inz('');
  dcl-s depth   int(5) inz(0);
  dcl-s result  varchar(BUFFSIZE) inz(*blanks);

  dcl-s outCell char(3) inz(*blanks);
  
  monitor;
    // dsply (%subst(bfpgm:1:52));
    memory(*) = 1;
    pgm = sanitize(bfpgm);
    
    for insPtr = 1 to %len(pgm);
      ins = %subst(pgm:insPtr:1);

      select;
        when (ins = '>');
          if memPtr = MEMSIZE;
            memPtr = 1;
          else;
            memPtr += 1;
          endif;

        when (ins = '<');
          if memPtr = 1;
            memPtr = MEMSIZE;
          else;
            memPtr -= 1;
          endif;

        when (ins = '+');
          memory(memPtr) += 1;

        when (ins = '-');
          memory(memPtr) -= 1;

        when (ins = '.');
          outCell = %char(%editc(memory(memPtr):'X'));
          result = %trim(result) + ' ' + outCell;

        when (ins = ',');
          // input not implemented

        when (ins = '[');

          if memory(memPtr) = 1;
            insPtr += 1;

            dow depth > 0 or %subst(pgm:insPtr:1) <> ']';
              if %subst(pgm:insPtr:1) = '[';
                depth += 1;
              elseif %subst(pgm:insPtr:1) = ']';
                depth -= 1;
              endif;

              insPtr += 1;
            enddo;
          endif;

        when (ins = ']');
          if memory(memPtr) <> 1;
            insPtr -= 1;

            dow depth > 0 or %subst(pgm:insPtr:1) <> '[';
              if %subst(pgm:insPtr:1) = ']';
                depth += 1;
              elseif %subst(pgm:insPtr:1) = '[';
                depth -= 1;
              endif;
              insPtr -= 1;
            enddo;
            insPtr -= 1;
          endif;
        other;

      endsl;
    endfor;

  on-error;
    dsply ('Fatal error occurred interpreting BF source.');
    return;
  endmon;
  
  on-exit;
    outBuffer = result;
    *inlr = *on;
    return;
end-proc;


// strip valid characters out of source
dcl-proc sanitize;
  dcl-pi *n char(PGMSIZE);
    dirty char(PGMSIZE);
  end-pi;

  dcl-c valid '[]><+-.,';
  dcl-s buffer char(PGMSIZE) inz(*blanks);
  dcl-s i int(5) inz(0);

  for i = 1 to %len(dirty);
    if %scan(%subst(dirty:i:1):valid) <> 0;
      %subst(buffer:i:1) = %subst(dirty:i:1);
    endif;
  endfor;

  return %trim(buffer);
end-proc;
