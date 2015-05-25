object Form1: TForm1
  Left = 409
  Top = 135
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
  object StringGrid1: TStringGrid
    Left = 208
    Top = 72
    Width = 121
    Height = 193
    ColCount = 2
    DefaultColWidth = 50
    RowCount = 7
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    OnExit = StringGrid1Exit
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24)
  end
  object Edit1: TEdit
    Left = 352
    Top = 72
    Width = 153
    Height = 21
    TabOrder = 1
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 352
    Top = 104
    Width = 153
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 520
    Top = 72
    Width = 113
    Height = 25
    Caption = 'Transform'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button1Click
  end
  object Edit3: TEdit
    Left = 360
    Top = 208
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object Button2: TButton
    Left = 352
    Top = 168
    Width = 129
    Height = 25
    Caption = 'Calculate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button2Click
  end
end
