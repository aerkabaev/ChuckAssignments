//Assignment_6_AE_bossa_nova

Gain master[4];
JCRev rev;
// sound chain
Rhodey piano[4];
//Whorley piano[4];
piano[0] => rev => master[0] => dac;
piano[1]=> rev => master[1] => Pan2 p1 => dac;
piano[2] => rev => master[2] => dac;
piano[3] => rev => master[3] => Pan2 p2 => dac;

p1.pan(-0.3);
p2.pan(0.3);

0.07 => float mg;
mg => master[0].gain;
mg => master[1].gain;
mg => master[2].gain;
mg => master[3].gain;

rev.mix(0.15);

// used chords
[[46,56,61,65],[49,58,65,68],[54,61,65,70],[53,60,63,68]] @=> int chords[][];

0.65=> float quart;
quart/2=> float eight;
eight*3/2=> float eight_dot;
eight/2=> float sixth;
sixth*3/2=> float sixth_dot;

"b"=> string b;
"c"=> string c;
"s"=> string s;

// pattern. b means bass, c means chord, s means silence
[[b    ,c    ,s    ,b    ,c    ,s    ],[b    ,c    ,s    ,c    ,s    ,b    ,c    ,b    ]] @=> string pattern[][];
[[eight,sixth,sixth,sixth,sixth,sixth],[eight,sixth,sixth,sixth,sixth,sixth,sixth,sixth]] @=> float dur[][];

0=> int n_pat;

// loop 
while( true )  
{  
    //chord counter
    for( 0 => int j; j < 4; j++ )
    {
        // set chord notes
        for( 0 => int i; i < 4; i++ )  
        {
            Std.mtof(chords[j][i]-12) => piano[i].freq;
        }
            
        j%2 => n_pat;
        // beat counter
        for( 0 => int beat; beat < dur[n_pat].cap(); beat++ )
        {
            
            // all notes of on silence
            if (pattern[n_pat][beat]=="s")
            {
                for( 0 => int i; i < 4; i++ )
                {
                    piano[i].noteOff(1);
                }
            }
            
            // only root note on b
            if (pattern[n_pat][beat]=="b")
            {
                piano[0].noteOn(1);
                for( 1 => int i; i < 4; i++ )
                {
                    piano[i].noteOff(1);
                }
            }           
            
            // only chords on c
            if (pattern[n_pat][beat]=="c")
            {
                piano[1].noteOff(1);
                for( 1 => int i; i < 4; i++ )
                {
                    piano[i].noteOn(1);
                }
            }                   
            
            dur[n_pat][beat]::second => now;
            
        }
    }
}
