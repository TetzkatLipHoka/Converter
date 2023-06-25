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

  Error Codes
     0 = Success
    -1 = Syntax error
    -2 = Unknown function or variable, see LastError for Name
*)

interface

{$DEFINE uCheckStringGrid}
{$DEFINE uTLH_ComponentTools}

uses
  Classes, Controls, ExtCtrls, Forms, StdCtrls, Grids
  {$IFDEF uCheckStringGrid}
  ,uCheckStringGrid
  {$ENDIF uCheckStringGrid}
  {$IFDEF uTLH_ComponentTools}
  ,uTLH.ComponentTools
  {$ENDIF uTLH_ComponentTools}
  ;

type
  TToken = (
    { } tkEOF, tkERROR, tkASSIGN,
    {7} tkLBRACE, tkRBRACE, tkNUMBER, tkIDENT, tkSEMICOLON,
    {6} tkPower,
    {5} tkInverse, tkNOT,
    {4} tkMUL, tkDIV, tkMOD, tkPER,
    {3} tkADD, tkSUB,
    {2} tkLess, tkLessEqual, tkEqual, tkNotEqual, tkGreaterEqual, tkGreater,
    {1} tkOR, tkXOR, tkAND
  );

  TCalcCBType = ( ctGetValue, ctSetValue, ctFunction );
  TCalcCBProc = function( ctype: TCalcCBType; const S: String; var Value: Double ): Boolean of object;

  PNamedVar = ^TNamedVar;
  TNamedVar = record
    Value : Double;
    Name  : array [ 0..0 ] of Char;
  end;

  TExpressionCalculator = class( TPersistent )
  private
    fLastError  : String;
    fPtr        : PChar;
    fResult     : Double;
    fsValue     : String;
    fToken      : TToken;
    fCalcProc   : TCalcCBProc;
    FExpression : String;
    FVars       : TList;
    { Default calculator callback proc }
    function    CalcProc( ctype: TCalcCBType; const S: String; var V: Double ): Boolean;
    { Calculate functions }
    function    Calculate( const Expression: String; var R: Double; Proc: TCalcCBProc = nil ): Integer; overload;
    function    start( var R: Double ) : Integer;
    function    Lex : Integer;
    function    term( var R: Double ) : Integer;
    function    Expression1( var R: Double ) : Integer;
    function    Expression2( var R: Double ) : Integer;
    function    Expression3( var R: Double ) : Integer;
    function    Expression4( var R: Double ) : Integer;
    function    Expression5( var R: Double ) : Integer;
    function    Expression6( var R: Double ) : Integer;

    function    GetResult: Double;
    function    GetVar( const Name: String ): Double;
    procedure   SetVar( const Name: String; value: Double );
  protected
    function    Callback( ctype: TCalcCBType; const Name: String; var Res: Double ): Boolean;
  public
    constructor Create;
    destructor  Destroy; override;
    function    NameOf( Index: Word ): String;
    procedure   ClearVars;
    property    Vars[ const Name: String ]: Double read GetVar Write SetVar;
    property    LastError  : String read fLastError;
    function    Calculate( var R: Double; const Expression: String = '' ): Integer; overload;
  published
    property    Expression : String read FExpression Write FExpression;
    property    Result     : Double read GetResult;
  end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  TFrExpressionCalculator = class(TFrame)
    grpExpression: TGroupBox;
    edtExpression: TEdit;
    btnClear: TButton;
    pnlResultTop: TPanel;
    grpOctal: TGroupBox;
    edtOctal: TEdit;
    grpBinary: TGroupBox;
    edtBinary: TEdit;
    splResultTop: TSplitter;
    pnlResultBottom: TPanel;
    grpDecimal: TGroupBox;
    edtDecimal: TEdit;
    splResultBottom: TSplitter;
    grpHexadecimal: TGroupBox;
    edtHexadecimal: TEdit;
    grpHistory: TGroupBox;
    procedure   edtExpressionChange(Sender: TObject);
    procedure   KeyPressReadOnly(Sender: TObject; var Key: Char);
    procedure   edtExpressionKeyPress(Sender: TObject; var Key: Char);
    procedure   btnClearClick(Sender: TObject);
    procedure   HistoryOnDblClick(Sender : TObject);
    procedure   FrameResize(Sender: TObject);
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
  Windows, SysUtils;

{$R *.dfm}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
constructor TExpressionCalculator.Create;
begin
  inherited Create;
  FVars := TList.Create;

  fPtr        := nil;
  fResult     := 0;
  fsValue     := '';
  fToken      := tkERROR;
  fCalcProc   := CalcProc;
  FExpression := '';
  fLastError  := '';
end;

destructor TExpressionCalculator.Destroy;
begin
  ClearVars;
  FVars.Free;
  inherited;
end;

function TExpressionCalculator.CalcProc( ctype: TCalcCBType; const S: String; var V: Double ): Boolean;
begin
  Result := TRUE;
  case ctype of
    ctGetValue: begin
                if S = 'pi' then
                  V := Pi
                else if S = 'e' then
                  V := 2.718281828
                else
                  Result := FALSE;
                end;
    ctSetValue: Result := FALSE;
    ctFunction: begin
                if S = 'round' then
                  V := Round( V )
                else if S = 'trunc' then
                  V := Trunc( V )
                else if S = 'int' then
                  V := Int( V )
                else if S = 'frac' then
                  V := Frac( V )
                else if S = 'sin' then
                  V := sin( V )
                else if S = 'cos' then
                  V := cos( V )
                else if S = 'tan' then
                  V := sin( V )/cos( V )
                else if S = 'atan' then
                  V := arctan( V )
                else if S = 'ln' then
                  V := ln( V )
                else if S = 'exp' then
                  V := exp( V )
                else if S = 'sign' then
                  begin
                  if ( V>0 ) then
                    V := 1
                  else if( V<0 ) then
                    V := -1
                  end
                else if S = 'sgn' then
                  begin
                  if ( V>0 ) then
                    V := 1
                  else if( V<0 ) then
                    V := 0
                  end
                else if S = 'xsgn' then
                  begin
                  if( V<0 ) then
                    V := 0
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
    fResult := 0;
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
      fResult := fResult * base + c;
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
      fResult := fResult * Pi / 180.0;
      Inc( fPtr ); frac := 0;
      while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
        begin
        frac := frac * 10 + ( Ord( fPtr^ ) - Ord( '0' ) );
        Inc( fPtr );
        end;
      fResult := fResult + ( frac * Pi / 180.0 / 60 );
      if ( fPtr^ = '`' ) then
        begin
        Inc( fPtr ); frac := 0;
        while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
          begin
          frac := frac * 10 + ( Ord( fPtr^ ) - Ord( '0' ) );
          Inc( fPtr );
          end;
        fResult := fResult + ( frac * Pi / 180.0 / 60 / 60 );
        end;
      fResult := fResult - Int( fResult / 2*Pi ) * 2*Pi;
      Exit;
      end;

    { match float numbers }
    if ( fPtr^ = '.' ) then
      begin
      Inc( fPtr );
      frac := 1;
      while {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ '0'..'9' ] ) do
         begin
        frac := frac / 10;
        fResult := fResult + frac * ( Ord( fPtr^ ) - Ord( '0' ) );
        Inc( fPtr );
        end;
      end;

    if {$IF CompilerVersion >= 20}CharInSet( fPtr^,{$ELSE}( fPtr^ in{$IFEND} [ 'E', 'e' ] ) then
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
        fResult := 1.0
      else if ( sign = '-' ) then
        while exp > 0 do
          begin
          fResult := fResult * 10;
          Dec( exp );
          end
      else
        while exp > 0 do
          begin
          fResult := fResult / 10;
          Dec( exp );
          end
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
        fToken := tkASSIGN;
        if ( fPtr^ = '=' ) then
          begin
          Inc( fPtr );
          fToken := tkEqual;
          end;
        end;
    '+': fToken := tkADD;
    '-': fToken := tkSUB;
    '*': begin
         fToken := tkMUL;
         if ( fPtr^ = '*' ) then
           begin
           Inc( fPtr );
           fToken := tkPower;
           end;
         end;
    '/': fToken := tkDIV;
    '%': begin
         fToken := tkMOD;
         if ( fPtr^ = '%' ) then
            begin
            Inc( fPtr );
            fToken := tkPER;
            end;
         end;
    '~': fToken := tkInverse;
    '^': fToken := tkXOR;
    '&': fToken := tkAND;
    '|': fToken := tkOR;
    '<': begin
         fToken := tkLess;
         if ( fPtr^ = '=' ) then
           begin
           Inc( fPtr );
           fToken := tkLessEqual;
           end
         else if ( fPtr^ = '>' ) then
           begin
           Inc( fPtr );
           fToken := tkNotEqual;
           end;
         end;
    '>': begin
         fToken := tkGreater;
         if ( fPtr^ = '=' ) then
           begin
           Inc( fPtr );
           fToken := tkGreaterEqual;
           end
         else if ( fPtr^ = '<' ) then
           begin
           Inc( fPtr );
           fToken := tkNotEqual;
           end;
         end;
    '!': begin
         fToken := tkNOT;
         if ( fPtr^ = '=' ) then
           begin
           Inc( fPtr );
           fToken := tkNotEqual;
           end;
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
function TExpressionCalculator.term( var R: Double ) : Integer;
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

function TExpressionCalculator.Expression1( var R: Double ) : Integer;
var
  V: Double;
begin
  result := term( R );
  if ( result < 0 ) then
    Exit;
  if ( fToken = tkPower ) then
    begin
    result := lex;
    if ( result < 0 ) then
      Exit;
    result := term( V );
    if ( result < 0 ) then
      Exit;
    if ( R = 0 ) then
      R := 1.0
    else
      R := Exp( Ln( R )*V );
    end;
end;

function TExpressionCalculator.Expression2( var R: Double ) : Integer;
var
  oldt: TToken;
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
             if not( Boolean( Trunc( R ) ) ) then
               R := 1.0
             else
               R := 0.0;
             end;
      tkInverse: R := ( not Trunc( R ) );
      tkADD: ;
      tkSUB: R := -R;
    end;
    end
  else
    result := Expression1( R );
end;

function TExpressionCalculator.Expression3( var R: Double ) : Integer;
var
  V: Double;
  oldt: TToken;
begin
  result := Expression2( R );
  if ( result < 0 ) then
    Exit;
  while fToken in [ tkMUL, tkDIV, tkMOD, tkPER ] do
    begin
    oldt := fToken;
    result := lex;
    if ( result < 0 ) then
      Exit;
    result := Expression2( V );
    if ( result < 0 ) then
      Exit;
    case oldt of
      tkMUL: R := R * V;
      tkDIV: R := R / V;
      tkMOD: R := Trunc( R ) mod Trunc( V );
      tkPER: R := R * V / 100.0;
    end;
    end;
end;

function TExpressionCalculator.Expression4( var R: Double ) : Integer;
var
  V: Double;
  oldt: TToken;
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
      tkADD: R := R + V;
      tkSUB: R := R - V;
    end;
    end;
end;

function TExpressionCalculator.Expression5( var R: Double ) : Integer;
var
  V: Double;
  oldt: TToken;
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
    Expression4( V );
    result := Expression4( V );
    if ( result < 0 ) then
      Exit;
    case oldt of
      tkLess         : begin
                       if ( R < V ) then
                         R := 1.0
                       else
                         R := 0.0;
                       end;
      tkLessEqual    : begin
                       if ( R <= V ) then
                         R := 1.0
                       else
                         R := 0.0;
                       end;
      tkEqual        : begin
                       if ( R = V ) then
                         R := 1.0
                       else
                         R := 0.0;
                       end;
      tkNotEqual     : begin
                       if ( R <> V ) then
                         R := 1.0
                       else
                         R := 0.0;
                       end;
      tkGreaterEqual : begin
                       if ( R >= V ) then
                         R := 1.0
                       else
                         R := 0.0;
                       end;
      tkGreater      : begin
                       if ( R > V ) then
                         R := 1.0
                       else
                         R := 0.0;
                       end;
    end;
    end;
end;

function TExpressionCalculator.Expression6( var R: Double ) : Integer;
var
  V: Double;
  oldt: TToken;
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
      tkOR : R := Trunc( R ) or  Trunc( V );
      tkAND: R := Trunc( R ) and Trunc( V );
      tkXOR: R := Trunc( R ) xor Trunc( V );
    end;
    end;
end;

function TExpressionCalculator.start( var R: Double ) : Integer;
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

function TExpressionCalculator.Calculate( const Expression: String; var R: Double; Proc: TCalcCBProc = nil ): Integer;
{
  -1 = Syntax error
  -2 = Unknown function or variable, see LastError for Name
}
begin
  if ( @Proc = Nil ) then
    fCalcProc := CalcProc
  else
    fCalcProc := Proc;

  R := 0;

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

function TExpressionCalculator.Calculate( var R: Double; const Expression: String = '' ): Integer;
begin
  if ( Expression <> '' ) then
    Result := Calculate( Expression, R )
  else
    Result := Calculate( FExpression, R );
end;

// TExpressionCalculator component
procedure TExpressionCalculator.SetVar( const Name: String; value: Double );
var
  i: SmallInt;
  V: PNamedVar;
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
    GetMem( V, sizeof( TNamedVar )+Length( Name ) );
    FVars.Add( V );
    StrPCopy( V^.Name, Name )
    end;
  V^.Value := Value;
end;

function TExpressionCalculator.GetVar( const Name: String ): Double;
var
  i: SmallInt;
  V: PNamedVar;
begin
  result := 0;
  fLastError := '';
  for i := 0 to FVars.Count-1 do
    begin
    V := FVars[ i ];
    if StrComp( V^.Name, PChar( Name ) ) = 0 then
      begin
      Result := V^.Value;
      Exit;
      end;
    end;
  fLastError := name;
//  result     := -2;
end;

function TExpressionCalculator.GetResult: Double;
begin
  calculate( FExpression, Result, Callback );
end;

function TExpressionCalculator.Callback( ctype: TCalcCBType; const Name: String; var Res: Double ): Boolean;
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
  Result := StrPas( PNamedVar( FVars[ Index ] )^.Name );
end;

procedure TExpressionCalculator.ClearVars;
var
  i: Integer;
  V: PNamedVar;
begin
  for i := 0 to FVars.Count-1 do
    begin
    V := FVars[ i ];
    FreeMem( V, sizeof( TNamedVar )+StrLen( V^.Name ) );
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
  D    : Double;
  I    : Int64;
  S    : String;
  sHex : String;
begin
  fCalculator.Expression := TEdit( Sender ).Text;
  fResult := fCalculator.Calculate( D );
  case fResult of
     0 : begin
         I := Trunc( D );
         if ( I = D ) then
           begin
           S := Format( '%d', [ I ] );
           sHex := PointerToHex( @I, SizeOf( I ) );
           end
         else
           begin
           S := Format( '%f', [ D ] );
           sHex := PointerToHex( @D, SizeOf( D ) );
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
    edtBinary.Text      := ConvertNumericalString( sHex, nsHexadecimal, nsBinary );
    edtOctal.Text       := ConvertNumericalString( sHex, nsHexadecimal, nsOctal );
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
