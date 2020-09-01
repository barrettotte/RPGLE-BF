source:
```
++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++.>+++++++++++++++.>.+++.------.--------.<<+.<.
```



Converted zero indexing to one indexing!


## Attempt 1
```%char(memory(memPtr))```

7310210910911233881121151091013411



## Attempt 2
```%char(%editc(memory(memPtr):'X'))```

 H   e   l   l   o       W   o   r   l   d   !   \n
values ('y' ,ascii('y') ,chr(ascii('y')) , hex(chr(ascii('y'))) );


ASCII and EBCDIC character sets
https://www.ibm.com/support/knowledgecenter/SSGH4D_16.1.0/com.ibm.xlf161.aix.doc/language_ref/asciit.html


| Expected | Actual | Character |
| -------- | ------ | --------- |
|          | 073    | H         |
| 101      | 102    | e         |
| 108      | 109    | l         |
| 108      | 109    | l         |
|          | 112    | o         |
|          | 033    | (space)   |
| 87       | 088    | W         |
|          | 112    | o         |
|          | 115    | r         |
|          | 109    | l         |
|          | 101    | d         |
| 33       | 034    | !         |
| 10       | 011    | \n        |


looks like i need to just subtract 1...probably from changing the array indexing




```PHP
outCell = %char(%editc(memory(memPtr):'X'));
charToHex(hexCell:outCell:(%size(outCell) * 2));
result = %trim(result) + hexCell;
```


073 102 109 109 112 033 088 112 115 109 101 034 011




**Problem:** I need to translate from ASCII decimal to an EBCDIC character.

**My Data:**
 H    e    l    l    o         W    o    r    l    d    !  
072  101  108  108  111  032  087  111  114  108  100  033

## Approach A
- Make a compile time array with hex from https://github.com/openssl/openssl/blob/master/crypto/ebcdic.c
- Access compile time array using ASCII decimal value as index to translate value to EBCDIC hex
- Use MI CVTCH instruction to convert value from EBCDIC hex to EBCDIC char
  - https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzatk/CVTCH.htm
  - https://www.itjungle.com/2020/03/02/guru-practicing-safe-hex-in-rpg/


## Approach B
- Use C sprintf function to translate from ASCII decimal to ASCII hex
- Find something to translate ASCII hex to EBCDIC hex
- Use MI CVTCH to translate from EBCDIC hex to EBCDIC char


## Links
https://stackoverflow.com/questions/58995801/convert-hexadecimal-ebcdic-to-character-ebcdic-iseries-as400



