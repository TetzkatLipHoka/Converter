object FrASMCalculator: TFrASMCalculator
  Left = 0
  Top = 0
  Width = 447
  Height = 406
  TabOrder = 0
  OnResize = FrameResize
  object pnlASMRight: TPanel
    Left = 247
    Top = 0
    Width = 200
    Height = 406
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object chklstCPUFlags: TCheckListBox
      Left = 0
      Top = 19
      Width = 200
      Height = 332
      OnClickCheck = chklstCPUFlagsClickCheck
      Align = alClient
      ItemHeight = 13
      Items.Strings = (
        '21 CPU Flag'
        '20 Virtual Interrupt Pending'
        '19 Virtual Interrupt Flag'
        '18 Alignment Check'
        '17 Virtual Mode Flag'
        '16 Resume Flag'
        '15 Reserved (0)'
        '14 Nested Task'
        '13 I/O Privilege Level'
        '12 I/O Privilege Level'
        '11 Overflow flag (OF)'
        '10 Direction flag (DF)'
        '9 Interrupt flag (IF)'
        '8 Trace flag (TF)'
        '7 Sign flag (SF)'
        '6 Zero flag (ZF)'
        '5 Reserved (0)'
        '4 Auxiliary carry flag (AF)'
        '3 Reserved (0)'
        '2 Parity flag (PF)'
        '1 Reserved (1)'
        '0 Carry flag (CF)')
      TabOrder = 0
    end
    object pnlASMJumps: TPanel
      Left = 0
      Top = 351
      Width = 200
      Height = 55
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lblASMJump_JO: TLabel
        Left = 2
        Top = 2
        Width = 14
        Height = 14
        Hint = 'Jump if Overflow'#13#10'OF=1'
        Caption = 'JO'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JNO: TLabel
        Left = 2
        Top = 15
        Width = 22
        Height = 14
        Hint = 'Jump if not Overflow'#13#10'OF=0'
        Caption = 'JNO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JS: TLabel
        Left = 2
        Top = 28
        Width = 12
        Height = 14
        Hint = 'Jump if negative'#13#10'SF=1'
        Caption = 'JS'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JNS: TLabel
        Left = 2
        Top = 41
        Width = 20
        Height = 14
        Hint = 'Jump if not negative'#13#10'SF=0'
        Caption = 'JNS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JP_JPE: TLabel
        Left = 28
        Top = 2
        Width = 36
        Height = 14
        Hint = 'Jump if Parity'#13#10'Jump if Parity even'#13#10'PF=1'
        Caption = 'JP/JPE'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JNP_JPO: TLabel
        Left = 28
        Top = 15
        Width = 46
        Height = 14
        Hint = 'Jump if not Parity'#13#10'Jump if Parity odd'#13#10'PF=0'
        Caption = 'JNP/JPO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JE_JZ: TLabel
        Left = 28
        Top = 28
        Width = 29
        Height = 14
        Hint = 'Jump if equal'#13#10'Jump if Zero'#13#10'ZF=1'#13#10'X = Y'
        Caption = 'JE/JZ'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JNE_JNZ: TLabel
        Left = 28
        Top = 41
        Width = 45
        Height = 14
        Hint = 'Jump if not equal'#13#10'Jump if not Zero'#13#10'ZF=0'#13#10'X <> Y'
        Caption = 'JNE/JNZ'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JA_JNBE: TLabel
        Left = 78
        Top = 2
        Width = 45
        Height = 14
        Hint = 
          'Jump if above'#13#10'Jump if not below or equal'#13#10'CF=0 AND ZF=0'#13#10'Unsign' +
          'ed X > Y'
        Caption = 'JA/JNBE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JB_JNAE_JC: TLabel
        Left = 78
        Top = 15
        Width = 62
        Height = 14
        Hint = 
          'Jump if below'#13#10'Jump if not above or equal'#13#10'Jump if Carry'#13#10'CF=1'#13#10 +
          'Unsigned X < Y'
        Caption = 'JB/JNAE/JC'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JAE_JNB_JNC: TLabel
        Left = 78
        Top = 28
        Width = 70
        Height = 14
        Hint = 
          'Jump if above or equal'#13#10'Jump if not below'#13#10'Jump if Carry'#13#10'CF=0'#13#10 +
          'Unsigned X >= Y'
        Caption = 'JAE/JNB/JNC'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JBE_JNA: TLabel
        Left = 78
        Top = 41
        Width = 45
        Height = 14
        Hint = 
          'Jump if below or equal'#13#10'Jump if not above'#13#10'CF=1 OR ZF=1'#13#10'Unsigne' +
          'd X <= Y'
        Caption = 'JBE/JNA'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JG_JNLE: TLabel
        Left = 152
        Top = 2
        Width = 44
        Height = 14
        Hint = 
          'Jump if greater'#13#10'Jump if not less or equal'#13#10'ZF=0 AND SF=OF'#13#10'Sign' +
          'ed X > Y'
        Caption = 'JG/JNLE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JL_JNGE: TLabel
        Left = 152
        Top = 15
        Width = 44
        Height = 14
        Hint = 'Jump if less'#13#10'Jump if not greater or equal'#13#10'SF<>OF'#13#10'Signed X < Y'
        Caption = 'JL/JNGE'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JGE_JNL: TLabel
        Left = 152
        Top = 28
        Width = 44
        Height = 14
        Hint = 'Jump if greater or equal'#13#10'Jump if not less'#13#10'SF=OF'#13#10'Signed X >= Y'
        Caption = 'JGE/JNL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblASMJump_JLE_JNG: TLabel
        Left = 152
        Top = 41
        Width = 44
        Height = 14
        Hint = 
          'Jump if less or equal'#13#10'Jump if not greater'#13#10'ZF=1 OR SF<>OF'#13#10'Sign' +
          'ed X <= Y'
        Caption = 'JLE/JNG'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlASMCPUFlags: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 19
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        200
        19)
      object lbledtASMCPUFlags: TLabeledEdit
        Left = 83
        Top = -1
        Width = 117
        Height = 21
        Anchors = [akLeft, akTop, akRight, akBottom]
        EditLabel.Width = 78
        EditLabel.Height = 13
        EditLabel.Caption = 'CPU Flags (Hex)'
        LabelPosition = lpLeft
        MaxLength = 8
        TabOrder = 0
        OnChange = lbledtASMCPUFlagsChange
        OnKeyDown = ASMHexKeyDown
        OnKeyPress = ASMHexKeyPress
      end
    end
  end
  object pnlASMLeft: TPanel
    Left = 0
    Top = 0
    Width = 247
    Height = 406
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlCaption: TPanel
      Left = 0
      Top = 33
      Width = 247
      Height = 14
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object lblASMOperation: TLabel
        Left = 0
        Top = 0
        Width = 247
        Height = 14
        Align = alClient
        Alignment = taCenter
        Caption = 'Logical Exclusive OR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnASMSwap: TBitBtn
        Left = 0
        Top = -1
        Width = 16
        Height = 16
        Hint = 'Swap Operands'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnASMSwapClick
      end
    end
    object pnlASMOperands: TPanel
      Left = 0
      Top = 47
      Width = 247
      Height = 82
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object splASMOperands: TSplitter
        Left = 123
        Top = 0
        Height = 82
      end
      object grpOperand1: TGroupBox
        Left = 0
        Top = 0
        Width = 123
        Height = 82
        Align = alLeft
        Caption = 'Operand 1'
        TabOrder = 0
        DesignSize = (
          123
          82)
        object lbledtASMHex1: TLabeledEdit
          Left = 36
          Top = 16
          Width = 84
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EditLabel.Width = 19
          EditLabel.Height = 13
          EditLabel.Caption = 'Hex'
          LabelPosition = lpLeft
          MaxLength = 8
          TabOrder = 0
          Text = '00'
          OnChange = lbledtASMHexChange
          OnKeyDown = ASMHexKeyDown
          OnKeyPress = ASMHexKeyPress
          OnKeyUp = lbledtASMHexKeyUp
        end
        object lbledtASMTyped1: TLabeledEdit
          Left = 36
          Top = 37
          Width = 84
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Typed'
          LabelPosition = lpLeft
          TabOrder = 1
          Text = '0'
          OnChange = lbledtASMTypedChange
          OnKeyDown = lbledtASMTypedKeyDown
          OnKeyPress = lbledtASMTypedKeyPress
          OnKeyUp = lbledtASMTypedKeyUp
        end
        object lbledtASMBinary1: TLabeledEdit
          Left = 36
          Top = 58
          Width = 84
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Binary'
          LabelPosition = lpLeft
          TabOrder = 2
          Text = '0'
          OnKeyPress = KeyPressReadOnly
        end
        object btnASMOperand1Result: TBitBtn
          Left = 105
          Top = 0
          Width = 16
          Height = 16
          Hint = 'Copy from Result'
          Anchors = [akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnASMOperandResultClick
        end
      end
      object grpOperand2: TGroupBox
        Left = 126
        Top = 0
        Width = 121
        Height = 82
        Align = alClient
        Caption = 'Operand 2'
        TabOrder = 1
        DesignSize = (
          121
          82)
        object lbledtASMHex2: TLabeledEdit
          Left = 36
          Top = 16
          Width = 84
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EditLabel.Width = 19
          EditLabel.Height = 13
          EditLabel.Caption = 'Hex'
          LabelPosition = lpLeft
          MaxLength = 8
          TabOrder = 0
          Text = '400000'
          OnChange = lbledtASMHexChange
          OnKeyDown = ASMHexKeyDown
          OnKeyPress = ASMHexKeyPress
          OnKeyUp = lbledtASMHexKeyUp
        end
        object lbledtASMTyped2: TLabeledEdit
          Left = 36
          Top = 37
          Width = 84
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Typed'
          LabelPosition = lpLeft
          TabOrder = 1
          Text = '4194304'
          OnChange = lbledtASMTypedChange
          OnKeyDown = lbledtASMTypedKeyDown
          OnKeyPress = lbledtASMTypedKeyPress
          OnKeyUp = lbledtASMTypedKeyUp
        end
        object lbledtASMBinary2: TLabeledEdit
          Left = 36
          Top = 58
          Width = 84
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Binary'
          LabelPosition = lpLeft
          TabOrder = 2
          Text = '00000000010000000000000000000000'
          OnKeyPress = KeyPressReadOnly
        end
        object btnASMOperand2Result: TBitBtn
          Left = 104
          Top = 0
          Width = 16
          Height = 16
          Hint = 'Copy from Result'
          Anchors = [akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnASMOperandResultClick
        end
      end
    end
    object grpResult: TGroupBox
      Left = 0
      Top = 129
      Width = 247
      Height = 82
      Align = alTop
      Caption = 'Result'
      TabOrder = 1
      DesignSize = (
        247
        82)
      object lbledtASMHex3: TLabeledEdit
        Left = 36
        Top = 16
        Width = 208
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        EditLabel.Width = 19
        EditLabel.Height = 13
        EditLabel.Caption = 'Hex'
        LabelPosition = lpLeft
        MaxLength = 2
        TabOrder = 0
        Text = '00'
        OnKeyPress = KeyPressReadOnly
      end
      object lbledtASMTyped3: TLabeledEdit
        Left = 36
        Top = 37
        Width = 208
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Typed'
        LabelPosition = lpLeft
        TabOrder = 1
        Text = '0'
        OnKeyPress = KeyPressReadOnly
      end
      object lbledtASMBinary3: TLabeledEdit
        Left = 36
        Top = 58
        Width = 208
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Binary'
        LabelPosition = lpLeft
        TabOrder = 2
        Text = '0'
        OnKeyPress = KeyPressReadOnly
      end
      object chkASMSigned: TCheckBox
        Left = 188
        Top = -1
        Width = 52
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Signed'
        TabOrder = 3
        OnClick = chkASMSignedClick
      end
    end
    object rgASMArchitecture: TRadioGroup
      Left = 0
      Top = 0
      Width = 247
      Height = 33
      Align = alTop
      Caption = 'Architecture'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'x86'
        'x64')
      TabOrder = 2
      OnClick = rgASMArchitectureClick
    end
    object pnlOperation: TPanel
      Left = 0
      Top = 211
      Width = 247
      Height = 195
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 4
      DesignSize = (
        247
        195)
      object rgASMOperator: TRadioGroup
        Left = 0
        Top = 0
        Width = 247
        Height = 195
        Align = alClient
        Caption = 'Operators'
        Columns = 4
        ItemIndex = 5
        Items.Strings = (
          'aaa'
          'aad'
          'aam'
          'aas'
          'adc'
          'add'
          'and'
          'bsf'
          'bsr'
          'bswap'
          'bt'
          'btc'
          'btr'
          'bts'
          'cbw'
          'cdq'
          'cmp'
          'cwd'
          'cwde'
          'daa'
          'das'
          'dec'
          'div'
          'idiv'
          'imul'
          'inc'
          'lzcnt'
          'mul'
          'neg'
          'not'
          'or'
          'popcnt'
          'rcl'
          'rcr'
          'rol'
          'ror'
          'sar'
          'sbb'
          'shl/sal'
          'shld'
          'shr'
          'shrd'
          'sub'
          'test'
          'xor')
        TabOrder = 0
        OnClick = rgASMOperatorClick
      end
      object chkASMCarryFlag: TCheckBox
        Left = 208
        Top = 0
        Width = 33
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'CF'
        TabOrder = 1
        OnClick = lbledtASMShiftChange
      end
      object grpASMShift: TGroupBox
        Left = 188
        Top = 160
        Width = 59
        Height = 35
        Anchors = [akRight, akBottom]
        Caption = 'Shift'
        Enabled = False
        TabOrder = 2
        object lbledtASMShift: TLabeledEdit
          Left = 26
          Top = 13
          Width = 31
          Height = 21
          AutoSize = False
          EditLabel.Width = 19
          EditLabel.Height = 13
          EditLabel.Caption = 'Hex'
          LabelPosition = lpLeft
          MaxLength = 2
          TabOrder = 0
          Text = '0'
          OnChange = lbledtASMShiftChange
          OnKeyDown = ASMHexKeyDown
          OnKeyPress = ASMHexKeyPress
        end
      end
    end
  end
end
