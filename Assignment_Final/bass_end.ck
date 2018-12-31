//Assignment_7_AE

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
    bass.noteOn(45,4*quart);

