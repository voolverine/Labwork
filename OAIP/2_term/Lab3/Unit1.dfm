object Form1: TForm1
  Left = 570
  Top = 195
  Width = 1305
  Height = 675
  Caption = '8'
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
    Left = 696
    Top = 40
    Width = 553
    Height = 305
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object StringGrid1: TStringGrid
    Left = 24
    Top = 72
    Width = 545
    Height = 73
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
    TabOrder = 1
    ColWidths = (
      64
      232
      129
      99
      64)
  end
  object Button1: TButton
    Left = 584
    Top = 64
    Width = 81
    Height = 25
    Caption = 'Add student'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 776
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Show All'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 872
    Top = 352
    Width = 121
    Height = 25
    Caption = 'Show Minsk Students'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 584
    Top = 104
    Width = 81
    Height = 25
    Caption = 'Delete Student'
    TabOrder = 5
    OnClick = Button4Click
  end
end
