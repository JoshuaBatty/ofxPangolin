#include "Pangolin.h"

// Look Here https://msdn.microsoft.com/en-us/library/ms810279.aspx

//-----------------------------------
void Pangolin::init() {
	BeyondCreatePtr = NULL;
	BeyondDestroyPtr = NULL;
	BeyondExeStartedPtr = NULL;
	BeyondExeReadyPtr = NULL;
	BeyondEnableLaserOutputPtr = NULL;
	BeyondDisableLaserOutputPtr = NULL;
	BeyondBlackoutPtr = NULL;
	BeyondGetDllVersionPtr = NULL;
    BeyondGetBeyondVersionPtr = NULL;
	BeyondGetProjectionCountPtr = NULL;
	BeyondGetZoneCountPtr = NULL;
	//BeyondGetProjectorEventPtr = NULL;

	BeyondCreateZoneImagePtr = NULL;
	BeyondCreateProjectorImagePtr = NULL;
	BeyondDeleteZoneImagePtr = NULL;
	BeyondDeleteProjectorImagePtr = NULL;

	BeyondSendFrameToImagePtr = NULL;

	// Link the Beyond DLL to the runtime
	dllHandle = LoadLibrary("BEYONDIO.dll");

	//Get pointers to our functions using GetProcAddress:
	loadFunctionPtrs();

	// Make sure all our function pointers are valid
	checkFunctionPtrs();

	// Init properties of Pangolin DLL
	create();
}

//-----------------------------------
void Pangolin::loadFunctionPtrs() {
	if (dllHandle != NULL) {
		BeyondCreatePtr = (BeyondCreate)GetProcAddress(dllHandle, "ldbCreate");
		BeyondDestroyPtr = (BeyondDestroy)GetProcAddress(dllHandle, "ldbDestroy");
		BeyondExeStartedPtr = (BeyondExeStarted)GetProcAddress(dllHandle, "ldbBeyondExeStarted");
		BeyondExeReadyPtr = (BeyondExeReady)GetProcAddress(dllHandle, "ldbBeyondExeReady");
		BeyondEnableLaserOutputPtr = (BeyondEnableLaserOutput)GetProcAddress(dllHandle, "ldbEnableLaserOutput");
		BeyondDisableLaserOutputPtr = (BeyondDisableLaserOutput)GetProcAddress(dllHandle, "ldbDisableLaserOutput");
		BeyondBlackoutPtr = (BeyondBlackout)GetProcAddress(dllHandle, "ldbBlackout");
		BeyondGetDllVersionPtr = (BeyondGetDllVersion)GetProcAddress(dllHandle, "ldbGetDllVersion");
		BeyondGetBeyondVersionPtr = (BeyondGetBeyondVersion)GetProcAddress(dllHandle, "ldbGetBeyondVersion");
		BeyondGetProjectionCountPtr = (BeyondGetProjectionCount)GetProcAddress(dllHandle, "ldbGetProjectorCount");
		BeyondGetZoneCountPtr = (BeyondGetZoneCount)GetProcAddress(dllHandle, "ldbGetZoneCount");
		//BeyondGetProjectorEventPtr = (BeyondGetProjectorEvent)GetProcAddress(dllHandle, "ldGetProjectorEvent");

		BeyondCreateZoneImagePtr = (BeyondCreateZoneImage)GetProcAddress(dllHandle, "ldbCreateZoneImage");
		BeyondCreateProjectorImagePtr = (BeyondCreateProjectorImage)GetProcAddress(dllHandle, "ldbCreateProjectorImage");
		BeyondDeleteZoneImagePtr = (BeyondDeleteZoneImage)GetProcAddress(dllHandle, "ldbDeleteZoneImage");
		BeyondDeleteProjectorImagePtr = (BeyondDeleteProjectorImage)GetProcAddress(dllHandle, "ldbDeleteProjectorImage");

		BeyondSendFrameToImagePtr = (BeyondSendFrameToImage)GetProcAddress(dllHandle, "ldbSendFrameToImage");
	}
	else {
		cout << "Pangolin Beyond Failed to Load!" << endl;
	}
}
//-----------------------------------
void Pangolin::checkFunctionPtrs() {
	bool runTimeLinkSuccess = false;

	if (dllHandle != NULL) {
		if (runTimeLinkSuccess = (NULL != BeyondCreatePtr)) assert("CreatePtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondDestroyPtr)) assert("DestroyPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondGetDllVersionPtr)) assert("GetDllVersionPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondGetBeyondVersionPtr)) assert("GetBeyondVersionPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondExeStartedPtr)) assert("ExeStartedPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondExeReadyPtr)) assert("ExeReadyPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondEnableLaserOutputPtr)) assert("EnableLaserOutputPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondDisableLaserOutputPtr)) assert("DisableLaserOutputPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondBlackoutPtr)) assert("BlackoutPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondGetProjectionCountPtr)) assert("ProjectionCountPtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondGetZoneCountPtr)) assert("ZoneCountPtr Not Linked!");
		//if (runTimeLinkSuccess = (NULL != BeyondGetProjectorEventPtr)) assert("ProjectorEventPtr Not Linked!");

		if (runTimeLinkSuccess = (NULL != BeyondCreateZoneImagePtr)) assert("BeyondCreateZoneImagePtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondCreateProjectorImagePtr)) assert("BeyondCreateProjectorImagePtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondDeleteZoneImagePtr)) assert("BeyondDeleteZoneImagePtr Not Linked!");
		if (runTimeLinkSuccess = (NULL != BeyondDeleteProjectorImagePtr)) assert("BeyondDeleteProjectorImagePtr Not Linked!");

		if (runTimeLinkSuccess = (NULL != BeyondSendFrameToImagePtr)) assert("BeyondSendFrameToImagePtr Not Linked!");
		cout << "All of the Beyond SDK Loaded Successfully!" << endl;
	}
}

///---------------------------------- General Functions
//-----------------------------------
bool Pangolin::create() {
	return BeyondCreatePtr();
}
//-----------------------------------
bool Pangolin::destroy() {
	return BeyondDestroyPtr();
}
//-----------------------------------
bool Pangolin::beyondExeStarted() {
	return BeyondExeStartedPtr();
}
//-----------------------------------
bool Pangolin::beyondExeReady() {
	return BeyondExeReadyPtr();
}
//-----------------------------------
bool Pangolin::enableLaserOutput() {
	return BeyondEnableLaserOutputPtr();
}
//-----------------------------------
bool Pangolin::disableLaserOutput() {
	return BeyondDisableLaserOutputPtr();
}
//-----------------------------------
bool Pangolin::blackout() {
	return BeyondBlackoutPtr();
}
//-----------------------------------
int Pangolin::getDllVersion() {
	return BeyondGetDllVersionPtr();
}
//-----------------------------------
int Pangolin::getBeyondVersion() {
	return BeyondGetBeyondVersionPtr();
}
//-----------------------------------
int Pangolin::getProjectionCount() {
	return BeyondGetProjectionCountPtr();
}
//-----------------------------------
int Pangolin::getZoneCount() {
	return BeyondGetZoneCountPtr();
}
//-----------------------------------
//int Pangolin::getProjectorEvent(int projectorIndex) {
//	return BeyondGetProjectorEventPtr(projectorIndex);
//}

///---------------------------------- Create & Delete Image
//-----------------------------------
int Pangolin::createZoneImage(int zoneIndex, string imageName) {
	return BeyondCreateZoneImagePtr(zoneIndex, convert_string_to_pchar(imageName));
}
//-----------------------------------
int Pangolin::createProjectionImage(int projectorIndex, string imageName) {
	return BeyondCreateProjectorImagePtr(projectorIndex, convert_string_to_pchar(imageName));
}
//-----------------------------------
int Pangolin::deleteZoneIndex(string imageName) {
	return BeyondDeleteZoneImagePtr(convert_string_to_pchar(imageName));
}
//-----------------------------------
int Pangolin::deleteProjectorImage(string imageName) {
	return BeyondDeleteProjectorImagePtr(convert_string_to_pchar(imageName));
}

//-----------------------------------
char* Pangolin::convert_string_to_pchar(string name) {
	char* pchar = new char[name.size() + 1];
	strcpy(pchar, name.c_str());
	return pchar;
}

///---------------------------------- Swend Frame to Beyond
//-----------------------------------
int Pangolin::sendFrameToImage(string imageName, 
								vector<LaserPoint> &laserPoints, 
								vector<int> zoneIndices, 
								int scanRate) 
{
	char* name = convert_string_to_pchar(imageName);
	// Make sure we dont exceed the max num points for pangolin
	assert(laserPoints.size() <= 8192);
	int num_points = laserPoints.size();
	if (laserPoints.size() < 0) {
		return 0;
	}

	vector<BeyondLaserPoint> points;
	for (auto& point : laserPoints) {
		points.push_back(convert_laser_point(point));
	}
	void* firstPoint = (void*)&points.front();
	
	unsigned char zoneArray[256];

	int i = 0;
	while (i < zoneIndices.size()) {
		assert(i < 256);
		zoneArray[i] = 1 + zoneIndices[i];
		i++;
	}
	zoneArray[i] = 0;
	void* zoneArrayPtr = (void*) &zoneArray[0];
	int pps = scanRate;
	return BeyondSendFrameToImagePtr(name, num_points, firstPoint, zoneArrayPtr, pps);
}

//-----------------------------------
BeyondLaserPoint Pangolin::convert_laser_point(LaserPoint laserPoint) {
	BeyondLaserPoint point;
	point.x = ofMap(laserPoint.x,0.0,1.0,-32000,32000);
	point.y = ofMap(laserPoint.y,1.0,0.0,-32000,32000);
	point.z = ofMap(laserPoint.z,0.0,1.0,-32000,32000);

	unsigned char a = 0;
	unsigned char g = laserPoint.g;
	unsigned char b = laserPoint.b;
	unsigned char r = laserPoint.r;

	int color = (a << 24) | (b << 16) | (g << 8) | r;

	point.pointColor = color;
	point.repCount = 0;
	point.focus = 0;
	point.status = 0;
	point.zero = 0;

	return point;
}



//-----------------------------------


//-----------------------------------


//-----------------------------------


//-----------------------------------


//-----------------------------------


//-----------------------------------


//-----------------------------------


//-----------------------------------


//-----------------------------------

