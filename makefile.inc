#------------------------------------------------------------------------------
#
# SQLHammer Build
# Copyright (c) 2005 MetadataForge, http://metadataforge.com
#
#------------------------------------------------------------------------------
#
# COMMAND-LINE TOOLS KEYS >>
#
#------------------------------------------------------------------------------
#Syntax: MAKE [options ...] target[s]
#    -B                Builds all targets regardless of dependency dates
#    -Dsymbol[=string] Defines symbol [equal to string]
#    -Idirectory       Names an include directory
#    -K                Keeps (does not erase) temporary files created by MAKE
#    -N                Increases MAKE's compatibility with NMAKE
#    -Wfilename        Writes MAKE to filename updating all non-string options
#    -Usymbol          Undefine symbol
#    -ffilename        Uses filename as the MAKEFILE
#    -a                Performs auto-dependency checks for include files
#    -c                Caches auto-dependency information
#    -e                Ignores redefinition of environment variable macros
#    -i                Ignores errors returned by commands
#    -l+               Enables use of long command lines
#    -m                Displays the date and time stamp of each file
#    -n                Prints commands but does not do them
#    -p                Displays all macro definitions and implicit rules
#    -q                Returns zero if target is up-to-date and nonzero
#                      if it is not (for use in batch files)
#    -r                Ignores rules and macros defined in BUILTINS.MAK
#    -s                Silent, does not print commands before doing them
#    -? or -h          Prints this message
#      Options marked with '+' are on by default. To turn off a default
#      option follow it by a '-', for example: -a-
#------------------------------------------------------------------------------
#Syntax: dcc32 [options] filename [options]
#  -A<unit>=<alias> = Set unit alias  -LU<package> = Use package
#  -B = Build all units               -M = Make modified units
#  -CC = Console target               -N<path> = DCU output directory
#  -CG = GUI target                   -O<paths> = Object directories
#  -D<syms> = Define conditionals     -P = look for 8.3 file names also
#  -E<path> = EXE output directory    -Q = Quiet compile
#  -F<offset> = Find error            -R<paths> = Resource directories
#  -GD = Detailed map file            -U<paths> = Unit directories
#  -GP = Map file with publics        -V = Debug information in EXE
#  -GS = Map file with segments       -VR = Generate remote debug (RSM)
#  -H = Output hint messages          -W = Output warning messages
#  -I<paths> = Include directories    -Z = Output 'never build' DCPs
#  -J = Generate .obj file            -$<dir> = Compiler directive
#  -JP = Generate C++ .obj file       --help = Show this help screen
#  -K<addr> = Set image base addr     --version = Show name and version
#Compiler switches: -$<letter><state> (defaults are shown below)
#  A8  Aligned record fields           P+  Open string params
#  B-  Full boolean Evaluation         Q-  Integer overflow checking
#  C+  Evaluate assertions at runtime  R-  Range checking
#  D+  Debug information               T-  Typed @ operator
#  G+  Use imported data references    U-  Pentium(tm)-safe divide
#  H+  Use long strings by default     V+  Strict var-strings
#  I+  I/O checking                    W-  Generate stack frames
#  J-  Writeable structured consts     X+  Extended syntax
#  L+  Local debug symbols             Y+  Symbol reference info
#  M-  Runtime type info               Z1  Minimum size of enum types
#  O+  Optimization
#------------------------------------------------------------------------------
#Syntax: brcc32 [options ...] filename
#  options marked with a '*' are on by default
#  @<filename>        Take instructions from command file
#  -r                    (ignored for compatibility)
#  -16                   Build 16-bit Windows compatible .res file
#  -32                 * Build 32-bit Windows compatible .res file
#  -fofilename           Set output filename
#  -v                    Verbose
#  -ipath                Set include path
#  -dname[=string]       Define #define
#  -x                    Ignore INCLUDE environment variable
#  -m                    Enable multi-byte character support
#  -cdddd                set default code page to nnnn
#  -lxxxx                set default language to xxxx
#  -31   Provided for downward compatibility (build 16-bit .res file)
#  -w32  Provided for downward compatibility (build 16-bit .res file)
#  -? or -h              Display this message
#------------------------------------------------------------------------------
#Usage: MAKEJCLDBG -<J|E> <map filenames>
#       J - Create .JDBG files
#       E - Insert debug data into executable files
#Executable files must be in the same directory like MAP files
#------------------------------------------------------------------------------
#
# SOURCE CODE OF THIS MAKEFILE.INC >>
#
#------------------------------------------------------------------------------
!ifndef ROOT
ROOT = $(MAKEDIR)\..
!endif
#------------------------------------------------------------------------------
VCL  = $(ROOT)\Lib;$(ROOT)\Bin;$(ROOT)\Imports;$(ROOT)\Projects\Bpl;$(ROOT)\Rave5\Lib;$(ROOT)\Source\ToolsAPI
VCL2 = $(VCL70)\EhLib\Delphi7;$(VCL70)\EhLib\DataService;$(VCL70)\ExtLib\;$(VCL70)\FIBPlus\;$(VCL70)\FIBPlus\Editors\;$(VCL70)\SynEdit\Packages\;$(VCL70)\SynEdit\Source\;$(VCL70)\UIB\Packages\;$(VCL70)\UIB\Source\;$(VCL70)\VT\Delphi\;$(VCL70)\VT\Design\;$(VCL70)\VT\Source\;$(SQLHAMMER_CVS)\;$(VCL70)\JCL\Source\;$(VCL70)\JCL\Source\Common;$(VCL70)\JCL\Source\Windows
SRC  = $(SQLHAMMER_CVS)
SRC2 = $(SRC)\_InterBase;$(SRC)\_InterBase\Actions;$(SRC)\_InterBase\Common;$(SRC)\_InterBase\Components;$(SRC)\_InterBase\Drivers;$(SRC)\_InterBase\Editors;$(SRC)\_InterBase\EditorTXT;$(SRC)\_InterBase\Forms;$(SRC)\_InterBase\Intf;$(SRC)\_InterBase\Packages;$(SRC)\Common;$(SRC)\Common\Components;$(SRC)\Common\Forms;$(SRC)\Common\Intf;$(SRC)\Common\Packages;$(SRC)\Environment;$(SRC)\Environment\Common;$(SRC)\Environment\Forms;$(SRC)\Environment\Intf;$(SRC)\Environment\System;$(SRC)\Pack;$(SRC)\Pack\Common;$(SRC)\Pack\Intf;$(SRC)\Pack\Packages;$(SRC)\Pack\SynEdit
BIN  = $(SQLHAMMER_BIN)\Bin
ALL  = $(SRC);$(SRC2);$(VCL);$(VCL2)
MAP  = $(BIN)\$&.map
#------------------------------------------------------------------------------
TYPE =  #RELEASE

!if "$(TYPE)" == ""
  # -V(for TD32) -VR(for remote debugger)
  DBG_KEYS = -GD -$D+ -$L+ -$C+ -$Y+
!endif

!if "$(TYPE)" == "RELEASE"
  DEFINE = RELEASE_BUILD
  DBG_KEYS = -$D- -$L- -$C- -$Y- 
!endif

#PRJ_KEYS = -$A8 -$B- -$C+ -$D+ -$E- -$F- -$G+ -$H+ -$I+ -$J- -$K- -$L+ -$M- \
#           -$N+ -$O+ -$P+ -$Q- -$R- -$S- -$T- -$U- -$V+ -$W- -$X+ -$YD -$Z1
#------------------------------------------------------------------------------
MK = make.exe
DC = dcc32.exe
RC = brcc32.exe
JD = makejcldbg.exe
#------------------------------------------------------------------------------
MK_KEYS = -$(MAKEFLAGS) -f$**
DC_KEYS = -B -Q -M -H -W -I$(ALL) -U$(ALL) -E$(BIN) $** -D$(DEFINE)
RC_KEYS = $**
JD_KEYS = -E
#------------------------------------------------------------------------------
CALL_MAKE = $(ROOT)\Bin\$(MK) $(MK_KEYS)
CALL_DCC  = $(ROOT)\Bin\$(DC) $(DC_KEYS) $(DBG_KEYS)
CALL_BRCC = $(ROOT)\Bin\$(RC) $(RC_KEYS)
CALL_JDBG = 
!if "$(TYPE)" == "DEBUG"
  CALL_JDBG = $(VCL70)\JCL\Bin\$(JD) $(JD_KEYS) $(MAP)
!endif
#------------------------------------------------------------------------------
.dpr.exe: 
  $(CALL_DCC)
  $(CALL_JDBG)

.dpr.dll: 
  $(CALL_DCC)
  $(CALL_JDBG)

.dpk.bpl:
  $(CALL_DCC) 
  $(CALL_JDBG)
#------------------------------------------------------------------------------
#
# Pack\Packages\makefile.mak; 
# Common\Packages\makefile.mak;  
# Environment\makefile.mak;  
# _InterBase\Packages\makefile.mak; 
#
#------------------------------------------------------------------------------
