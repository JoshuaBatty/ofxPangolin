unit DllCalls;

interface

const DLL_NAME='BEYONDIO.DLL';

function ldbCreate:integer; cdecl; external DLL_NAME;
function ldbDestroy:integer; cdecl; external DLL_NAME;

function ldbBeyondExeStarted:integer; cdecl; external DLL_NAME;
function ldbBeyondExeReady:integer; cdecl; external DLL_NAME;
function ldbGetBeyondVersion:integer; cdecl; external DLL_NAME;
function ldbGetDllVersion:integer; cdecl; external DLL_NAME;

function ldbGetProjectorEvent(AIndex:integer):THandle;cdecl; external DLL_NAME;

function ldbSendFrameToImage(AImageName:PChar; ACount:integer; AFrame:pointer; AZones:pointer; ARate:integer):integer; cdecl; external DLL_NAME;

function ldbCreateZoneImage(AZoneIndex:integer; AName:PChar):integer; cdecl; external DLL_NAME;
function ldbCreateProjectorImage(AProjIndex:integer; AName:PChar):integer; cdecl; external DLL_NAME;
function ldbDeleteZoneImage(AName:PChar):integer; cdecl; external DLL_NAME;
function ldbDeleteProjectorImage(AName:PChar):integer; cdecl; external DLL_NAME;
function ldbGetProjectorCount:integer; cdecl; external DLL_NAME;
function ldbGetZoneCount:integer; cdecl; external DLL_NAME;

function ldbGetTimeCode:integer; cdecl; external DLL_NAME;
function ldbSetTimeCode(AValueMS:integer):integer; cdecl; external DLL_NAME;
function ldbSetMidiIn(ACmd, AData1, AData2, ADevIndex:byte):integer; cdecl; external DLL_NAME;
function ldbSetMidiOut(ACmd, AData1, AData2, ADevIndex:byte):integer; cdecl; external DLL_NAME;

function ldbSetKinect(AIndex:integer; AData:pointer):integer; cdecl; external DLL_NAME;
function ldbSetDmx(AIndex:integer; AData:pointer):integer; cdecl; external DLL_NAME;
function ldbSetChannels(AChannels:pointer; ACount:integer):integer; cdecl; external DLL_NAME;

function ldbTimelineStop:integer; cdecl; external DLL_NAME;
function ldbTimelinePlay:integer; cdecl; external DLL_NAME;
function ldbTimelineSetPos(ATime:integer):integer; cdecl; external DLL_NAME;
function ldbTimelineGetPos:integer; cdecl; external DLL_NAME;
function ldbTimelineGetDuration:integer; cdecl; external DLL_NAME;
function ldbTimelineSetOnline(AEnabled:integer):integer; cdecl; external DLL_NAME;
function ldbTimelineGetOnline:integer; cdecl; external DLL_NAME;
function ldbTimelineGetPlaying:integer; cdecl; external DLL_NAME;


implementation

end.
