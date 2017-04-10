unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, DllCalls, ShellAPI, StdCtrls, mmSystem;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    mnStartBEYOND: TMenuItem;
    mnAbout: TMenuItem;
    pnStatus: TPanel;
    tmStatus: TTimer;
    N1: TMenuItem;
    pnIN: TPanel;
    cbReadIn: TCheckBox;
    lblIn: TLabel;
    pnOUT: TPanel;
    cbSendOut: TCheckBox;
    lblOut: TLabel;
    tmWork: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnStartBEYONDClick(Sender: TObject);
    procedure mnAboutClick(Sender: TObject);
    procedure tmStatusTimer(Sender: TObject);
    procedure cbReadInClick(Sender: TObject);
    procedure cbSendOutClick(Sender: TObject);
    procedure tmWorkTimer(Sender: TObject);
  private
    { Private declarations }
  public
    StartTick:integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ldbCreate;
  tmStatus.Enabled:=true;
  tmWork.Enabled:=true;
  cbReadInClick(nil);
  cbSendOutClick(nil);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ldbDestroy;
end;

procedure TMainForm.mnStartBEYONDClick(Sender: TObject);
var
  DefaultExeFileName:string;
  ErrorCode: Integer;
begin
  DefaultExeFileName:='C:\BEYOND\BEYOND.EXE';
  if not FileExists(DefaultExeFileName)
     then begin
            MessageDlg('BEYOND Application is not found in default folder.', mtInformation, [mbOK], 0);
            exit;
          end;

  ErrorCode := ShellExecute(Handle, 'open', PChar(DefaultExeFileName), nil, nil, SW_SHOWNORMAL);

  if ErrorCode <= HINSTANCE_ERROR { = 32 }
     then begin
            case ErrorCode of
              0: Application.MessageBox(PChar('The operating system is out of memory or resources.'), 'Error', MB_OK or MB_ICONERROR);
              ERROR_FILE_NOT_FOUND: Application.MessageBox(PChar('The specified file was not found.'), 'Error', MB_OK or MB_ICONERROR);
              ERROR_PATH_NOT_FOUND: Application.MessageBox(PChar('The specified path was not found.'), 'Error', MB_OK or MB_ICONERROR);
              ERROR_BAD_FORMAT: Application.MessageBox(PChar('The .exe file is invalid (non-Win32 .exe or error in .exe image).'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_ACCESSDENIED: Application.MessageBox(PChar('The operating system denied access to the specified file.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_ASSOCINCOMPLETE: Application.MessageBox(PChar('The file name association is incomplete or invalid.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_DDEBUSY: Application.MessageBox(PChar('The DDE transaction could not be completed because other DDE transactions were being processed.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_DDEFAIL: Application.MessageBox(PChar('The DDE transaction failed.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_DDETIMEOUT: Application.MessageBox(PChar('The DDE transaction could not be completed because the request timed out.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_DLLNOTFOUND: Application.MessageBox(PChar('The specified DLL was not found.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_NOASSOC: Application.MessageBox(PChar('There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_OOM: Application.MessageBox(PChar('There was not enough memory to complete the operation.'), 'Error', MB_OK or MB_ICONERROR);
              SE_ERR_SHARE: Application.MessageBox(PChar('A sharing violation occurred.'), 'Error', MB_OK or MB_ICONERROR);
              else Application.MessageBox(PChar(Format('Unknown Error %d', [ErrorCode])), 'Error', MB_OK or MB_ICONERROR);
            end;
          end;
end;

procedure TMainForm.mnAboutClick(Sender: TObject);
var
  version:integer;
  build:string;
  ready:string;
begin
  version:=ldbGetDllVersion;
  if ldbBeyondExeReady=1
     then begin
            ready:='Yes';
            build:=inttostr( ldbGetBeyondVersion );
          end
     else begin
            ready:='No';
            build:='N/A';
          end;

  MessageDlg(
    Format(
      'Pangolin Lasershow Designer BEYOND SDK Demo.'#13#10#13#10+
      'DLL version: %s'#13#10+
      'BEYOND Ready: %s'#13#10+
      'BEYOND Build number: %s',
      [FormatFloat('0.00',version/100), ready, build]), mtInformation, [mbOK], 0);
end;

procedure TMainForm.tmStatusTimer(Sender: TObject);
var
  StatusInfo:string;
begin
  if ldbBeyondExeReady=1
     then StatusInfo:='BEYOND Ready ' else
  if ldbBeyondExeStarted=1
     then StatusInfo:='Starting BEYOND, please wait... '
     else StatusInfo:='BEYOND is not started ';

  if pnStatus.Caption<>StatusInfo
     then pnStatus.Caption:=StatusInfo;
end;

procedure TMainForm.cbReadInClick(Sender: TObject);
begin
  if cbReadIn.Checked
     then lblIN.Font.Color:=clGreen
     else lblIN.Font.Color:=clGray
end;

procedure TMainForm.cbSendOutClick(Sender: TObject);
begin
  StartTick:=GetTickCount;

  if cbSendOut.Checked
     then lblOut.Font.Color:=clRed
     else lblOut.Font.Color:=clGray
end;

procedure TMainForm.tmWorkTimer(Sender: TObject);
var
  h,m,s,d:integer;
  T:integer;
begin
 if cbSendOut.checked
     then begin
            T:=GetTickCount-StartTick;
            ldbSetTimeCode(T);

            d:=(T div 10) mod 100;
            s:=(T div 1000) mod 60;
            m:=(T div (60*1000)) mod 60;
            h:=(T div (60*60*1000)) mod 24;

            lblOut.Caption:=FormatFloat('00',h)+':'+FormatFloat('00',m)+':'+FormatFloat('00',s)+':'+FormatFloat('00',d);
          end;

  if cbReadIn.checked
     then begin
            T:=ldbGetTimeCode;
            d:=(T div 10) mod 100;
            s:=(T div 1000) mod 60;
            m:=(T div (60*1000)) mod 60;
            h:=(T div (60*60*1000)) mod 24;

            lblIN.Caption:=FormatFloat('00',h)+':'+FormatFloat('00',m)+':'+FormatFloat('00',s)+':'+FormatFloat('00',d);
          end;
end;

end.
