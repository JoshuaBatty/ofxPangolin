unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, DllCalls, ShellAPI, StdCtrls;

const
  knHipCenter           =00;
  knSpine               =01;
  knShoulderCenter      =02;
  knHead                =03;

  knLeftShoulder        =04;
  knLeftElbow           =05;
  knLeftWrist           =06;
  knLeftHand            =07;

  knRightShoulder       =08;
  knRightElbow          =09;
  knRightWrist          =10;
  knRightHand           =11;

  knLeftHip             =12;
  knLeftKnee            =13;
  knLeftAnkle           =14;
  knLeftFoot            =15;

  knRightHip            =16;
  knRightKnee           =17;
  knRightAnkle          =18;
  knRightFoot           =19;
type
  TKPoint=packed record
    X,Y,Z:single;
    Active:boolean;
  end;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    mnStartBEYOND: TMenuItem;
    mnAbout: TMenuItem;
    pnStatus: TPanel;
    tmStatus: TTimer;
    N1: TMenuItem;
    pbMain: TPaintBox;
    Object1: TMenuItem;
    mnFirst: TMenuItem;
    mnSecond: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnStartBEYONDClick(Sender: TObject);
    procedure mnAboutClick(Sender: TObject);
    procedure tmStatusTimer(Sender: TObject);
    procedure pbMainPaint(Sender: TObject);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnFirstClick(Sender: TObject);
    procedure mnSecondClick(Sender: TObject);
  private
    { Private declarations }
  public
    data:array[0..19] of TKPoint;
    SpaceX:single;
    SpaceY:single;
    DownIndex:integer;

    function ScreenToX(S:integer):single;
    function ScreenToY(S:integer):single;
    function XtoScreen(X:single):integer;
    function YtoScreen(Y:single):integer;
    function KPoint(X,Y:single):TKPoint;
    function FindNode(X,Y:integer):integer;
    procedure SendData;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ldbCreate;
  tmStatus.Enabled:=true;

  SpaceX:=5;
  SpaceY:=5;
  DownIndex:=-1;

  data[knHipCenter      ]:=KPoint(0, 1.1);
  data[knSpine          ]:=KPoint(0, 1.30);
  data[knShoulderCenter ]:=KPoint(0, 1.70);
  data[knHead           ]:=KPoint(0, 1.85);

  data[knLeftShoulder   ]:=KPoint(0.3, 1.65);
  data[knLeftElbow      ]:=KPoint(0.32, 1.45);
  data[knLeftWrist      ]:=KPoint(0.35, 1.35);
  data[knLeftHand       ]:=KPoint(0.35, 1.30);

  data[knRightShoulder  ]:=KPoint(-0.3, 1.65);
  data[knRightElbow     ]:=KPoint(-0.32, 1.45);
  data[knRightWrist     ]:=KPoint(-0.35, 1.35);
  data[knRightHand      ]:=KPoint(-0.35, 1.30);

  data[knLeftHip        ]:=KPoint(0.3,1.0);
  data[knLeftKnee       ]:=KPoint(0.3,0.5);
  data[knLeftAnkle      ]:=KPoint(0.3,0.1);
  data[knLeftFoot       ]:=KPoint(0.35,0.0);

  data[knRightHip       ]:=KPoint(-0.3,1.0);
  data[knRightKnee      ]:=KPoint(-0.3,0.5);
  data[knRightAnkle     ]:=KPoint(-0.3,0.1);
  data[knRightFoot      ]:=KPoint(-0.35,0.0);

  pbMain.Align:=alClient;
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

procedure TMainForm.pbMainPaint(Sender: TObject);
var
  bmp:TBitmap;
  i:integer;
  X,Y:integer;
begin
  bmp:=TBitmap.Create;
  bmp.Width:=pbMain.Width;
  bmp.Height:=pbMain.Height;

  with bmp.Canvas do begin
    brush.color:=0;
    fillrect(rect(0,0, bmp.width, bmp.Height));

    pen.color:=clGray;
    for i:=-5 to 5 do begin
      moveto(XtoScreen(-5),YtoScreen(i));
      lineto(XtoScreen( 5),YtoScreen(i));
    end;

    for i:=-5 to 5 do begin
      moveto(XtoScreen(i),YtoScreen(-5));
      lineto(XtoScreen(i),YtoScreen(5));
    end;


    pen.width:=2;
    pen.color:=clGreen;
    moveto(XtoScreen(data[knHipCenter      ].X),   YtoScreen(data[knHipCenter      ].Y));
    lineto(XtoScreen(data[knSpine          ].X),   YtoScreen(data[knSpine          ].Y));
    lineto(XtoScreen(data[knShoulderCenter ].X),   YtoScreen(data[knShoulderCenter ].Y));
    lineto(XtoScreen(data[knHead           ].X),   YtoScreen(data[knHead           ].Y));

    moveto(XtoScreen(data[knShoulderCenter ].X),   YtoScreen(data[knShoulderCenter ].Y));
    lineto(XtoScreen(data[knLeftShoulder   ].X),   YtoScreen(data[knLeftShoulder   ].Y));
    lineto(XtoScreen(data[knLeftElbow      ].X),   YtoScreen(data[knLeftElbow      ].Y));
    lineto(XtoScreen(data[knLeftWrist      ].X),   YtoScreen(data[knLeftWrist      ].Y));
    lineto(XtoScreen(data[knLeftHand       ].X),   YtoScreen(data[knLeftHand       ].Y));

    moveto(XtoScreen(data[knShoulderCenter ].X),   YtoScreen(data[knShoulderCenter ].Y));
    lineto(XtoScreen(data[knRightShoulder  ].X),   YtoScreen(data[knRightShoulder  ].Y));
    lineto(XtoScreen(data[knRightElbow     ].X),   YtoScreen(data[knRightElbow     ].Y));
    lineto(XtoScreen(data[knRightWrist     ].X),   YtoScreen(data[knRightWrist     ].Y));
    lineto(XtoScreen(data[knRightHand      ].X),   YtoScreen(data[knRightHand      ].Y));

    moveto(XtoScreen(data[knHipCenter      ].X),   YtoScreen(data[knHipCenter      ].Y));
    lineto(XtoScreen(data[knLeftHip        ].X),   YtoScreen(data[knLeftHip        ].Y));
    lineto(XtoScreen(data[knLeftKnee       ].X),   YtoScreen(data[knLeftKnee       ].Y));
    lineto(XtoScreen(data[knLeftAnkle      ].X),   YtoScreen(data[knLeftAnkle      ].Y));
    lineto(XtoScreen(data[knLeftFoot       ].X),   YtoScreen(data[knLeftFoot       ].Y));

    moveto(XtoScreen(data[knHipCenter      ].X),   YtoScreen(data[knHipCenter      ].Y));
    lineto(XtoScreen(data[knRightHip       ].X),   YtoScreen(data[knRightHip       ].Y));
    lineto(XtoScreen(data[knRightKnee      ].X),   YtoScreen(data[knRightKnee      ].Y));
    lineto(XtoScreen(data[knRightAnkle     ].X),   YtoScreen(data[knRightAnkle     ].Y));
    lineto(XtoScreen(data[knRightFoot      ].X),   YtoScreen(data[knRightFoot      ].Y));

    brush.color:=clGray;
    pen.color:=clLime;
    for i:=0 to 19 do begin
      X:=XtoScreen(data[i].X);
      Y:=YtoScreen(data[i].Y);
      Ellipse(X-3,Y-3,X+4,Y+4);
    end;
    pen.width:=1;
  end;
  BitBlt(pbMain.Canvas.Handle,0,0, bmp.Width,bmp.Height, bmp.canvas.Handle, 0,0, SRCCOPY);
  bmp.Free;
end;

function TMainForm.ScreenToX(S: integer): single;
begin
  result:=S/pbMain.Width*SpaceX-SpaceX/2
end;

function TMainForm.ScreenToY(S: integer): single;
begin
  result:=(pbMain.Height-S)/pbMain.Height*SpaceY-SpaceY/2
end;

function TMainForm.XtoScreen(X: single): integer;
begin
  result:=round((X+SpaceX/2)/SpaceX*pbMain.Width);
end;

function TMainForm.YtoScreen(Y: single): integer;
begin
  result:=round(pbMain.Height-(Y+SpaceY/2)/SpaceY*pbMain.Height)
end;

function TMainForm.KPoint(X, Y: single): TKPoint;
begin
  result.X:=X;
  result.Y:=Y;
  result.Z:=0;
  result.Active:=true;
end;

function TMainForm.FindNode(X, Y: integer): integer;
const
  Delta=4;
var
  i,px,py:integer;
begin
  for i:=0 to 19 do begin
    px:=XtoScreen(data[i].X);
    py:=YtoScreen(data[i].Y);

    if (abs(px-X)<=delta) and (abs(py-Y)<=delta)
       then begin
              result:=i;
              exit;
            end;
  end;
  result:=-1;
end;

procedure TMainForm.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft
     then begin
            DownIndex:=FindNode(X,Y);
          end;

end;

procedure TMainForm.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) and (DownIndex<>-1)
     then begin
            if X<0 then X:=0 else
            if X>pbMain.Width
               then X:=pbMain.Width;

            if Y<0 then Y:=0 else
            if Y>pbMain.Height
               then X:=pbMain.Height;

            data[DownIndex].X:=ScreenToX(X);
            data[DownIndex].Y:=ScreenToY(Y);
            pbMainPaint(nil);
            SendData;
          end
     else begin
            if FindNode(X, Y)<>-1
               then pbMain.Cursor:=crHandPoint
               else pbMain.Cursor:=crDefault;
          end;
end;

procedure TMainForm.SendData;
begin
  if mnFirst.checked
     then ldbSetKinect(0, @data)
     else ldbSetKinect(1, @data);
end;

procedure TMainForm.pbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft
     then DownIndex:=-1;
end;

procedure TMainForm.mnFirstClick(Sender: TObject);
begin
  mnFirst.checked:=true;
  mnSecond.checked:=false;
  SendData;
end;

procedure TMainForm.mnSecondClick(Sender: TObject);
begin
  mnSecond.checked:=true;
  mnFirst.checked:=false;
  SendData;
end;

end.
