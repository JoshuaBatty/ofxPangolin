unit SdkImage;

interface

uses
  Messages, Windows;

const
  SkdImageWndClass = 'BeyondSDKWndCls'; //used when RegisterClass and for CreateWindow
  SkdCoreWndClass = 'BeyondSDKCoreWndCls'; //used when RegisterClass and for CreateWindow
  // Data Types
  CDT_SINGLE_FRAME       =1;
  CDT_CREATE_ZONE_IMG    =2;
  CDT_CREATE_SCAN_IMG    =3;
  CDT_DELETE_ZONE_IMG    =4;
  CDT_DELETE_SCAN_IMG    =5;
  CDT_DMX                =6;
  CDT_KINECT             =7;
  CDT_CHANNEL            =8;

  WM_GETVERSION         = WM_USER+1;
  WM_GETSCANCOUNT       = WM_USER+2;
  WM_GETPZCOUNT         = WM_USER+3;
  WM_GETTIMECODE        = WM_USER+4;
  WM_SETTIMECODE        = WM_USER+5;
  WM_MIDI_IN            = WM_USER+6;
  WM_MIDI_OUT           = WM_USER+7;
  WM_ENABLE_LASER       = WM_USER+8;
  WM_DISABLE_LASER      = WM_USER+9;
  WM_BLACKOUT           = WM_USER+10;


  WM_TL_STOP             = WM_USER+11;
  WM_TL_PLAY             = WM_USER+12;
  WM_TL_SET_POS          = WM_USER+13;
  WM_TL_GET_POS          = WM_USER+14;
  WM_TL_GET_DURATION     = WM_USER+15;
  WM_TL_SET_ONLINE       = WM_USER+16;
  WM_TL_GET_ONLINE       = WM_USER+17;
  WM_TL_GET_PLAYING      = WM_USER+18;


type
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  // Frame for "copy data" has a header, and after that arrat of points.
  // Header is "must have" thing, points are optional.
  // If you want to stop - send there 0 points array (set PointCount to zero)

  PSdkImageHeader=^TSdkImageHeader;
  TSdkImageHeader=packed record
                                      // 1234 5678
    Signature   :array[0..7] of char; // PANG OLIN,   yes.. simplest answer, 8 characters should have PANGOLIN
    PointCount  :integer; // reflect number of points in frame
    SampleRate  :integer; // In points. 30000 means 30KPPS. Leave 0 if not used
    ScanRate    :integer; // Percens of default sample rate. Range 10..400. Leave 0 if not used
    Tag        :integer;  //
  end;

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

  PSdkImageFrame=^TSdkImageFrame;
  TSdkImageFrame=packed record
    Header:TSdkImageHeader;
    Zones:TSdkZoneArray;
    Points:TSdkImagePointArray;
  end;

  PSdkCoreMessage=^TSdkCoreMessage;
  TSdkCoreMessage=packed record
    Signature   :array[0..7] of char; // PANG OLIN,   yes.. simplest answer, 8 characters should have PANGOLIN
    Command     :integer;
    Param1      :integer;
    Param2      :integer;
    Param3      :integer;
    case integer of
    0:( Text    :array[0..4192-24] of char;);
    1:( Dmx     :array[0..511] of byte;);
    2:( Kinect  :array[0..19] of packed record X,Y,Z:single; Active:boolean; end;);
    3:( Channel :array[0..255] of single;);
  end;

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



implementation

end.
