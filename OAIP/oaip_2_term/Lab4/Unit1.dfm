object Form1: TForm1
  Left = 733
  Top = 301
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
  object Memo1: TMemo
    Left = 640
    Top = 80
    Width = 505
    Height = 313
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object StringGrid1: TStringGrid
    Left = 24
    Top = 80
    Width = 465
    Height = 120
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    ColWidths = (
      228
      64
      66
      64
      64)
  end
  object Button1: TButton
    Left = 536
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 536
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 664
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Show all'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 760
    Top = 408
    Width = 177
    Height = 25
    Caption = 'Show with rating >= 4,5'
    TabOrder = 5
    OnClick = Button4Click
  end
end
