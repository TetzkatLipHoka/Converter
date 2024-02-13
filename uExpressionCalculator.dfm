object FrExpressionCalculator: TFrExpressionCalculator
  Left = 0
  Top = 0
  Width = 331
  Height = 338
  TabOrder = 0
  OnResize = FrameResize
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 338
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object grpExpression: TGroupBox
      Left = 0
      Top = 35
      Width = 320
      Height = 39
      Align = alTop
      Caption = 'Expression'
      TabOrder = 0
      DesignSize = (
        320
        39)
      object edtExpression: TEdit
        Left = 2
        Top = 15
        Width = 316
        Height = 21
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        OnChange = edtExpressionChange
        OnKeyPress = edtExpressionKeyPress
      end
    end
    object btnClear: TButton
      Left = 0
      Top = 156
      Width = 320
      Height = 25
      Caption = 'Clear'
      TabOrder = 1
      OnClick = btnClearClick
    end
    object pnlResultTop: TPanel
      Left = 0
      Top = 74
      Width = 320
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object splResultTop: TSplitter
        Left = 158
        Top = 0
        Height = 41
      end
      object grpOctal: TGroupBox
        Left = 161
        Top = 0
        Width = 159
        Height = 41
        Align = alClient
        Caption = 'Octal'
        TabOrder = 0
        DesignSize = (
          159
          41)
        object edtOctal: TEdit
          Left = 2
          Top = 15
          Width = 155
          Height = 21
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          OnKeyPress = KeyPressReadOnly
        end
      end
      object grpBinary: TGroupBox
        Left = 0
        Top = 0
        Width = 158
        Height = 41
        Align = alLeft
        Caption = 'Binary'
        TabOrder = 1
        DesignSize = (
          158
          41)
        object edtBinary: TEdit
          Left = 2
          Top = 15
          Width = 154
          Height = 21
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          OnKeyPress = KeyPressReadOnly
        end
      end
    end
    object pnlResultBottom: TPanel
      Left = 0
      Top = 115
      Width = 320
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object splResultBottom: TSplitter
        Left = 158
        Top = 0
        Height = 41
      end
      object grpDecimal: TGroupBox
        Left = 0
        Top = 0
        Width = 158
        Height = 41
        Align = alLeft
        Caption = 'Decimal'
        TabOrder = 0
        DesignSize = (
          158
          41)
        object edtDecimal: TEdit
          Left = 2
          Top = 15
          Width = 154
          Height = 21
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          OnKeyPress = KeyPressReadOnly
        end
      end
      object grpHexadecimal: TGroupBox
        Left = 161
        Top = 0
        Width = 159
        Height = 41
        Align = alClient
        Caption = 'Hexadecimal'
        TabOrder = 1
        DesignSize = (
          159
          41)
        object edtHexadecimal: TEdit
          Left = 2
          Top = 15
          Width = 155
          Height = 21
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          OnKeyPress = KeyPressReadOnly
        end
      end
    end
    object grpHistory: TGroupBox
      Left = 0
      Top = 156
      Width = 320
      Height = 182
      Align = alClient
      Caption = 'History'
      TabOrder = 4
    end
    object rgMode: TRadioGroup
      Left = 0
      Top = 0
      Width = 320
      Height = 35
      Align = alTop
      Caption = 'Mode'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        'Signed'
        'Unsigned'
        'Float')
      TabOrder = 5
      OnClick = rgModeClick
    end
  end
  object pnlHelp: TPanel
    Left = 320
    Top = 0
    Width = 11
    Height = 338
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object mmoHelp: TMemo
      Left = 11
      Top = 0
      Width = 0
      Height = 338
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Consolas'
      Font.Style = []
      Lines.Strings = (
        'Prefixes'
        '  0b0101, 01010b, 0101b - Binary number'
        '  0o377,  0377o,  377o  - Octal number'
        '  0xABCD, 0ABCDh, $ABCD - Hex number'
        '  90`15`2               - Degree'
        ''
        'Operators by priorities:'
        '    {7} ( )   (BRACES)'
        '    {6} **    (POWER)'
        '    {5} ~     (INVERSE)'
        '        ! NOT (NOT)'
        '    {4} *     (MUL)'
        '        /     (DIV)'
        '        % MOD (MOD)'
        '        %%    (PERSENT)'
        '        <<    (Shift Left)'
        '        >>    (Shift Right)'
        '    {3} +     (ADD)'
        '        -     (SUB)'
        '    {2} <     (Less)'
        '        <=    (Less or Equal)'
        '        ==    (Equal)'
        '        <> != (Not Equal)'
        '        >=    (Greater or Equal)'
        '        >     (Greater)'
        '    {1} | OR  (OR)'
        '        ^ XOR (XOR)'
        '        & AND (AND)'
        ''
        '  Functions'
        '    atan / arctan'
        '    ceil'
        '    cos'
        '    exp'
        '    floor'
        '    frac'
        '    int'
        '    ln'
        '    pi'
        '    round'
        '    sgn'
        '    sign'
        '    sin'
        '    sqr'
        '    sqrt'
        '    tan'
        '    trunc'
        '    xsgn')
      ParentFont = False
      TabOrder = 0
      WordWrap = False
    end
    object pnlHelpButton: TPanel
      Left = 0
      Top = 0
      Width = 11
      Height = 338
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        11
        338)
      object btnHelp: TButton
        Left = -1
        Top = 1
        Width = 12
        Height = 337
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = '<'
        TabOrder = 0
        OnClick = btnHelpClick
      end
    end
  end
end
