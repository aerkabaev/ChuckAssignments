//Assignment_6_AE_bossa_nova

Gain master => dac;

master.gain(0.07);

// Sound needs additional low octave
SawOsc bazz => LPF lpf_b => ADSR bass => master;
SawOsc bazz_oct => lpf_b => bass => master;

bazz.gain(0.3);
bazz_oct.gain(0.4);

3000 => lpf_b.freq;
1.0 => lpf_b.Q;

(0.01::second,0.15::second,0.6,0.1::second) => bass.set;

0.65=> float quart;
quart/2=> float eight;
eight*3/2=> float eight_dot;
eight/2=> float sixth;
sixth*3/2=> float sixth_dot;

// notes pattern
[[46   ,0    ,46   ,48    ,0   ],[49   ,0    ,53   ,0    ,49   ,53   ],[ 54  ,0    ,49   ,54    ,0   ],[53   ,0    ,48   ,0    ,53   ,48   ]] @=> int pattern[][];
[[eight,eight,sixth,sixth,sixth],[eight,eight,sixth,sixth,sixth,eight],[eight,eight,sixth,sixth,sixth],[eight,eight,sixth,sixth,sixth,eight]] @=> float dur[][];

0=> int n_pat;

// loop 
while( true )  
{  
    //chord counter
    for( 0 => int j; j < 4; j++ )
    {
           
        j%4 => n_pat;
        // beat counter
        for( 0 => int beat; beat < dur[n_pat].cap(); beat++ )
        {
            
            // all notes of on silence
            if (pattern[n_pat][beat]==0)
            {
                bass.keyOff(1);
            }
            else
            {
                Std.mtof(pattern[j][beat]-12) => bazz.freq;
                Std.mtof(pattern[j][beat]-24) => bazz_oct.freq;
                bass.keyOn(1);
            }           
            
            dur[n_pat][beat]::second => now;
            
        }
    }
}
