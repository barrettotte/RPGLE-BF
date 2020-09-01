#!/QOpenSys/pkgs/bin/bash
#
# A completely stripped down version of 
#   https://github.com/barrettotte/RPGLE-Twilio/blob/master/build.sh

BIN_LIB='BOLIB'

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
  exec_qsh "CRTSRCPF FILE($BIN_LIB/QRPGLESRC) RCDLEN(112)"
  exec_qsh "CPYFRMSTMF FROMSTMF('$IFS_SRC/$1.rpgle') TOMBR('/QSYS.lib/$BIN_LIB.lib/QRPGLESRC.file/$1.mbr') MBROPT(*REPLACE)"
  exec_qsh "CHGPFM FILE($BIN_LIB/QRPGLESRC) MBR($1) SRCTYPE(RPGLE) TEXT('$2')"
  exec_qsh "CRTBNDRPG PGM($BIN_LIB/$1) SRCFILE($BIN_LIB/QRPGLESRC) OPTION(*NOUNREF) DBGVIEW(*LIST) INCDIR('$IFS_SRC')" -log "$1.rpgle"
}

build_sqlrpgle(){
  echo ' '
  exec_qsh "CRTSRCPF FILE($BIN_LIB/QRPGLESRC) RCDLEN(112)"
  exec_qsh "CPYFRMSTMF FROMSTMF('$IFS_SRC/$1.sqlrpgle') TOMBR('/QSYS.lib/$BIN_LIB.lib/QRPGLESRC.file/$1.mbr') MBROPT(*REPLACE)"
  exec_qsh "CHGPFM FILE($BIN_LIB/QRPGLESRC) MBR($1) SRCTYPE(SQLRPGLE) TEXT('$2')"
  objtype=${3:-'*PGM'}
  exec_qsh "CRTSQLRPGI OBJ($BIN_LIB/$1) SRCFILE($BIN_LIB/QRPGLESRC) RPGPPOPT(*LVL2) COMPILEOPT('OPTION(*NOUNREF) DBGVIEW(*SOURCE) INCDIR(''$IFS_SRC'')') DBGVIEW(*NONE) COMMIT(*NONE) OBJTYPE($objtype)" -log "$1.sqlrpgle"
}

build_clle(){
  echo ' '
  exec_qsh "CRTSRCPF FILE($BIN_LIB/QCLLESRC) RCDLEN(112)"
  exec_qsh "CPYFRMSTMF FROMSTMF('$IFS_SRC/$1.clle') TOMBR('/QSYS.lib/$BIN_LIB.lib/QCLLESRC.file/$1.mbr') MBROPT(*REPLACE)"
  exec_qsh "CHGPFM FILE($BIN_LIB/QCLLESRC) MBR($1) SRCTYPE(CLLE) TEXT('$2')"
  exec_qsh "CRTBNDCL PGM($BIN_LIB/$1) SRCFILE($BIN_LIB/QCLLESRC) DBGVIEW(*LIST)" -log "$1.clle"
}

build_cmd(){
  echo ' '
  exec_qsh "CRTSRCPF FILE($BIN_LIB/QCMDSRC) RCDLEN(132)"
  exec_qsh "CPYFRMSTMF FROMSTMF('$IFS_SRC/$1.cmd') TOMBR('/QSYS.lib/$BIN_LIB.lib/QCMDSRC.file/$1.mbr') MBROPT(*REPLACE)"
  exec_qsh "CHGPFM FILE($BIN_LIB/QCMDSRC) MBR($1) SRCTYPE(CMD) TEXT('$2')"
  exec_qsh "CRTCMD PRDLIB($BIN_LIB) CMD($BIN_LIB/$1) PGM($1) SRCFILE($BIN_LIB/QCMDSRC)" -log "$1.cmd"
}

build_rpgle    'ifsread' 'Read file from IFS'
build_sqlrpgle 'bfint' 'BF Interpreter'
build_clle     'bf' 'Interpret BF source from IFS'
build_cmd      'bf' 'Interpret BF source from IFS'

echo -e '\nDone.'