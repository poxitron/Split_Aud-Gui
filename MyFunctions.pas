{
        File: MyFunctions.pas
        License: GPLv3
        This file is part of Split_Aud Gui.
}

unit MyFunctions;

interface

uses
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
 Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ShellAPI,
 INIFiles, Vcl.ExtCtrls, Vcl.Buttons, System.Zip, System.UITypes;


 type
    TArg<T> = reference to procedure(const Arg: T);

function ExtractFileNameOnly(const FileName: string): string;
function GetAppVersion:string; // código extraído del blog de choirul ihwan
function RunAsAdminAndWaitForCompletion(hWnd: HWND; filename: string; Parameters: string): Boolean;
procedure ExecNewProcess(ProgramName: String; ShowCmd: DWORD; Wait: Boolean);  // código de Chris Bray
procedure CaptureConsoleOutput(const ACommand, AParameters: String; CallBack: TArg<PAnsiChar>);
procedure CaptureConsoleOutputMod(const ACommand, AParameters: String; AMemo: TMemo);


implementation

function ExtractFileNameOnly(const FileName: string): string;
begin
  Result:=ChangeFileExt(ExtractFileName(FileName), '');
end;

function GetAppVersion:string;
var
 Size, Size2: DWord;
 Pt, Pt2: Pointer;
 begin
   Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
   if Size > 0 then
   begin
     GetMem (Pt, Size);
     try
       GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
       VerQueryValue (Pt, '\', Pt2, Size2);
       with TVSFixedFileInfo (Pt2^) do
       begin
         Result:= ' '+
         IntToStr (HiWord (dwFileVersionMS)) + '.' +
         IntToStr (LoWord (dwFileVersionMS)) + '.' +
         IntToStr (HiWord (dwFileVersionLS)) + '.' +
         IntToStr (LoWord (dwFileVersionLS));
       end;
     finally
     FreeMem (Pt);
   end;
 end;
end;

function RunAsAdminAndWaitForCompletion(hWnd: HWND; filename: string; Parameters: string): Boolean;
var
  sei: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  ZeroMemory(@sei, SizeOf(sei));
  sei.cbSize := SizeOf(TShellExecuteInfo);
  sei.Wnd := hwnd;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
  sei.lpVerb := PChar('runas');
  sei.lpFile := PChar(Filename); // PAnsiChar;
  if parameters <> '' then
    sei.lpParameters := PChar(parameters); // PAnsiChar;
    sei.nShow := SW_HIDE; //Integer;

  if ShellExecuteEx(@sei) then begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(sei.hProcess, ExitCode) ;
    until (ExitCode <> STILL_ACTIVE) or  Application.Terminated;
  end;
end;

procedure ExecNewProcess(ProgramName: String; ShowCmd: DWORD; Wait: Boolean);
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CreateOK: Boolean;
begin
    { fill with known state }
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb:= SizeOf(TStartupInfo);
  StartInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
  StartInfo.wShowWindow:= ShowCmd;
  CreateOK:= CreateProcessW(nil, PChar(ProgramName), nil, nil,False,
              CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS,
              nil, nil, StartInfo, ProcInfo);
    { check to see if successful }
  if CreateOK then
    begin
        //may or may not be needed. Usually wait for child processes
      if Wait then
        WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    end
  else
    begin
      ShowMessage('Unable to run '+ProgramName);
     end;

  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;


//Anonymous procedure approach by Lars Fosdal
procedure CaptureConsoleOutput(const ACommand, AParameters: String; CallBack: TArg<PAnsiChar>);
const
  CReadBuffer = 2400;
var
  saSecurity: TSecurityAttributes;
  hRead: THandle;
  hWrite: THandle;
  suiStartup: TStartupInfo;
  piProcess: TProcessInformation;
  pBuffer: array [0 .. CReadBuffer] of AnsiChar;
  dBuffer: array [0 .. CReadBuffer] of AnsiChar;
  dRead: DWORD;
  dRunning: DWORD;
  dAvailable: DWORD;
begin
  saSecurity.nLength := SizeOf(TSecurityAttributes);
  saSecurity.bInheritHandle := true;
  saSecurity.lpSecurityDescriptor := nil;
  if CreatePipe(hRead, hWrite, @saSecurity, 0) then
    try
      FillChar(suiStartup, SizeOf(TStartupInfo), #0);
      suiStartup.cb := SizeOf(TStartupInfo);
      suiStartup.hStdInput := hRead;
      suiStartup.hStdOutput := hWrite;
      suiStartup.hStdError := hWrite;
      suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      suiStartup.wShowWindow := SW_HIDE;
      if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity, @saSecurity, true, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup,
        piProcess) then
        try
          repeat
            dRunning := WaitForSingleObject(piProcess.hProcess, 100);
            PeekNamedPipe(hRead, nil, 0, nil, @dAvailable, nil);
            if (dAvailable > 0) then
              repeat
                dRead := 0;
                ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
                pBuffer[dRead] := #0;
                OemToCharA(pBuffer, dBuffer);
                CallBack(dBuffer);
              until (dRead < CReadBuffer);
            Application.ProcessMessages;
          until (dRunning <> WAIT_TIMEOUT);
        finally
          CloseHandle(piProcess.hProcess);
          CloseHandle(piProcess.hThread);
        end;
    finally
      CloseHandle(hRead);
      CloseHandle(hWrite);
    end;
end;

//Versión modificada
procedure CaptureConsoleOutputMod(const ACommand, AParameters: String; AMemo: TMemo);
const
  CReadBuffer = 2400;
var
  saSecurity: TSecurityAttributes;
  hRead: THandle;
  hWrite: THandle;
  suiStartup: TStartupInfo;
  piProcess: TProcessInformation;
  pBuffer: array [0 .. CReadBuffer] of AnsiChar;
  dRead: DWORD;
  dRunning: DWORD;
  dAvailable: DWORD;
begin
  saSecurity.nLength := SizeOf(TSecurityAttributes);
  saSecurity.bInheritHandle := true;
  saSecurity.lpSecurityDescriptor := nil;
  if CreatePipe(hRead, hWrite, @saSecurity, 0) then
    try
      FillChar(suiStartup, SizeOf(TStartupInfo), #0);
      suiStartup.cb := SizeOf(TStartupInfo);
      suiStartup.hStdInput := hRead;
      suiStartup.hStdOutput := hWrite;
      suiStartup.hStdError := hWrite;
      suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      suiStartup.wShowWindow := SW_HIDE;
      if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity, @saSecurity, true, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup,
        piProcess) then
        try
          repeat
            dRunning := WaitForSingleObject(piProcess.hProcess, 100);
            PeekNamedPipe(hRead, nil, 0, nil, @dAvailable, nil);
            if (dAvailable > 0) then
              repeat
                dRead := 0;
                ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
                pBuffer[dRead] := #0;
                AnsiToUtf8(pBuffer);
                AMemo.Lines.Add(pBuffer)
              until (dRead < CReadBuffer);
            Application.ProcessMessages;
          until (dRunning <> WAIT_TIMEOUT);
        finally
          CloseHandle(piProcess.hProcess);
          CloseHandle(piProcess.hThread);
        end;
    finally
      CloseHandle(hRead);
      CloseHandle(hWrite);
    end;
end;

end.
