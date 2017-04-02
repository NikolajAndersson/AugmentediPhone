declare name "UnderApp";

import("stdfaust.lib");
// declare the interface with the smart keyboard
declare interface "SmartKeyboard{
	'Number of Keyboards' : '2',
	'Keyboard 0 - Lowest Key' : '24',
	'Keyboard 0 - Orientation' : '1',
	'Keyboard 0 - Number of Keys':'11',
	'Keyboard 0 - Piano Keyboard':'0',
	'Keyboard 0 - Scale':'2',
	'Keyboard 1 - Lowest Key' : '36',
	'Keyboard 1 - Orientation' : '1',
	'Keyboard 1 - Number of Keys':'11',
	'Keyboard 1 - Piano Keyboard':'0',
	'Keyboard 1 - Scale':'2',
	'Rounding Mode':'2'
}";
key = nentry("key",0,0,13,1) : int;

// 60 	62 	64 	65 	67 	69 	71 	72
//scale = 55, 57, 60, 62, 64, 67, 69, 72, 74, 76, 79, 81, 84;
f = nentry("freq",440,50,2000,0.01);
bend = nentry("bend",1,0,10,0.01) : si.polySmooth(trigger,0.999,1);
frequency = f*bend;
y = nentry("y",0.5,0,1,0.01) : si.smoo;
cutoff = y*4000+50;

wet = hslider("wet[acc: 0 0 -10 0 10]",0,0,1,0.01);
// the resonance factor of the reverb
res = hslider("res[acc: 1 0 -10 0 10]",0.5,0,1,0.01);
reverb(wet,res)  =  _ <: *(1-wet),(*(wet) : re.mono_freeverb(res, 0.5, 0.5, 0)) :> _;

trigger = button("gate") : si.smooth(ba.tau2pole(0.01));
//trigger = button("gate") : en.adsr(0.01,0.01,80,0.01);
process = os.sawtooth(frequency)*trigger*0.4 : fi.lowpass(3,cutoff) : reverb(wet,res);

/*// import standard library
import ("stdfaust.lib");

declare interface "SmartKeyboard{
    'Number of Keyboards' : '1',
    'Max Keyboard Polyphony': '0',
    'Keyboard 0 - Number of Keys': '1',
    'Keyboard 0 - Piano Keyboard': '0',
    'Keyboard 0 - Count Fingers': '1',
    'Keyboard 0 - Send Freq': '1',
    'Keyboard 0 - Static Mode': '1'
}";

x0 = nentry("x0", 0.5, 0, 1, 0.01) : si.smoo; // x0, first finger x axis
y0 = nentry("y0", 0.5, 0, 1, 0.01) : si.smoo; // y0, first finger y axis
x1 = nentry("x1", 0.5, 0, 1, 0.01) : si.smoo; // y1, second finger y axis
y1 = nentry("y1", 0.5, 0, 1, 0.01) : si.smoo; // y1, second finger y axis
x2 = nentry("x2", 0.5, 0, 1, 0.01) : si.smoo; // y1, second finger y axis
x3 = nentry("x3", 0.5, 0, 2, 0.01) : si.smoo; // y1, second finger y axis

trigger = button("gate") : si.smooth(ba.tau2pole(0.01));

resFreq = y0 * 3000 + 300;
echoResFreq = y1 * 3000 + 20;
q = x0 * 20;

impFreq = 100 + x0 * 1000;
del = nentry("del[acc: 0 0 -20 0 20]", 0.5, 0.01, 1, 0.01) : si.smoo; // delay duration in seconds
feedback = nentry("fb[acc: 1 0 -10 0 10]", 0.5, 0, 1, 0.01) : si.smoo;
wah = nentry("del[gyr: 0 0 -20 0 20]", 0.5, 0.01, 1, 0.01) : si.smoo;
echo = +~(de.delay(65536, del * ma.SR)*feedback);
// sawTrombone(att,freq,gain,gate) : _ sawTrombone
s = sy.sawTrombone(0.001, impFreq, 1, button("gate"));
dry = wah;

process = s : fi.resonlp(resFreq, q, 1) : echo <: ve.moog_vcf(echoResFreq, x1)*(1-dry),*(dry) :> _;
*/
