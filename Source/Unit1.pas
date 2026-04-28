unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WinInet, StdCtrls, ExtCtrls, ShellAPI, IniFiles, ComCtrls, MMSystem;

type
  TMain = class(TForm)
    Panel: TPanel;
    TextLbl: TLabel;
    TimerDelay: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerDelayTimer(Sender: TObject);
  private
    procedure ThreadTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyThread = class(TThread)
    private
      { Private declarations }
      //procedure UpdateUI;
    protected
      procedure Execute; override;
  end;

var
  Main: TMain;
  MyThread: TMyThread;
  AppsList: TStringList;
  WriteLaunchTime, WaitInternetMode: boolean;
  TimeFinished: boolean = false;
  StartTime, LaunchTime: int64;

  IDS_WAITING_TIME, IDS_WAITING_INTERNET_CONNECTION, IDS_REMAINING_TIME: string;
  SoundPlay: boolean;
  SoundFileName: string;

implementation

{$R *.dfm}

function HTTPGet(URL: string): string;
var
  hSession, hUrl: HINTERNET;
  Buffer: array [1..8192] of Byte;
  dwFlags, BufferLen: DWORD;
  StrStream: TStringStream;
begin
  Result:='';
  hSession:=InternetOpen('Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hSession) then begin

    if Copy(LowerCase(URL), 1, 8) = 'https://' then
      dwFlags:=INTERNET_FLAG_SECURE
    else
      dwFlags:=INTERNET_FLAG_RELOAD;

    hUrl:=InternetOpenUrl(hSession, PChar(URL), nil, 0, dwFlags, 0);
    if Assigned(hUrl) then begin
      StrStream:=TStringStream.Create('');
      try
        try
          repeat
            FillChar(Buffer, SizeOf(Buffer), 0);
            BufferLen:=0;
            if InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen) then
              StrStream.WriteBuffer(Buffer, BufferLen)
            else
              Break;
            Application.ProcessMessages;
          until BufferLen = 0;
          Result:=StrStream.DataString;
        except
          Result:='';
        end;
      finally
        StrStream.Free;
      end;

      InternetCloseHandle(hUrl);
    end;

    InternetCloseHandle(hSession);
  end;
end;

procedure TMain.ThreadTerminate(Sender: TObject);
begin
  //MyThread.Free; // блокирует закрывание
  MyThread:=nil;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

function GetLocaleInformation(Flag: integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  AppsFileName: string;
  ForceEngLang: boolean;
  i: integer;
begin
  StartTime:=GetTickCount;

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  WaitInternetMode:=Ini.ReadBool('Main', 'WaitInternet', false);
  WriteLaunchTime:=Ini.ReadBool('Main', 'WriteLaunchTime', false);
  LaunchTime:=Ini.ReadInteger('Main', 'LaunchTime', 0) * 1000;
  SoundPlay:=Ini.ReadBool('Main', 'PlaySound', false);
  SoundFileName:=Trim(Ini.ReadString('Main', 'SoundFile', ''));
  Ini.Free;

  ForceEngLang:=false;
  AppsFileName:=ExtractFilePath(ParamStr(0)) + 'Apps.txt';
  for i:=0 to ParamCount do begin
    if (ParamStr(i) = '-f') and (ParamStr(i + 1) <> '') and (FileExists(ParamStr(i + 1))) then
      AppsFileName:=ParamStr(i + 1)
    else if ParamStr(i) = '-en' then
      ForceEngLang:=true;
  end;

  AppsList:=TStringList.Create;
  if FileExists(AppsFileName) then begin
    AppsList.LoadFromFile(AppsFileName);
    AppsList.Text:=UTF8ToAnsi(AppsList.Text);
  end;

  MyThread:=TMyThread.Create(False);
  MyThread.Priority:=tpNormal;
  MyThread.OnTerminate:=ThreadTerminate;

  Application.Title:=Caption;
  if (ForceEngLang) or (GetLocaleInformation(LOCALE_SENGLANGUAGE) <> 'Russian')  then begin
    IDS_WAITING_TIME:='Waiting...';
    IDS_WAITING_INTERNET_CONNECTION:='Waiting for internet connection...';
    IDS_REMAINING_TIME:='Remaining time: ';
  end else begin
    IDS_WAITING_TIME:='ќжидаем...';
    IDS_WAITING_INTERNET_CONNECTION:='∆дЄм подключени€ интернет-соединени€...';
    IDS_REMAINING_TIME:='ќсталось времени: ';
  end;

  if WaitInternetMode then
    Main.TextLbl.Caption:=IDS_WAITING_INTERNET_CONNECTION + #13#10 + IDS_REMAINING_TIME + '0:00'
  else
    Main.TextLbl.Caption:=IDS_WAITING_TIME + #13#10 + IDS_REMAINING_TIME + '0:00';
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AppsList.Free;
  if Assigned(MyThread) then
  begin
    MyThread.Terminate;
    MyThread.WaitFor;
    MyThread.Free;
    MyThread:=nil;
  end;
end;

function MsToMinSec(Ms: int64): string;
var
  Minutes, Seconds: Integer;
begin
  Seconds:=Ms div 1000;
  Minutes:=Seconds div 60;
  Seconds:=Seconds mod 60;
  Result:=Format('%d:%2.2d', [Minutes, Seconds]);
end;

{procedure TMyThread.UpdateUI;
begin

end;}

procedure TMyThread.Execute;
var
  Ini: TIniFile;
  AppPath, AppParams: string;
  i, DelimPos: integer;
begin
  while not Terminated do begin
    //Synchronize(UpdateUI);

    if (TimeFinished) or (WaitInternetMode and (HTTPGet('http://www.msftconnecttest.com/connecttest.txt') = 'Microsoft Connect Test') ) then begin

      if (SoundPlay) and (SoundFileName <> '') then
        sndPlaySound(PChar(SoundFileName), SND_SYNC);

      if (WaitInternetMode) and (WriteLaunchTime) then begin
        Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
        Ini.WriteBool('Main', 'FirstRun', False);
        Ini.WriteInteger('Main', 'LaunchTime', (GetTickCount - StartTime) div 1000);
        Ini.Free;
      end;

      for i:=0 to AppsList.Count - 1 do begin

        if Trim(AppsList.Strings[i]) = '' then Continue;
        if Trim(AppsList.Strings[i])[1] = '#' then Continue;

        DelimPos:=Pos('|', AppsList.Strings[i]);

        if DelimPos > 0 then begin
          AppPath:=Copy(AppsList.Strings[i], 1, DelimPos - 1);
          AppParams:=Copy(AppsList.Strings[i], DelimPos + 1, Length(AppsList.Strings[i]) - DelimPos);
        end else begin
          AppPath:=AppsList.Strings[i];
          AppParams:='';
        end;

        if not FileExists(AppPath) then Continue;

        ShellExecute(0, 'open', PChar(AppPath), PChar(AppParams), nil, SW_SHOWNORMAL);

      end;

      Terminate;
    end;

    Sleep(1000);
  end;
end;

procedure TMain.TimerDelayTimer(Sender: TObject);
var
  RemainingTime: int64;
begin
  RemainingTime:=LaunchTime - (GetTickCount - StartTime);
  if RemainingTime < 0 then begin
    RemainingTime:=0;
    if WaitInternetMode = false then
      TimeFinished:=true;
  end;

  if WaitInternetMode then
    Main.TextLbl.Caption:=IDS_WAITING_INTERNET_CONNECTION + #13#10 + IDS_REMAINING_TIME + MsToMinSec(RemainingTime)
  else
    Main.TextLbl.Caption:=IDS_WAITING_TIME + #13#10 + IDS_REMAINING_TIME + MsToMinSec(RemainingTime);
end;

end.
