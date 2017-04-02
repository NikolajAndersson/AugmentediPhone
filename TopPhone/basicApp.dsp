declare name "TopApp";

import("stdfaust.lib");

declare interface "SmartKeyboard{
	'Number of Keyboards':'3',
  'Rounding Mode':'2',
	'Keyboard 0 - Orientation' : '1',
	'Keyboard 1 - Orientation' : '1',
	'Keyboard 2 - Orientation' : '1',
	'Keyboard 0 - Number of Keys':'11',
	'Keyboard 1 - Number of Keys':'24',
	'Keyboard 2 - Number of Keys':'11',
	'Keyboard 0 - Lowest Key':'72',
	'Keyboard 1 - Lowest Key':'60',
	'Keyboard 2 - Lowest Key':'60',
	'Keyboard 0 - Piano Keyboard':'0',
	'Keyboard 1 - Piano Keyboard':'0',
	'Keyboard 2 - Piano Keyboard':'0',
	'Keyboard 0 - Scale':'2',
	'Keyboard 1 - Scale':'2',
	'Keyboard 2 - Scale':'2',
}";

//================================ Instrument Parameters =================================
// Creates the connection between the synth and the mobile device
//========================================================================================
y = hslider("y",0,0,1,0.01);

// the string resonance in second is controlled by the x axis of the accelerometer
res = hslider("res[acc: 0 0 -10 0 10]",2,0.1,4,0.01);
// Smart Keyboard frequency parameter
freq = hslider("freq",400,50,2000,0.01);
// Smart Keyboard gate parameter
gate = button("gate");

bend = hslider("bend",1,0,10,0.01) : si.polySmooth(gate,0.999,1);
//echoResFreq = nentry("ech[acc: 1 0 -20 0 20]", 1000, 20, 15000, 1) : si.smoo; // delay duration in seconds
//del = nentry("del[acc: 1 0 -20 0 20]", 0.5, 0.01, 1, 0.01) : si.smoo; // delay duration in seconds
//feedback = nentry("fb[gyr: 0 0 -10 0 10]", 0.5, 0, 1, 0.01) : si.smoo;
//filterAmount = nentry("filt[gyr: 1 0 -10 0 10]", 0.5, 0, 1, 0.01) : si.smoo;

keyboard = hslider("keyboard",0,0,2,1) : int;

//=================================== Parameters Mapping =================================
//========================================================================================
// number of modes
nModes = 6;
// distance between each mode
maxModeSpread = 5;
modeSpread = y*maxModeSpread;
// computing modes frequency ratio
modeFreqRatios = par(i,nModes,1+(i+1)/nModes*modeSpread);
// computing modes gain
minModeGain = 0.3;
modeGains = par(i,nModes,1-(i+1)/(nModes*minModeGain));
// smoothed mode resonance
modeRes = res : si.smoo;

chimes = (keyboard == 1) * sy.additiveDrum(freq * bend,modeFreqRatios,modeGains,0.8,0.001,modeRes,gate)*0.05;

//stringFreq = freq;
fluteFreq = freq * bend;

//echo = +~(de.delay(65536, del * ma.SR)*feedback);
//string = ((keyboard == 0) || (keyboard == 1))*sy.combString(freq,res,gate);
//string = (keyboard == 1)*sy.combString(freq,res,gate);
s = os.triangle(fluteFreq)* (((keyboard == 2) | (keyboard == 0))*gate : si.smoo); // +  os.triangle(fluteFreq) * ((keyboard == 0)*gate : si.smoo);//*sy.combString(freq,res,gate);//
synths = chimes + s;
//q = y*10+0.1;

//filteredEcho = echo : fi.resonlp(echoResFreq, q, filterAmount);
//============================================ DSP =======================================
//========================================================================================

process = synths;
