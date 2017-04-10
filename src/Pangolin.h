#pragma once

#include "ofMain.h"

#undef UNICODE
#include <windows.h>
#include <tchar.h>

#ifdef UNICODE
	#define LoadLibrary  LoadLibraryW
#else
	#define LoadLibrary  LoadLibraryA
#endif // !UNICODE


/*
--------- LASER POINT ------------
X,Y,Z - 32 bit float point value. Standard "single". The coordinate system is -32K...+32K. Please fit your data in the range.
Color - 32 bit integer number. Color is 24bit RGB, standard encoding in windows format. Red bytes comes low (00..FF), Green after that, Blue the most signification. It exactly as in GDI.
RepCount -  usigned byte. Repeat counter of the point. 0 - no repeats. 1 - one repeat and so on. - usigned byte.
Focus - usigned byte. Now it unused
Status - flags, now leave it zero.
Zero - usigned byte. leave it zero.

You need have array with points and supply pointed on this array into ldSendFrameToImage.
*/

typedef struct {
	float x, y, z; // 32bit float point, Coordinate system -32k to +32k
	int pointColor; // RGB in Windows style
	unsigned char repCount; // Repeat Count
	unsigned char focus; // Beam brush reserved, leave it zero
	unsigned char status; // bitmask -- attributes
	unsigned char zero; // Leave it zero
} BeyondLaserPoint;

typedef struct {
	float x, y, z; // Normalised Coords
	int r, g, b; 	
} LaserPoint;


typedef UINT(CALLBACK* LPFNDLLFUNC1)(DWORD, UINT);

//---------Define the function prototypes
/// General Functions
typedef bool (CALLBACK* BeyondCreate)();
typedef bool (CALLBACK* BeyondDestroy)();
typedef bool (CALLBACK* BeyondExeStarted)();
typedef bool (CALLBACK* BeyondExeReady)();
typedef bool (CALLBACK* BeyondEnableLaserOutput)();
typedef bool (CALLBACK* BeyondDisableLaserOutput)();
typedef bool (CALLBACK* BeyondBlackout)();
typedef int (CALLBACK* BeyondGetDllVersion)();
typedef int (CALLBACK* BeyondGetBeyondVersion)();
typedef int (CALLBACK* BeyondGetProjectionCount)();
typedef int (CALLBACK* BeyondGetZoneCount)();
//typedef int (__cdecl* BeyondGetProjectorEvent)(int index);

/// Create & Delete Image
typedef int (__cdecl* BeyondCreateZoneImage)(int zoneIndex, char* imageName);
typedef int (__cdecl* BeyondCreateProjectorImage)(int projectorIndex, char* imageName);
typedef int (__cdecl* BeyondDeleteZoneImage)(char* imageName);
typedef int (__cdecl* BeyondDeleteProjectorImage)(char* imageName);

/// Send Framd to Beyond
typedef int (__cdecl* BeyondSendFrameToImage)(char* imageName, int numPointsInFrame, void* firstPoint, void* zoneArrayPtr, int scanRate);


class Pangolin {
public:
	
	void init();
	void loadFunctionPtrs();
	void checkFunctionPtrs();

	/// General Functions
	bool create();
	bool destroy();
	bool beyondExeStarted();
	bool beyondExeReady();
	bool enableLaserOutput();
	bool disableLaserOutput();
	bool blackout();

	int getDllVersion();
	int getBeyondVersion();
	int getProjectionCount();
	int getZoneCount();
	//int getProjectorEvent(int projectorIndex);

	///Create and Delete Image
	int createZoneImage(int zoneIndex, string imageName);
	int createProjectionImage(int projectorIndex, string imageName);
	int deleteZoneIndex(string imageName);
	int deleteProjectorImage(string imageName);

	/// Send Framd to Beyond
	int sendFrameToImage(string imageName, vector<LaserPoint> &laserPoints, vector<int> zoneIndices, int scanRate);
	BeyondLaserPoint convert_laser_point(LaserPoint laserPoint);

private:
	HINSTANCE dllHandle; // Handle to DLL  S

	// Helper Methods
	char* convert_string_to_pchar(string name);

	/// General Functions
	BeyondCreate BeyondCreatePtr;
	BeyondDestroy BeyondDestroyPtr;
	BeyondGetDllVersion BeyondGetDllVersionPtr;
	BeyondGetBeyondVersion BeyondGetBeyondVersionPtr;
	BeyondExeStarted BeyondExeStartedPtr;
	BeyondExeReady BeyondExeReadyPtr;
	BeyondEnableLaserOutput BeyondEnableLaserOutputPtr;
	BeyondDisableLaserOutput BeyondDisableLaserOutputPtr;
	BeyondBlackout BeyondBlackoutPtr;
	BeyondGetProjectionCount BeyondGetProjectionCountPtr;
	BeyondGetZoneCount BeyondGetZoneCountPtr;
	//BeyondGetProjectorEvent BeyondGetProjectorEventPtr;

	/// Create & Delete Image
	BeyondCreateZoneImage BeyondCreateZoneImagePtr;
	BeyondCreateProjectorImage BeyondCreateProjectorImagePtr;
	BeyondDeleteZoneImage BeyondDeleteZoneImagePtr;
	BeyondDeleteProjectorImage BeyondDeleteProjectorImagePtr;

	/// Send Framd to Beyond
	BeyondSendFrameToImage BeyondSendFrameToImagePtr;

};