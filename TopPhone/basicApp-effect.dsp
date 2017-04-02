import("stdfaust.lib");

y = hslider("y",0,0,1,0.01);
mix = nentry("mix[acc: 2 0 -20 0 20]", 0.2, 0, 1, 0.01) : si.smoo; // delay duration in seconds
echo = +~(de.delay(65536, del * ma.SR)*feedback);
echoResFreq = nentry("ech[acc: 1 0 -20 0 20]", 1000, 20, 15000, 1) : si.smoo; // delay duration in seconds
del = nentry("del[acc: 1 0 -20 0 20]", 0.5, 0.01, 1, 0.01) : si.smoo; // delay duration in seconds
feedback = nentry("fb[gyr: 0 0 -10 0 10]", 0.5, 0, 1, 0.01) : si.smoo;
filterAmount = nentry("filt[gyr: 1 0 -10 0 10]", 0.5, 0, 1, 0.01) : si.smoo;
q = y*10+0.1;

filteredEcho = echo : fi.resonlp(echoResFreq, q, filterAmount);
process = filteredEcho : ef.cubicnl(mix,0)*0.95;
