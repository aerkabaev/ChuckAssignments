//Assignment_1_Random_Experiment
// In this program I want randomly chose the OSC and attribute it random frequency.

//Soud Networks
//why it calls network?
SinOsc sin => dac;
TriOsc tri => dac; 
SqrOsc sqr => dac;
SawOsc saw => dac;

//this variable defines the OSC
int OscType;

// duration of each note
0.1 => float timequant;
// define timequant and obtain number of cycles
30/timequant => float n_cycle;

//main cycle
0 => int i;
while ( i < 300)
{
    // I want only one oscilator simultaneously sounding, so zero to all gains!
    0.0 => sin.gain;
    0.0 => tri.gain;
    0.0 => sqr.gain;
    0.0 => saw.gain;
    
    // get random OSC
    Math.random2(1,4) => OscType;
    
    // write it to console
    <<<OscType>>>;
 
    // get random freuency to chosen OSC
    //this will be easier with arrays or case statement
    
    if (OscType == 1)
    {
        1.0 => sin.gain;
        Math.random2f(200,400) => sin.freq;
    }
    
    if (OscType == 2)
    {
        0.5 => tri.gain;
        Math.random2f(200,400) => tri.freq;
    }

    if (OscType == 3)
    {
        0.2 => sqr.gain;
        Math.random2f(200,400) => sqr.freq;
    }
    
    if (OscType == 4)
    {
        0.2 => saw.gain;
        Math.random2f(200,400) => saw.freq;
    }    
    
    timequant::second => now;
    
    // and mute the OSCs again
    0.0 => sin.gain;
    0.0 => tri.gain;
    0.0 => sqr.gain;
    0.0 => saw.gain;
    
    i++;
}
