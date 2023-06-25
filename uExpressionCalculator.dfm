object FrExpressionCalculator: TFrExpressionCalculator
  Left = 0
  Top = 0
  Width = 320
  Height = 305
  TabOrder = 0
  OnResize = FrameResize
  object grpExpression: TGroupBox
    Left = 0
    Top = 0
    Width = 320
    Height = 39
    Align = alTop
    Caption = 'Expression'
    TabOrder = 0
    object edtExpression: TEdit
      Left = 2
      Top = 15
      Width = 316
      Height = 22
      Align = alClient
      TabOrder = 0
      OnChange = edtExpressionChange
      OnKeyPress = edtExpressionKeyPress
    end
  end
  object btnClear: TButton
    Left = 0
    Top = 121
    Width = 320
    Height = 25
    Align = alTop
    Caption = 'Clear'
    TabOrder = 1
    OnClick = btnClearClick
  end
  object pnlResultTop: TPanel
    Left = 0
    Top = 39
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
      object edtOctal: TEdit
        Left = 2
        Top = 15
        Width = 155
        Height = 24
        Align = alClient
        Alignment = taCenter
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
      object edtBinary: TEdit
        Left = 2
        Top = 15
        Width = 154
        Height = 24
        Align = alClient
        Alignment = taCenter
        TabOrder = 0
        OnKeyPress = KeyPressReadOnly
      end
    end
  end
  object pnlResultBottom: TPanel
    Left = 0
    Top = 80
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
      object edtDecimal: TEdit
        Left = 2
        Top = 15
        Width = 154
        Height = 24
        Align = alClient
        Alignment = taCenter
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
      object edtHexadecimal: TEdit
        Left = 2
        Top = 15
        Width = 155
        Height = 24
        Align = alClient
        Alignment = taCenter
        TabOrder = 0
        OnKeyPress = KeyPressReadOnly
      end
    end
  end
  object grpHistory: TGroupBox
    Left = 0
    Top = 146
    Width = 320
    Height = 159
    Align = alClient
    Caption = 'History'
    TabOrder = 4
  end
end
