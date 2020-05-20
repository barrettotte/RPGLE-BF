# RPG400-BF
Showing the evolution of RPG by making a BF interpreter in RPG/400, RPGLE Fixed, and RPGLE free.


## Setup
* clone - ```git -c http.sslVerify=false clone https://github.com/barrettotte/RPG-BF.git```
* build - ```cd RPG-BF; chmod u+x build.sh; ./build.sh```
* set CCSID - ```CHGJOB CCSID(37)``` (CL)
* run - ```CALL PGM(BOLIB/BFFREE) PARM('...' '')```


## Commands
* build - ```./build.sh```
* Git push - ```git -c http.sslVerify=false push origin master```


## References
* Prior BF interpreter I wrote in Groovy - https://github.com/barrettotte/Groovy-BF
