#include "ofApp.h"

//--------------------------------------------------------------
ofApp::~ofApp() {
	// Free up allocated resources in Pangolin Exe
	pangolin.destroy();
}

//--------------------------------------------------------------
void ofApp::setup(){
	//ofSetFrameRate(10);
	pangolin.init();

	cout << "Beyond Exe Started = " << pangolin.beyondExeStarted() << endl;
	cout << "Beyond Exe Ready   = " << pangolin.beyondExeReady() << endl;
	cout << "Beyond App Version = " << pangolin.getBeyondVersion() << endl;
	cout << "Beyond Dll Version = " << pangolin.getDllVersion() << endl;
	cout << "Beyond Projection Count = " << pangolin.getProjectionCount() << endl;
	cout << "Beyond Zone Count = " << pangolin.getZoneCount() << endl;
	//cout << "Beyond Projector Event = " << pangolin.getProjectorEvent(0) << endl;

	pangolin.createZoneImage(0, "openFrameworks");

	//pangolin.createZoneImage(0, "openFrameworks");
	//pangolin.createProjectionImage(1, "openFrameworks");
	//pangolin.deleteZoneIndex("openFrameworks");
	//pangolin.deleteProjectorImage("fuck yea");

}

//--------------------------------------------------------------
void ofApp::update(){
	if (pangolin.beyondExeReady()) {

	}
}

//--------------------------------------------------------------
void ofApp::draw(){
	ofBackground(0);

	ofPolyline heart;

	float i = 0;
	while (i < TWO_PI) { // make a heart
		float r = (2 - 2 * sin(i) + sin(i)*sqrt(abs(cos(i))) / (sin(i) + 1.4)) * -80;
		r *= sin(ofGetFrameNum()*0.01);
		float x = ofGetWidth() / 2 + cos(i) * r;
		float y = ofGetHeight() / 2 + sin(i) * r;
		heart.addVertex(ofVec2f(x, y - 100));
		i += 0.005*HALF_PI*0.5;
	}
	heart.close(); // close the shape
	ofSetColor(255, 0, 0);
	heart.draw();

	vector<LaserPoint> points;
	int size = heart.getVertices().size();
	for (int i = 0; i < size; i++) {
		points.push_back(LaserPoint());
		points[i].x = heart.getVertices()[i].x / ofGetWidth();
		//points[i].x = 0.25+ ofRandomuf()*0.5;
		//points[i].y = 0.25+ ofRandomuf()*0.5;
		points[i].y = heart.getVertices()[i].y / ofGetHeight();
		points[i].z = 0.5;// abs(sin(ofGetFrameNum()*0.5));
		points[i].r = 255;
		points[i].g = 0;
		points[i].b = 0;
	}
	
	vector<int> zoneIndices = { 2 };
	int pps = 50;
	
	pangolin.sendFrameToImage("openFrameworks", points, zoneIndices, pps);
	//pangolin.deleteZoneIndex("openFrameworks");

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
	if (key == 'e') {
		pangolin.enableLaserOutput();
	}
	else if (key == 'd') {
		pangolin.disableLaserOutput();
	}
	else if (key == 'b') {
		pangolin.blackout();
	}

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
