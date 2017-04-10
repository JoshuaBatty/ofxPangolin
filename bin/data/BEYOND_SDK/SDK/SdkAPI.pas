unit SdkAPI;

interface
{.$DEFINE WINAPI}

{$IFDEF WINAPI}
  function ldbCreate:integer; stdcall;
  function ldbDestroy:integer; stdcall;
  function ldbGetBeyondVersion:integer; stdcall;

  function ldbBeyondExeStarted:integer; stdcall;
  function ldbBeyondExeReady:integer; stdcall;

  function ldbEnableLaserOutput:integer; stdcall;
  function ldbDisableLaserOutput:integer; stdcall;
  function ldbBlackout:integer; stdcall;

  function ldbGetDllVersion:integer; stdcall;
  function ldbGetProjectorEvent(AIndex:integer):THandle; stdcall;
  function ldbSendFrameToImage(AImageName:PChar; ACount:integer; AFrame:pointer; AZones:pointer; ARate:integer):integer; stdcall;

  function ldbCreateZoneImage(AZoneIndex:integer; AName:PChar):integer; stdcall;
  function ldbCreateProjectorImage(AProjIndex:integer; AName:PChar):integer; stdcall;

  function ldbDeleteZoneImage(AName:PChar):integer; stdcall;
  function ldbDeleteProjectorImage(AName:PChar):integer; stdcall;

  function ldbGetProjectorCount:integer; stdcall;
  function ldbGetZoneCount:integer; stdcall;
  function ldbGetTimeCode:integer; stdcall;
  function ldbSetTimeCode(AValueMS:integer):integer; stdcall;
  function ldbSetMidiIn(ACmd, AData1, AData2, ADevIndex:byte):integer; stdcall;
  function ldbSetMidiOut(ACmd, AData1, AData2, ADevIndex:byte):integer; stdcall;

  function ldbSetKinect(AIndex:integer; AData:pointer):integer; stdcall;
  function ldbSetDmx(AIndex:integer; AData:pointer):integer; stdcall;
  function ldbSetChannels(AChannels:pointer; ACount:integer):integer; stdcall;

  function ldbTimelineStop:integer; stdcall;
  function ldbTimelinePlay:integer; stdcall;
  function ldbTimelineSetPos(ATime:integer):integer; stdcall;
  function ldbTimelineGetPos:integer; stdcall;
  function ldbTimelineGetDuration:integer; stdcall;
  function ldbTimelineSetOnline(AEnabled:integer):integer; stdcall;
  function ldbTimelineGetOnline:integer; stdcall;
  function ldbTimelineGetPlaying:integer; stdcall;

{$ELSE}
  function ldbCreate:integer; cdecl;
  function ldbDestroy:integer; cdecl;
  function ldbGetBeyondVersion:integer; cdecl;

  function ldbBeyondExeStarted:integer; cdecl;
  function ldbBeyondExeReady:integer; cdecl;

  function ldbEnableLaserOutput:integer; cdecl;
  function ldbDisableLaserOutput:integer; cdecl;
  function ldbBlackout:integer; cdecl;

  function ldbGetDllVersion:integer; cdecl;
  function ldbGetProjectorEvent(AIndex:integer):THandle; cdecl;
  function ldbSendFrameToImage(AImageName:PChar; ACount:integer; AFrame:pointer; AZones:pointer; ARate:integer):integer; cdecl;

  function ldbCreateZoneImage(AZoneIndex:integer; AName:PChar):integer; cdecl;
  function ldbCreateProjectorImage(AProjIndex:integer; AName:PChar):integer; cdecl;

  function ldbDeleteZoneImage(AName:PChar):integer; cdecl;
  function ldbDeleteProjectorImage(AName:PChar):integer; cdecl;

  function ldbGetProjectorCount:integer; cdecl;
  function ldbGetZoneCount:integer; cdecl;
  function ldbGetTimeCode:integer; cdecl;
  function ldbSetTimeCode(AValueMS:integer):integer; cdecl;
  function ldbSetMidiIn(ACmd, AData1, AData2, ADevIndex:byte):integer; cdecl;
  function ldbSetMidiOut(ACmd, AData1, AData2, ADevIndex:byte):integer; cdecl;

  function ldbSetKinect(AIndex:integer; AData:pointer):integer; cdecl;
  function ldbSetDmx(AIndex:integer; AData:pointer):integer; cdecl;
  function ldbSetChannels(AChannels:pointer; ACount:integer):integer; cdecl;

  function ldbTimelineStop:integer; cdecl;
  function ldbTimelinePlay:integer; cdecl;
  function ldbTimelineSetPos(ATime:integer):integer; cdecl;
  function ldbTimelineGetPos:integer; cdecl;
  function ldbTimelineGetDuration:integer; cdecl;
  function ldbTimelineSetOnline(AEnabled:integer):integer; cdecl;
  function ldbTimelineGetOnline:integer; cdecl;
  function ldbTimelineGetPlaying:integer; cdecl;

{$ENDIF}

implementation

uses
  Messages, Windows, SysUtils, SdkImage;

const
  MULTI_COUNT=24;

  NO_WINDOW=-1;

var
  initialized:boolean=false;
  ProjEv:array[0..MULTI_COUNT-1] of THandle;
  Frame:TSdkImageFrame;
  CoreMsg:TSdkCoreMessage;
  CS:TRTLCriticalSection;

function ldbCreate:integer;
var
  i:integer;
  s:string;
begin
  result:=0;
  if initialized then exit;

  initialized:=true;
  InitializeCriticalSection(CS);
  //
  for i:=0 to MULTI_COUNT-1 do begin
    s:='BeyondProjector'+inttostr(i);
    ProjEv[i]:=CreateEvent(nil, false, false, PChar(s));
  end;

  result:=1;
end;

function ldbDestroy:integer;
var
  i:integer;
begin
  result:=0;
  if not initialized then exit;
  DeleteCriticalSection(CS);

  initialized:=false;
  for i:=0 to MULTI_COUNT-1 do begin
    CloseHandle(ProjEv[i]);
  end;
  result:=1;
end;

function ldbGetBeyondVersion:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_GETVERSION, 0,0)
     else result:=NO_WINDOW;;
end;

function ldbBeyondExeStarted:integer;
var AppNameMutexB:THandle;
begin
  AppNameMutexB:=CreateMutex(nil,True,'PangolinBEYOND');

  if (AppNameMutexB=0) or (GetLastError=ERROR_ALREADY_EXISTS)
     then result:=1
     else result:=0;

  CloseHandle( AppNameMutexB );
end;

function ldbBeyondExeReady:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=1
     else result:=0;
end;


function ldbSetMidiIn(ACmd, AData1, AData2, ADevIndex:byte):integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_MIDI_IN, ((ADevIndex*256+ACmd)*256+AData1)*256+AData2,0)
     else result:=NO_WINDOW;;
end;

function ldbSetMidiOut(ACmd, AData1, AData2, ADevIndex:byte):integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_MIDI_OUT, ((ADevIndex*256+ACmd)*256+AData1)*256+AData2,0)
     else result:=NO_WINDOW;
end;



function ldbGetProjectorCount:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_GETSCANCOUNT, 0,0)
     else result:=NO_WINDOW;
end;

function ldbGetZoneCount:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_GETPZCOUNT, 0,0)
     else result:=NO_WINDOW;
end;

function ldbGetTimeCode:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_GETTIMECODE, 0,0)
     else result:=NO_WINDOW;
end;

function ldbSetTimeCode(AValueMS:integer):integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_SETTIMECODE, AValueMS, 1)
     else result:=NO_WINDOW;
end;

function ldbGetDllVersion:integer;
begin
  result:=100;
end;

function ldbGetProjectorEvent(AIndex:integer):THandle;
begin
  result:=0;
  if not initialized then exit;

  if (AIndex>=0) and (AIndex<MULTI_COUNT)
     then result:=ProjEv[AIndex];
end;


function ldbSendFrameToImage(AImageName:PChar; ACount:integer; AFrame:pointer; AZones:pointer; ARate:integer):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  i:integer;
  pB:^byte;
begin
  h:=FindWindow(SkdImageWndClass, AImageName);
  if h<32
     then begin
            result:=NO_WINDOW;
            exit;
          end;

  EnterCriticalSection(CS);
  try
    if ACount<0
       then ACount:=0 else
    if ACount>1024*8
       then ACount:=1024*8;

    {1. Header}
    fillchar(Frame.Header, sizeof(Frame.Header),0);
    Frame.Header.Signature :='PANGOLIN';
    Frame.Header.PointCount:=ACount;
    if ARate<0
       then begin
              Frame.Header.SampleRate:=-ARate;// 0 meand unused
              Frame.Header.ScanRate  :=0; // 100% of default sample rate
            end
       else begin
              Frame.Header.SampleRate:=0;// 0 meand unused
              Frame.Header.ScanRate  :=ARate; // 100% of default sample rate
            end;

    {2. Zones }
    fillchar(Frame.Zones, sizeof(Frame.Zones),0);
    pB:=AZones;
    for i:=0 to 255 do
      if pB^=0
         then break
         else begin
                Frame.Zones[i]:=pB^;
                inc(pB);
              end;

    {3. Points }
    if ACount>0
       then move(AFrame^, Frame.Points, ACount*sizeof(TSdkImagePoint));

    //----------------------------------------------------------------------------

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_SINGLE_FRAME; // This means - a single frame for output.
    cds.cbData:=sizeof(Frame.Header)+sizeof(TSdkImagePoint) * Frame.Header.PointCount + sizeof(Frame.Zones);
    cds.lpData:=@Frame;

    { Send the data and result comes from BEYOND }
    result:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));
  finally
    LeaveCriticalSection(CS);
  end;
end;

function ldbCreateZoneImage(AZoneIndex:integer; AName:PChar):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  res:integer;
begin
  EnterCriticalSection(CS);
  try
    fillchar(CoreMsg, sizeof(CoreMsg),0);

    CoreMsg.Signature :='PANGOLIN';
    CoreMsg.Param1:=AZoneIndex;

    StrCopy(@CoreMsg.Text[0], AName);

    //----------------------------------------------------------------------------

    h:=FindWindow(SkdCoreWndClass, nil);
    if h<32
       then begin
              result:=NO_WINDOW;
              exit;
            end;

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_CREATE_ZONE_IMG; // This means - a single frame for output.
    cds.cbData:=sizeof(CoreMsg);
    cds.lpData:=@CoreMsg;

    { Send the data }
    res:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));

    { See what comes back, should be 1 }
    result:=res;
    //if res<>1
    //   then MessageDlg('Incorrect result of call: '+inttostr(res), mtError, [mbOK], 0);
  finally
    LeaveCriticalSection(CS);
  end;
end;

function ldbCreateProjectorImage(AProjIndex:integer; AName:PChar):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  res:integer;
begin
  EnterCriticalSection(CS);
  try
    fillchar(CoreMsg, sizeof(CoreMsg),0);

    CoreMsg.Signature :='PANGOLIN';
    CoreMsg.Param1:=AProjIndex;

    StrCopy(@CoreMsg.Text[0], AName);

    //----------------------------------------------------------------------------

    h:=FindWindow(SkdCoreWndClass, nil);
    if h<32
       then begin
              //MessageDlg('BEYOND "SDK Image" with name "My Image" not found. '+#13+#10+''+#13+#10+'You should start BEYOND and create SDK-Image with name "My Image".', mtInformation, [mbOK], 0);
              result:=NO_WINDOW;
              exit;
            end;

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_CREATE_SCAN_IMG; // This means - a single frame for output.
    cds.cbData:=sizeof(CoreMsg);
    cds.lpData:=@CoreMsg;

    { Send the data }
    res:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));

    { See what comes back, should be 1 }
    result:=res;
    //if res<>1
    //   then MessageDlg('Incorrect result of call: '+inttostr(res), mtError, [mbOK], 0);
  finally
    LeaveCriticalSection(CS);
  end;
end;

function ldbDeleteZoneImage(AName:PChar):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  res:integer;
begin
  EnterCriticalSection(CS);
  try
    fillchar(CoreMsg, sizeof(CoreMsg),0);

    CoreMsg.Signature :='PANGOLIN';
    StrCopy(@CoreMsg.Text[0], AName);

    //----------------------------------------------------------------------------

    h:=FindWindow(SkdCoreWndClass, nil);
    if h<32
       then begin
              //MessageDlg('BEYOND "SDK Image" with name "My Image" not found. '+#13+#10+''+#13+#10+'You should start BEYOND and create SDK-Image with name "My Image".', mtInformation, [mbOK], 0);
              result:=NO_WINDOW;
              exit;
            end;

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_DELETE_ZONE_IMG; // This means - a single frame for output.
    cds.cbData:=sizeof(CoreMsg);
    cds.lpData:=@CoreMsg;

    { Send the data }
    res:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));

    { See what comes back, should be 1 }
    result:=res;
    //if res<>1
    //   then MessageDlg('Incorrect result of call: '+inttostr(res), mtError, [mbOK], 0);
  finally
    LeaveCriticalSection(CS);
  end;
end;

function ldbDeleteProjectorImage(AName:PChar):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  res:integer;
begin
  EnterCriticalSection(CS);
  try
    fillchar(CoreMsg, sizeof(CoreMsg),0);

    CoreMsg.Signature :='PANGOLIN';
    StrCopy(@CoreMsg.Text[0], AName);

    //----------------------------------------------------------------------------

    h:=FindWindow(SkdCoreWndClass, nil);
    if h<32
       then begin
              //MessageDlg('BEYOND "SDK Image" with name "My Image" not found. '+#13+#10+''+#13+#10+'You should start BEYOND and create SDK-Image with name "My Image".', mtInformation, [mbOK], 0);
              result:=NO_WINDOW;
              exit;
            end;

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_DELETE_SCAN_IMG; // This means - a single frame for output.
    cds.cbData:=sizeof(CoreMsg);
    cds.lpData:=@CoreMsg;

    { Send the data }
    res:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));

    { See what comes back, should be 1 }
    result:=res;
    //if res<>1
    //   then MessageDlg('Incorrect result of call: '+inttostr(res), mtError, [mbOK], 0);
  finally
    LeaveCriticalSection(CS);
  end;
end;
//////////
//  PSdkCoreMessage=^TSdkCoreMessage;
//  TSdkCoreMessage=packed record
//    Signature   :array[0..7] of char; // PANG OLIN,   yes.. simplest answer, 8 characters should have PANGOLIN
//    Command     :integer;
//    Param1      :integer;
//    Param2      :integer;
//    Param3      :integer;
//    case integer of
//    0:( Text    :array[0..4192-24] of char;);
//    1:( Dmx     :array[0..511] of byte;);
//    2:( Kinect  :array[0..19] of packed record X,Y,Z:single; Active:boolean; end;);
//    3:( Channel :array[0..255] of single;);
//  end;
//
//////////

function ldbSetChannels(AChannels:pointer; ACount:integer):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  res:integer;
  i:integer;
  pS:^single;
begin
  if ACount>255
     then ACount:=255;

  EnterCriticalSection(CS);
  try
    fillchar(CoreMsg, sizeof(CoreMsg),0);
    CoreMsg.Signature :='PANGOLIN';
    pS:=AChannels;
    for i:=0 to ACount-1 do begin
      CoreMsg.Channel[i]:=pS^;
      inc(pS);
    end;


    //----------------------------------------------------------------------------

    h:=FindWindow(SkdCoreWndClass, nil);
    if h<32
       then begin
              //MessageDlg('BEYOND "SDK Image" with name "My Image" not found. '+#13+#10+''+#13+#10+'You should start BEYOND and create SDK-Image with name "My Image".', mtInformation, [mbOK], 0);
              result:=NO_WINDOW;
              exit;
            end;

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_CHANNEL; // This means - a single frame for output.
    cds.cbData:=sizeof(CoreMsg);
    cds.lpData:=@CoreMsg;

    { Send the data }
    res:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));

    { See what comes back, should be 1 }
    result:=res;
  finally
    LeaveCriticalSection(CS);
  end;
end;

function ldbSetKinect(AIndex:integer; AData:pointer):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  res:integer;
begin
  result:=0;
  if (AIndex<0) or (AIndex>1) then exit;

  EnterCriticalSection(CS);
  try
    fillchar(CoreMsg, sizeof(CoreMsg),0);
    CoreMsg.Signature :='PANGOLIN';
    CoreMsg.Param1:=AIndex;
    move(AData^, CoreMsg.Kinect, sizeof(CoreMsg.Kinect));

    //----------------------------------------------------------------------------

    h:=FindWindow(SkdCoreWndClass, nil);
    if h<32
       then begin
              //MessageDlg('BEYOND "SDK Image" with name "My Image" not found. '+#13+#10+''+#13+#10+'You should start BEYOND and create SDK-Image with name "My Image".', mtInformation, [mbOK], 0);
              result:=NO_WINDOW;
              exit;
            end;

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_KINECT; // This means - a single frame for output.
    cds.cbData:=sizeof(CoreMsg);
    cds.lpData:=@CoreMsg;

    { Send the data }
    res:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));

    { See what comes back, should be 1 }
    result:=res;
  finally
    LeaveCriticalSection(CS);
  end;
end;

function ldbSetDmx(AIndex:integer; AData:pointer):integer;
var
  cds:CopyDataStruct;
  h:THandle;
  res:integer;
begin
  result:=0;
  if (AIndex<0) or (AIndex>1) then exit;

  EnterCriticalSection(CS);
  try
    fillchar(CoreMsg, sizeof(CoreMsg),0);
    CoreMsg.Signature :='PANGOLIN';
    CoreMsg.Param1:=AIndex;
    move(AData^, CoreMsg.DMX, 512);

    //----------------------------------------------------------------------------

    h:=FindWindow(SkdCoreWndClass, nil);
    if h<32
       then begin
              //MessageDlg('BEYOND "SDK Image" with name "My Image" not found. '+#13+#10+''+#13+#10+'You should start BEYOND and create SDK-Image with name "My Image".', mtInformation, [mbOK], 0);
              result:=NO_WINDOW;
              exit;
            end;

    { Prepare Copy Data Struct }
    cds.dwData:=CDT_DMX; // This means - a single frame for output.
    cds.cbData:=sizeof(CoreMsg);
    cds.lpData:=@CoreMsg;

    { Send the data }
    res:=SendMessage(h, WM_COPYDATA, 0, cardinal(@cds));

    { See what comes back, should be 1 }
    result:=res;
  finally
    LeaveCriticalSection(CS);
  end;
end;


function ldbEnableLaserOutput:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_ENABLE_LASER, 0,0)
     else result:=NO_WINDOW;
end;

function ldbDisableLaserOutput:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_DISABLE_LASER, 0,0)
     else result:=NO_WINDOW;
end;

function ldbBlackout:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_BLACKOUT, 0,0)
     else result:=NO_WINDOW;
end;


function ldbTimelineStop:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_STOP, 0,0)
     else result:=NO_WINDOW;
end;

function ldbTimelinePlay:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_PLAY, 0,0)
     else result:=NO_WINDOW;
end;

function ldbTimelineSetPos(ATime:integer):integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_SET_POS, ATime,0)
     else result:=NO_WINDOW;
end;

function ldbTimelineGetPos:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_GET_POS, 0,0)
     else result:=NO_WINDOW;
end;

function ldbTimelineGetDuration:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_GET_DURATION, 0,0)
     else result:=NO_WINDOW;
end;

function ldbTimelineSetOnline(AEnabled:integer):integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_SET_ONLINE, integer(AEnabled>0),0)
     else result:=NO_WINDOW;
end;

function ldbTimelineGetOnline:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_GET_ONLINE, 0,0)
     else result:=NO_WINDOW;
end;

function ldbTimelineGetPlaying:integer;
var h:THandle;
begin
  h:=FindWindow(SkdCoreWndClass, nil);
  if h>=32
     then result:=SendMessage(h, WM_TL_GET_PLAYING, 0,0)
     else result:=NO_WINDOW;
end;

end.

