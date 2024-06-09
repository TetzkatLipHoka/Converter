unit uExpressionCalculator;

(*
  Syntax:
  0b0101, 01010b, 0101b - Binary number
  0o377,  0377o,  377o  - Octal number
  0xABCD, 0ABCDh, $ABCD - Hex number
  90`15`2               - Degree

  Operators by priorities:
    {7} ( )   (BRACES)
    {6} **    (POWER)
    {5} ~     (INVERSE)
        ! NOT (NOT)
    {4} *     (MUL)
        /     (DIV)
        % MOD (MOD)
        %%    (PERSENT)
        <<    (Shift Left)
        >>    (Shift Right)
    {3} +     (ADD)
        -     (SUB)
    {2} <     (Less)
        <=    (Less or Equal)
        ==    (Equal)
        <> != (Not Equal)
        >=    (Greater or Equal)
        >     (Greater)
    {1} | OR  (OR)
        ^ XOR (XOR)
        & AND (AND)

  Functions
    atan / arctan
    ceil
    cos
    exp
    floor
    frac
    int
    ln
    pi
    round
    sgn
    sign
    sin
    sqr
    sqrt
    tan
    trunc
    xsgn

  Error Codes
     0 = Success
    -1 = Syntax error
    -2 = Unknown function or variable, see LastError for Name
*)

// MS KeyUp/Down? -> Auto detect mode...

interface

{$DEFINE uCheckStringGrid}
{$DEFINE uTLH_ComponentTools}
{$DEFINE BigNumbers}

{$WARN SYMBOL_PLATFORM OFF}

uses
  Classes, Controls, ExtCtrls, Forms, StdCtrls, Grids

  {$IFDEF BigNumbers}
  ,Velthuis.BigIntegers
  ,Velthuis.BigDecimals
  {$ENDIF BigNumbers}

  {$IFDEF uCheckStringGrid}
  ,uCheckStringGrid
  {$ENDIF uCheckStringGrid}
  {$IFDEF uTLH_ComponentTools}
  ,uTLH.ComponentTools
  {$ENDIF uTLH_ComponentTools}
  ;

type
  TExpressionCalculatorToken = (
    { } tkEOF, tkERROR, tkASSIGN,
    {7} tkLBRACE, tkRBRACE, tkNUMBER, tkIDENT, tkSEMICOLON,
    {6} tkPower,
    {5} tkInverse, tkNOT,
    {4} tkMUL, tkDIV, tkMOD, tkPER, tkShiftLeft, tkShiftRight,
    {3} tkADD, tkSUB,
    {2} tkLess, tkLessEqual, tkEqual, tkNotEqual, tkGreaterEqual, tkGreater,
    {1} tkOR, tkXOR, tkAND
  );

  TExpressionCalculatorMode = (
    ecmSigned,
    ecmUnsigned,
    ecmDouble
    {$IFDEF BigNumbers}
    ,ecmBigInteger
    ,ecmBigDecimal
    {$ENDIF BigNumbers}
  );

  TExpressionCalculatorValue = packed record
    {$IFDEF BigNumbers}
    BigInteger : BigInteger;
    BigDecimal : BigDecimal;
    {$ENDIF BigNumbers}
    case Integer of
      0 : ( Int64  : Int64 );
      1 : ( UInt64 : UInt64 );
      2 : ( Double : Double );
//    {$IFDEF BigNumbers}
//      3 : ( BigInteger : BigInteger );
//      4 : ( BigDecimal : BigDecimal );
//    {$ENDIF BigNumbers}
  end;

  TExpressionCalculatorCallbackType = ( ctGetValue, ctSetValue, ctFunction );
  TExpressionCalculatorCallback = function( ctype: TExpressionCalculatorCallbackType; const S: String; var Value: TExpressionCalculatorValue ): Boolean of object;

  TExpressionCalculatorNamedVariable = record
    Value : TExpressionCalculatorValue;
    Name  : array [ 0..0 ] of Char;
  end;
  PExpressionCalculatorNamedVariable = ^TExpressionCalculatorNamedVariable;

  TExpressionCalculator = class( TPersistent )
  private
    fLastError  : String;
    fPtr        : PChar;
    fMode       : TExpressionCalculatorMode;
    fResult     : TExpressionCalculatorValue;
    fsValue     : String;
    fToken      : TExpressionCalculatorToken;
    fCalcProc   : TExpressionCalculatorCallback;
    FExpression : String;
    FVars       : TList;
    { Default calculator callback proc }
    function    CalcProc( ctype: TExpressionCalculatorCallbackType; const S: String; var V: TExpressionCalculatorValue ): Boolean;
    { Calculate functions }
    function    start( var R: TExpressionCalculatorValue ) : Integer;
    function    Lex : Integer;
    function    term( var R: TExpressionCalculatorValue ) : Integer;
    function    Expression1( var R: TExpressionCalculatorValue ) : Integer;
    function    Expression2( var R: TExpressionCalculatorValue ) : Integer;
    function    Expression3( var R: TExpressionCalculatorValue ) : Integer;
    function    Expression4( var R: TExpressionCalculatorValue ) : Integer;
    function    Expression5( var R: TExpressionCalculatorValue ) : Integer;
    function    Expression6( var R: TExpressionCalculatorValue ) : Integer;

    function    GetResult: TExpressionCalculatorValue;
    function    GetVar( const Name: String ): TExpressionCalculatorValue;
    procedure   SetVar( const Name: String; value: TExpressionCalculatorValue );
  protected
    function    Callback( ctype: TExpressionCalculatorCallbackType; const Name: String; var Res: TExpressionCalculatorValue ): Boolean;
  public
    constructor Create;
    destructor  Destroy; override;
    function    NameOf( Index: Word ): String;
    procedure   ClearVars;
    property    Vars[ const Name: String ]: TExpressionCalculatorValue read GetVar Write SetVar;
    property    LastError  : String read fLastError;
    function    Calculate( var R: TExpressionCalculatorValue; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer; overload;
    function    CalculateSigned( var Value: Int64; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
    function    CalculateUnSigned( var Value: UInt64; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
    function    CalculateDouble( var Value: Double; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer; overload;
    {$IFDEF BigNumbers}
    function    CalculateBigInteger( var Value: BigInteger; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer; overload;
    function    CalculateBigDecimal( var Value: BigDecimal; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer; overload;
    {$ENDIF BigNumbers}
  published
    property    Mode       : TExpressionCalculatorMode  read fMode       write fMode;
    property    Expression : String                     read FExpression write FExpression;
    property    Result     : TExpressionCalculatorValue read GetResult;
  end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  TFrExpressionCalculator = class(TFrame)
    pnlMain: TPanel;
    grpExpression: TGroupBox;
    edtExpression: TEdit;
    btnClear: TButton;
    pnlResultTop: TPanel;
    splResultTop: TSplitter;
    grpOctal: TGroupBox;
    edtOctal: TEdit;
    grpBinary: TGroupBox;
    edtBinary: TEdit;
    pnlResultBottom: TPanel;
    splResultBottom: TSplitter;
    grpDecimal: TGroupBox;
    edtDecimal: TEdit;
    grpHexadecimal: TGroupBox;
    edtHexadecimal: TEdit;
    grpHistory: TGroupBox;
    rgMode: TRadioGroup;
    pnlHelp: TPanel;
    mmoHelp: TMemo;
    pnlHelpButton: TPanel;
    btnHelp: TButton;
    procedure   edtExpressionChange(Sender: TObject);
    procedure   KeyPressReadOnly(Sender: TObject; var Key: Char);
    procedure   edtExpressionKeyPress(Sender: TObject; var Key: Char);
    procedure   btnClearClick(Sender: TObject);
    procedure   HistoryOnDblClick(Sender : TObject);
    procedure   FrameResize(Sender: TObject);
    procedure   rgModeClick(Sender: TObject);
    procedure   btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    fCalculator : TExpressionCalculator;
    fHistory    : {$IFDEF uCheckStringGrid}TCheckStringGrid{$ELSE}TStringGrid{$ENDIF};
    fResult     : Integer;
  public
    { Public declarations }
    constructor Create( AOwner: TComponent ); override;
    destructor  Destroy; override;
    property    History : {$IFDEF uCheckStringGrid}TCheckStringGrid{$ELSE}TStringGrid{$ENDIF} read fHistory;
  end;

  TFrmCalculator = class( TForm )
  private
    fCalculator : TFrExpressionCalculator;
  public
    constructor CreateNew( AOwner: TComponent; Dummy: Integer  = 0 ); reintroduce;
  end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var
  Calculator    : TExpressionCalculator;
  FrmCalculator : TFrmCalculator;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
implementation

uses
  Windows, SysUtils, Math;

{$R *.dfm}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
const
  FUNCTION_NAMES : Array [ 0..60 ] of String = (
    'cycletograd',
    'gradtocycle',
    'cycletodeg',
    'cycletorad',
    'degtocycle',
    'radtocycle',
    'degtograd',
    'gradtodeg',
    'gradtorad',
    'radtograd',
    'cosecant',
    'degtorad',
    'radtodeg',
    'arccosh',
    'arccoth',
    'arccsch',
    'arcsech',
    'arcsinh',
    'arctanh',
    'sqrteps',
    'arccos',
    'arccot',
    'arccsc',
    'arcsec',
    'arcsin',
    'arctan',
    'secant',
    'cosec',
    'cotan',
    'floor',
    'lnxp1',
    'log10',
    'round',
    'trunc',
    'atan',
    'ceil',
    'cosh',
    'coth',
    'even',
    'frac',
    'log2',
    'sech',
    'sign',
    'sign',
    'sinh',
    'sqrt',
    'tanh',
    'xsgn',
    'abs',
    'cos',
    'eps',
    'exp',
    'int',
    'odd',
    'sec',
    'sgn',
    'sin',
    'sqr',
    'tan',
    'ln',
    'pi'
  );

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
constructor TExpressionCalculator.Create;
begin
  inherited Create;
  FVars := TList.Create;

  fPtr               := nil;
  fMode              := ecmSigned;
  fResult.Int64      := 0;
  {$IFDEF BigNumbers}
  fResult.BigInteger.RoundingMode := rmRound;
  fResult.BigInteger := 0;
  fResult.BigDecimal := 0;
  {$ENDIF BigNumbers}
  fsValue            := '';
  fToken             := tkERROR;
  fCalcProc          := CalcProc;
  FExpression        := '';
  fLastError         := '';
end;

destructor TExpressionCalculator.Destroy;
begin
  ClearVars;
  FVars.Free;
  inherited;
end;

function TExpressionCalculator.CalcProc( ctype: TExpressionCalculatorCallbackType; const S: String; var V: TExpressionCalculatorValue ): Boolean;
const
  EPS = 2.220446049250313E-16;
  SQRTEPS = 1.4901161194e-08; // SQRT( EPS )
begin
  Result := TRUE;
  case ctype of
    ctGetValue: begin
                if S = 'pi' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := Pi
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := Pi
                  {$ENDIF BigNumbers}
                  else
                    result := False;
                  end
                else if S = 'eps' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := EPS
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := EPS
                  {$ENDIF BigNumbers}
                  else
                    result := False;
                  end
                else if S = 'sqrteps' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := SQRTEPS
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := SQRTEPS
                  {$ENDIF BigNumbers}
                  else
                    result := False;
                  end
                else if S = 'e' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := 2.718281828
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := 2.718281828
                  {$ENDIF BigNumbers}
                  else
                    result := False;
                  end
                else
                  Result := FALSE;
                end;
    ctSetValue: Result := FALSE;
    ctFunction: begin
                if S = 'abs' then
                  begin
                  if ( fMode = ecmSigned ) then
                    V.Int64 := ABS( V.Int64 )
                  else if ( fMode = ecmUnSigned ) then
//                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
//                    V.UInt64 := ABS( V.UInt64 )
//                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                  else if ( fMode = ecmDouble ) then
                    V.Double := ABS( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    V.BigInteger := V.BigInteger.ABS
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.ABS;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'round' then
                  begin
//                  if ( fMode = ecmSigned ) then
//                  else if ( fMode = ecmUnSigned ) then
                  if ( fMode = ecmDouble ) then
                    V.Double := Round( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.RoundTo( 0 );
                  {$ENDIF BigNumbers}
                  end

                else if S = 'trunc' then
                  begin
//                  if ( fMode = ecmSigned ) then
//                  else if ( fMode = ecmUnSigned ) then
                  if ( fMode = ecmDouble ) then
                    V.Double := Trunc( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Int; //.Trunc;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'int' then
                  begin
//                  if ( fMode = ecmSigned ) then
//                  else if ( fMode = ecmUnSigned ) then
                  if ( fMode = ecmDouble ) then
                    V.Double := Int( V.Double )
                  {$IFDEF BigNumbers}
//                  else if ( fMode = ecmBigInteger ) then
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Int;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'frac' then
                  begin
                  if ( fMode = ecmSigned ) then
                    V.Int64 := 0
                  else if ( fMode = ecmUnSigned ) then
                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    V.UInt64 := 0
                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                  else if ( fMode = ecmDouble ) then
                    V.Double := Frac( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    V.BigInteger := 0
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Frac;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'sin' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := sin( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    result := false
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Sin
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'cos' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := cos( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Cos
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'tan' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := tan( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Tan
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'cotan' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := CoTan( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.CoTan
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if ( S = 'atan' ) OR ( S = 'arctan' ) then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcTan( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.ArcTan
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if ( S = 'sec' ) OR ( S = 'secant' ) then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := Secant( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Secant
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if ( S = 'cosec' ) OR ( S = 'cosecant' ) then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := CoSecant( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.CoSecant
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arcsin' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcSin( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.ArcSin
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arccos' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcCos( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.ArcCos
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arctanh' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcTanH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    try
                      V.BigDecimal := V.BigDecimal.ArcTanH;
                    except
                      result := false;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arcsec' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcSec( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    try
                      V.BigDecimal := V.BigDecimal.ArcSec;
                    except
                      result := false;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arccsc' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcCsc( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    try
                      V.BigDecimal := V.BigDecimal.ArcCsc;
                    except
                      result := false;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arccoth' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcCotH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    try
                      V.BigDecimal := V.BigDecimal.ArcCotH;
                    except
                      result := false;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arcsech' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcSecH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    try
                      V.BigDecimal := V.BigDecimal.ArcSecH;
                    except
                      result := false;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arccsch' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcCscH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    try
                      V.BigDecimal := V.BigDecimal.ArcCscH;
                    except
                      result := false;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'sinh' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := SinH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.SinH
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'cosh' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := CosH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.CosH
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arcsinh' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcSinH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.ArcSinH
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arccosh' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcCosH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.ArcCosH
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'tanh' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := TanH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.TanH
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'coth' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := CotH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.CotH
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'sech' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := SecH( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.SecH
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'arccot' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ArcCot( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.ArcCot
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'ln' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := ln( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Ln
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'exp' then
                  begin
                  if ( fMode = ecmDouble ) then
                    try
                      V.Double := exp( V.Double );
                    except
                      V.Double := 0;
                      fToken := tkERROR;
                    end
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.exp
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'sign' then
                  begin
                  if ( fMode = ecmSigned ) then
                    begin
                    if ( V.Int64 > 0 ) then
                      V.Int64 := 1
                    else if ( V.Int64 < 0 ) then
                      V.Int64 := -1;
                    end
                  else if ( fMode = ecmUnSigned ) then
                    result := false
                  else if ( fMode = ecmDouble ) then
                    begin
                    if ( V.Double > 0 ) then
                      V.Double := 1
                    else if ( V.Double < 0 ) then
                      V.Double := -1;
                    end
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    begin
                    if ( V.BigInteger > 0 ) then
                      V.BigInteger := 1
                    else if ( V.BigInteger < 0 ) then
                      V.BigInteger := -1;
                    end
                  else if ( fMode = ecmBigDecimal ) then
                    begin
                    if ( V.BigDecimal > 0 ) then
                      V.BigDecimal := 1
                    else if ( V.BigDecimal < 0 ) then
                      V.BigDecimal := -1;
                    end;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'sgn' then
                  begin
                  if ( fMode = ecmSigned ) then
                    begin
                    if ( V.Int64 > 0 ) then
                      V.Int64 := 1
                    else if ( V.Int64 < 0 ) then
                      V.Int64 := 0;
                    end
                  else if ( fMode = ecmUnSigned ) then
                    begin
                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    if ( V.UInt64 > 0 ) then
                      V.UInt64 := 1
                    else if ( V.UInt64 < 0 ) then
                      V.UInt64 := 0;
                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    end
                  else if ( fMode = ecmDouble ) then
                    begin
                    if ( V.Double > 0 ) then
                      V.Double := 1
                    else if ( V.Double < 0 ) then
                      V.Double := 0;
                    end
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    begin
                    if ( V.BigInteger > 0 ) then
                      V.BigInteger := 1
                    else if ( V.BigInteger < 0 ) then
                      V.BigInteger := 0;
                    end
                  else if ( fMode = ecmBigDecimal ) then
                    begin
                    if ( V.BigDecimal > 0 ) then
                      V.BigDecimal := 1
                    else if ( V.BigDecimal < 0 ) then
                      V.BigDecimal := 0;
                    end;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'xsgn' then
                  begin
                  if ( fMode = ecmSigned ) then
                    begin
                    if ( V.Int64 < 0 ) then
                      V.Int64 := 0;
                    end
                  else if ( fMode = ecmUnSigned ) then
                    begin
                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    if ( V.UInt64 < 0 ) then
                      V.UInt64 := 0;
                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    end
                  else if ( fMode = ecmDouble ) then
                    begin
                    if ( V.Double < 0 ) then
                      V.Double := 0;
                    end
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    begin
                    if ( V.BigInteger < 0 ) then
                      V.BigInteger := 0
                    end
                  else if ( fMode = ecmBigDecimal ) then
                    begin
                    if ( V.BigDecimal < 0 ) then
                      V.BigDecimal := 0;
                    end;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'ceil' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := Ceil( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    result := false
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Ceil
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'floor' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := Floor( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    result := false
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.Floor
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'sqr' then
                  begin
                  if ( fMode = ecmSigned ) then
                    V.Int64 := SQR( V.Int64 )
                  else if ( fMode = ecmUnSigned ) then
                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    V.UInt64 := SQR( V.UInt64 )
                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                  else if ( fMode = ecmDouble ) then
                    V.Double := SQR( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    V.BigInteger := V.BigInteger.SQR( V.BigInteger )
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.SQR;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'sqrt' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := SQRT( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    result := false
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.SQRT
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'even' then
                  begin
                  if ( fMode = ecmSigned ) then
                    begin
                    if NOT odd( V.Int64 ) then
                      V.Int64 := 1
                    else
                      V.Int64 := 0;
                    end
                  else if ( fMode = ecmUnSigned ) then
                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    begin
                    if NOT odd( V.UInt64 ) then
                      V.UInt64 := 1
                    else
                      V.UInt64 := 0;
                    end
                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    begin
                    if V.BigInteger.IsEven then
                      V.BigInteger := 1
                    else
                      V.BigInteger := 0;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'odd' then
                  begin
                  if ( fMode = ecmSigned ) then
                    begin
                    if odd( V.Int64 ) then
                      V.Int64 := 1
                    else
                      V.Int64 := 0;
                    end
                  else if ( fMode = ecmUnSigned ) then
                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                    begin
                    if odd( V.UInt64 ) then
                      V.UInt64 := 1
                    else
                      V.UInt64 := 0;
                    end
                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    begin
                    if V.BigInteger.IsOdd then
                      V.BigInteger := 1
                    else
                      V.BigInteger := 0;
                    end
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'sign' then
                  begin
                  if ( fMode = ecmSigned ) then
                    V.Int64 := sign( V.Int64 )
                  else if ( fMode = ecmUnSigned ) then
                    result := false
//                    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
//                    V.UInt64 := sign( V.UInt64 )
//                    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                  else if ( fMode = ecmDouble ) then
                    V.Double := sign( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigInteger ) then
                    V.BigInteger := V.BigInteger.sign
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.sign;
                  {$ENDIF BigNumbers}
                  end

                else if S = 'log2' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := log2( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.log2
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'log10' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := log10( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.log10
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'lnxp1' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := LnXP1( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.LnXP1
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'degtorad' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := DegToRad( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.DegToRad
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'radtodeg' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := RadToDeg( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.RadToDeg
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'gradtorad' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := GradToRad( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.GradToRad
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'radtograd' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := RadToGrad( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.RadToGrad
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'gradtodeg' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := GradToDeg( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.GradToDeg
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'gradtocycle' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := GradToCycle( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.GradToCycle
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'cycletodeg' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := CycleToDeg( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.CycleToDeg
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'cycletograd' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := CycleToGrad( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.CycleToGrad
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'cycletorad' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := CycleToRad( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.CycleToRad
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'radtocycle' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := RadToCycle( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.RadToCycle
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'degtograd' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := DegToGrad( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.DegToGrad
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end

                else if S = 'degtocycle' then
                  begin
                  if ( fMode = ecmDouble ) then
                    V.Double := DegToCycle( V.Double )
                  {$IFDEF BigNumbers}
                  else if ( fMode = ecmBigDecimal ) then
                    V.BigDecimal := V.BigDecimal.DegToCycle
                  {$ENDIF BigNumbers}
                  else
                    result := false;
                  end
                else
                  Result := FALSE;
                end;
  end;
end;

{ yylex like function }
function TExpressionCalculator.lex : Integer;
  function ConvertNumber( first, last: PChar; base: Word ): boolean;
  var
    c: Byte;
  begin
    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
    fResult.UInt64 := 0;
    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
    {$IFDEF BigNumbers}
    fResult.BigInteger := 0;
    fResult.BigDecimal := 0;
    {$ENDIF BigNumbers}
    if ( first^ = '' ) then
      begin
      result := False;
      Exit;
      end;
    while first < last do
      begin
      c := Ord( first^ ) - Ord( '0' );
      if ( c > 9 ) then
        begin
        Dec( c, Ord( 'A' ) - Ord( '9' ) - 1 );
        if ( c > 15 ) then
          Dec( c, Ord( 'a' ) - Ord( 'A' ) );
        end;
      if ( c >= base ) then
        break;

      if ( fMode = ecmSigned ) then
        fResult.Int64 := fResult.Int64 * base + c
      else if ( fMode = ecmUnSigned ) then
        {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
        fResult.UInt64 := fResult.UInt64 * base + c
        {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
      else if ( fMode = ecmDouble ) then
        fResult.Double := fResult.Double * base + c
      {$IFDEF BigNumbers}
      else if ( fMode = ecmBigInteger ) then
        fResult.BigInteger := fResult.BigInteger * base + c
      else if ( fMode = ecmBigDecimal ) then
        fResult.BigDecimal := fResult.BigDecimal * base + c
      {$ENDIF BigNumbers}
      ;

      Inc( first );
      end;
    Result := ( first = last );
  end;
var
  c, sign: char;
  frac: Double;
  exp: LongInt;
  s_pos: PChar;
  S : String;
  i : Integer;
  bFunc : Byte;
begin
  result := 0;
  { skip blanks }
  while fPtr^ <> #0 do
    begin
    if ( fPtr^ = #13 ) then
//      Inc( fLineNo )
    else if ( fPtr^ > ' ' ) then
      break;
    Inc( fPtr );
    end;

  { check EOF }
  fToken := tkEOF;
  if ( fPtr^ = #0 ) then
    Exit;

  s_pos := fPtr;

  S := LowerCase( fPtr );
  for i := Low( FUNCTION_NAMES ) to High( FUNCTION_NAMES ) do
    begin
    bFunc := Length( FUNCTION_NAMES[ i ] );
    if ( Copy( S, 1, bFunc ) = FUNCTION_NAMES[ i ] ) then
      begin
      fsValue := Copy( S, 1, bFunc );
      Inc( fPtr, bFunc );
      fToken := tkIDENT;
      Exit;
      end;
    end;

  fToken := tkNUMBER;      
  { match pascal like hex number }
  if ( fPtr^ = '$' ) then
    begin
    Inc( fPtr );
    s_pos := fPtr;
    while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9', 'A'..'H', 'a'..'h' ] ) do
      Inc( fPtr );
    if not ConvertNumber( s_pos, fPtr, 16 ) then
      begin
      fToken := tkERROR;
      result := -1;
      end;
    Exit;
    end;

  { match numbers }
  if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9', 'A'..'H', 'a'..'h' ] ) then
    begin
    { C like mathing }
    if ( fPtr^ = '0' ) then
      begin
      Inc( fPtr );

      { match C like hex number }
      if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'x', 'X' ] ) then
        begin
        Inc( fPtr );
        s_pos := fPtr;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9', 'A'..'H', 'a'..'h' ] ) do
          Inc( fPtr );
        if not ConvertNumber( s_pos, fPtr, 16 ) then
          begin
          fToken := tkERROR;
          result := -1;
          end;
        Exit;
        end;

      { match C like binary number }
      if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'b', 'B' ] ) then
        begin
        Inc( fPtr );
        s_pos := fPtr;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'1' ] ) do
          Inc( fPtr );
        if not ConvertNumber( s_pos, fPtr, 2 ) then
          begin
          fToken := tkERROR;
          result := -1;
          end;
        Exit;
        end;

      { match C like ordinal number }
      if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'o', 'O' ] ) then
        begin
        Inc( fPtr );
        s_pos := fPtr;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          Inc( fPtr );
        if not ConvertNumber( s_pos, fPtr, 8 ) then
          begin
          fToken := tkERROR;
          result := -1;
          end;
        Exit;
        end;
      end;

    while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9', 'A'..'F', 'a'..'f' ] ) do
      Inc( fPtr );

    { match assembler like hex number }
    if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'H', 'h' ] ) then
      begin
      if not ConvertNumber( s_pos, fPtr, 16 ) then
        begin
        fToken := tkERROR;
        result := -1;
        Exit;
        end;
      Inc( fPtr );
      Exit;
      end;

    { match assembler like binary number }
    Dec( fPtr );
    if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'B', 'b' ] ) then
      begin
      if not ConvertNumber( s_pos, fPtr, 2 ) then
        begin
        fToken := tkERROR;
        result := -1;
        Exit;
        end;
      Inc( fPtr, 2 );
      Exit;
      end;
    Inc( fPtr );

    { match assembler like ordinal number }
    if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'O', 'o' ] ) then
      begin
      if not ConvertNumber( s_pos, fPtr, 8 ) then
        begin
        fToken := tkERROR;
        result := -1;
        Exit;
        end;
      Inc( fPtr );
      Exit;
      end;

    { match simple decimal number }
    if not ConvertNumber( s_pos, fPtr, 10 ) then
      begin
      fToken := tkERROR;
      result := -1;
      Exit;
      end;

    { match degree number }
    if ( fPtr^ = '`' ) then
      begin
      if ( fMode = ecmDouble ) then
        begin
        fResult.Double := fResult.Double * Pi / 180.0;
        Inc( fPtr );
        frac := 0;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          begin
          frac := frac * 10 + ( Ord( fPtr^ ) - Ord( '0' ) );
          Inc( fPtr );
          end;
        fResult.Double := fResult.Double + ( frac * Pi / 180.0 / 60 );
        if ( fPtr^ = '`' ) then
          begin
          Inc( fPtr );
          frac := 0;
          while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
            begin
            frac := frac * 10 + ( Ord( fPtr^ ) - Ord( '0' ) );
            Inc( fPtr );
            end;
          fResult.Double := fResult.Double + ( frac * Pi / 180.0 / 60 / 60 );
          end;
        fResult.Double := fResult.Double - Int( fResult.Double / 2*Pi ) * 2*Pi;
        end
      {$IFDEF BigNumbers}
      else if ( fMode = ecmBigDecimal ) then
        begin
        fResult.BigDecimal := fResult.BigDecimal * Pi / 180.0;
        Inc( fPtr );
        frac := 0;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          begin
          frac := frac * 10 + ( Ord( fPtr^ ) - Ord( '0' ) );
          Inc( fPtr );
          end;
        fResult.BigDecimal := fResult.BigDecimal + ( frac * Pi / 180.0 / 60 );
        if ( fPtr^ = '`' ) then
          begin
          Inc( fPtr );
          frac := 0;
          while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
            begin
            frac := frac * 10 + ( Ord( fPtr^ ) - Ord( '0' ) );
            Inc( fPtr );
            end;
          fResult.BigDecimal := fResult.BigDecimal + ( frac * Pi / 180.0 / 60 / 60 );
          end;

        fResult.BigDecimal := fResult.BigDecimal - ( fResult.BigDecimal / 2*Pi ).Int * 2*Pi;
        end
      {$ENDIF BigNumbers}
      else
        begin
        fToken := tkERROR;
        result := -1;
        end;

      Exit;
      end;

    { match float numbers }
    if ( fPtr^ = FormatSettings.DecimalSeparator{'.'} ) then
      begin
      if ( fMode = ecmDouble ) then
        begin
        Inc( fPtr );
        frac := 1;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          begin
          frac := frac / 10;
          fResult.Double := fResult.Double + frac * ( Ord( fPtr^ ) - Ord( '0' ) );
          Inc( fPtr );
          end;
        end
      {$IFDEF BigNumbers}
      else if ( fMode = ecmBigDecimal ) then
        begin
        Inc( fPtr );
        frac := 1;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          begin
          frac := frac / 10;
          fResult.BigDecimal := fResult.BigDecimal + frac * ( Ord( fPtr^ ) - Ord( '0' ) );
          Inc( fPtr );
          end;
        end
      {$ENDIF BigNumbers}
      else
        begin
        fToken := tkERROR;
        result := -1;
        end;
      end;

    if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'E', 'e' ] ) then
      begin
      if ( fMode = ecmDouble ) then
        begin
        Inc( fPtr );
        exp := 0;
        sign := fPtr^;
        if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '+', '-' ] ) then
          Inc( fPtr );
        if not {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) then
          begin
          fToken := tkERROR;
          result := -1;
          Exit;
          end;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          begin
          exp := exp * 10 + Ord( fPtr^ ) - Ord( '0' );
          Inc( fPtr );
          end;
        if ( exp = 0 ) then
          fResult.Double := 1.0
        else if ( sign = '-' ) then
          while exp > 0 do
            begin
            fResult.Double := fResult.Double * 10;
            Dec( exp );
            end
        else
          while exp > 0 do
            begin
            fResult.Double := fResult.Double / 10;
            Dec( exp );
            end;
        end
      {$IFDEF BigNumbers}
      else if ( fMode = ecmBigDecimal ) then
        begin
        Inc( fPtr );
        exp := 0;
        sign := fPtr^;
        if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '+', '-' ] ) then
          Inc( fPtr );
        if not {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) then
          begin
          fToken := tkERROR;
          result := -1;
          Exit;
          end;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          begin
          exp := exp * 10 + Ord( fPtr^ ) - Ord( '0' );
          Inc( fPtr );
          end;
        if ( exp = 0 ) then
          fResult.BigDecimal := 1.0
        else if ( sign = '-' ) then
          while exp > 0 do
            begin
            fResult.BigDecimal := fResult.BigDecimal * 10;
            Dec( exp );
            end
        else
          while exp > 0 do
            begin
            fResult.BigDecimal := fResult.BigDecimal / 10;
            Dec( exp );
            end;
        end
      {$ENDIF BigNumbers}
      else
        begin
        fToken := tkERROR;
        result := -1;
        end;
      end;
      
    Exit;
    end;

  { match identifiers }
  if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'A'..'Z','a'..'z','_' ] ) then
    begin
    fsValue := fPtr^;
    Inc( fPtr );
    while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'A'..'Z','a'..'z','0'..'9' ] ) and
          ( Length( fsValue ) < sizeof( fsValue )-1 ) do
      begin
      fsValue := fsValue + fPtr^;
      Inc( fPtr );
      end;

    S := LowerCase( fsValue );
    if ( S = 'not' ) then
      fToken := tkNOT
    else if ( S = 'and' ) then
      fToken := tkAND
    else if ( S = 'or' ) then
      fToken := tkOR
    else if ( S = 'xor' ) then
      fToken := tkXOR
    else if ( S = 'mod' ) then
      fToken := tkMOD
    else
      fToken := tkIDENT;
    Exit;
    end;
 
  { match operators }
  c := fPtr^;
  Inc( fPtr );
  case c of
    '=': begin
         if ( fPtr^ = '=' ) then
           begin
           Inc( fPtr );
           fToken := tkEqual;
           end
         else
           fToken := tkASSIGN;
         end;
    '+': fToken := tkADD;
    '-': fToken := tkSUB;
    '*': begin
         if ( fPtr^ = '*' ) then
           begin
           Inc( fPtr );
           fToken := tkPower;
           end
         else
           fToken := tkMUL;
         end;
    '/': fToken := tkDIV;
    '%': begin
         if ( fPtr^ = '%' ) then
           begin
           Inc( fPtr );
           fToken := tkPER;
           end
         else
           fToken := tkMOD;
         end;
    '~': fToken := tkInverse;
    '^': fToken := tkXOR;
    '&': fToken := tkAND;
    '|': fToken := tkOR;
    '<': begin
         if ( fPtr^ = '=' ) then
           begin
           Inc( fPtr );
           fToken := tkLessEqual;
           end
         else if ( fPtr^ = '>' ) then
           begin
           Inc( fPtr );
           fToken := tkNotEqual;
           end
         else if ( fPtr^ = '<' ) then
           begin
           Inc( fPtr );
           fToken := tkShiftLeft;
           end
         else
           fToken := tkLess;
         end;
    '>': begin
         if ( fPtr^ = '=' ) then
           begin
           Inc( fPtr );
           fToken := tkGreaterEqual;
           end
         else if ( fPtr^ = '>' ) then
           begin
           Inc( fPtr );
           fToken := tkShiftRight;
           end
         else
           fToken := tkGreater;
         end;
    '!': begin
         if ( fPtr^ = '=' ) then
           begin
           Inc( fPtr );
           fToken := tkNotEqual;
           end
         else
           fToken := tkNOT;
         end;
    '(': fToken := tkLBRACE;
    ')': fToken := tkRBRACE;
    ';': fToken := tkSEMICOLON
  else
    fToken := tkERROR;
    dec( fPtr );
  end;
end;

// LL grammatic for calculator, priorities from down to up
//
// start: Expression6;
// Expression6: Expression5 { & Expression5 | ^ Expression5 | & Expression5 }*;
// Expression5: Expression4 { < Expression4 | > Expression4 | <= Expression4 | >= Expression4 | != Expression4 | == Expression4 }*;
// Expression4: Expression3 { + Expression3 | - Expression3 }*;
// Expression3: Expression2 { * Expression2 | / Expression2 | % Expression2 | %% Expression2 }*;
// Expression2: Expression1 { ! Expression1 | ~ Expression1 | - Expression1 | + Expression1 };
// Expression1: term ** term
// term: tkNUMBER | tkIDENT | ( start ) | tkIDENT( start ) | tkIDENT = start;
//
function TExpressionCalculator.term( var R: TExpressionCalculatorValue ) : Integer;
var
  S: String;
begin
  case fToken of
    tkNUMBER: begin
              R := fResult;
              Result := lex;
              if ( result < 0 ) then
                Exit;
              end;
    tkLBRACE: begin
              Result := lex;
              if ( result < 0 ) then
                Exit;
              result := Expression6( R );
              if ( result < 0 ) then
                Exit;
              if ( fToken = tkRBRACE ) then
                lex
              else
                result := -1;
              end;
    tkIDENT: begin
             S := LowerCase( fsValue );
             Result := lex;
             if ( result < 0 ) then
               Exit;
             if fToken = tkLBRACE then
               begin
                Result := lex;
                if ( result < 0 ) then
                  Exit;
               result := Expression6( R );
               if ( result < 0 ) then
                 Exit;
               if ( fToken = tkRBRACE ) then
                 begin
                 Result := lex;
                 if ( result < 0 ) then
                   Exit;
                 end
               else
                 result     := -1;
               if not fCalcProc( ctFunction, s, R ) then
                 begin
                 fLastError := s;
                 result     := -2;
                 end;
               end
             else if ( fToken = tkASSIGN ) then
               begin
               Result := lex;
               if ( result < 0 ) then
                 Exit;
               result := Expression6( R );
               if ( result < 0 ) then
                 Exit;
               if not fCalcProc( ctSetValue, s, R ) then
                 begin
                 fLastError := s;
                 result     := -2;
                 end;
               end
             else if not fCalcProc( ctGetValue, s, R ) then
               begin
               fLastError := s;
               result     := -2;
               end;
             end;
  else
    result := -1;
  end;
end;

function TExpressionCalculator.Expression1( var R: TExpressionCalculatorValue ) : Integer;
var
  V: TExpressionCalculatorValue;
begin
  result := term( R );
  if ( result < 0 ) then
    Exit;

  if ( fToken = tkPower ) then
    begin
//    if ( fMode <> ecmDouble ) then
//      begin
//      result := -1;
//      Exit;
//      end;

    result := lex;
    if ( result < 0 ) then
      Exit;
    result := term( V );
    if ( result < 0 ) then
      Exit;

    if ( fMode = ecmSigned ) then
      begin
      if ( R.Int64 = 0 ) then
        R.Int64 := 1
      else
        R.Int64 := Round( Exp( Ln( R.Int64 )*V.Int64 ) );
      end
    else if ( fMode = ecmUnSigned ) then
      begin
      {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
      if ( R.UInt64 = 0 ) then
        R.UInt64 := 1
      else
        R.UInt64 := Round( Exp( Ln( R.UInt64 )*V.UInt64 ) );
      {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
      end
    else if ( fMode = ecmDouble ) then
      begin
      if ( R.Double = 0 ) then
        R.Double := 1.0
      else
        R.Double := Exp( Ln( R.Double )*V.Double );
      end
    {$IFDEF BigNumbers}
    else if ( fMode = ecmBigInteger ) then
      begin
      if ( R.BigInteger = 0 ) then
        R.BigInteger := 1
      else
        R.BigInteger := R.BigInteger.Exp( R.BigInteger.Ln * V.BigInteger.AsInt64 );
      end
    else if ( fMode = ecmBigDecimal ) then
      begin
      if ( R.BigDecimal = 0 ) then
        R.BigDecimal := 1.0
      else
        begin
        if ( R.BigDecimal.Precision = 1 ) AND ( V.BigDecimal.Precision = 1 ) then
          R.BigDecimal := R.BigDecimal.Exp( R.BigDecimal.Ln*V.BigDecimal ).RoundTo( 0, rmNearestUp )
        else
          R.BigDecimal := R.BigDecimal.Exp( R.BigDecimal.Ln*V.BigDecimal );
        end;
      end
    {$ENDIF BigNumbers}
    end;
end;

function TExpressionCalculator.Expression2( var R: TExpressionCalculatorValue ) : Integer;
var
  oldt: TExpressionCalculatorToken;
begin
  if ( fToken in [ tkNOT, tkInverse, tkADD, tkSUB ] ) then
    begin
    oldt := fToken;
    result := lex;
    if ( result < 0 ) then
      Exit;
    result := Expression2( R );
    if ( result < 0 ) then
      Exit;
    case oldt of
      tkNOT: begin
             if ( fMode = ecmSigned ) then
               begin
               if not( Boolean( R.Int64 ) ) then
                 R.Int64 := 1
               else
                 R.Int64 := 0;
               end
             else if ( fMode = ecmUnSigned ) then
               begin
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               if not( Boolean( R.UInt64 ) ) then
                 R.UInt64 := 1
               else
                 R.UInt64 := 0;
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
               end
             else if ( fMode = ecmDouble ) then
               begin
               if not( Boolean( Trunc( R.Double ) ) ) then
                 R.Double := 1.0
               else
                 R.Double := 0.0
               end
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               begin
               if ( R.BigInteger = 0 ) then
                 R.BigInteger := 1
               else
                 R.BigInteger := 0
               end
             else if ( fMode = ecmBigDecimal ) then
               begin
               if ( R.BigDecimal = 0 ) then
                 R.BigDecimal := 1.0
               else
                 R.BigDecimal := 0.0
               end
             {$ENDIF BigNumbers}
             end;
      tkInverse: begin
                 if ( fMode = ecmSigned ) then
                   R.Int64 := ( not R.Int64 )
                 else if ( fMode = ecmUnSigned ) then
                   {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                   R.UInt64 := ( not R.UInt64 )
                   {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                 else if ( fMode = ecmDouble ) then
                   R.Double := ( not Trunc( R.Double ) )
                 {$IFDEF BigNumbers}
                 else if ( fMode = ecmBigInteger ) then
                   R.BigInteger := R.BigInteger.Negate( R.BigInteger )
                 else if ( fMode = ecmBigDecimal ) then
                   R.BigDecimal := R.BigDecimal.Negate( R.BigDecimal.Int{Trunc} );
                 {$ENDIF BigNumbers}
                 end;
      tkADD: ;
      tkSUB: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := -R.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := -R.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := -R.Double
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := -R.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := -R.BigDecimal;
             {$ENDIF BigNumbers}
             end;
    end;
    end
  else
    result := Expression1( R );
end;

function TExpressionCalculator.Expression3( var R: TExpressionCalculatorValue ) : Integer;
var
  V: TExpressionCalculatorValue;
  oldt: TExpressionCalculatorToken;
begin
  result := Expression2( R );
  if ( result < 0 ) then
    Exit;
  while fToken in [ tkMUL, tkDIV, tkMOD, tkPER, tkShiftLeft, tkShiftRight ] do
    begin
    oldt := fToken;
    result := lex;
    if ( result < 0 ) then
      Exit;
    result := Expression2( V );
    if ( result < 0 ) then
      Exit;
    case oldt of
      tkMUL: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 * V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 * V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := R.Double * V.Double
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger * V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal * V.BigDecimal;
             {$ENDIF BigNumbers}
             end;
      tkDIV: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 div V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 div V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := R.Double / V.Double
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger div V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal / V.BigDecimal;
             {$ENDIF BigNumbers}
             end;
      tkMOD: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 mod V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 mod V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := Trunc( R.Double ) mod Trunc( V.Double )
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger mod V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal mod V.BigDecimal;
             {$ENDIF BigNumbers}
             end;
      tkPER: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 * V.Int64 div 100
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 * V.UInt64 div 100
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := R.Double * V.Double / 100.0
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger * V.BigInteger div 100
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal * V.BigDecimal / 100.0
             {$ENDIF BigNumbers}
             end;

      tkShiftLeft  : begin
                     if ( fMode = ecmSigned ) then
                       R.Int64 := R.Int64 SHL V.Int64
                     else if ( fMode = ecmUnSigned ) then
                       {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                       R.UInt64 := R.UInt64 SHL V.UInt64
                       {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                     else if ( fMode = ecmDouble ) then
//                       R.Double := R.Double SHL Trunc( V.Double )
//                       {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
//                       R.UInt64 := R.UInt64 SHL Trunc( V.Double )
//                       {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                       R.Double := Trunc( R.Double ) SHL Trunc( V.Double )
                     {$IFDEF BigNumbers}
                     else if ( fMode = ecmBigInteger ) then
                       R.BigInteger := R.BigInteger SHL V.BigInteger
                     else if ( fMode = ecmBigDecimal ) then
//                       R.BigDecimal := R.BigDecimal.AsBigInteger SHL V.BigDecimal.AsInt32
                       R.BigDecimal := R.BigDecimal.Int.AsBigInteger SHL V.BigDecimal.AsInt32
                     {$ENDIF BigNumbers}
                     end;

      tkShiftRight : begin
                     if ( fMode = ecmSigned ) then
                       R.Int64 := R.Int64 SHR V.Int64
                     else if ( fMode = ecmUnSigned ) then
                       {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                       R.UInt64 := R.UInt64 SHR V.UInt64
                       {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                     else if ( fMode = ecmDouble ) then
//                       R.Double := R.Double SHR Trunc( V.Double )
//                       {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
//                       R.UInt64 := R.UInt64 SHR Trunc( V.Double )
//                       {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                       R.Double := Trunc( R.Double ) SHR Trunc( V.Double )
                     {$IFDEF BigNumbers}
                     else if ( fMode = ecmBigInteger ) then
                       R.BigInteger := R.BigInteger SHR V.BigInteger
                     else if ( fMode = ecmBigDecimal ) then
//                       R.BigDecimal := R.BigDecimal.AsBigInteger SHR V.BigDecimal.AsInt32
                       R.BigDecimal := R.BigDecimal.Int.AsBigInteger SHR V.BigDecimal.AsInt32
                     {$ENDIF BigNumbers}
                     end;
    end;
    end;
end;

function TExpressionCalculator.Expression4( var R: TExpressionCalculatorValue ) : Integer;
var
  V: TExpressionCalculatorValue;
  oldt: TExpressionCalculatorToken;
begin
  result := Expression3( R );
  if ( result < 0 ) then
    Exit;
  while fToken in [ tkADD, tkSUB ] do
    begin
    oldt := fToken;
    result := lex;
    if ( result < 0 ) then
      Exit;
    result := Expression3( V );
    if ( result < 0 ) then
      Exit;
    case oldt of
      tkADD: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 + V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 + V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := R.Double + V.Double
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger + V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal + V.BigDecimal
             {$ENDIF BigNumbers}
             end;
      tkSUB: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 - V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 - V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := R.Double - V.Double
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger - V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal - V.BigDecimal
             {$ENDIF BigNumbers}
             end;
    end;
    end;
end;

function TExpressionCalculator.Expression5( var R: TExpressionCalculatorValue ) : Integer;
var
  V: TExpressionCalculatorValue;
  oldt: TExpressionCalculatorToken;
begin
  result := Expression4( R );
  if ( result < 0 ) then
    Exit;
  while fToken in [ tkLess, tkLessEqual, tkEqual, tkNotEqual, tkGreaterEqual, tkGreater ] do
    begin
    oldt := fToken;
    result := lex;
    if ( result < 0 ) then
      Exit;
//    Expression4( V );
//    result := Expression4( V );
    result := Expression2( V );
    if ( result < 0 ) then
      Exit;
    case oldt of
      tkLess         : begin
                       if ( fMode = ecmSigned ) then
                         begin
                         if ( R.Int64 < V.Int64 ) then
                           R.Int64 := 1
                         else
                           R.Int64 := 0;
                         end
                       else if ( fMode = ecmUnSigned ) then
                         begin
                         {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         if ( R.UInt64 < V.UInt64 ) then
                           R.UInt64 := 1
                         else
                           R.UInt64 := 0;
                         {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         end
                       else if ( fMode = ecmDouble ) then
                         begin
                         if ( R.Double < V.Double ) then
                           R.Double := 1.0
                         else
                           R.Double := 0.0;
                         end
                       {$IFDEF BigNumbers}
                       else if ( fMode = ecmBigInteger ) then
                         begin
                         if ( R.BigInteger < V.BigInteger ) then
                           R.BigInteger := 1
                         else
                           R.BigInteger := 0;
                         end
                       else if ( fMode = ecmBigDecimal ) then
                         begin
                         if ( R.BigDecimal < V.BigDecimal ) then
                           R.BigDecimal := 1.0
                         else
                           R.BigDecimal := 0.0;
                         end
                       {$ENDIF BigNumbers}
                       end;
      tkLessEqual    : begin
                       if ( fMode = ecmSigned ) then
                         begin
                         if ( R.Int64 <= V.Int64 ) then
                           R.Int64 := 1
                         else
                           R.Int64 := 0;
                         end
                       else if ( fMode = ecmUnSigned ) then
                         begin
                         {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         if ( R.UInt64 <= V.UInt64 ) then
                           R.UInt64 := 1
                         else
                           R.UInt64 := 0;
                         {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         end
                       else if ( fMode = ecmDouble ) then
                         begin
                         if ( R.Double <= V.Double ) then
                           R.Double := 1.0
                         else
                           R.Double := 0.0;
                         end
                       {$IFDEF BigNumbers}
                       else if ( fMode = ecmBigInteger ) then
                         begin
                         if ( R.BigInteger <= V.BigInteger ) then
                           R.BigInteger := 1
                         else
                           R.BigInteger := 0;
                         end
                       else if ( fMode = ecmBigDecimal ) then
                         begin
                         if ( R.BigDecimal <= V.BigDecimal ) then
                           R.BigDecimal := 1.0
                         else
                           R.BigDecimal := 0.0;
                         end
                       {$ENDIF BigNumbers}
                       end;
      tkEqual        : begin
                       if ( fMode = ecmSigned ) then
                         begin
                         if ( R.Int64 = V.Int64 ) then
                           R.Int64 := 1
                         else
                           R.Int64 := 0;
                         end
                       else if ( fMode = ecmUnSigned ) then
                         begin
                         {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         if ( R.UInt64 = V.UInt64 ) then
                           R.UInt64 := 1
                         else
                           R.UInt64 := 0;
                         {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         end
                       else if ( fMode = ecmDouble ) then
                         begin
                         if ( R.Double = V.Double ) then
                           R.Double := 1.0
                         else
                           R.Double := 0.0;
                         end
                       {$IFDEF BigNumbers}
                       else if ( fMode = ecmBigInteger ) then
                         begin
                         if ( R.BigInteger = V.BigInteger ) then
                           R.BigInteger := 1
                         else
                           R.BigInteger := 0;
                         end
                       else if ( fMode = ecmBigDecimal ) then
                         begin
                         if ( R.BigDecimal = V.BigDecimal ) then
                           R.BigDecimal := 1.0
                         else
                           R.BigDecimal := 0.0;
                         end
                       {$ENDIF BigNumbers}
                       end;
      tkNotEqual     : begin
                       if ( fMode = ecmSigned ) then
                         begin
                         if ( R.Int64 <> V.Int64 ) then
                           R.Int64 := 1
                         else
                           R.Int64 := 0;
                         end
                       else if ( fMode = ecmUnSigned ) then
                         begin
                         {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         if ( R.UInt64 <> V.UInt64 ) then
                           R.UInt64 := 1
                         else
                           R.UInt64 := 0;
                         {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         end
                       else if ( fMode = ecmDouble ) then
                         begin
                         if ( R.Double <> V.Double ) then
                           R.Double := 1.0
                         else
                           R.Double := 0.0;
                         end
                       {$IFDEF BigNumbers}
                       else if ( fMode = ecmBigInteger ) then
                         begin
                         if ( R.BigInteger <> V.BigInteger ) then
                           R.BigInteger := 1
                         else
                           R.BigInteger := 0;
                         end
                       else if ( fMode = ecmBigDecimal ) then
                         begin
                         if ( R.BigDecimal <> V.BigDecimal ) then
                           R.BigDecimal := 1.0
                         else
                           R.BigDecimal := 0.0;
                         end
                       {$ENDIF BigNumbers}
                       end;
      tkGreaterEqual : begin
                       if ( fMode = ecmSigned ) then
                         begin
                         if ( R.Int64 >= V.Int64 ) then
                           R.Int64 := 1
                         else
                           R.Int64 := 0;
                         end
                       else if ( fMode = ecmUnSigned ) then
                         begin
                         {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         if ( R.UInt64 >= V.UInt64 ) then
                           R.UInt64 := 1
                         else
                           R.UInt64 := 0;
                         {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         end
                       else if ( fMode = ecmDouble ) then
                         begin
                         if ( R.Double >= V.Double ) then
                           R.Double := 1.0
                         else
                           R.Double := 0.0;
                         end
                       {$IFDEF BigNumbers}
                       else if ( fMode = ecmBigInteger ) then
                         begin
                         if ( R.BigInteger >= V.BigInteger ) then
                           R.BigInteger := 1
                         else
                           R.BigInteger := 0;
                         end
                       else if ( fMode = ecmBigDecimal ) then
                         begin
                         if ( R.BigDecimal >= V.BigDecimal ) then
                           R.BigDecimal := 1.0
                         else
                           R.BigDecimal := 0.0;
                         end
                       {$ENDIF BigNumbers}
                       end;
      tkGreater      : begin
                       if ( fMode = ecmSigned ) then
                         begin
                         if ( R.Int64 > V.Int64 ) then
                           R.Int64 := 1
                         else
                           R.Int64 := 0;
                         end
                       else if ( fMode = ecmUnSigned ) then
                         begin
                         {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         if ( R.UInt64 > V.UInt64 ) then
                           R.UInt64 := 1
                         else
                           R.UInt64 := 0;
                         {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
                         end
                       else if ( fMode = ecmDouble ) then
                         begin
                         if ( R.Double > V.Double ) then
                           R.Double := 1.0
                         else
                           R.Double := 0.0;
                         end
                       {$IFDEF BigNumbers}
                       else if ( fMode = ecmBigInteger ) then
                         begin
                         if ( R.BigInteger > V.BigInteger ) then
                           R.BigInteger := 1
                         else
                           R.BigInteger := 0;
                         end
                       else if ( fMode = ecmBigDecimal ) then
                         begin
                         if ( R.BigDecimal > V.BigDecimal ) then
                           R.BigDecimal := 1.0
                         else
                           R.BigDecimal := 0.0;
                         end
                       {$ENDIF BigNumbers}
                       end;
    end;
    end;
end;

function TExpressionCalculator.Expression6( var R: TExpressionCalculatorValue ) : Integer;
var
  V: TExpressionCalculatorValue;
  oldt: TExpressionCalculatorToken;
begin
  result := Expression5( R );
  if ( result < 0 ) then
    Exit;
  while fToken in [ tkOR, tkXOR, tkAND ] do
    begin
    oldt := fToken;
    result := lex;
    if ( result < 0 ) then
      Exit;
    result := Expression5( V );
    if ( result < 0 ) then
      Exit;

    case oldt of
      tkOR : begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 or V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 or V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := Trunc( R.Double ) or Trunc( V.Double )
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger or V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal.AsBigInteger{Trunc} or V.BigDecimal.AsBigInteger{Trunc}
             {$ENDIF BigNumbers}
             end;
      tkAND: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 and V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 and V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := Trunc( R.Double ) and Trunc( V.Double )
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger and V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal.AsBigInteger{Trunc} and V.BigDecimal.AsBigInteger{Trunc}
             {$ENDIF BigNumbers}
             end;
      tkXOR: begin
             if ( fMode = ecmSigned ) then
               R.Int64 := R.Int64 xor V.Int64
             else if ( fMode = ecmUnSigned ) then
               {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
               R.UInt64 := R.UInt64 xor V.UInt64
               {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
             else if ( fMode = ecmDouble ) then
               R.Double := Trunc( R.Double ) xor Trunc( V.Double )
             {$IFDEF BigNumbers}
             else if ( fMode = ecmBigInteger ) then
               R.BigInteger := R.BigInteger xor V.BigInteger
             else if ( fMode = ecmBigDecimal ) then
               R.BigDecimal := R.BigDecimal.AsBigInteger{Trunc} xor V.BigDecimal.AsBigInteger{Trunc}
             {$ENDIF BigNumbers}
             end;
    end;
    end;
end;

function TExpressionCalculator.start( var R: TExpressionCalculatorValue ) : Integer;
begin
  result := Expression6( R );
  if ( result < 0 ) then
    Exit;
  while ( fToken = tkSEMICOLON ) do
    begin
    Result := lex;
    if ( result < 0 ) then
      Exit;
    result := Expression6( R );
    if ( result < 0 ) then
      Exit;
    end;
  if not ( fToken = tkEOF ) then
    result := -1
  else
    result := 0;
end;

function TExpressionCalculator.Calculate( var R: TExpressionCalculatorValue; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
{
  -1 = Syntax error
  -2 = Unknown function or variable, see LastError for Name
}
begin
  if ( Expression = '' ) then
    Expression := FExpression;

  if ( @Proc = Nil ) then
    fCalcProc := CalcProc
  else
    fCalcProc := Proc;

  R.Int64 := 0;
  {$IFDEF BigNumbers}
  R.BigInteger := 0;
  R.BigDecimal := 0;
  {$ENDIF BigNumbers}

  fLastError := '';
  if ( Expression = '' ) then
    begin
    result := 0;
    Exit;
    end;

  fPtr := PChar( Expression );
  Result := lex;
  if ( result < 0 ) then
    Exit;
  Result := start( R );
end;

function TExpressionCalculator.CalculateSigned( var Value: Int64; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
var
  M : TExpressionCalculatorMode;
  R : TExpressionCalculatorValue;
begin
  M := fMode;
  fMode := ecmSigned;
  Result := Calculate( R, Expression, Proc );
  fMode := M;
  if ( result < 0 ) then
    begin
    Value := 0;
    Exit;
    end;

  Value := R.Int64;
end;

function TExpressionCalculator.CalculateUnSigned( var Value: UInt64; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
var
  M : TExpressionCalculatorMode;
  R : TExpressionCalculatorValue;
begin
  M := fMode;
  fMode := ecmUnSigned;
  Result := Calculate( R, Expression, Proc );
  fMode := M;
  if ( result < 0 ) then
    begin
    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
    Value := 0;
    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
    Exit;
    end;

  {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
  Value := R.UInt64;
  {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
end;

function TExpressionCalculator.CalculateDouble( var Value: Double; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
var
  M : TExpressionCalculatorMode;
  R : TExpressionCalculatorValue;
begin
  M := fMode;
  fMode := ecmDouble;
  Result := Calculate( R, Expression, Proc );
  fMode := M;
  if ( result < 0 ) then
    begin
    Value := 0;
    Exit;
    end;

  Value := R.Double;
end;

{$IFDEF BigNumbers}
function TExpressionCalculator.CalculateBigInteger( var Value: BigInteger; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
var
  M : TExpressionCalculatorMode;
  R : TExpressionCalculatorValue;
begin
  M := fMode;
  fMode := ecmBigInteger;
  Result := Calculate( R, Expression, Proc );
  fMode := M;
  if ( result < 0 ) then
    begin
    Value := 0;
    Exit;
    end;

  Value := R.BigInteger;
end;

function TExpressionCalculator.CalculateBigDecimal( var Value: BigDecimal; Expression: String = ''; Proc: TExpressionCalculatorCallback = nil ): Integer;
var
  M : TExpressionCalculatorMode;
  R : TExpressionCalculatorValue;
begin
  M := fMode;
  fMode := ecmBigDecimal;
  Result := Calculate( R, Expression, Proc );
  fMode := M;
  if ( result < 0 ) then
    begin
    Value := 0;
    Exit;
    end;

  Value := R.BigDecimal;
end;
{$ENDIF BigNumbers}

// TExpressionCalculator component
procedure TExpressionCalculator.SetVar( const Name: String; value: TExpressionCalculatorValue );
var
  i: SmallInt;
  V: PExpressionCalculatorNamedVariable;
begin
  i := 0;
  V := nil;
  while ( i < FVars.Count-1 ) do
    begin
    V := FVars[ i ];
    if StrComp( V^.Name, PChar( Name ) ) = 0 then
      Break;
    Inc( i );
    end;
  if ( i = FVars.Count ) then
    begin
    GetMem( V, sizeof( TExpressionCalculatorNamedVariable )+Length( Name ) );
    FVars.Add( V );
    StrPCopy( V^.Name, Name )
    end;
  V^.Value := Value;
end;

function TExpressionCalculator.GetVar( const Name: String ): TExpressionCalculatorValue;
var
  i: SmallInt;
  V: PExpressionCalculatorNamedVariable;
begin
  result.Int64 := 0;
  fLastError := '';
  for i := 0 to FVars.Count-1 do
    begin
    V := FVars[ i ];
    if StrComp( V^.Name, PChar( Name ) ) = 0 then
      begin
      Result.Int64 := V^.Value.Int64;
      Exit;
      end;
    end;
  fLastError := name;
//  result     := -2;
end;

function TExpressionCalculator.GetResult: TExpressionCalculatorValue;
begin
  calculate( Result, FExpression, Callback );
end;

function TExpressionCalculator.Callback( ctype: TExpressionCalculatorCallbackType; const Name: String; var Res: TExpressionCalculatorValue ): Boolean;
begin
  Result := CalcProc( ctype, name, Res );
  if Result then
    Exit;
  Result := TRUE;
  case ctype of
    ctGetValue : Res := Vars[ Name ];
    ctSetValue : Vars[ Name ] := Res;
    ctFunction : Result := FALSE;
  end;
end;

function TExpressionCalculator.NameOf( Index: Word ): String;
begin
  Result := StrPas( PExpressionCalculatorNamedVariable( FVars[ Index ] )^.Name );
end;

procedure TExpressionCalculator.ClearVars;
var
  i: Integer;
  V: PExpressionCalculatorNamedVariable;
begin
  for i := 0 to FVars.Count-1 do
    begin
    V := FVars[ i ];
    FreeMem( V, sizeof( TExpressionCalculatorNamedVariable )+StrLen( V^.Name ) );
    FVars[ i ] := Nil;
    end;
  FVars.Clear;
end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
constructor TFrExpressionCalculator.Create( AOwner: TComponent );
var
  i : Integer;
begin
  inherited;
  fCalculator := TExpressionCalculator.Create;
  fResult     := -1;

  fHistory                  := {$IFDEF uCheckStringGrid}TCheckStringGrid{$ELSE}TStringGrid{$ENDIF}.Create( grpHistory );
  fHistory.Parent           := grpHistory;
  fHistory.Align            := alClient;
  fHistory.RowCount         := 1;
  fHistory.ColCount         := 6;
  fHistory.FixedCols        := 1;
  fHistory.FixedRows        := 0;
  fHistory.Cells[ 0, 0 ]    := 'ID';
  fHistory.Cells[ 1, 0 ]    := 'Expression';
  fHistory.Cells[ 2, 0 ]    := 'Binary';
  fHistory.Cells[ 3, 0 ]    := 'Octal';
  fHistory.Cells[ 4, 0 ]    := 'Decimal';
  fHistory.Cells[ 5, 0 ]    := 'Hexadecimal';
  fHistory.OnDblClick       := HistoryOnDblClick;
  fHistory.OnKeyPress       := KeyPressReadOnly;
  {$IFDEF uCheckStringGrid}
  fHistory.MenuEnabled      := False;
  fHistory.SortColMode[ 0 ] := scmDefault;
  fHistory.Options := fHistory.Options + [ goEditing ];
  for i := 0 to fHistory.ColCount-1 do
    begin
    fHistory.TextFormat[ i, 0 ] := DT_CENTER;
    fHistory.ReadOnlyCol[ i ]   := True;
    end;
  fHistory.InflateColumns;
  {$ENDIF uCheckStringGrid}

  {$IFDEF BigNumbers}
  rgMode.Items.Add( 'BigInteger' );
  rgMode.Items.Add( 'BigDecimal' );
  rgMode.Columns := 5;
  {$ENDIF BigNumbers}
end;

destructor TFrExpressionCalculator.Destroy;
begin
  fCalculator.free;

  inherited;
end;

procedure TFrExpressionCalculator.FrameResize(Sender: TObject);
begin
  {$IFDEF uCheckStringGrid}
  fHistory.InflateColumns;
  {$ENDIF uCheckStringGrid}

  grpBinary.Width  := pnlResultTop.Width div 2;
  grpDecimal.Width := pnlResultBottom.Width div 2;
end;

procedure TFrExpressionCalculator.KeyPressReadOnly(Sender: TObject; var Key: Char);
begin
  {$IFDEF uTLH_ComponentTools}
  OnKeyPressCheckChar( Sender, Key, kpmReadOnly );
  {$ELSE}
  Key := #0;
  {$ENDIF uTLH_ComponentTools}
end;

procedure TFrExpressionCalculator.rgModeClick(Sender: TObject);
begin
  if ( TRadioGroup( Sender ).ItemIndex < 0 ) then
    Exit;
  fCalculator.Mode := TExpressionCalculatorMode( TRadioGroup( Sender ).ItemIndex );
  edtExpressionChange( edtExpression );
end;

procedure TFrExpressionCalculator.btnHelpClick(Sender: TObject);
const
  DEFAULT_WIDTH = 260;
begin
  if ( pnlHelp.Width = pnlHelpButton.Width ) then
    begin
    pnlHelp.Width := DEFAULT_WIDTH;
    TButton( Sender ).Caption := '>';
    end
  else
    begin
    pnlHelp.Width := pnlHelpButton.Width;
    TButton( Sender ).Caption := '<';
    end;

  FrameResize( Sender );
end;

procedure TFrExpressionCalculator.edtExpressionChange(Sender: TObject);
  type
    TNumericalSystem = (
      nsBinary      = 2,
      nsOctal       = 8,
      nsDecimal     = 10,
      nsHexadecimal = 16
    );
  function ConvertNumericalString( const Value : String; const InputSystem : TNumericalSystem; const OutputSystem : TNumericalSystem ) : String;
  const
    DigitList : Array [ 0..15 ] of Char = ( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' );
    NumberMap : Array [ #48..#57 ] of Byte = ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ); // 0..9
    UpperMap  : Array [ #65..#70 ] of Byte = ( 10, 11, 12, 13, 14, 15 ); // A..F
    LowerMap  : Array [ #97..#102 ] of Byte = ( 10, 11, 12, 13, 14, 15 ); // a..f
  var
    v : UInt64;
    vi : Int64 absolute v;
    i : Integer;
    si : Integer;
    C : Char;
    t : Byte;
    Neg : Boolean;
  begin
    result := '';
    if ( Value = '' ) then
      Exit;
    if ( InputSystem = OutputSystem ) then
      begin
      result := Value;
      Exit;
      end;

    if ( Copy( Value, 1, 1 ) = '-' ) then
      begin
      Neg := True;
//      Value := Copy( Value, 2, Length( Value )-1 );
      si := 2;
      end
    else
      begin
      Neg := False;
      si := 1;
      end;

    {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
    v := 0;
    {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
    for i := si to Length( Value ) do
      begin
      C := Value[ i ];
      if ( C >= Low( NumberMap ) ) AND ( C <= High( NumberMap ) ) then
        t := NumberMap[ C ]
      else if ( C >= Low( UpperMap ) ) AND ( C <= High( UpperMap ) ) then
        t := UpperMap[ C ]
      else if ( C >= Low( LowerMap ) ) AND ( C <= High( LowerMap ) ) then
        t := LowerMap[ C ]
      else
        Exit;

      {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
      v := v * Byte( InputSystem ) + t;
      {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
      end;

    if v = 0 then
      begin
      result := '0';
      exit;
      end;

    if Neg then
      Vi := Vi*-1;

    while ( v > 0 ) do
      begin
      {$IF CompilerVersion <= 20}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
      result := DigitList[ v mod Byte( OutputSystem ) ] + result;
      v := v div Byte( OutputSystem );
      {$IF CompilerVersion <= 20}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
      end;
  end;

  function PointerToHex( P : Pointer; TypeSize : Byte; BigEndian : boolean = false ): string;
  const
    HexTable : Array[ 0..15 ] of Char = ( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' );
  type
    TBytes = Array [ 0..0 ] of Byte;
    PBytes = ^TBytes;
  var
    Bytes : PBytes absolute P;
    i     : Integer;
  begin
    result := '';
    if ( P = nil ) then
      Exit;

    if BigEndian then
      begin
      for i := Low( Bytes^ ) To TypeSize-1 do
        {$R-}
        result := result +  HexTable[ Bytes^[ i ] div 16 ] + HexTable[ Bytes^[ i ] mod 16 ];
        {$R+}
      end
    else
      begin
      for i := TypeSize-1 downTo Low( Bytes^ ) do
        {$R-}
        result := result +  HexTable[ Bytes^[ i ] div 16 ] + HexTable[ Bytes^[ i ] mod 16 ];
        {$R+}
      end;

    i := Pos( ' ', Result );
    while ( i <> 0 ) do
      begin
      Result[ I ] := '0';
      i := Pos( ' ', Result );
      end;
  end;
var
  Val  : TExpressionCalculatorValue;
  S    : String;
  sHex : String;
  LF   : TFormatSettings;
begin
  {$IF CompilerVersion >= 30}
  LF := TFormatSettings.Create( LOCALE_SYSTEM_DEFAULT );
  {$ELSE}
  GetLocaleFormatSettings( LOCALE_SYSTEM_DEFAULT, LF );
  {$IFEND}

  fCalculator.Expression := TEdit( Sender ).Text;
  fResult := fCalculator.Calculate( Val );
  case fResult of
     0 : begin
         case fCalculator.Mode of
           ecmSigned     : begin
                           S := IntToStr( Val.Int64 );
                           sHex := PointerToHex( @Val.Int64, SizeOf( Val.Int64 ) );
                           end;
           ecmUnsigned   : begin
                           S := UIntToStr( Val.UInt64 );
                           sHex := PointerToHex( @Val.UInt64, SizeOf( Val.UInt64 ) );
                           end;
           ecmDouble     : begin
//                           S := Format( '%f', [ Val.Double ] );
                           S := FloatToStr( Val.Double );
                           sHex := PointerToHex( @Val.Double, SizeOf( Val.Double ) );
                           end;
           {$IFDEF BigNumbers}
           ecmBigInteger : begin
                           S := Val.BigInteger.ToString;
                           sHex := Val.BigInteger.ToHexString;
                           end;
           ecmBigDecimal : begin
                           S := Val.BigDecimal.ToString( LF );
                           sHex := Val.BigDecimal.ToHexString;
                           end;
           {$ENDIF BigNumbers}
         end;

         while ( Copy( sHex, 1, 2 ) = '00' ) AND ( Length( sHex ) > 2 ) do
           sHex := Copy( sHex, 3, Length( sHex )-2 );
         end;
    -1 : S := 'Syntax error';
    -2 : S := 'Unknown function or variable "' + fCalculator.LastError + '"';
  else
    S := '';
  end;

  if ( fResult = 0 ) then
    begin
    {$IFDEF BigNumbers}
    if ( fCalculator.Mode = ecmBigInteger ) then
      begin
      edtBinary.Text    := Val.BigInteger.ToBinaryString;
      edtOctal.Text     := Val.BigInteger.ToOctalString;
      end
    else if ( fCalculator.Mode = ecmBigDecimal ) then
      begin
      edtBinary.Text    := Val.BigDecimal.ToBinaryString;
      edtOctal.Text     := Val.BigDecimal.ToOctalString;
      end
    else
    {$ENDIF BigNumbers}
      begin
      edtBinary.Text    := ConvertNumericalString( sHex, nsHexadecimal, nsBinary );
      edtOctal.Text     := ConvertNumericalString( sHex, nsHexadecimal, nsOctal );
      end;
    edtDecimal.Text     := S;
    edtHexadecimal.Text := '0x' + sHex;
    end
  else
    begin
    edtBinary.Text      := S;
    edtOctal.Text       := S;
    edtDecimal.Text     := S;
    edtHexadecimal.Text := S;
    end
end;

procedure TFrExpressionCalculator.edtExpressionKeyPress(Sender: TObject; var Key: Char);
var
  i : Integer;
begin
  if ( Key = #13 ) then
    begin
    if ( fResult = 0 ) then
      begin
      fHistory.RowCount  := fHistory.RowCount+1;
      fHistory.Cells[ 0, fHistory.RowCount-1 ] := IntToStr( fHistory.RowCount-1 );
      fHistory.Cells[ 1, fHistory.RowCount-1 ] := edtExpression.Text;
      fHistory.Cells[ 2, fHistory.RowCount-1 ] := edtBinary.Text;
      fHistory.Cells[ 3, fHistory.RowCount-1 ] := edtOctal.Text;
      fHistory.Cells[ 4, fHistory.RowCount-1 ] := edtDecimal.Text;
      fHistory.Cells[ 5, fHistory.RowCount-1 ] := edtHexadecimal.Text;

      {$IFDEF uCheckStringGrid}
      for i := 0 to fHistory.ColCount-1 do
        fHistory.TextFormat[ i, fHistory.RowCount-1 ] := DT_CENTER;
      {$ENDIF uCheckStringGrid}

      if ( fHistory.RowCount = 2 ) then
        begin
        fHistory.FixedRows := 1;
        {$IFDEF uCheckStringGrid}
        fHistory.InflateColumns;
        {$ENDIF uCheckStringGrid}
        end;
      {$IFDEF uCheckStringGrid}
      fHistory.Sort( fHistory.SortCol, fHistory.SortDescending );
      {$ENDIF uCheckStringGrid}
      end;

    Key := #0;
    end;
end;

procedure TFrExpressionCalculator.btnClearClick(Sender: TObject);
var
  b : Boolean;
begin
  if ( fHistory.RowCount > 1 ) then
    begin
    {$IFDEF uCheckStringGrid}
    fHistory.Clear;
    {$ENDIF uCheckStringGrid}

    fHistory.RowCount := 1;

    {$IFDEF uCheckStringGrid}
    fHistory.InflateColumns;

    b := fHistory.SortDescending;
    if b then
      fHistory.Sort( 0, b );
    {$ENDIF uCheckStringGrid}
    end;
end;

procedure TFrExpressionCalculator.HistoryOnDblClick(Sender : TObject);
var
  C : {$IFDEF uCheckStringGrid}TCheckStringGrid{$ELSE}TStringGrid{$ENDIF};
begin
  C := {$IFDEF uCheckStringGrid}TCheckStringGrid{$ELSE}TStringGrid{$ENDIF}( Sender );
  case C.Col of
    1,
    4 : edtExpression.Text := C.Cells[ C.Col, C.Row ];
    2 : edtExpression.Text := {'0b' + }C.Cells[ C.Col, C.Row ] + 'b';
    3 : edtExpression.Text := {'0o' + }C.Cells[ C.Col, C.Row ] + 'o';
    5 : edtExpression.Text := {'0x' + }C.Cells[ C.Col, C.Row ]{ + 'h'};
  end;
end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
constructor TFrmCalculator.CreateNew(AOwner: TComponent; Dummy: Integer  = 0);
begin
  inherited;
  Caption            := 'Calculator';

  fCalculator        := TFrExpressionCalculator.Create( self );
  fCalculator.Parent := self;
  fCalculator.Align  := alClient;
end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

initialization
  Calculator    := TExpressionCalculator.Create;
  FrmCalculator := TFrmCalculator.CreateNew( Application );

finalization
  Calculator.Free;

end.
