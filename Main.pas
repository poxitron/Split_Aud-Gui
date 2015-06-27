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

unit Main;

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
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
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
  if Msg.message=WM_DROPFILES then
  begin
    QtyDroppedFiles:=DragQueryFile(Msg.wParam, Cardinal(-1), nil, 0);
    try
      for FileIndex:=0 to QtyDroppedFiles -1 do
      begin
        DragQueryFile(Msg.wParam, FileIndex, @pDroppedFilename, sizeof(pDroppedFilename));
        if Msg.hwnd=SourceFile_Edit.Handle then
          begin
           SourceFile_Edit.Text:=PChar(@pDroppedFilename);
          end;
      end;
    finally
      DragFinish(Msg.wParam);
      Handled:=True;
    end;
  end;
end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String);
var
  i: Integer;
begin
 for i := Low(FileNames) to High(FileNames) do
  SourceFile_Edit.Text:=FileNames[i];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin  //Asignar los valores a las variables
  Merge:= ' -m';
  Remove:= ' -r';
  Verbose:= ' -v';
  Framerate:=' -f 24000/1001';
  avsfile:=GetCurrentDir+'\temp.avs';
  Application.OnMessage:=AppMessage;
  DragAcceptFiles(SourceFile_Edit.Handle, True);
  with Form1.Constraints do
    begin
      MinWidth:=505;
      MinHeight:=220;
      MaxWidth:=0;
      MaxHeight:=220;
    end;
  try  //Leer y cargar el archivo de configuración
   INI := TINIFile.Create(GetCurrentDir+'\config.ini');
   Merge_CheckBox.Checked:=INI.ReadBool('Config','Merge',true);
   Remove_CheckBox.Checked:=INI.ReadBool('Config','Remove',true);
   Verbose_CheckBox.Checked:=INI.ReadBool('Config','Verbose',true);
   Framerate_ComboBox.ItemIndex:=INI.ReadInteger('Config','Framerate',0);
   OpenDialog.InitialDir:=INI.ReadString('Config','Latest',GetCurrentDir);
  finally
    INI.Free;
  end;
end;

//Guardar la configuración al salir
procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  try
   INI:=TINIFile.Create(GetCurrentDir+'\config.ini');
   INI.WriteBool('Config','Merge',Merge_CheckBox.Checked);
   INI.WriteBool('Config','Remove',Remove_CheckBox.Checked);
   INI.WriteBool('Config','Verbose',Verbose_CheckBox.Checked);
   INI.WriteInteger('Config','Framerate',Framerate_ComboBox.ItemIndex);
   if SourceFile_Edit.Text<>'' then
     INI.WriteString('Config','Latest',ExtractFilePath(SourceFile_Edit.Text));
  finally
   INI.Free;
  end;
end;

procedure TForm1.ShowLog_ButtonClick(Sender: TObject);
begin
 Form1.Constraints.MinHeight:=400;
 Form1.Constraints.MaxHeight:=0;
 Log_Memo.Visible:=True;
 ShowLog_Button.Visible:=False;
 HideLog_Button.Visible:=True;
end;

procedure TForm1.HideLog_ButtonClick(Sender: TObject);
begin
  Form1.Constraints.MinHeight:=220;
  Form1.Constraints.MaxHeight:=220;
  Log_Memo.Visible:=False;
  HideLog_Button.Visible:=False;
  ShowLog_Button.Visible:=True;
end;


//---- Archivo de origen y destino ----
procedure TForm1.SourceFile_ButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    SourceFile_Edit.Text:=OpenDialog.Filename;
  end;
end;

//Copia la ruta de origen a la de destino
procedure TForm1.SourceFile_EditChange(Sender: TObject);
var
  f: string;
begin
  f:=ExtractFilePath(SourceFile_Edit.Text)+ExtractFileNameOnly(SourceFile_Edit.Text);
  DestinationFile_Edit.Text:=f+'_split.mka';
end;

procedure TForm1.DestinationFile_ButtonClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    DestinationFile_Edit.Text:=SaveDialog.FileName;
  end;
end;
//-------------------------------

//Asignar el comando a la variable según el estado del CheckBox y del ComboBox
procedure TForm1.Merge_CheckBoxClick(Sender: TObject);
begin
  if Merge_CheckBox.Checked then
    Merge:=' -m'
  else
    Merge:='';
end;

procedure TForm1.Remove_CheckBoxClick(Sender: TObject);
begin
  if Remove_CheckBox.Checked then
    Remove:=' -r'
  else
    Remove:='';
end;

procedure TForm1.Verbose_CheckBoxClick(Sender: TObject);
begin
  if Verbose_CheckBox.Checked then
    Verbose:=' -v'
  else
    Verbose:='';
end;

procedure TForm1.Framerate_ComboBoxSelect(Sender: TObject);
begin
  if Framerate_ComboBox.ItemIndex = 0 then
    Framerate:=' -f 24000/1001'
  else
    if Framerate_ComboBox.ItemIndex = 1 then
      Framerate:=' -f 30000/1001';
end;

procedure TForm1.AddTrim_ButtonClick(Sender: TObject);
begin
  if Trims_Edit.Text='' then
    Trims_Edit.Text:='trim(0,0)'
  else
    Trims_Edit.Text:=Trims_Edit.Text+'+trim(0,0)';
end;

procedure TForm1.DeleteTrim_ButtonClick(Sender: TObject);
var
  RegEx: TRegEx;
  M: TMatch;
begin
  RegEx.Create('\+trim\([0-9]+,[0-9]+\)$',[roSingleLine]);
  M := Regex.Match(Trims_Edit.Text);
  if M.Success then
    Trims_Edit.Text:= RegEx.Replace(Trims_Edit.Text,'');
end;

//Inicar el proceso de cortado del audio
procedure TForm1.CutButtonClick(Sender: TObject);
var
  AStringList: TStringList;
begin
  input:=SourceFile_Edit.Text;
  output:=DestinationFile_Edit.Text;
  ejecutable:='"'+GetCurrentDir+'\split_aud.exe "';
  parametros:=Merge+Remove+Verbose+Framerate+' -i "'+input+'" -o "'+output+'" "'+avsfile+'"';
  if input='' then
    MessageDlg('No has seleccionado ningún archivo para cortar.', mtError, [mbOK], 0)
  else
  if not FileExists(input) then
    MessageDlg('El archivo de origen no existe.', mtError, [mbOK], 0)
  else
  try
    Estado_Label.Caption:='Estado: Cortando el archivo...';
    AStringList:=TStringList.Create;
    AStringList.Add(Trims_Edit.Text);
    AStringList.SaveToFile(avsfile);
    Log_Memo.Clear;
    CaptureConsoleOutputMod(ejecutable, parametros, Log_Memo);
  finally
    AStringList.Free;
    Estado_Label.Caption:='Estado: Operación finalizada.';
  end;
end;

end.

