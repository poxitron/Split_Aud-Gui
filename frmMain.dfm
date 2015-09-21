object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Split_Aud GUI 1.0.1'
  ClientHeight = 366
  ClientWidth = 489
  Color = clBtnFace
  Constraints.MinWidth = 489
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    000000000000000000000000000000000000B4AEE05C8482D09A6161B8BF635F
    BCC08B85E39DB0B0EA62FFFFFF06000000000000000000000000000000000000
    00000000000000000000C3C3E6523332ACDF0D08A4FF0D09A5FF1611A8FF1C18
    AAFF180CB5FF1D0ECBFF493FD0E5C2BFE7580000000000000000000000000000
    000000000000ADAAD96D160FA5FF4340B9FF2B29B3FF362EB5FF423EB8FF3230
    B3FF3132ACFF3935BCFF281ECDFF1C11C5FFAAA6E47C00000000000000000000
    0000D1D5E53D0E09A3FF625FC6FF8C88D2FF6560CAFF6261C3FF7E7DCFFF1F1D
    ADFF3432B5FF3131ADFF3937BAFF382BD4FF220FCAFFC4C1EA57000000000000
    00004948B6E11E1BADFF8B88D0FF0700A2FF5E56C3FF8888CFFF3F3DB4FF5451
    C0FF3432B4FF4948BBFF5553BDFF4239C9FF2E1ED4FF4A3AD0F8EBFEFE0DC9C9
    E5471813ACFF241FAFFF5F5AC2FF7C7ACFFF7F81CAFF9A90D1FF6D6BC8FFACA6
    DFFF7874CCFF4946BBFFC0BBE5FF5D56CAFF4537D8FF281BCCFFBFBFEB5C9997
    D685100AA5FF3731B5FF2522ACFF4847BDFFABA8E0FFA39EDEFF7F79CDFFADA8
    DFFFAEA9E0FF9B96D9FFA9A4DDFF8B86D7FF4B3ED6FF2317D0FF969BE8958482
    CEA2120CA7FF3732B4FF3935B5FF0A03A4FF5F5AC4FFE0E2F6FF8581D2FFA39E
    DCFFA19CDBFF9C98D9FFA09BDAFF938ED9FFD6CDF2FF4A3FD8FF7E7EE4B88484
    CFA2130BA7FF3732B3FF3533B3FF120EA8FFC0BFE8FFD6D2ECFF6D69C6FFA7A2
    DEFFA19CDBFF9C98D9FF9F9BD9FF938DDAFFCBC2F0FF483ED7FF7F82E4B49D9D
    DE7E1109A3FF3733B4FF201EAFFF4A49BBFFF5F2FCFF8485CFFF8884D2FFA5A0
    DCFFA29DDBFF9D98D9FFA8A4DCFF857EDAFF4838D8FF2116CDFF9AA1EA8BD6D6
    F538271CBDFF2D2BAEFF0E09A5FFABA9E0FFD8D8F0FF2E29B0FF908CD4FFABA6
    DFFFA5A0DCFF4341B6FFC2BBE7FF6155D9FF4334D7FF2A20CCFFCCD0F0470000
    00007067DACA0E03B8FF2F2FABFFEAEAF7FF7371CEFF3C35B5FF7672CDFF9792
    D8FF5553BEFF5856BFFF7F77DBFF4B3CDAFF2414CCFF5E56D2E0000000000000
    0000E9E9F724281DCDFF3A31C5FFB7B3E4FF362BCBFF514AC4FF6461C3FF615F
    C1FF3332B1FF584FD0FF6558DFFF301FD1FF2A1ECBFFDDDDF535000000000000
    000000000000D6D6F045312ACCFC190EC2FF362DD3FF5147D4FF4F48CBFF3430
    BCFF4138CBFF4636DAFF2414CDFF2C1FC8FFC7C7ED5700000000000000000000
    00000000000000000000E9E9F024675DD6B73025C9FF190CC5FF200ECEFF2D1B
    D3FF2312CEFF2A1CCCFF6259D5D0DEDEF1370000000000000000000000000000
    000000000000000000000000000000000000DEDEF42F9F99E17B8781DCA2847D
    DFAB928BE296C9CCEF510000000000000000000000000000000000000000F80F
    2600E0072600C003260080012600800026000000260000002600000026000000
    260000002600000026008001260080012600C0032600E0072600F81F2600}
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    489
    366)
  PixelsPerInch = 96
  TextHeight = 13
  object Estado_Label: TLabel
    Left = 84
    Top = 161
    Width = 92
    Height = 13
    Caption = 'Estado: En espera.'
  end
  object Label1: TLabel
    Left = 8
    Top = 20
    Width = 36
    Height = 13
    Caption = 'Origen:'
    Color = clBtnFace
    ParentColor = False
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 40
    Height = 13
    Caption = 'Destino:'
    Color = clBtnFace
    ParentColor = False
  end
  object Label3: TLabel
    Left = 8
    Top = 84
    Width = 36
    Height = 13
    Caption = 'Cortes:'
    Color = clBtnFace
    ParentColor = False
  end
  object AddTrim_Button: TButton
    Left = 432
    Top = 80
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '+'
    TabOrder = 5
    OnClick = AddTrim_ButtonClick
  end
  object CutButton: TButton
    Left = 413
    Top = 150
    Width = 70
    Height = 24
    Anchors = [akTop, akRight]
    Caption = 'Cortar'
    TabOrder = 10
    OnClick = CutButtonClick
  end
  object DeleteTrim: TButton
    Left = 460
    Top = 79
    Width = 23
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '-'
    TabOrder = 6
    OnClick = DeleteTrim_ButtonClick
  end
  object DestinationFile_Button: TButton
    Left = 432
    Top = 48
    Width = 51
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = DestinationFile_ButtonClick
  end
  object DestinationFile_Edit: TEdit
    Left = 56
    Top = 48
    Width = 368
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object HideLog_Button: TButton
    Left = 8
    Top = 149
    Width = 70
    Height = 25
    Caption = 'Ocultar log'
    TabOrder = 9
    Visible = False
    OnClick = HideLog_ButtonClick
  end
  object Log_Memo: TMemo
    Left = 8
    Top = 180
    Width = 473
    Height = 184
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 11
    Visible = False
  end
  object Panel2: TPanel
    Left = 56
    Top = 107
    Width = 370
    Height = 22
    Anchors = [akTop]
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 7
    DesignSize = (
      370
      22)
    object Label4: TLabel
      Left = 247
      Top = 5
      Width = 54
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Framerate:'
      Color = clBtnFace
      ParentColor = False
    end
    object Merge_CheckBox: TCheckBox
      Left = 0
      Top = 2
      Width = 60
      Height = 19
      Caption = 'Combinar'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = Merge_CheckBoxClick
    end
    object Remove_CheckBox: TCheckBox
      Left = 70
      Top = 2
      Width = 60
      Height = 19
      Caption = 'Eliminar'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = Remove_CheckBoxClick
    end
    object Verbose_CheckBox: TCheckBox
      Left = 132
      Top = 2
      Width = 80
      Height = 19
      Caption = 'Log detallado'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = Verbose_CheckBoxClick
    end
    object Framerate_ComboBox: TComboBox
      Left = 305
      Top = 1
      Width = 64
      Height = 21
      Anchors = [akTop, akRight]
      ItemIndex = 0
      TabOrder = 3
      Text = '23,976'
      OnSelect = Framerate_ComboBoxSelect
      Items.Strings = (
        '23,976'
        '29,970')
    end
  end
  object ShowLog_Button: TButton
    Left = 8
    Top = 149
    Width = 70
    Height = 25
    Caption = 'Mostrar log'
    TabOrder = 8
    OnClick = ShowLog_ButtonClick
  end
  object SourceFile_Button: TButton
    Left = 432
    Top = 16
    Width = 51
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 1
    OnClick = SourceFile_ButtonClick
  end
  object SourceFile_Edit: TEdit
    Left = 56
    Top = 16
    Width = 368
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = SourceFile_EditChange
  end
  object Trims_Edit: TEdit
    Left = 56
    Top = 82
    Width = 370
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = 'trim(0,0)'
  end
  object OpenDialog: TOpenDialog
    Left = 280
    Top = 136
  end
  object SaveDialog: TSaveDialog
    Filter = 'Matroska audio|*.mka'
    Left = 352
    Top = 136
  end
end
