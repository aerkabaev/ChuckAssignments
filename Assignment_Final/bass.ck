//Assignment_Final_AE

// used classes
MIXER mix;
BPM tempo;
// Instrument
Bass_Synth_Module bass;
// bass paramaters (see explanations in class)
bass.set(mix.bass, 0.2, 500, 3000, 2, [0.01,0.15,0.6,0.1], [0.1,0.06,0.3,0.0025]);

//set tempo
mix.bpm => tempo.tempo;
tempo.quart => dur quart;
tempo.eight => dur eight;
tempo.eight_dot => dur eight_dot;
tempo.sixth => dur sixth;
tempo.sixth_dot => dur sixth_dot;

// loop 
while( true )  
{  
    // chord 1
    bass.noteOn(45,1.5*quart);
    bass.noteOn(45,quart);
    bass.noteOn(45,eight);
    bass.noteOn(52,57,quart);
    bass.noteOn(57,eight);
    bass.noteOn(55,eight);
    bass.noteOn(45,eight);
    bass.noteOn(57,quart,"v");
    bass.noteOn(45,eight);
    bass.noteOn(55,52,quart);
    // chord 2
    bass.noteOn(45,1.5*quart);
    bass.noteOn(45,quart);
    bass.noteOn(45,eight);
    bass.noteOn(52,55,quart);
    bass.noteOn(55,eight);
    bass.noteOn(53,eight);
    bass.noteOn(45,eight);
    bass.noteOn(55,quart,"v");
    bass.noteOn(45,eight);
    bass.noteOn(53,52,quart);    
    // chord 3
    bass.noteOn(43,eight);
    bass.noteOn(41,quart);
    bass.noteOn(41,quart);
    bass.noteOn(41,eight);
    bass.noteOn(53,57,quart);
    bass.noteOn(57,eight);
    bass.noteOn(55,eight);
    bass.noteOn(45,eight);
    bass.noteOn(60,quart,"v");
    bass.noteOn(45,eight);
    bass.noteOn(59,quart,"v");  
    // chord 4
    bass.noteOn(41,eight);
    bass.noteOn(40,quart);
    bass.noteOn(40,quart);
    bass.noteOn(40,eight);
    bass.noteOn(48,52,quart);
    bass.noteOn(52,eight);
    bass.noteOn(50,eight);
    bass.noteOn(40,eight);
    bass.noteOn(48,quart,"v");
    bass.noteOn(40,eight);
    bass.noteOn(47,quart,"v");      
}

