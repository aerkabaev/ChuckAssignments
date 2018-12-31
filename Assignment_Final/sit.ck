//Assignment_Final_AE

// used classes
MIXER mix;
BPM tempo;
// Instrument
Sitar_Module sit;

//set tempo
mix.bpm => tempo.tempo;
tempo.quart => dur quart;
tempo.eight => dur eight;
tempo.eight_dot => dur eight_dot;
tempo.sixth => dur sixth;
tempo.sixth_dot => dur sixth_dot;

// sit paramaters (see explanations in class)
sit.set(mix.sit,eight,0.35, 6000, 10000, 1, [0.0,0.0,1.0,0.0], [0.1,0.0,1.0,0.00]); 
    // chord 1
    sit.noteOn(50,52,eight);
    sit.noteOn(52,quart);
    sit.noteOn(52,1.5*quart);
    sit.noteOn(52,quart,"v");
    sit.noteOn(57,eight);
    sit.noteOn(55,quart);
    sit.noteOn(57,1.5*quart);
    sit.noteOn(55,quart,"v");
    // chord 2
    sit.noteOn(50,52,eight);
    sit.noteOn(52,quart);
    sit.noteOn(52,1.5*quart);
    sit.noteOn(52,quart,"v");
    sit.noteOn(55,eight);
    sit.noteOn(53,quart);
    sit.noteOn(55,1.5*quart);
    sit.noteOn(53,quart,"v");   
    // chord 3
    sit.noteOn(52,53,eight);
    sit.noteOn(53,quart);
    sit.noteOn(53,1.5*quart);
    sit.noteOn(53,quart,"v");
    sit.noteOn(57,eight);
    sit.noteOn(55,quart);
    sit.noteOn(60,1.5*quart);
    sit.noteOn(59,quart,"v");  
    // chord 4
    sit.noteOn(53,52,eight);
    sit.noteOn(52,quart);
    sit.noteOn(52,1.5*quart);
    sit.noteOn(52,quart,"v");
    sit.noteOn(52,50,eight);
    sit.noteOn(50,eight);
    sit.noteOn(40,eight);
    sit.noteOn(48,quart,"v");
    sit.noteOn(40,eight);
    sit.noteOn(47,quart,"v");  

// secret melody
while( true )  
{  
    // chord 1
    sit.noteOn(45,1.5*quart);
    sit.noteOn(45,quart);
    sit.noteOn(45,eight);
    sit.noteOn(52,57,quart);
    sit.noteOn(57,eight);
    sit.noteOn(55,quart);
    sit.noteOn(57,1.5*quart);
    sit.noteOn(55,52,quart);
    // chord 2
    sit.noteOn(45,1.5*quart);
    sit.noteOn(45,quart);
    sit.noteOn(45,eight);
    sit.noteOn(52,55,quart);
    sit.noteOn(55,eight);
    sit.noteOn(53,quart);
    sit.noteOn(55,1.5*quart);
    sit.noteOn(53,52,quart);    
    // chord 3
    sit.noteOn(43,eight);
    sit.noteOn(41,quart);
    sit.noteOn(41,quart);
    sit.noteOn(41,eight);
    sit.noteOn(53,57,quart);
    sit.noteOn(57,eight);
    sit.noteOn(55,quart);
    sit.noteOn(60,1.5*quart);
    sit.noteOn(59,quart);  
    // chord 4
    sit.noteOn(41,eight);
    sit.noteOn(40,quart);
    sit.noteOn(40,quart);
    sit.noteOn(40,eight);
    sit.noteOn(48,52,quart);
    sit.noteOn(52,eight);
    sit.noteOn(50,quart);
    sit.noteOn(48,1.5*quart);
    sit.noteOn(47,quart);  
}


