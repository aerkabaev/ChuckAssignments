//Assignment_2_AE_Arp_Melody

<<< "Assignment_3_AE_Arp_TechnoMelody" >>>;

// Sound Chain
Gain master [3];
master[0] => dac; 
master[1] => dac.left;
master[2] => dac.right;

0.2 => master[0].gain;
0.2 => master[1].gain;
0.2 => master[2].gain;

//our sound generators
TriOsc chord => master[0];
SawOsc bass => master[0];

// drums
SndBuf kick => master[0]; 
SndBuf hihat => master[1];
SndBuf snare => master[0];
SndBuf clap => master[0]; 
SndBuf bell => master[2]; 
SndBuf fx => master[0]; 

// load soundfiles
["kick_01.wav","hihat_02.wav","snare_01.wav","clap_01.wav","cowbell_01.wav","stereo_fx_02.wav"] @=> string Files[];
me.dir() + "/audio/" + Files[0] => kick.read;
me.dir() + "/audio/" + Files[1] => hihat.read;
me.dir() + "/audio/" + Files[2] => snare.read;
me.dir() + "/audio/" + Files[3] => clap.read;
me.dir() + "/audio/" + Files[4] => bell.read;
me.dir() + "/audio/" + Files[5] => fx.read;

//set all playheads to end
kick.samples() => kick.pos; 
hihat.samples() => hihat.pos; 
snare.samples() => snare.pos; 
clap.samples() => clap.pos;
bell.samples() => bell.pos;
fx.samples() => fx.pos;

// used notes, 3 octaves is enough
[ 50, 52, 53, 55, 57, 59, 60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83, 84, 86] @=> int Notes[];

// Set sequence of chord notes
[1,3,5,1,3,5,7,9] @=> int Arpegio[];
// Set sequence of chords. it can be chosen randomly in code
[8,7,5,2,8,7,2,5] @=> int Melody[];
// Set bass sequence, it's gain, bass playes only root note
[1,1,0,0,0,1,0,0] @=> int Bass[];

// 
int note_to_play;
int lead_note_to_play;
int chord_note;

// for loops
0 => int i;
0 => int j;
0 => int k;

// Introduction
0. => chord.gain;
0. => bass.gain;

    0 => fx.pos;
    0.8 => fx.rate; 
    1.0::second => now;

for(0=>k;k<3;k++)
{
for(0=>j;j<8;j++)
{
    if ((j==0) || (j==2) || (j==4) || (j==6))
    {
        0 => kick.pos;
        
    }else{
        0 => hihat.pos;
    }
    
    if ((j==2) || (j==6))
    {if (k==1)
     {
        0 => clap.pos;
     }}
    
    .25::second => now;
}
}

for(0=>j;j<6;j++)
{
    0 => fx.pos;
    if ((j==0) || (j==2) || (j==4) || (j==6))
    {
        0 => kick.pos;
        0 => clap.pos;
        //REVERSE OF SAMPLES
        -1 => snare.rate;
        snare.samples() => snare.pos;
    }
    .25::second => now;
}

        0 => kick.pos;
        0 => clap.pos;


for(0=>j;j<8;j++)
{
    //RANDOM rate
    Math.random2f(1.,2.8) => snare.rate;
    0 => snare.pos;
    .0625::second => now;   
}

1 => snare.rate;

fx.samples() => fx.pos;

// This loop is to chords
for(0=>i;i<8;i++)
{
    // choose chord
    Melody[i] - 1 => chord_note;
    
    // loop to notes from chord
    for(0=>j;j<8;j++)
    {
        // choose note
        Notes[chord_note + Arpegio[j]-1] => note_to_play;
        
        0.4 => chord.gain;
        
        // accent on the root note
        if (Arpegio[j] == 1)
        {
            0.8 => chord.gain;
        }
        
        // and accent on the 7th note
        if ( Arpegio[j] == 7)
        {
            0.6 => chord.gain;
        }
        
        Std.mtof(note_to_play) => chord.freq;
        
        // bass is 2 octaves lower the melody
        Std.mtof(Notes[chord_note]-24) => bass.freq;
        0.13 * Bass[j] => bass.gain;
        
        2.5 => kick.gain;
        2.5 => snare.gain;
        
        0 => hihat.pos;
        
        // bell and hats pattern
        if ((j==0) || (j==2) || (j==4) || (j==6))
            {
                1.0 => hihat.gain;
            }
        else
            {
                0.5 => hihat.gain;
                0 => bell.pos;
            }    
        
        // kick is playing with bass
        if (Bass[j]==1)
            {
                0 => kick.pos;
            }
        
        // snare pattern   
        if ((j==2) || (j==6))
            {
                0 => snare.pos;
            }    
        
        .25::second => now;
    }    
   
}

// End Chord

0 => kick.pos;
0 => hihat.pos;
0 => bell.pos;

0.0 => bass.gain;

Melody[0] -1 => chord_note;

    for(0=>j;j<8;j++)
    {
        Notes[chord_note + Arpegio[j]-1] => note_to_play;
        
        <<< note_to_play >>>;
        
        0.4 => chord.gain;
        
        // accent on the root note
        if (Arpegio[j] == 1)
        {
            0.8 => chord.gain;
        }
        
        // and accent on the 7th note
        if ( Arpegio[j] == 7)
        {
            0.6 => chord.gain;
        }

        Std.mtof(note_to_play) => chord.freq;
        
        .25::second => now;
    }
    
   0 => i;
    //End note
   while (i<16)
   {
       i % 2 => j;
         Std.mtof(Notes[chord_note]+15) => chord.freq;
       <<< j >>>;
       
       if (j==0)
       {
           0.8*(16-i)/16 => chord.gain;
       }
       else
       {
           0.0 => chord.gain;
       }
       .25::second => now;
       i++;
   }
 