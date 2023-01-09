unit uASMCalculator;

interface

{$WARN UNSAFE_CODE OFF}
{$OPTIMIZATION OFF}

{$IF CompilerVersion > 23}
  {$LEGACYIFEND ON}
{$IFEND}

// Result=EFLAGS
function EFlags32_XOR( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_AND( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_OR( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_Test( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_CMP( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_INC( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_DEC( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_Add( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_ADC( Operand1, Operand2 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
function EFlags32_Sub( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_Sbb( Operand1, Operand2 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
function EFlags32_NOT( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_NEG( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_SHLD( Operand1, Operand2 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
function EFlags32_SHRD( Operand1, Operand2 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
function EFlags32_SHL_SAL( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
function EFlags32_SHR( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
function EFlags32_SAR( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
function EFlags32_ROL( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
function EFlags32_ROR( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
function EFlags32_RCL( Operand1 : Integer; Shift : Byte; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
function EFlags32_RCR( Operand1 : Integer; Shift : Byte; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
function EFlags32_MUL( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
function EFlags32_IMUL( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
function EFlags32_DIV( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
function EFlags32_IDIV( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
function EFlags32_CBW( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_CWDE( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_CWD( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
function EFlags32_CDQ( Operand1 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
function EFlags32_BSwap( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_BSF( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_BSR( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_BT( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
function EFlags32_BTC( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
function EFlags32_BTR( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
function EFlags32_BTS( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
function EFlags32_PopCnt( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_LzCnt( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_DAA( Operand1 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
function EFlags32_DAS( Operand1 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
function EFlags32_AAA( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_AAS( Operand1 : Integer; out OutValue : Integer ) : THandle;
function EFlags32_AAM( Operand1 : Byte; out OutValue : Integer ) : THandle;
function EFlags32_AAD( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;

{$IFDEF Win64}
function EFlags64_XOR( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_AND( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_OR( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_Test( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_CMP( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_INC( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_DEC( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_Add( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_ADC( Operand1, Operand2 : Int64; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
function EFlags64_Sub( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_Sbb( Operand1, Operand2 : Int64; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
function EFlags64_NOT( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_NEG( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_SHLD( Operand1, Operand2 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_SHRD( Operand1, Operand2 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_SHL_SAL( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_SHR( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_SAR( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_ROL( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_ROR( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_RCL( Operand1 : Int64; Shift : Byte; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
function EFlags64_RCR( Operand1 : Int64; Shift : Byte; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
function EFlags64_MUL( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
function EFlags64_IMUL( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
function EFlags64_DIV( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
function EFlags64_IDIV( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
function EFlags64_CBW( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_CWDE( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_CWD( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
function EFlags64_CDQ( Operand1 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
function EFlags64_BSwap( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_BSF( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_BSR( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_BT( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_BTC( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_BTR( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_BTS( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
function EFlags64_PopCnt( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
function EFlags64_LzCnt( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
{$ENDIF}

//type
//  TAsmOperands = (
const
  asmAAA      = 0{,};
  asmAAD      = 1{,};
  asmAAM      = 2{,};
  asmAAS      = 3{,};
  asmADC      = 4{,};
  asmADD      = 5{,};
  asmAND      = 6{,};
  asmBSF      = 7{,};
  asmBSR      = 8{,};
  asmBSWAP    = 9{,};
  asmBT       = 10{,};
  asmBTC      = 11{,};
  asmBTR      = 12{,};
  asmBTS      = 13{,};
  asmCBW      = 14{,};
  asmCDQ      = 15{,};
  asmCMP      = 16{,};
  asmCWD      = 17{,};
  asmCWDE     = 18{,};
  asmDAA      = 19{,};
  asmDAS      = 20{,};
  asmDEC      = 21{,};
  asmDIV      = 22{,};
  asmIDIV     = 23{,};
  asmIMUL     = 24{,};
  asmINC      = 25{,};
  asmLZCNT    = 26{,};
  asmMUL      = 27{,};
  asmNEG      = 28{,};
  asmNOT      = 29{,};
  asmOR       = 30{,};
  asmPOPCNT   = 31{,};
  asmRCL      = 32{,};
  asmRCR      = 33{,};
  asmROL      = 34{,};
  asmROR      = 35{,};
  asmSAR      = 36{,};
  asmSBB      = 37{,};
  asmSHL_SAL  = 38{,};
  asmSHLD     = 39{,};
  asmSHR      = 40{,};
  asmSHRD     = 41{,};
  asmSUB      = 42{,};
  asmTEST     = 43{,};
  asmXOR      = 44;
//  );

  AsmOperands_Description : Array [ asmAAA..asmXOR ] of String = (
    'ASCII Adjust After Addition',
    'ASCII Adjust Before Division',
    'ASCII Adjust After Multiply',
    'ASCII Adjust After Subtraction',
    'Integer Addition with Carry',
    'Integer Addition',
    'Logical AND',
    'Bit Scan Forward',
    'Bit Scan Reverse',
    'Byte Swap',
    'Bit Test',
    'Bit Test and Complement',
    'Bit Test and Reset',
    'Bit Test and Set',
    'Convert Byte to Word',
    'Convert DoubleWord to QuadWord',
    'Compare Two Operands',
    'Convert Word to DoubleWord',
    'Convert Word to Ext. DoubleWord',
    'Decimal Adjust After Addition',
    'Decimal Adjust After Subtraction',
    'Decrement by 1',
    'Unsigned Integer Division',
    'Signed Integer Division',
    'Signed Integer Multiply',
    'Increment by 1',
    'Leading Zeros Count',
    'UnSigned Integer Multiply',
    'Twos Complement Negation',
    'Bitwise Logical Negation',
    'Logical Inclusive OR',
    'Bit Population Count',
    'Rotate Through Carry Left',
    'Rotate Through Carry Right',
    'Rotate Left',
    'Rotate Right',
    'Shift Arithmetical Right',
    'Integer Subtraction with Borrow',
    'Shift Logical/Arithmetical Left',
    'Double Percision Shift Left',
    'Shift Logical Right',
    'Double Percision Shift Right',
    'Integer Subtraction',
    'Logical Compare',
    'Logical Exclusive OR'
  );

implementation

function EFlags32_XOR( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 XOR b;
  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    XOR eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    XOR eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_AND( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 AND b;
  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    AND eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    AND eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_OR( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 OR b;
  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    OR eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    OR eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_TEST( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    TEST eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    TEST eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_CMP( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    CMP eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    CMP eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_INC( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    INC eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    INC eax
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_DEC( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    DEC eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    DEC eax
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_Add( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 + b;
  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    add eax, edx // Add B
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    add eax, edx // Add B
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_ADC( Operand1, Operand2 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    ADC eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    ADC eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_Sub( Operand1, Operand2 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 + b;
  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    sub eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    sub eax, edx // Sub B
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_Sbb( Operand1, Operand2 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    SBB eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    SBB eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_NOT( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    NOT eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    NOT eax
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_NEG( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    NEG eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    NEG eax
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_SHLD( Operand1, Operand2 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ELSE}
  push ebx
  mov bl, cl
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, r8b

    SHLD eax, edx, cl
    pop rcx
    mov [r9],eax // (r9=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, bl
    SHLD eax, edx, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}

  {$IFNDEF Win64}
  mov ecx, [ebp+$08]
  mov [ecx], edx
  pop ebx
  {$ENDIF}
end;

function EFlags32_SHRD( Operand1, Operand2 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ELSE}
  push ebx
  mov bl, cl
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, r8b

    SHRD eax, edx, cl
    pop rcx
    mov [r9],eax // (r9=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, bl
    SHRD eax, edx, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}

  {$IFNDEF Win64}
  mov ecx, [ebp+$08]
  mov [ecx], edx
  pop ebx
  {$ENDIF}
end;

function EFlags32_SHL_SAL( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, dl
    SHL eax, cl
    pop rcx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, dl
    SHL eax, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_SHR( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, dl
    SHR eax, cl
    pop rcx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, dl
    SHR eax, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_SAR( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, dl
    SAR eax, cl
    pop rcx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, dl
    SAR eax, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_ROL( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, dl
    ROL eax, cl
    pop rcx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, dl
    ROL eax, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_ROR( Operand1 : Integer; Shift : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, dl
    ROR eax, cl
    pop rcx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, dl
    ROR eax, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_RCL( Operand1 : Integer; Shift : Byte; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, dl
    RCL eax, cl
    pop rcx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, dl
    RCL eax, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_RCR( Operand1 : Integer; Shift : Byte; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rcx
    mov cl, dl
    RCR eax, cl
    pop rcx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ecx
    mov cl, dl
    RCR eax, cl
    pop ecx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_MUL( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    MUL eax, edx
    mov [r8],eax // (r8=@OutValueLo)=eax
    mov [r9],edx // (r9=@OutValueHi)=edx
  {$ELSE}
    pop eax      // Restore Operand1
    MUL eax, edx

    push edx
    mov edx,[ebp-$04]
    mov [edx],eax
    pop edx

    mov eax,[ebp+$08]
    mov [eax],edx
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_IMUL( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    mov r14, rdx
    IMUL r14d
    mov [r8],eax // (r8=@OutValueLo)=eax
    mov [r9],edx // (r9=@OutValueHi)=edx
  {$ELSE}
    pop eax      // Restore Operand1
    push ebx
    mov ebx, edx
    IMUL ebx
    pop ebx

    push edx
    mov edx,[ebp-$04]
    mov [edx],eax
    pop edx

    mov eax,[ebp+$08]
    mov [eax],edx
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_DIV( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rbx
    mov rbx, rdx
    cdq
    DIV ebx
    pop rbx

    mov [r8],eax // (r8=@OutValueLo)=eax
    mov [r9],edx // (r9=@OutValueHi)=edx
  {$ELSE}
    pop eax      // Restore Operand1
    push ebx
    mov ebx, edx
    cdq
    DIV ebx
    pop ebx

    push edx
    mov edx,[ebp-$04]
    mov [edx],eax
    pop edx

    mov eax,[ebp+$08]
    mov [eax],edx
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_IDIV( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    push rbx
    mov rbx, rdx
    cdq
    IDIV rbx
    pop rbx

    mov [r8],eax // (r8=@OutValueLo)=eax
    mov [r9],edx // (r9=@OutValueHi)=edx
  {$ELSE}
    pop eax      // Restore Operand1
    push ebx
    mov ebx, edx
    cdq
    DIV ebx
    pop ebx

    push edx
    mov edx,[ebp-$04]
    mov [edx],eax
    pop edx

    mov eax,[ebp+$08]
    mov [eax],edx
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_CBW( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    CBW
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    CBW
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_CWDE( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    CWDE
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    CWDE
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_CWD( Operand1, Operand2 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

   {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    CWD
    mov [r8],eax // (r8=@OutValueLo)=eax
    mov [r9],edx // (r9=@OutValueHi)=edx
  {$ELSE}
    pop eax      // Restore Operand1
    CWD

    push edx
    mov edx,[ebp-$04]
    mov [edx],eax
    pop edx

    mov eax,[ebp+$08]
    mov [eax],edx
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_CDQ( Operand1 : Integer; out OutValueLo, OutValueHi : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    mov r9d, edx
    CDQ
    mov [r9],eax
    mov [r8],edx // (r8=@OutValueHi)=edx
  {$ELSE}
    pop eax      // Restore Operand1

    push ecx
    mov ecx, edx
    CDQ
    mov [ecx],eax
    pop ecx

    lea eax,[ebp-$04]
    mov [eax],edx
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_BSwap( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    BSWAP eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    BSWAP eax
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_BSF( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    BSF eax, eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    BSF eax, eax
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_BSR( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    BSR eax, eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    BSR eax, eax
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_BT( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    BT eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    BT eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_BTC( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    BTC eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    BTC eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_BTR( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    BTR eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    BTR eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_BTS( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    BTS eax, edx
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    BTS eax, edx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

function EFlags32_PopCnt( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    PopCnt eax, eax
    mov [rdx], eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    {$IF CompilerVersion < 23}
    xor eax, eax
    {$ELSE}
    PopCnt eax, eax
    {$IFEND}
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_LzCnt( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$IFDEF Win64}
  mov r14, rcx
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
    mov eax, r14d // eax=Operand1
    LzCnt eax, eax
    mov [rdx],eax // (rdx=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    {$IF CompilerVersion < 23}
    xor eax, eax
    {$ELSE}
    LzCnt eax, eax
    {$IFEND}
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_DAA( Operand1 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
asm
  {$IFNDEF Win64}
  push ebx
  mov bl, cl
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp bl, 1 // CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  {$IFNDEF Win64}
  pop ebx
  {$ENDIF}

  {$IFDEF Win64}
  // Only x86
    xor eax, eax
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    mov eax, ebx
    DAA
    mov [edx], eax
    pop eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_DAS( Operand1 : Integer; out OutValue : Integer; CarryFlag : boolean = False ) : THandle;
asm
  {$IFNDEF Win64}
  push ebx
  mov bl, cl
  {$ENDIF}

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp bl, 1 // CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  {$IFNDEF Win64}
  pop ebx
  {$ENDIF}

  {$IFDEF Win64}
  // Only x86
    xor eax, eax
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    mov eax, ebx
    DAS
    mov [edx], eax
    pop eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_AAA( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
  // Only x86
    xor eax, eax
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    AAA
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_AAS( Operand1 : Integer; out OutValue : Integer ) : THandle;
asm
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
  // Only x86
    xor eax, eax
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    AAS
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_AAM( Operand1 : Byte; out OutValue : Integer ) : THandle;
asm
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
  // Only x86
    xor eax, eax
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    AAM
    mov [edx], eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags32_AAD( Operand1 : Integer; B : Byte; out OutValue : Integer ) : THandle;
asm
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  {$IFDEF Win64}
  // Only x86
    xor eax, eax
    mov [r8],eax // (r8=@OutValue)=eax
  {$ELSE}
    pop eax      // Restore Operand1
    push ebx
    mov bl, dl
    AAD
    pop ebx
    mov edx, eax
  {$ENDIF}

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
  {$IFNDEF Win64}
  mov [ecx],edx // (ecx=@OutValue)=edx
  {$ENDIF}
end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{$IFDEF Win64}
function EFlags64_XOR( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 XOR b;
  mov rax, r14 // eax=Operand1
  XOR rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_AND( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 AND b;
  mov rax, r14 // eax=Operand1
  AND rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_OR( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 OR b;
  mov rax, r14 // eax=Operand1
  OR rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_TEST( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  TEST rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_CMP( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  CMP rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_INC( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  INC rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_DEC( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  DEC rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_Add( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 + Operand2;
  mov rax, r14 // eax=Operand1
  add rax, rdx // Add Operand2
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_ADC( Operand1, Operand2 : Int64; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  mov rax, r14 // eax=Operand1
  ADC rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_Sub( Operand1, Operand2 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  // c := Operand1 - Operand2;
  mov rax, r14 // eax=Operand1
  sub rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_Sbb( Operand1, Operand2 : Int64; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  mov rax, r14 // eax=Operand1
  SBB rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_NOT( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  NOT rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_NEG( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  NEG rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_SHLD( Operand1, Operand2 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, r8b

  SHLD rax, rdx, cl
  pop rcx
  mov [r9],rax // (r9=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_SHRD( Operand1, Operand2 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, r8b

  SHRD rax, rdx, cl
  pop rcx
  mov [r9],rax // (r9=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_SHL_SAL( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, dl
  SHL rax, cl
  pop rcx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_SHR( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, dl
  SHR rax, cl
  pop rcx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_SAR( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, dl
  SAR rax, cl
  pop rcx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_ROL( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, dl
  ROL rax, cl
  pop rcx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_ROR( Operand1 : Int64; Shift : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, dl
  ROR rax, cl
  pop rcx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_RCL( Operand1 : Int64; Shift : Byte; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, dl
  RCL rax, cl
  pop rcx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_RCR( Operand1 : Int64; Shift : Byte; out OutValue : Int64; CarryFlag : boolean = False ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  cmp CarryFlag, 1
  je @@CF
  clc
  jmp @@NCF
  @@CF:
  stc
  @@NCF:

  mov rax, r14 // eax=Operand1
  push rcx
  mov cl, dl
  RCR rax, cl
  pop rcx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_MUL( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  MUL rax, rdx
  mov [r8],rax // (r8=@OutValueLo)=rax
  mov [r9],rdx // (r9=@OutValueHi)=rdx

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_IMUL( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  mov r14, rdx
  IMUL r14d
  mov [r8],rax // (r8=@OutValueLo)=rax
  mov [r9],rdx // (r9=@OutValueHi)=rdx

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_DIV( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rbx
  mov rbx, rdx
  cdq
  DIV rbx
  pop rbx

  mov [r8],rax // (r8=@OutValueLo)=rax
  mov [r9],rdx // (r9=@OutValueHi)=rdx

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_IDIV( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  push rbx
  mov rbx, rdx
  cdq
  IDIV rbx
  pop rbx

  mov [r8],rax // (r8=@OutValueLo)=rax
  mov [r9],rdx // (r9=@OutValueHi)=rdx

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_CBW( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  CBW
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_CWDE( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  CWDE
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_CWD( Operand1, Operand2 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  CWD
  mov [r8],rax // (r8=@OutValueLo)=rax
  mov [r9],rdx // (r9=@OutValueHi)=rdx

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_CDQ( Operand1 : Int64; out OutValueLo, OutValueHi : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov eax, r14d // eax=Operand1
  mov r9d, edx
  CDQ
  mov [r9],eax
  mov [r8],edx // (r8=@OutValueHi)=edx

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_BSwap( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  BSWAP rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_BSF( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  BSF rax, rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_BSR( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  BSR rax, rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_BT( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  BT rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_BTC( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  BTC rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_BTR( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  BTR rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_BTS( Operand1 : Int64; B : Byte; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  BTS rax, rdx
  mov [r8],rax // (r8=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_PopCnt( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx
  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  PopCnt rax, rax
  mov [rdx], eax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;

function EFlags64_LzCnt( Operand1 : Int64; out OutValue : Int64 ) : UInt64;
asm
  mov r14, rcx

  {$DEFINE EFLAGS_BACKUP}
  {$I *.inc}
  {$UNDEF EFLAGS_BACKUP}

  mov rax, r14 // eax=Operand1
  LzCnt rax, rax
  mov [rdx],rax // (rdx=@OutValue)=rax

  {$DEFINE EFLAGS_RESTORE}
  {$I *.inc}
  {$UNDEF EFLAGS_RESTORE}
end;
{$ENDIF}

end.
