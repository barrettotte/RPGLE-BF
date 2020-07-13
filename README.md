# RPGLE-BF
A crude BF interpreter in RPGLE. Invokes BF interpreter with IFS file contents.


## Setup
* clone - ```git -c http.sslVerify=false clone https://github.com/barrettotte/RPGLE-BF.git```
* build - ```cd RPGLE-BF; chmod u+x build.sh; ./build.sh```


## Objects
* BF.CMD - Command wrapper over BF CL
* BF.CLLE - Invokes BF interpreter with file contents from IFS
* BFINT.RPGLE - BF interpreter
* IFSREAD.RPGLE - Read file contents from IFS


## Commands
* build - ```./build.sh```
* Git push - ```git -c http.sslVerify=false push origin master```


## References
* Prior BF interpreter I wrote in Groovy - https://github.com/barrettotte/Groovy-BF
