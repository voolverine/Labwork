object Form1: TForm1
  Left = 394
  Top = 102
  Width = 1305
  Height = 675
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 184
    Top = 96
    Width = 20
    Height = 13
    Caption = 'N = '
  end
  object Label2: TLabel
    Left = 160
    Top = 168
    Width = 42
    Height = 13
    Caption = 'Result = '
  end
  object Edit1: TEdit
    Left = 216
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 232
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Calculate'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 216
    Top = 168
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
end
