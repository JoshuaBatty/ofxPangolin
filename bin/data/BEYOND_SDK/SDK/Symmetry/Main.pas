unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, DllCalls, ShellAPI;

const
  psVector=1;

type
  PSdkImagePoint=^TSdkImagePoint;
  TSdkImagePoint=packed record
    X,Y,Z       :single;  // 32bit float point, Coordinate system -32K to +32K
    Color       :longint; // RGB in Windows style
    RepCount    :byte;    // Repeat counter
    Focus       :byte;    // Beam brush reserved, leave it zero
    Status      :byte;    // bitmask - attributes
    Zero        :byte;    // Leave it zero
  end;

  PSdkImagePointArray=^TSdkImagePointArray;
  TSdkImagePointArray=array[0..8191] of TSdkImagePoint;
  TSdkZoneArray=array[0..255] of byte;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    mnStartBEYOND: TMenuItem;
    mnAbout: TMenuItem;
    pnStatus: TPanel;
    tmStatus: TTimer;
    N1: TMenuItem;
    pbMain: TPaintBox;
    tmAction: TTimer;
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
  private
    { Private declarations }
  public
    ImageName:string;
    ImageCreated:boolean;

    DataCount:integer;
    Data:array[0..4095] of record
      X,Y:single;
      Color:TColor;
    end;
    ColorMod:single;

    PointCount:integer;
    Points:TSdkImagePointArray;
    Zones:array[0..255] of byte;
    procedure CalcPoints;

    procedure CreateImageInPZ;
    function SendFrameData:integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ImageName:='Symmetry SDK Demo';
  ImageCreated:=false;

  ldbCreate;

  tmStatus.Enabled:=true;
  fillchar(Points, sizeof(Points),0);
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
     then begin
            StatusInfo:='BEYOND Ready ';
            if not ImageCreated
               then begin
                      ImageCreated:=true;
                      CreateImageInPZ;
                    end;
          end
     else begin
            ImageCreated:=false;
            if ldbBeyondExeStarted=1
               then StatusInfo:='Starting BEYOND, please wait... '
               else StatusInfo:='BEYOND is not started ';
          end;

  if pnStatus.Caption<>StatusInfo
     then pnStatus.Caption:=StatusInfo;
end;

function TMainForm.SendFrameData: integer;
var
  ScanRate:integer;
  i:integer;
  Offset:single;
  proc:single;
begin
  ScanRate:=100;
  Zones[0]:=1;
  Zones[1]:=0;

//  for i:=0 to PointCount-1 do begin
//    points[i].X:=i;
//    points[i].y:=i;
//    points[i].z:=i;
//    points[i].color:=i;
//  end;

  result:=ldbSendFrameToImage(PChar(ImageName), PointCount, @Points, @Zones, ScanRate);
end;

procedure TMainForm.pbMainPaint(Sender: TObject);
var
  bmp:Tbitmap;
  X,Y:integer;
  i:integer;
begin
  bmp:=TBitmap.Create;
  bmp.Width:=pbMain.Width;
  bmp.Height:=pbMain.Height;
  with bmp.Canvas do begin
    brush.color:=0;
    fillrect(rect(0,0, bmp.width, bmp.Height));

    for i:=0 to PointCount-1 do begin
      X:=round( (Points[i].X+32000)/64000*bmp.Width );
      Y:=round( (Points[i].Y+32000)/64000*bmp.Height );
      if Points[i].Color=0
         then moveto(X,Y)
         else begin
                pen.color:=Points[i].Color;
                lineto(X,Y);

                brush.color:=Points[i].Color;
                fillrect(rect(x-1,y-1,x+2,y+2));
              end;
    end;

    if not ImageCreated
       then begin
              font.color:=clWhite;
              brush.color:=clBlack;
              TextOut(4,4, 'Waiting for BEYOND start');
            end
       else begin
              font.color:=clWhite;
              brush.color:=clBlack;
              TextOut(4,bmp.Height-16, 'Draw a shape using the mouse. Right click - clear.');
            end;
  end;
  BitBlt(pbMain.Canvas.Handle, 0,0, bmp.Width, bmp.Height, bmp.Canvas.Handle, 0,0, SRCCOPY);
  bmp.Free;
end;

procedure TMainForm.CalcPoints;
const
  Copies=6;
var
  i,n:integer;
  X,Y:single;
  angle:single;
  Scale:single;
begin
  // Original
  PointCount:=0;

  for i:=0 to DataCount-1 do begin
    if Data[i].Color=0
       then Scale:=0.1 else
    if Scale<0.95
       then Scale:=Scale+0.1;

    Points[PointCount].X:=Data[i].X;
    Points[PointCount].Y:=Data[i].Y;
    Points[PointCount].Color:=RGB(
      round(GetRValue(Data[i].Color)*Scale),
      round(GetGValue(Data[i].Color)*Scale),
      round(GetBValue(Data[i].Color)*Scale));

    if (i=0) or (i=DataCount-1)
       then Points[PointCount].Status:=psVector
       else Points[PointCount].Status:=0;
    inc(PointCount);
  end;

  for n:=1 to Copies do begin
    angle:=n*2*pi/Copies;
    for i:=0 to DataCount-1 do begin
      if Data[i].Color=0
         then Scale:=0.1 else
      if Scale<0.95
         then Scale:=Scale+0.1;

      Points[PointCount].X:=Data[i].X*cos(angle)-Data[i].Y*sin(angle);
      Points[PointCount].Y:=Data[i].X*sin(angle)+Data[i].Y*cos(angle);
      Points[PointCount].Color:=RGB(
        round(GetRValue(Data[i].Color)*Scale),
        round(GetGValue(Data[i].Color)*Scale),
        round(GetBValue(Data[i].Color)*Scale));

      if (i=0) or (i=DataCount-1)
         then Points[PointCount].Status:=psVector
         else Points[PointCount].Status:=0;
      inc(PointCount);
    end;
  end;
end;

procedure TMainForm.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbLeft)
     then begin
            data[DataCount].X:=X/pbMain.width*64000-32000;
            data[DataCount].Y:=Y/pbMain.height*64000-32000;
            data[DataCount].Color:=0;
            inc(DataCount);

            data[DataCount].X:=X/pbMain.width*64000-32000;
            data[DataCount].Y:=Y/pbMain.height*64000-32000;
            data[DataCount].Color:=clWhite;
            inc(DataCount);
            CalcPoints;
            pbMainPaint(nil);

            if ImageCreated
               then SendFrameData;
          end;

  if Button=mbRight
     then begin
            DataCount:=0;
            CalcPoints;
            pbMainPaint(nil);
          end;
end;

procedure TMainForm.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) and (DataCount>1)
     then begin
            data[DataCount-1].X:=X/pbMain.width*64000-32000;
            data[DataCount-1].Y:=Y/pbMain.height*64000-32000;
            if sqrt(sqr(data[DataCount-1].X-data[DataCount-2].X)+sqr(data[DataCount-1].Y-data[DataCount-2].Y))>1000
               then begin
                      data[DataCount]:=data[DataCount-1];

                      data[DataCount].color:=
                       RGB(
                         round(150+100*cos(ColorMod/2)),
                         round(150+100*cos(ColorMod/3)),
                         round(150+100*cos(ColorMod/5)));
                      ColorMod:=ColorMod+pi/20;

                      if DataCount>40
                         then begin
                                move(data[1], data[0], sizeof(data[0])*dataCount);
                                data[0].color:=0;
                              end  
                         else inc(DataCount);
                    end;

            CalcPoints;
            pbMainPaint(nil);

            if ImageCreated
               then SendFrameData;
          end;

end;

procedure TMainForm.CreateImageInPZ;
var n:integer;
begin
  n:=ldbCreateZoneImage(0, PChar(ImageName));
  MessageDlg(inttostr(n), mtInformation, [mbOK], 0);
end;

end.
