{
        Split_Aud Gui
        Copyright © 2014, poxitron
        This file is part of Split_Aud Gui.

    Split_Aud Gui is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Split_Aud Gui is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Split_Aud Gui.  If not, see <http://www.gnu.org/licenses/>.
}

unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.UITypes, Winapi.ShellAPI, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons, INIFiles, RegularExpressions, Vcl.ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    AddTrim_Button: TButton;
    DeleteTrim: TButton;
    DestinationFile_Button: TButton;
    DestinationFile_Edit: TEdit;
    SaveDialog: TSaveDialog;
    SourceFile_Button: TButton;
    SourceFile_Edit: TEdit;
    OpenDialog: TOpenDialog;
    CutButton: TButton;
    Trims_Edit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Merge_CheckBox: TCheckBox;
    Remove_CheckBox: TCheckBox;
    Verbose_CheckBox: TCheckBox;
    Label4: TLabel;
    Framerate_ComboBox: TComboBox;
    ShowLog_Button: TButton;
    Log_Memo: TMemo;
    HideLog_Button: TButton;
    Estado_Label: TLabel;
    procedure AddTrim_ButtonClick(Sender: TObject);
    procedure DeleteTrim_ButtonClick(Sender: TObject);
    procedure DestinationFile_ButtonClick(Sender: TObject);
    procedure SourceFile_ButtonClick(Sender: TObject);
    procedure CutButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Framerate_ComboBoxSelect(Sender: TObject);
    procedure Merge_CheckBoxClick(Sender: TObject);
    procedure Remove_CheckBoxClick(Sender: TObject);
    procedure SourceFile_EditChange(Sender: TObject);
    procedure Verbose_CheckBoxClick(Sender: TObject);
    procedure ShowLog_ButtonClick(Sender: TObject);
    procedure HideLog_ButtonClick(Sender: TObject);
  private
    { private declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);

  public
    { public declarations }
  end;


var
  Form1: TForm1;
  Merge, Remove, Verbose, Framerate: String;
  avsfile, LastestPath: String;
  input, output: String;
  parametros, ejecutable: String;
  INI: TIniFile;

implementation

uses MyFunctions;

{$R *.dfm}

{ TForm1 }
//Arrastrar y soltar archivos desde Windows
procedure TForm1.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  QtyDroppedFiles, FileIndex: Integer;
  pDroppedFilename: array[0..255] of Char;
begin
  if Msg.message = WM_DROPFILES then
  begin
    QtyDroppedFiles := DragQueryFile(Msg.wParam, Cardinal(-1), nil, 0);
    try
      for FileIndex :=0 to QtyDroppedFiles -1 do
      begin
        DragQueryFile(Msg.wParam, FileIndex, @pDroppedFilename, sizeof(pDroppedFilename));
        if Msg.hwnd = SourceFile_Edit.Handle then
          begin
           SourceFile_Edit.Text := PChar(@pDroppedFilename);
          end;
      end;
    finally
      DragFinish(Msg.wParam);
      Handled := True;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin  //Asignar los valores a las variables
  Merge := ' -m';
  Remove := ' -r';
  Verbose := ' -v';
  Framerate := ' -f 24000/1001';
  avsfile := ExtractFileDir(Application.ExeName) + '\temp.avs';
  Application.OnMessage := AppMessage;
  DragAcceptFiles(SourceFile_Edit.Handle, True);
  with Form1.Constraints do
    begin
      MinWidth := 505;
      MinHeight := 220;
      MaxWidth := 0;
      MaxHeight := 220;
    end;
  try  //Leer y cargar el archivo de configuración
    INI := TINIFile.Create(ExtractFileDir(Application.ExeName) + '\config.ini');
    Merge_CheckBox.Checked := INI.ReadBool('Config', 'Merge', True);
    Remove_CheckBox.Checked := INI.ReadBool('Config', 'Remove', True);
    Verbose_CheckBox.Checked := INI.ReadBool('Config', 'Verbose', True);
    Framerate_ComboBox.ItemIndex := INI.ReadInteger('Config', 'Framerate', 0);
    OpenDialog.InitialDir := INI.ReadString('Config', 'Latest', ExtractFileDir(Application.ExeName));
    Self.Top := INI.ReadInteger('form', 'MainFormTop', Screen.DesktopHeight div 2 - 120);
    Self.Left := INI.ReadInteger('form', 'MainFormLeft', Screen.DesktopWidth div 2 - 225);
    Self.Width := INI.ReadInteger('form', 'MainFormWidth', 500);
    Self.Height := INI.ReadInteger('form', 'MainFormHeight', 520);
  finally
    INI.Free;
  end;
end;

//Guardar la configuración al salir
procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DragAcceptFiles(SourceFile_Edit.Handle, False);
  try
    INI := TINIFile.Create(ExtractFileDir(Application.ExeName) + '\config.ini');
    INI.WriteBool('Config', 'Merge', Merge_CheckBox.Checked);
    INI.WriteBool('Config', 'Remove', Remove_CheckBox.Checked);
    INI.WriteBool('Config', 'Verbose', Verbose_CheckBox.Checked);
    INI.WriteInteger('Config', 'Framerate', Framerate_ComboBox.ItemIndex);
    if SourceFile_Edit.Text <> '' then
    begin
      INI.WriteString('Config', 'Latest', ExtractFilePath(SourceFile_Edit.Text));
    end;
    INI.WriteInteger('form', 'MainFormTop', Self.Top);
    INI.WriteInteger('form', 'MainFormLeft', Self.Left);
    INI.WriteInteger('form', 'MainFormWidth', Self.Width);
    INI.WriteInteger('form', 'MainFormHeight', Self.Height);
  finally
    INI.Free;
  end;
end;

procedure TForm1.ShowLog_ButtonClick(Sender: TObject);
begin
  Form1.Constraints.MinHeight := 400;
  Form1.Constraints.MaxHeight := 0;
  Log_Memo.Visible := True;
  ShowLog_Button.Visible := False;
  HideLog_Button.Visible := True;
end;

procedure TForm1.HideLog_ButtonClick(Sender: TObject);
begin
  Form1.Constraints.MinHeight := 220;
  Form1.Constraints.MaxHeight := 220;
  Log_Memo.Visible := False;
  HideLog_Button.Visible := False;
  ShowLog_Button.Visible := True;
end;


//---- Archivo de origen y destino ----
procedure TForm1.SourceFile_ButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    SourceFile_Edit.Text := OpenDialog.Filename;
  end;
end;

//Copia la ruta de origen a la de destino
procedure TForm1.SourceFile_EditChange(Sender: TObject);
var
  f: string;
begin
  f := ExtractFilePath(SourceFile_Edit.Text) + ExtractFileNameOnly(SourceFile_Edit.Text);
  DestinationFile_Edit.Text := f + '_split.mka';
end;

procedure TForm1.DestinationFile_ButtonClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    DestinationFile_Edit.Text := SaveDialog.FileName;
  end;
end;
//-------------------------------

//Asignar el comando a la variable según el estado del CheckBox y del ComboBox
procedure TForm1.Merge_CheckBoxClick(Sender: TObject);
begin
  if Merge_CheckBox.Checked then
  begin
    Merge := ' -m';
  end
  else
  begin
    Merge := '';
  end;
end;

procedure TForm1.Remove_CheckBoxClick(Sender: TObject);
begin
  if Remove_CheckBox.Checked then
  begin
    Remove := ' -r';
  end
  else
  begin
    Remove := '';
  end;
end;

procedure TForm1.Verbose_CheckBoxClick(Sender: TObject);
begin
  if Verbose_CheckBox.Checked then
  begin
    Verbose := ' -v';
  end
  else
  begin
    Verbose := '';
  end;
end;

procedure TForm1.Framerate_ComboBoxSelect(Sender: TObject);
begin
  if Framerate_ComboBox.ItemIndex = 0 then
  begin
    Framerate := ' -f 24000/1001';
  end
  else
  if Framerate_ComboBox.ItemIndex = 1 then
  begin
    Framerate := ' -f 30000/1001';
  end;
end;

procedure TForm1.AddTrim_ButtonClick(Sender: TObject);
begin
  if Trims_Edit.Text = '' then
  begin
    Trims_Edit.Text := 'trim(0,0)';
  end
  else
  begin
    Trims_Edit.Text := Trims_Edit.Text + '+trim(0,0)';
  end;
end;

procedure TForm1.DeleteTrim_ButtonClick(Sender: TObject);
var
  RegEx: TRegEx;
  M: TMatch;
begin
  RegEx.Create('\+trim\([0-9]+,[0-9]+\)$', [roSingleLine]);
  M := Regex.Match(Trims_Edit.Text);
  if M.Success then
  begin
    Trims_Edit.Text := RegEx.Replace(Trims_Edit.Text, '');
  end;
end;

//Inicar el proceso de cortado del audio
procedure TForm1.CutButtonClick(Sender: TObject);
var
  AStringList: TStringList;
begin
  input := SourceFile_Edit.Text;
  output := DestinationFile_Edit.Text;
  ejecutable := '"' + ExtractFileDir(Application.ExeName) + '\split_aud.exe "';
  parametros := Merge + Remove + Verbose + Framerate + ' -i "' + input + '" -o "' + output + '" "' + avsfile + '"';
  if input = '' then
  begin
    MessageDlg('No has seleccionado ningún archivo para cortar.', mtError, [mbOK], 0);
  end
  else
  if not FileExists(input) then
  begin
    MessageDlg('El archivo de origen no existe.', mtError, [mbOK], 0);
  end
  else
  try
    Estado_Label.Caption := 'Estado: Cortando el archivo...';
    AStringList := TStringList.Create;
    AStringList.Add(Trims_Edit.Text);
    AStringList.SaveToFile(avsfile);
    Log_Memo.Clear;
    CaptureConsoleOutputMod(ejecutable, parametros, Log_Memo);
    Estado_Label.Caption := 'Estado: Operación finalizada.';
  finally
    AStringList.Free;
  end;
end;

end.

