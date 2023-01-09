unit uFrASMCalculator;

interface

{$DEFINE uTLH_ComponentTools}

{$WARN UNSAFE_CODE OFF}

{$IF CompilerVersion > 23}
  {$LEGACYIFEND ON}
{$IFEND}

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls, CheckLst, Messages
  {$IFDEF uTLH_ComponentTools}, uTLH.ComponentTools{$ENDIF}
  ;

type
  TFrASMCalculator = class(TFrame)
    pnlASMRight: TPanel;
    chklstCPUFlags: TCheckListBox;
    pnlASMJumps: TPanel;
    lblASMJump_JO: TLabel;
    lblASMJump_JNO: TLabel;
    lblASMJump_JS: TLabel;
    lblASMJump_JNS: TLabel;
    lblASMJump_JP_JPE: TLabel;
    lblASMJump_JNP_JPO: TLabel;
    lblASMJump_JE_JZ: TLabel;
    lblASMJump_JNE_JNZ: TLabel;
    lblASMJump_JA_JNBE: TLabel;
    lblASMJump_JB_JNAE_JC: TLabel;
    lblASMJump_JAE_JNB_JNC: TLabel;
    lblASMJump_JBE_JNA: TLabel;
    lblASMJump_JG_JNLE: TLabel;
    lblASMJump_JL_JNGE: TLabel;
    lblASMJump_JGE_JNL: TLabel;
    lblASMJump_JLE_JNG: TLabel;
    pnlASMCPUFlags: TPanel;
    lbledtASMCPUFlags: TLabeledEdit;
    pnlASMLeft: TPanel;
    pnlASMOperands: TPanel;
    splASMOperands: TSplitter;
    grpOperand1: TGroupBox;
    lbledtASMHex1: TLabeledEdit;
    lbledtASMTyped1: TLabeledEdit;
    btnASMOperand1Result: TButton;
    lbledtASMBinary1: TLabeledEdit;
    grpOperand2: TGroupBox;
    lbledtASMHex2: TLabeledEdit;
    lbledtASMTyped2: TLabeledEdit;
    btnASMOperand2Result: TButton;
    lbledtASMBinary2: TLabeledEdit;
    grpResult: TGroupBox;
    lbledtASMHex3: TLabeledEdit;
    lbledtASMTyped3: TLabeledEdit;
    lbledtASMBinary3: TLabeledEdit;
    chkASMSigned: TCheckBox;
    rgASMArchitecture: TRadioGroup;
    pnlCaption: TPanel;
    lblASMOperation: TLabel;
    btnASMSwap: TButton;
    pnlOperation: TPanel;
    rgASMOperator: TRadioGroup;
    chkASMCarryFlag: TCheckBox;
    grpASMShift: TGroupBox;
    lbledtASMShift: TLabeledEdit;
    procedure chklstCPUFlagsClickCheck(Sender: TObject);
    procedure lbledtASMCPUFlagsKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtASMCPUFlagsChange(Sender: TObject);
    procedure lbledtASMTypedKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtASMTypedChange(Sender: TObject);
    procedure lbledtASMHexChange(Sender: TObject);
    procedure rgASMOperatorClick(Sender: TObject);
    procedure chkASMSignedClick(Sender: TObject);
    procedure btnASMOperandResultClick(Sender: TObject);
    procedure ASMHexKeyPress(Sender: TObject; var Key: Char);
    procedure ASMHexKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnASMSwapClick(Sender: TObject);
    procedure pnlASMOperandsResize(Sender: TObject);
    procedure lbledtASMShiftChange(Sender: TObject);
    procedure rgASMArchitectureClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure KeyPressReadOnly(Sender: TObject; var Key: Char);
    procedure OnBeforePasteTyped( Sender: TObject; var s: String; var StopPaste : boolean );
    procedure OnBeforePasteHex( Sender: TObject; var s: String; var StopPaste : boolean );
    procedure OnBeforePasteReadOnly( Sender: TObject; var s: String; var StopPaste : boolean );
    procedure lbledtASMTypedKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbledtASMTypedKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbledtASMHexKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    {$IF DECLARED( uTLH.ComponentTools )}
    function  GetMouseMode : Boolean;
    procedure SetMouseMode( Value : Boolean );
    {$IFEND}
    procedure UpdateCPUFlagLabels( Sender: TObject );

    {$IF DECLARED( uTLH.ComponentTools )}
    procedure OnMouseWheelVerticalHex( Sender : TObject; Msg : TWMMouseWheel );
    procedure OnMouseWheelVerticalTyped( Sender : TObject; Msg : TWMMouseWheel );
    {$IFEND}
  public
    { Public-Deklarationen }
    constructor Create( AOwner: TComponent ); override;
    procedure ASMCalculator;
    {$IF DECLARED( uTLH.ComponentTools )}
    property  MouseMode : Boolean read GetMouseMode write SetMouseMode;
    {$IFEND}
  end;

implementation

uses
  Windows, SysUtils,
  uTLH.Strings, uTLH.Numeral,
  uASMCalculator;

{$R *.dfm}

constructor TFrASMCalculator.Create( AOwner: TComponent );
begin
  inherited;

  chklstCPUFlagsClickCheck( chklstCPUFlags );
  rgASMOperatorClick( rgASMOperator );
  {$IFNDEF Win64}
  rgASMArchitecture.ItemIndex := 0;
  rgASMArchitecture.Visible := false;
  chkASMCarryFlag.Top := rgASMOperator.Top-2;
  btnASMSwap.Top      := lblASMOperation.Top;
  {$ENDIF}

  {$IF DECLARED( uTLH.ComponentTools )}
  lbledtASMHex1.OnBeforePaste := OnBeforePasteHex;
  lbledtASMTyped1.OnBeforePaste := OnBeforePasteTyped;
  lbledtASMHex2.OnBeforePaste := OnBeforePasteHex;
  lbledtASMTyped2.OnBeforePaste := OnBeforePasteTyped;

  lbledtASMHex3.OnBeforePaste := OnBeforePasteReadOnly;
  lbledtASMTyped3.OnBeforePaste := OnBeforePasteReadOnly;
  lbledtASMBinary3.OnBeforePaste := OnBeforePasteReadOnly;
  {$IFEND}
end;

procedure TFrASMCalculator.FrameResize(Sender: TObject);
begin
  grpOperand1.Width := ( pnlASMOperands.Width-splASMOperands.Width ) div 2;
end;

procedure TFrASMCalculator.chklstCPUFlagsClickCheck(Sender: TObject);
var
  Bytes : Array [0..4-1] of Byte;
  bC    : Byte;
  biC   : Byte;
  i     : Integer;
begin
  if NOT ( Sender is TCheckListBox ) then
    Exit;

  UpdateCPUFlagLabels( Sender );

  bC := 1; // 0
  biC := 5; // 7
  FillChar( Bytes, SizeOf( Bytes ), 0 );
  for i := 0 to TCheckListBox( Sender ).Items.Count-1 do
    begin
    if NOT TCheckListBox( Sender ).Checked[ i ] then
      Bytes[ 3-bC ] := Bytes[ 3-bC ] AND ( High( Bytes[ 3-bC ] ) xor ( 1 shl biC ) )
    else
      Bytes[ 3-bC ] := Bytes[ 3-bC ] OR ( Byte( TCheckListBox( Sender ).Checked[ i ] ) shl biC );

    if ( biC = 0 ) then
      begin
      Inc( bC );
      biC := 7;
      end
    else
      Dec( biC );
    end;

  lbledtASMCPUFlags.Text := PointerToHex( @Bytes, 4, False );
end;

procedure TFrASMCalculator.lbledtASMCPUFlagsKeyPress(Sender: TObject; var Key: Char);
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  OnKeyPressCheckChar( Sender, Key, kpmHex );
  {$IFEND}
end;

procedure TFrASMCalculator.UpdateCPUFlagLabels( Sender: TObject );
var
  OF_, SF,
  ZF,// AF,
  PF, CF  : boolean;
begin
  // Reserved
  TCheckListBox( Sender ).Checked[ 6 ]  := false;
  TCheckListBox( Sender ).Checked[ 16 ] := false;
  TCheckListBox( Sender ).Checked[ 18 ] := false;
  TCheckListBox( Sender ).Checked[ 20 ] := True;

  CF  := TCheckListBox( Sender ).Checked[ TCheckListBox( Sender ).Count-1 ];
  PF  := TCheckListBox( Sender ).Checked[ TCheckListBox( Sender ).Count-3 ];
//  AF  := TCheckListBox( Sender ).Checked[ TCheckListBox( Sender ).Count-5 ];
  ZF  := TCheckListBox( Sender ).Checked[ TCheckListBox( Sender ).Count-7 ];
  SF  := TCheckListBox( Sender ).Checked[ TCheckListBox( Sender ).Count-8 ];
  OF_ := TCheckListBox( Sender ).Checked[ TCheckListBox( Sender ).Count-12 ];

  lblASMJump_JO.Enabled          := OF_;
  lblASMJump_JNO.Enabled         := NOT OF_;
  lblASMJump_JS.Enabled          := SF;
  lblASMJump_JNS.Enabled         := NOT SF;
  lblASMJump_JP_JPE.Enabled      := PF;
  lblASMJump_JNP_JPO.Enabled     := NOT PF;
  lblASMJump_JE_JZ.Enabled       := ZF;
  lblASMJump_JNE_JNZ.Enabled     := NOT ZF;
  lblASMJump_JA_JNBE.Enabled     := ( NOT CF ) AND ( NOT ZF );
  lblASMJump_JB_JNAE_JC.Enabled  := CF;
  lblASMJump_JAE_JNB_JNC.Enabled := NOT CF;
  lblASMJump_JBE_JNA.Enabled     := CF OR ZF;
  lblASMJump_JG_JNLE.Enabled     := ( NOT ZF ) AND ( SF = OF_ );
  lblASMJump_JL_JNGE.Enabled     := ( SF <> OF_ );
  lblASMJump_JGE_JNL.Enabled     := ( SF = OF_ );
  lblASMJump_JLE_JNG.Enabled     := ZF OR ( SF <> OF_ );
end;

procedure TFrASMCalculator.lbledtASMCPUFlagsChange(Sender: TObject);
var
  Bytes : Array [0..4-1] of Byte;
  bC    : Byte;
  biC   : Byte;
  i     : Integer;
  N     : TNotifyEvent;
begin
  if NOT ( Sender is TLabeledEdit ) then
    Exit;

  FillChar( Bytes, SizeOf( Bytes ), 0 );
  if NOT HexToPointer( TLabeledEdit( Sender ).Text, @Bytes, 4, False ) then
    Exit;

  N := chklstCPUFlags.OnClick;
  chklstCPUFlags.OnClick := nil;

  bC := 1;// 0;
  biC := 5;// 7;
  for i := 0 to chklstCPUFlags.Items.Count-1 do
    begin
    case i of
       6,
      16,
      18 : chklstCPUFlags.Checked[ i ] := false;
      20 : chklstCPUFlags.Checked[ i ] := True;
    else
      chklstCPUFlags.Checked[ i ] := Boolean( ( Bytes[ 3-bC ] shr biC ) and $0001 );
    end;

    if ( biC = 0 ) then
      begin
      Inc( bC );
      biC := 7;
      end
    else
      Dec( biC );
    end;

  chklstCPUFlags.OnClick := N;
  UpdateCPUFlagLabels( chklstCPUFlags );
end;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
procedure TFrASMCalculator.lbledtASMTypedKeyPress(Sender: TObject; var Key: Char);
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  if chkASMSigned.Checked then
    OnKeyPressCheckChar( Sender, Key, kpmSigned )
  else
    OnKeyPressCheckChar( Sender, Key, kpmUnSigned );
  {$IFEND}
end;

procedure TFrASMCalculator.ASMHexKeyPress(Sender: TObject; var Key: Char);
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  OnKeyPressCheckChar( Sender, Key, kpmHex );
  {$IFEND}
end;

procedure TFrASMCalculator.KeyPressReadOnly(Sender: TObject; var Key: Char);
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  OnKeyPressCheckChar( Sender, Key, kpmReadOnly );
  {$IFEND}
end;

procedure TFrASMCalculator.OnBeforePasteTyped( Sender: TObject; var s: String; var StopPaste : boolean );
var
  tS : String;
begin
  if NOT IsNum( S, chkASMSigned.Checked ) then
    begin
    tS := StringReplace( S, {$IF CompilerVersion >= 30}FormatSettings.{$ELSE}SysUtils.{$IFEND}ThousandSeparator, '', [ rfReplaceAll ] );
    if IsNum( tS ) then
      S := tS
    else
      StopPaste := True;
    end;
end;

procedure TFrASMCalculator.OnBeforePasteHex( Sender: TObject; var s: String; var StopPaste : boolean );
begin
  if IsHex( S ) then
    begin
    S := ProperHex( S );
    S := TrimHex( S )
    end
  else
    StopPaste := True;
end;

procedure TFrASMCalculator.OnBeforePasteReadOnly( Sender: TObject; var s: String; var StopPaste : boolean );
begin
  StopPaste := True;
end;

procedure TFrASMCalculator.ASMHexKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  OnKeyDownManipulateNumbersViaUpDown( Sender, Key, Shift, kpmHex );
  {$IFEND}
end;

procedure TFrASMCalculator.lbledtASMTypedKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  if chkASMSigned.Checked then
    OnKeyDownManipulateNumbersViaUpDown( Sender, Key, Shift, kpmSigned )
  else
    OnKeyDownManipulateNumbersViaUpDown( Sender, Key, Shift, kpmUnSigned );
  {$IFEND}
end;

procedure TFrASMCalculator.pnlASMOperandsResize(Sender: TObject);
begin
  grpOperand1.Width := TPanel( Sender ).Width div 2;
end;

procedure TFrASMCalculator.chkASMSignedClick(Sender: TObject);
begin
  lbledtASMHexChange( lbledtASMHex1 );
  lbledtASMHexChange( lbledtASMHex2 );
end;

procedure TFrASMCalculator.lbledtASMHexChange(Sender: TObject);
var
  I : Int64;
  N : TNotifyEvent;
begin
  if NOT ( Sender is TLabeledEdit ) then
    Exit;

  if ( Sender = lbledtASMHex1 ) then
    begin
    N := lbledtASMTyped1.OnChange;
    lbledtASMTyped1.OnChange := NIL;
    if chkASMSigned.Checked then
      begin
      if ( rgASMArchitecture.ItemIndex = 1 ) then
        i := HexToInt64( TLabeledEdit( Sender ).Text )
      else
        i := HexToInt( TLabeledEdit( Sender ).Text );
      lbledtASMTyped1.Text := IntToStr( I );
      end
    else
      lbledtASMTyped1.Text := UIntToStr( HexToUInt64( TLabeledEdit( Sender ).Text ) );
    lbledtASMTyped1.OnChange := N;

    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      lbledtASMBinary1.Text := HexToBinaryString( TLabeledEdit( Sender ).Text, 8 )
    else
    {$ENDIF}
      lbledtASMBinary1.Text := HexToBinaryString( TLabeledEdit( Sender ).Text, 4 );
    lbledtASMBinary1.Hint := lbledtASMBinary1.Text;
    end
  else if ( Sender = lbledtASMHex2 ) then
    begin
    N := lbledtASMTyped2.OnChange;
    lbledtASMTyped2.OnChange := NIL;
    if chkASMSigned.Checked then
      begin
      if ( rgASMArchitecture.ItemIndex = 1 ) then
        i := HexToInt64( TLabeledEdit( Sender ).Text )
      else
        i := HexToInt( TLabeledEdit( Sender ).Text );
      lbledtASMTyped2.Text := IntToStr( I );
      end
    else
      lbledtASMTyped2.Text := UIntToStr( HexToUInt64( TLabeledEdit( Sender ).Text ) );
    lbledtASMTyped2.OnChange := N;

    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      lbledtASMBinary2.Text := HexToBinaryString( TLabeledEdit( Sender ).Text, 8 )
    else
    {$ENDIF}
      lbledtASMBinary2.Text := HexToBinaryString( TLabeledEdit( Sender ).Text, 4 );
    lbledtASMBinary2.Hint := lbledtASMBinary2.Text;
    end;

  ASMCalculator;
end;

procedure TFrASMCalculator.lbledtASMShiftChange(Sender: TObject);
begin
  ASMCalculator;
end;

procedure TFrASMCalculator.lbledtASMHexKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
{$IF DECLARED( uTLH.ComponentTools )}
var
  S : tOnKeyPressRangeLimitSettings;
{$IFEND}
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  FillChar( S, SizeOf( S ), 0 );
  if chkASMSigned.Checked then
    begin
    S.Mode := kplmSigned;
    S.MinI := 0;
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      S.MaxI := High( Int64 )
    else
      S.MaxI := High( Integer );
    S.IncI := 1;
    end
  else
    begin
    S.Mode := kplmUnSigned;
    S.MinU := 0;
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      S.MaxU := {$IF CompilerVersion < 23}High( Cardinal ){$ELSE}High( UInt64 ){$IFEND}
    else
      S.MaxU := High( Cardinal );
    S.IncU := 1;
    end;
  S.Hex  := True;

  OnKeyUpNumberRangeLimit( Sender, Key, S );
  {$IFEND}
end;

procedure TFrASMCalculator.lbledtASMTypedKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
{$IF DECLARED( uTLH.ComponentTools )}
var
  S : tOnKeyPressRangeLimitSettings;
{$IFEND}
begin
  {$IF DECLARED( uTLH.ComponentTools )}
  FillChar( S, SizeOf( S ), 0 );

  if chkASMSigned.Checked then
    begin
    S.Mode := kplmSigned;
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      begin
      S.MinI := Low( Int64 );
      S.MaxI := High( Int64 )
      end
    else
      begin
      S.MinI := Low( Integer );
      S.MaxI := High( Integer )
      end;
    S.IncI := 1;
    end
  else
    begin
    S.Mode := kplmUnSigned;
    S.MinU := 0;
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      S.MaxU := {$IF CompilerVersion < 23}High( Cardinal ){$ELSE}High( UInt64 ){$IFEND}
    else
      S.MaxU := High( Cardinal );
    S.IncU := 1;
    end;

  OnKeyUpNumberRangeLimit( Sender, Key, S );
  {$IFEND}
end;

procedure TFrASMCalculator.lbledtASMTypedChange(Sender: TObject);
var
  N : TNotifyEvent;
  I  : Int64;
  UI : UInt64 absolute I;
begin
  {$IFDEF Win64}
  if ( rgASMArchitecture.ItemIndex = 1 ) then
    begin
    if chkASMSigned.Checked then
      I  := StrToInt64Def( TLabeledEdit( Sender ).Text, 0 )
    else
      UI := StrToUInt64Def( TLabeledEdit( Sender ).Text, 0 );
    end
  else
  {$ENDIF}
    begin
    if chkASMSigned.Checked then
      I  := StrToIntDef( TLabeledEdit( Sender ).Text, 0 )
    else
      UI := StrToUIntDef( TLabeledEdit( Sender ).Text, 0 );
    end;

  if ( Sender = lbledtASMTyped1 ) then
    begin
    N := lbledtASMHex1.OnChange;
    lbledtASMHex1.OnChange := NIL;
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      begin
      lbledtASMHex1.Text := PointerToHex( @I, 8 );
      lbledtASMBinary1.Text := HexToBinaryString( lbledtASMHex1.Text, 8 )
      end
    else
    {$ENDIF}
      begin
      lbledtASMHex1.Text := PointerToHex( @I, 4 );
      lbledtASMBinary1.Text := HexToBinaryString( lbledtASMHex1.Text, 4 );
      end;
    lbledtASMHex1.OnChange := N;
    lbledtASMBinary1.Hint := lbledtASMBinary1.Text;
    end
  else if ( Sender = lbledtASMTyped2 ) then
    begin
    N := lbledtASMHex2.OnChange;
    lbledtASMHex2.OnChange := NIL;
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      begin
      lbledtASMHex2.Text := PointerToHex( @I, 8 );
      lbledtASMBinary2.Text := HexToBinaryString( lbledtASMHex2.Text, 8 )
      end
    else
    {$ENDIF}
      begin
      lbledtASMHex2.Text := PointerToHex( @I, 4 );
      lbledtASMBinary2.Text := HexToBinaryString( lbledtASMHex2.Text, 4 );
      end;
    lbledtASMHex2.OnChange := N;
    lbledtASMBinary2.Hint := lbledtASMBinary2.Text;
    end;
    
  ASMCalculator;
end;

procedure TFrASMCalculator.btnASMOperandResultClick(Sender: TObject);
begin
  if ( Sender = btnASMOperand1Result ) then
    lbledtASMHex1.Text := lbledtASMHex3.Text
  else if ( Sender = btnASMOperand2Result ) then
    lbledtASMHex2.Text := lbledtASMHex3.Text;
end;

procedure TFrASMCalculator.btnASMSwapClick(Sender: TObject);
var
  s : string;
begin
  s                  := lbledtASMHex1.Text;
  lbledtASMHex1.Text := lbledtASMHex2.Text;
  lbledtASMHex2.Text := s;
end;

procedure TFrASMCalculator.rgASMArchitectureClick(Sender: TObject);
var
  S : string;
  N : TNotifyEvent;
begin
  if NOT ( Sender is TRadioGroup ) then
    Exit;

  case TRadioGroup( Sender ).ItemIndex of
    0 : begin
        lbledtASMHex1.MaxLength := 8;
        N := lbledtASMHex1.OnChange;
        S := TrimHex( lbledtASMHex1.Text );
        if ( Length( S ) > 8 ) then
          S := Copy( S, 1, 8 );
        lbledtASMHex1.Text := S;
        lbledtASMHex1.OnChange := N;

        lbledtASMHex2.MaxLength := 8;
        N := lbledtASMHex2.OnChange;
        S := TrimHex( lbledtASMHex2.Text );
        if ( Length( S ) > 8 ) then
          S := Copy( S, 1, 8 );

        lbledtASMHex2.Text := S;
        lbledtASMHex2.OnChange := N;
        end;
    1 : begin
        lbledtASMHex1.MaxLength := 16;
        lbledtASMHex2.MaxLength := 16;
        end;
  end;
  ASMCalculator;
end;

procedure TFrASMCalculator.rgASMOperatorClick(Sender: TObject);
begin
  if NOT ( Sender is TRadioGroup ) then
    Exit;

  chkASMCarryFlag.Enabled := ( TRadioGroup( Sender ).ItemIndex in [ asmADC, asmDAA, asmDAS, asmRCL, asmRCR, asmSBB ] );
  if NOT chkASMCarryFlag.Enabled then
    chkASMCarryFlag.Checked := false;

//  chkASMSigned.Enabled         := NOT ( TRadioGroup( Sender ).ItemIndex in [ asmCDQ, asmCWD, asmDIV, asmIDIV, asmMUL, asmIMUL ] );
//  if NOT chkASMSigned.Enabled then
//    chkASMSigned.Checked := false;

  grpOperand2.Enabled          := NOT ( TRadioGroup( Sender ).ItemIndex in [ asmCDQ, asmINC, asmDEC, asmNEG, asmNOT, asmCBW, asmCWDE, asmBSWAP, asmBSF, asmBSR, asmPOPCNT, asmLZCNT, asmDAA, asmDAS, asmAAA, asmAAS, asmAAM ] );
  lbledtASMHex2.Enabled        := grpOperand2.Enabled;
  lbledtASMTyped2.Enabled      := grpOperand2.Enabled;
  lbledtASMBinary2.Enabled     := grpOperand2.Enabled;
  btnASMOperand2Result.Enabled := grpOperand2.Enabled;
  btnASMSwap.Enabled           := grpOperand2.Enabled;

  grpASMShift.Enabled          := ( TRadioGroup( Sender ).ItemIndex in [ asmSHLD, asmSHRD ] );
  lbledtASMShift.Enabled       := ( TRadioGroup( Sender ).ItemIndex in [ asmSHLD, asmSHRD ] );

  if ( TRadioGroup( Sender ).ItemIndex >= asmAAA ) AND ( TRadioGroup( Sender ).ItemIndex <= asmXOR ) then
    lblASMOperation.Caption := AsmOperands_Description[ TRadioGroup( Sender ).ItemIndex ]
  else
    lblASMOperation.Caption := 'Error';

  ASMCalculator;
end;

procedure TFrASMCalculator.ASMCalculator;
  procedure InvalidValue( I : Byte = 2 );
  begin
    if ( i = 0 ) then
      lbledtASMHex3.Text   := 'Unsupported'
    else if ( i = 1 ) then
      lbledtASMHex3.Text   := 'Invalid 1st Operand'
    else if ( i = 2 ) then
      lbledtASMHex3.Text   := 'Invalid 2nd Operand'
    else if ( i = 3 ) then
      lbledtASMHex3.Text   := 'Invalid Shift Operand'
    else
      lbledtASMHex3.Text   := 'Error';
    lbledtASMTyped3.Text   := lbledtASMHex3.Text;
    lbledtASMBinary3.Text  := lbledtASMHex3.Text;
    lbledtASMBinary3.Hint  := lbledtASMBinary3.Text;
    lbledtASMCPUFlags.Text := '0';
  end;
var
  Flags   : THandle;
  Res,
  ResLo   : Integer;
  CRes    : Cardinal absolute Res;
  {$IFDEF Win64}
  Res64,
  ResLo64 : Int64;
  uiRes   : UInt64 absolute Res64;
  {$ENDIF}
  N       : TNotifyEvent;
  A, B    : Integer;
  cA      : Cardinal absolute A;
  cB      : Cardinal absolute B;
  A64,
  B64     : Int64;
  uiA     : UInt64 absolute A64;
  uiB     : UInt64 absolute B64;

  vShift  : Integer;
  ui      : UInt64;
  iiA     : Array [ 0..1 ] of Integer absolute ui;
//  ciA   : Array [ 0..1 ] of Cardinal absolute i;
begin
  Res     := 0;
  ResLo   := 0;
  {$IFDEF Win64}
  Res64   := 0;
  ResLo64 := 0;
  {$ENDIF}
  if NOT chkASMSigned.Checked then
    begin
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      begin
      if NOT TryStrToUInt64( lbledtASMTyped1.Text, uiA ) then
        begin
        InvalidValue( 1 );
        Exit;
        end;
      if NOT TryStrToUInt64( lbledtASMTyped2.Text, uiB ) then
        begin
        InvalidValue( 2 );
        Exit;
        end;
      end
    else
    {$ENDIF}
      begin
      if NOT TryStrToUInt( lbledtASMTyped1.Text, cA ) then
        begin
        InvalidValue( 1 );
        Exit;
        end;
      if NOT TryStrToUInt( lbledtASMTyped2.Text, cB ) then
        begin
        InvalidValue( 2 );
        Exit;
        end;
      end
    end
  else
    begin
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      begin
      if NOT TryStrToInt64( lbledtASMTyped1.Text, A64 ) then
        begin
        InvalidValue( 1 );
        Exit;
        end;
      if NOT TryStrToInt64( lbledtASMTyped2.Text, B64 ) then
        begin
        InvalidValue( 2 );
        Exit;
        end;
      end
    else
    {$ENDIF}
      begin
      if NOT TryStrToInt( lbledtASMTyped1.Text, A ) then
        begin
        InvalidValue( 1 );
        Exit;
        end;
      if NOT TryStrToInt( lbledtASMTyped2.Text, B ) then
        begin
        InvalidValue( 2 );
        Exit;
        end;
      end;
    end;

  if NOT TryStrToInt( lbledtASMShift.Text, vShift ) then
    begin
    InvalidValue( 3 );
    Exit;
    end;

  try
    case rgASMOperator.ItemIndex of
      {$IFNDEF Win64}
      asmAAA     : Flags := EFLAGS32_AAA( A, Res );
      {$ENDIF}
      asmAAD     : begin
                   {$IFNDEF Win64}
                   if ( B <= High( Byte ) ) then
                     Flags := EFLAGS32_AAD( A, B, Res )
                   else
                   {$ENDIF}
                     begin
                     InvalidValue( {$IFDEF Win64}0{$ENDIF} );
                     Exit;
                     end;
                   end;

      asmAAM     : begin
                   {$IFNDEF Win64}
                   if ( A <= High( Byte ) ) then
                     Flags := EFLAGS32_AAM( A, Res )
                   else
                   {$ENDIF}
                     begin
                     InvalidValue( {$IFDEF Win64}0{$ELSE}1{$ENDIF} );
                     Exit;
                     end;
                   end;

      {$IFNDEF Win64}
      asmAAS     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_AAS( A64, Res );
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_AAS( A, Res );
                   end;
      {$ENDIF}

      asmADC     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_ADC( A64, B64, Res64, chkASMCarryFlag.Checked )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_ADC( A, B, Res, chkASMCarryFlag.Checked );
                   end;

      asmADD     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_Add( A64, B64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_Add( A, B, Res );
                   end;

      asmAND     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_AND( A64, B64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_AND( A, B, Res );
                   end;

      asmBSF     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_BSF( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_BSF( A, Res );
                   end;

      asmBSR     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_BSR( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_BSR( A, Res );
                   end;

      asmBSWAP   : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_BSwap( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_BSwap( A, Res );
                   end;

      asmBT      : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_BT( A64, B64, Res64 )
                     else
                     {$ENDIF}
                       Flags := EFLAGS32_BT( A, B, Res );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmBTC     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_BTC( A64, B64, Res64 )
                     else
                     {$ENDIF}
                       Flags := EFLAGS32_BTC( A, B, Res );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmBTR     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_BTR( A64, B64, Res64 )
                     else
                     {$ENDIF}
                       Flags := EFLAGS32_BTR( A, B, Res );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmBTS     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_BTS( A64, B64, Res64 )
                     else
                     {$ENDIF}
                       Flags := EFLAGS32_BTS( A, B, Res );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmCBW     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_CBW( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_CBW( A, Res );
                   end;

      asmCDQ     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     begin
                     if ( uiA <= High( Cardinal ) ) then
                       Flags := EFLAGS64_CDQ( A64, ResLo64, Res64 )
                     else
                       begin
                       InvalidValue( 1 );
                       Exit;
                       end;
                     end
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_CDQ( A, ResLo, Res );
                   end;

      asmCMP     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_CMP( A64, B64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_CMP( A, B, Res );
                   end;

      asmCWD     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_CWD( A64, B64, ResLo64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_CWD( A, B, ResLo, Res );
                   end;

      asmCWDE    : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_CWDE( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_CWDE( A, Res );
                   end;

      {$IFNDEF Win64}
      asmDAA     : Flags := EFLAGS32_DAA( A, Res, chkASMCarryFlag.Checked );
      asmDAS     : Flags := EFLAGS32_DAS( A, Res, chkASMCarryFlag.Checked );
      {$ENDIF}

      asmDEC     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_DEC( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_DEC( A, Res );
                   end;

      asmDIV     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_DIV( A64, B64, ResLo64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_DIV( A, B, ResLo, Res );
                   end;

      asmIDIV    : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_IDIV( A64, B64, ResLo64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_IDIV( A, B, ResLo, Res );
                   end;

      asmIMUL    : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_IMUL( A64, B64, ResLo64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_IMUL( A, B, ResLo, Res );
                   end;

      asmINC     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_INC( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_INC( A, Res );
                   end;

      {$IF CompilerVersion >= 23}
      asmLZCNT   : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_LzCnt( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_LzCnt( A, Res );
                   end;
      {$IFEND}

      asmMUL     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_MUL( A64, B64, ResLo64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_MUL( A, B, ResLo, Res );
                   end;

      asmNEG     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_NEG( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_NEG( A, Res );
                   end;

      asmNOT     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_NOT( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_NOT( A, Res );
                   end;

      asmOR      : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_OR( A64, B64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_OR( A, B, Res );
                   end;

      {$IF CompilerVersion >= 23}
      asmPOPCNT  : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_PopCnt( A64, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_PopCnt( A, Res );
                   end;
      {$IFEND}

      asmRCL     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_RCL( A64, B64, Res64, chkASMCarryFlag.Checked )
                     else
                     {$ENDIF}
                       Flags := EFLAGS32_RCL( A, B, Res, chkASMCarryFlag.Checked );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmRCR     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_RCR( A64, B64, Res64, chkASMCarryFlag.Checked )
                     else
                     {$ENDIF}
                      Flags := EFLAGS32_RCR( A, B, Res, chkASMCarryFlag.Checked );
                      end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmROL     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_ROL( A64, B64, Res64 )
                     else
                    {$ENDIF}
                       Flags := EFLAGS32_ROL( A, B, Res );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmROR     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                    begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_ROR( A64, B64, Res64 )
                     else
                     {$ENDIF}
                       Flags := EFLAGS32_ROR( A, B, Res );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmSAR     : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                     begin
                     {$IFDEF Win64}
                     if ( rgASMArchitecture.ItemIndex = 1 ) then
                       Flags := EFLAGS64_SAR( A64, B64, Res64 )
                     else
                     {$ENDIF}
                       Flags := EFLAGS32_SAR( A, B, Res );
                     end
                   else
                     begin
                     InvalidValue;
                     Exit;
                     end;
                   end;

      asmSBB     : begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_Sbb( A64, B64, Res64, chkASMCarryFlag.Checked )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_Sbb( A, B, Res, chkASMCarryFlag.Checked );
                   end;

      asmSHL_SAL : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                      begin
                      {$IFDEF Win64}
                      if ( rgASMArchitecture.ItemIndex = 1 ) then
                        Flags := EFLAGS64_SHL_SAL( A64, B64, Res64 )
                      else
                      {$ENDIF}
                        Flags := EFLAGS32_SHL_SAL( A, B, Res );
                      end
                    else
                      begin
                      InvalidValue;
                      Exit;
                      end;
                    end;

      asmSHLD  : begin
                 if ( vShift <= High( Byte ) ) then
                   begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_SHLD( A64, B64, vShift, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_SHLD( A, B, vShift, Res );
                   end
                 else
                   begin
                   InvalidValue( 3 );
                   Exit;
                   end;
                 end;

      asmSHR  : begin
                   if ( ( B <= High( Byte ) div 2 ) {$IFDEF Win64}AND ( rgASMArchitecture.ItemIndex = 0 ) ) OR ( ( B64 <= High( Byte ) div 2 ) AND ( rgASMArchitecture.ItemIndex = 1 ) {$ENDIF} ) then
                  begin
                  {$IFDEF Win64}
                  if ( rgASMArchitecture.ItemIndex = 1 ) then
                    Flags := EFLAGS64_SHR( A64, B64, Res64 )
                  else
                   {$ENDIF}
                    Flags := EFLAGS32_SHR( A, B, Res );
                  end
                else
                  begin
                  InvalidValue;
                  Exit;
                  end;
                end;

      asmSHRD  : begin
                 if ( vShift <= High( Byte ) ) then
                   begin
                   {$IFDEF Win64}
                   if ( rgASMArchitecture.ItemIndex = 1 ) then
                     Flags := EFLAGS64_SHRD( A64, B64, vShift, Res64 )
                   else
                   {$ENDIF}
                     Flags := EFLAGS32_SHRD( A, B, vShift, Res );
                   end
                 else
                   begin
                   InvalidValue( 3 );
                   Exit;
                   end;
                 end;

      asmSUB   : begin
                 {$IFDEF Win64}
                 if ( rgASMArchitecture.ItemIndex = 1 ) then
                   Flags := EFLAGS64_Sub( A64, B64, Res64 )
                 else
                 {$ENDIF}
                   Flags := EFLAGS32_Sub( A, B, Res );
                 end;

      asmTEST  : begin
                 {$IFDEF Win64}
                 if ( rgASMArchitecture.ItemIndex = 1 ) then
                   Flags := EFLAGS64_TEST( A64, B64, Res64 )
                 else
                 {$ENDIF}
                   Flags := EFLAGS32_TEST( A, B, Res );
                 end;

      asmXOR   : begin
                 {$IFDEF Win64}
                 if ( rgASMArchitecture.ItemIndex = 1 ) then
                   Flags := EFLAGS64_XOR( A64, B64, Res64 )
                 else
                 {$ENDIF}
                   Flags := EFLAGS32_XOR( A, B, Res );
                 end
    else
      begin
      InvalidValue( 0 );
      Exit;
      end;
    end;
  except
    InvalidValue( 4 );
    lbledtASMCPUFlags.Text := '0';
    Exit;
  end;

  N := lbledtASMHex3.OnChange;
  if ( rgASMOperator.ItemIndex in [ asmCDQ, asmCWD, asmDIV, asmIDIV, asmMUL, asmIMUL ] ) then
    begin
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      lbledtASMHex3.Text   := Format( '%s:%s', [ IntToHex( Res64{$IF CompilerVersion < 23}, SizeOf( Int64 )*2{$ELSE}, False{$IFEND} ), IntToHex( ResLo64{$IF CompilerVersion < 23}, SizeOf( Int64 )*2{$ELSE}, False{$IFEND} ) ] )
    else
    {$ENDIF}
      lbledtASMHex3.Text   := Format( '%s:%s', [ IntToHex( Res{$IF CompilerVersion < 23}, SizeOf( Integer )*2{$ELSE}, False{$IFEND} ), IntToHex( ResLo{$IF CompilerVersion < 23}, SizeOf( Integer )*2{$ELSE}, False{$IFEND} ) ] );
    end
  else
    begin
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      lbledtASMHex3.Text   := IntToHex( Res64{$IF CompilerVersion < 23}, SizeOf( Int64 )*2{$ELSE}, False{$IFEND} )
    else
    {$ENDIF}
      lbledtASMHex3.Text   := IntToHex( Res{$IF CompilerVersion < 23}, SizeOf( Integer )*2{$ELSE}, False{$IFEND} );
    end;
  lbledtASMHex3.OnChange := N;

  N := lbledtASMTyped3.OnChange;
  lbledtASMTyped3.OnChange := nil;
  if {$IFNDEF Win64}( rgASMArchitecture.ItemIndex = 0 ) AND{$ENDIF} ( rgASMOperator.ItemIndex in [ asmCDQ, asmCWD, {asmDIV, asmIDIV, }asmMUL, asmIMUL ] ) then
    begin
    iiA[ 1 ] := Res;
    iiA[ 0 ] := ResLo;
    {$IF CompilerVersion < 23}{$RANGECHECKS OFF}{$IFEND} // RangeCheck might cause Internal-Error C1118
    lbledtASMTyped3.Text := UIntToStr( ui );
    {$IF CompilerVersion < 23}{$RANGECHECKS ON}{$IFEND} // RangeCheck might cause Internal-Error C1118
    end
  else
    begin
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      begin
      if chkASMSigned.Checked then
        lbledtASMTyped3.Text := IntToStr( Res64 )
      else
        lbledtASMTyped3.Text := UIntToStr( uiRes );
      end
    else
    {$ENDIF}
      begin
      if chkASMSigned.Checked then
        lbledtASMTyped3.Text := IntToStr( Res )
      else
        lbledtASMTyped3.Text := UIntToStr( CRes );
      end
    end;
  lbledtASMTyped3.OnChange := N;

  if ( rgASMOperator.ItemIndex in [ asmCDQ, asmCWD, asmDIV, asmIDIV, asmMUL, asmIMUL ] ) then
    begin
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      lbledtASMBinary3.Text := Format( '%s:%s', [ HexToBinaryString( IntToHex( Res64{$IF CompilerVersion < 23}, SizeOf( Int64 )*2{$ELSE}, False{$IFEND} ), 8 ), HexToBinaryString( IntToHex( ResLo64{$IF CompilerVersion < 23}, SizeOf( Int64 )*2{$ELSE}, False{$IFEND} ), 8 ) ] )
    else
    {$ENDIF}
      lbledtASMBinary3.Text := Format( '%s:%s', [ HexToBinaryString( IntToHex( Res{$IF CompilerVersion < 23}, SizeOf( Integer )*2{$ELSE}, False{$IFEND} ), 4 ), HexToBinaryString( IntToHex( ResLo{$IF CompilerVersion < 23}, SizeOf( Integer )*2{$ELSE}, False{$IFEND} ), 4 ) ] );
    end
  else
    begin
    {$IFDEF Win64}
    if ( rgASMArchitecture.ItemIndex = 1 ) then
      lbledtASMBinary3.Text := HexToBinaryString( lbledtASMHex3.Text, 8 )
    else
    {$ENDIF}
      lbledtASMBinary3.Text := HexToBinaryString( lbledtASMHex3.Text, 4 );
    end;
  lbledtASMBinary3.Hint   := lbledtASMBinary3.Text;
  lbledtASMCPUFlags.Text  := IntToHex( Flags, SizeOf( Integer )*2 );
end;

{$IF DECLARED( uTLH.ComponentTools )}
function TFrASMCalculator.GetMouseMode : Boolean;
begin
  result := Assigned( lbledtASMHex1.OnMouseWheelVertical );
end;

procedure TFrASMCalculator.SetMouseMode( Value : Boolean );
begin
  if Value then
    begin
    lbledtASMHex1.OnMouseWheelVertical              := OnMouseWheelVerticalHex;
    lbledtASMHex2.OnMouseWheelVertical              := OnMouseWheelVerticalHex;
    lbledtASMHex3.OnMouseWheelVertical              := OnMouseWheelVerticalHex;
    lbledtASMTyped1.OnMouseWheelVertical            := OnMouseWheelVerticalTyped;
    lbledtASMTyped2.OnMouseWheelVertical            := OnMouseWheelVerticalTyped;
    lbledtASMTyped3.OnMouseWheelVertical            := OnMouseWheelVerticalTyped;

    lbledtASMCPUFlags.OnMouseWheelVertical          := OnMouseWheelVerticalHex;
    end
  else
    begin
    lbledtASMHex1.OnMouseWheelVertical              := nil;
    lbledtASMHex2.OnMouseWheelVertical              := nil;
    lbledtASMHex3.OnMouseWheelVertical              := nil;
    lbledtASMTyped1.OnMouseWheelVertical            := nil;
    lbledtASMTyped2.OnMouseWheelVertical            := nil;
    lbledtASMTyped3.OnMouseWheelVertical            := nil;

    lbledtASMCPUFlags.OnMouseWheelVertical          := nil;
    end;
end;

procedure TFrASMCalculator.OnMouseWheelVerticalHex( Sender : TObject; Msg : TWMMouseWheel );
var
  Key : Word;
begin
  if ( Msg.WheelDelta < 0 ) then
    Key := VK_DOWN
  else
    Key := VK_UP;

//  if chkBigEndian.checked then
//    OnKeyDownManipulateNumbersViaUpDown( Sender, Key, [], kpmHexBigEndian )
//  else
    OnKeyDownManipulateNumbersViaUpDown( Sender, Key, [], kpmHex );
end;

procedure TFrASMCalculator.OnMouseWheelVerticalTyped( Sender : TObject; Msg : TWMMouseWheel );
var
  Key : Word;
begin
  if ( Msg.WheelDelta < 0 ) then
    Key := VK_DOWN
  else
    Key := VK_UP;

  if chkASMSigned.Checked then
    OnKeyDownManipulateNumbersViaUpDown( Sender, Key, [], kpmSigned )
  else
    OnKeyDownManipulateNumbersViaUpDown( Sender, Key, [], kpmUnsigned );
end;
{$IFEND}

end.
