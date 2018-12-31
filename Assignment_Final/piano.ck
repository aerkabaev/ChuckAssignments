//Assignment_Final_AE

// used classes
MIXER mix;
BPM tempo;

// set volume from mixer
Gain master => dac;
mix.piano => master.gain;

//set tempo
mix.bpm => tempo.tempo;
tempo.quart => dur quart;
tempo.eight => dur eight;
tempo.eight_dot => dur eight_dot;
tempo.sixth => dur sixth;
tempo.sixth_dot => dur sixth_dot;

JCRev rev;
// sound chain
Rhodey piano[4];
//Whorley piano[4];
piano[0] => rev => master;
piano[1] => Pan2 p1 => rev => master;
piano[2] => rev => master;
piano[3] => Pan2 p2 => rev => master;

p1.pan(-0.3);
p2.pan(0.3);

rev.mix(0.15);

// used chords
[[45,60,64,69],[45,60,64,69],[43,60,64,69],[43,60,64,69],[41,60,65,69],[41,60,65,69],[40,59,64,69],[40,60,64,69]] @=> int chords[][];

"b"=> string b;
"c"=> string c;
"bc"=> string bc;
"s"=> string s;

// pattern. b means bass, c means chord, s means silence
[b        ,c              ] @=> string pattern[];
[quart*1.5,quart*1.5+quart] @=> dur dur_pattern[];

0=> int n_pat;

// loop 
while( true )  
{  
    //chord counter
    for( 0 => int j; j < 8; j++ )
    {
        // set chord notes
        for( 0 => int i; i < 4; i++ )  
        {
            Std.mtof(chords[j][i]-12) => piano[i].freq;
        }
        // beat counter
        for( 0 => int beat; beat < dur_pattern.cap(); beat++ )
        {
            
            // all notes of on silence
            if (pattern[beat]=="s")
            {
                for( 0 => int i; i < 4; i++ )
                {
                    piano[i].noteOff(1);
                }
            }
            
            // only root note on b
            if (pattern[beat]=="b")
            {
                piano[0].noteOn(1);
                for( 1 => int i; i < 4; i++ )
                {
                    piano[i].noteOff(1);
                }
            }           
            
            // only chords on c
            if (pattern[beat]=="c")
            {
                piano[1].noteOff(1);
                for( 1 => int i; i < 4; i++ )
                {
                    piano[i].noteOn(1);
                }
            }    
            
            // all on bc
            if (pattern[beat]=="bc")
            {
                for( 0 => int i; i < 4; i++ )
                {
                    piano[i].noteOn(1);
                }
            }              
            
            dur_pattern[beat] => now;
            
        }
    }
}
