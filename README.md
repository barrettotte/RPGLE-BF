# RPGLE-BF
A BF interpreter in RPGLE


## Setup
* clone - ```git -c http.sslVerify=false clone https://github.com/barrettotte/RPGLE-BF.git```
* build - ```cd RPG-BF; chmod u+x build.sh; ./build.sh```
* set CCSID - ```CHGJOB CCSID(37)``` (CL)
* run - ```CALL PGM(BOLIB/BFFREE) PARM('...' '')```


## Commands
* build - ```./build.sh```
* Git push - ```git -c http.sslVerify=false push origin master```


## References
* Prior BF interpreter I wrote in Groovy - https://github.com/barrettotte/Groovy-BF
