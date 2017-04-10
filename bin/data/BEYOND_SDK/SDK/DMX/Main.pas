unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, DllCalls, ShellAPI, StdCtrls;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    mnStartBEYOND: TMenuItem;
    mnAbout: TMenuItem;
    pnStatus: TPanel;
    tmStatus: TTimer;
    N1: TMenuItem;
    sbMain: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnStartBEYONDClick(Sender: TObject);
    procedure mnAboutClick(Sender: TObject);
    procedure tmStatusTimer(Sender: TObject);
    procedure sbMainChange(Sender: TObject);
  private
    { Private declarations }
  public
    data:array[0..511] of byte;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  i:integer;
  sb: TScrollBar;
begin
  ldbCreate;
  tmStatus.Enabled:=true;

  for i:=1 to 31 do begin
    sb := TScrollBar.Create(Self);
    sb.Name := 'sb'+inttostr(i);
    sb.Parent := Self;
    sb.Kind := sbVertical;
    sb.Left := 8+i*24;
    sb.Top := 8;
    sb.Width := 17;
    sb.Height := 201;
    sb.Anchors := [akLeft, akTop];
    sb.Max := 255;
    sb.PageSize := 0;
    sb.Tag:=i;
    sb.position:=255;
    sb.OnChange:=sbMainChange;
  end;
  ClientWidth:=24*32+16;
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

procedure TMainForm.sbMainChange(Sender: TObject);
begin
  data[(Sender as TScrollBar).Tag]:=255-(Sender as TScrollBar).Position;
  // 0 - index of DMX IN, value 0..3
  // @Data - pointer on 512 DMX Channel array
  ldbSetDmx(0, @data);
end;

end.
