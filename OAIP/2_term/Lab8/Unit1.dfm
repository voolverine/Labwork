object Form1: TForm1
  Left = 371
  Top = 144
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
    Left = 192
    Top = 40
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
    Left = 208
    Top = 480
    Width = 302
    Height = 16
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080#1084#1105#1085' '#1085#1072#1095#1080#1085#1072#1102#1097#1080#1093#1089#1103' '#1089' '#1073#1091#1082#1074#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 560
    Top = 480
    Width = 9
    Height = 16
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StringGrid1: TStringGrid
    Left = 192
    Top = 72
    Width = 233
    Height = 329
    ColCount = 2
    FixedCols = 0
    RowCount = 10
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    ColWidths = (
      121
      100)
  end
  object Edit1: TEdit
    Left = 224
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 352
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Change'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object TreeView1: TTreeView
    Left = 456
    Top = 40
    Width = 281
    Height = 361
    Indent = 19
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 760
    Top = 40
    Width = 273
    Height = 361
    TabOrder = 4
  end
  object Button2: TButton
    Left = 208
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Add in tree'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 296
    Top = 416
    Width = 97
    Height = 25
    Caption = 'Remove from tree'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 768
    Top = 416
    Width = 121
    Height = 25
    Caption = #1055#1088#1103#1084#1086#1081' '#1086#1073#1093#1086#1076
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 920
    Top = 416
    Width = 107
    Height = 25
    Caption = #1054#1073#1088#1072#1090#1085#1099#1081' '#1086#1073#1093#1086#1076
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 600
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Delete Tree'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 496
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Balance'
    TabOrder = 10
    OnClick = Button7Click
  end
  object Edit2: TEdit
    Left = 520
    Top = 480
    Width = 33
    Height = 21
    TabOrder = 11
  end
  object Edit3: TEdit
    Left = 576
    Top = 480
    Width = 57
    Height = 21
    TabOrder = 12
  end
  object Button8: TButton
    Left = 640
    Top = 480
    Width = 75
    Height = 25
    Caption = 'Get this'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    OnClick = Button8Click
  end
end
