//Assignment_7_AE

// used classes
MIXER mix;
BPM tempo;
// Instrument
Bass_Synth_Module bass;
// bass paramaters (see explanations in class)
bass.set(mix.bass, 0.1, 500, 3000, 2, [0.01,0.15,0.6,0.1], [0.1,0.06,0.3,0.0025]);

//set tempo
mix.bpm => tempo.tempo;
tempo.quart => dur quart;
tempo.eight => dur eight;
tempo.eight_dot => dur eight_dot;
tempo.sixth => dur sixth;
tempo.sixth_dot => dur sixth_dot;

// notes pattern
[[48   ,0    ,48   ,0    ],[41   ,0    ,40   ,0    ,57,55,52],
[47   ,0    ,47   ,0    ],[43   ,0    ,41   ,0    ,41,43,47,50]] @=> int pattern[][];
[[sixth,eight,sixth,eight],[sixth,eight,sixth,eight,sixth,sixth,eight],
[sixth,eight,sixth,eight],[sixth,eight,sixth,eight,sixth,sixth,sixth,sixth]] @=> dur dur_pattern[][];

0=> int n_pat;

// loop 
while( true )  
{  
    //chord counter
    for( 0 => int j; j < 4; j++ )
    {
           
        j%4 => n_pat;
        // beat counter
        for( 0 => int beat; beat < dur_pattern[n_pat].cap(); beat++ )
        {
            
            // all notes of on silence
            if (pattern[n_pat][beat]==0)
            {
                bass.noteOff();
            }
            else
            {
                //Std.mtof(pattern[j][beat]-12) => bazz.freq;
                //Std.mtof(pattern[j][beat]-24) => bazz_oct.freq;
                bass.noteOn(pattern[j][beat]);
            }           
            
            dur_pattern[n_pat][beat] -0.001::second => now;
            bass.noteOff();
            0.001::second => now;
            
        }
    }
}


