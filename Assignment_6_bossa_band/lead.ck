//Assignment_6_AE_bossa_nova

// Lead voice. Clarinet with random reeds and vibrato on long notes (realized with spork).

0.65=> float quart;
quart/2=> float eight;
eight*3/2=> float eight_dot;
eight/2=> float sixth;
sixth*3/2=> float sixth_dot;

// clarintet sounds like real flute, unlicke Stk Flute
Clarinet solo => JCRev rev => dac;
0.1 => rev.mix;
solo => Delay d => d => rev;
sixth_dot :: second => d.max => d.delay;
0.5 => d.gain;
0.16 => solo.gain;
6 => solo.vibratoFreq;
0.3 => solo.rate;

// melody
[
0    ,58   ,61   ,63   ,65   ,0    ,63   ,0    ,61   ,0    ,58   ,
0    ,63   ,65   ,61   ,
0    ,70   ,68   ,65   ,63   ,0    ,61   ,0    ,63   ,0    ,65   ,
0    ,66   ,58   ,63   ,65   ,63   ,61   ,58   
] @=> int pattern[];
[
eight*2,sixth,sixth,sixth,sixth,sixth,sixth,sixth,sixth,sixth,sixth,
eight,3*eight,sixth,3*eight+sixth,
eight*3,sixth,sixth,sixth,sixth,sixth,sixth,sixth,sixth,sixth,sixth,
sixth,sixth+3*eight,sixth,eight,eight_dot,sixth,sixth,sixth*2
] @=> float dur[];

    for( 0 => int j; j <dur.cap() ; j++ )
    {
           
            // all notes of on silence
            if (pattern[j]!=0)
            {
                Std.mtof(pattern[j]+12) => solo.freq;
                //Std.mtof(pattern[j][beat]-24) => solo.freq;
                solo.noteOn(1);
            }
            // Vibrato on long notes
            spork ~ vibrato(dur[j]);
            // to more natural sound
            Math.random2f(0.3,0.7) => solo.reed;
            
            (dur[j]-0.015)::second => now;   
            solo.noteOff(1);
            0.015::second => now;   
    }


// vibrato function    
fun void vibrato(float dur)
{
    solo.vibratoGain(0.0);
    // only long notes
    if (dur > 0.325)
    {
        0.2::second => now;
        for( 0 => int j; j <15 ; j++ )
        {
            j*0.04 => solo.vibratoGain;
            0.01::second => now;
        }
    }
}
    