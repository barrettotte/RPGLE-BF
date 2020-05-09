#!/QOpenSys/pkgs/bin/bash
# A completely stripped down version of 
#   https://github.com/barrettotte/RPGLE-Twilio/blob/master/build.sh

BIN_LIB='OTTEB1'

IFS_BASE=$(pwd)
IFS_SRC="src"
LOG_DIR="$IFS_BASE/logs"

mkdir -p "$LOG_DIR"

exec_qsh(){
  echo $1
  output=$(qsh -c "liblist -a $BIN_LIB ; system \"$1\"")
  if [ "$2" == "-log" ]; then
    echo -e "$1\n\n$output" > "$LOG_DIR/$3.log"
  fi
}

build_rpgle(){
  echo ' '
  exec_qsh "CHGATR OBJ('$IFS_SRC/$1.rpgle') ATR(*CCSID) VALUE(1252)"
  exec_qsh "CRTSRCPF FILE($BIN_LIB/QRPGLESRC) RCDLEN(112) CCSID($CCSID)"
  exec_qsh "CPYFRMSTMF FROMSTMF('$IFS_SRC/$1.rpgle') TOMBR('/QSYS.lib/$BIN_LIB.lib/QRPGLESRC.file/$1.mbr') MBROPT(*REPLACE)"
  exec_qsh "CHGPFM FILE($BIN_LIB/QRPGLESRC) MBR($1) SRCTYPE(RPGLE) TEXT('$2')"
  exec_qsh "CRTBNDRPG PGM($BIN_LIB/$1) SRCSTMF('$IFS_SRC/$1.rpgle') OPTION(*NOUNREF) DBGVIEW(*LIST) INCDIR('$IFS_SRC')" -log "$1.rpgle"
}

build_rpgle 'bffree' 'BF RPGLE Free'
echo -e '\nDone.'