object Form1: TForm1
  Left = 347
  Top = 175
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
    Left = 672
    Top = 128
    Width = 28
    Height = 16
    Caption = 'N = '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 672
    Top = 216
    Width = 27
    Height = 16
    Caption = 'Key'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 232
    Top = 40
    Width = 385
    Height = 513
    TabOrder = 0
  end
  object StringGrid1: TStringGrid
    Left = 672
    Top = 40
    Width = 545
    Height = 73
    ColCount = 2
    RowCount = 2
    FixedRows = 0
    TabOrder = 1
    RowHeights = (
      24
      24)
  end
  object Edit1: TEdit
    Left = 704
    Top = 128
    Width = 33
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 744
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Generate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 824
    Top = 128
    Width = 169
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1093#1077#1096'-'#1090#1072#1073#1083#1080#1094#1091
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 712
    Top = 216
    Width = 49
    Height = 21
    TabOrder = 5
  end
  object Button3: TButton
    Left = 888
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Find'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = Button3Click
  end
  object Edit3: TEdit
    Left = 984
    Top = 216
    Width = 281
    Height = 21
    TabOrder = 7
  end
  object Button4: TButton
    Left = 792
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Delete'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = Button4Click
  end
  object Button6: TButton
    Left = 672
    Top = 256
    Width = 385
    Height = 25
    Caption = 'Show Elements in each stack'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button5: TButton
    Left = 1008
    Top = 128
    Width = 129
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091
    TabOrder = 10
    OnClick = Button5Click
  end
end
