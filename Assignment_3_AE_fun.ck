<<< "Assignment_4_AE_Arp_TechnoMelody" >>>;
// Thank you for your review!!!

// Sound Chain
Gain master [4];
master[0] => dac;
master[1] => dac.left;
master[2] => dac.right;
master[3] => dac;

// Mixer
//drums
0.8 => master[0].gain;
0.4 => master[1].gain;
0.4 => master[2].gain;
//Synth
0.1 => master[3].gain;

//our sound generators
SqrOsc chord[3];
chord[0] => master[3];
chord[1] => master[3];
chord[2] => master[3];
SawOsc bass => master[3];

// drums
SndBuf kick => master[0];
SndBuf hat => master[1];
SndBuf snare => master[0];
SndBuf clap => master[0];
SndBuf bell => master[2];
SndBuf fx => master[0];

// load soundfiles
["kick_01.wav","hihat_02.wav","snare_03.wav","clap_01.wav","cowbell_01.wav","stereo_fx_02.wav"] @=> string Files[];
me.dir() + "/audio/" + Files[0] => kick.read;
me.dir() + "/audio/" + Files[1] => hat.read;
me.dir() + "/audio/" + Files[2] => snare.read;
me.dir() + "/audio/" + Files[3] => clap.read;
me.dir() + "/audio/" + Files[4] => bell.read;
me.dir() + "/audio/" + Files[5] => fx.read;

//set all playheads to end
kick.samples() => kick.pos; 
hat.samples() => hat.pos; 
snare.samples() => snare.pos; 
clap.samples() => clap.pos;
bell.samples() => bell.pos;
fx.samples() => fx.pos;

// Main function. Plays All
fun void Sequencer(int kick_p[],int snare_p[],int hat_p[],int bell_p[],int bass_p[],int chord_p[][],float beattime)
{
    
    for(0 => int i; i < kick_p.cap();i++)
    {

        if ( kick_p[i] == 1 )
        {
            0 => kick.pos;
        }
            
        if ( snare_p[i] == 1 )
        {
            0 => snare.pos;
        }
        
        if ( hat_p[i] == 1 )
        {
            0 => hat.pos;
        }
        
        if ( bell_p[i] == 1 )
        {
            0 => bell.pos;
        }
        
        // Is there another way to do this? for example chord_p[i,:] @=> int chord[]
        [chord_p[i,0],chord_p[i,1],chord_p[i,2]] @=> int chord[];
        
        SetChordNotes(chord);
        SetBassNotes(bass_p,i);
        
        // Sets attack and decay to chord notes only. Bass sounds is good without it (trombone like)
        PlayNotes(chord,beattime);
    }
}

// Midi to freq function to bass
fun void SetBassNotes(int bass_p[], int beat)
{
    0.0 => bass.gain;
    
    if (bass_p[beat] != 0 )
    {
        1.0 => bass.gain;
        Std.mtof(bass_p[beat]) => bass.freq;
    }
    
}

// Midi to freq function to chords
fun void SetChordNotes(int chord_p[])
{

    for(0=>int i;i<3;i++)
    {
        if (chord_p[i] != 0 )
        {
            Std.mtof(chord_p[i]) => chord[i].freq;
        }
    }
    
}

fun void MakeChordGain(int chord_p[],float gain)
{
    for (0 => int i; i<3; i++)
    {
        if (chord_p[i] == 0)
        {
            0.0 => chord[i].gain;
        }
        else
        {
            gain => chord[i].gain;
        }
    }

}

//This is envelope funtion to chords
fun void PlayNotes(int chord[],float beattime)
{
    float out_time;
    float gain;
    
    //Atack
    for (0=>int i; i < 10; i++)
    {
        1./10*i => gain;
        MakeChordGain(chord,gain);
        0.01::second => now;
    }

    beattime-10*0.01 => out_time;

        //Release
    for (0=>int i; i < 10; i++)
    {
        0.6/10*(9-i) => gain;
        MakeChordGain(chord,gain);
        out_time*0.1::second => now;
    }
}

// Arrays with silence patterns. Zero means silence
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] @=> int slnc[];
[[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]] @=> int chord_p_0[][];

//Intro drum patterns
[0,0,1,0] @=> int snare_p_1[];
[1,0,0,0] @=> int kick_p_1[];
[0,1,0,1] @=> int hat_p_1[];
[0,1,1,0] @=> int snare_p_1_1[];
[0,1,1,0] @=> int hat_p_1_1[];
[0,0,0,1] @=> int bell_p_1[];
[1,0,1,0] @=> int hat_p_1_2[];

[0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0] @=> int snare_p_4[];
[1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0] @=> int kick_p_4[];
[0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0] @=> int hat_p_4[];

[0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0] @=> int snare_p_4_4[];
[1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0] @=> int kick_p_4_4[];
[0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0] @=> int hat_p_4_4[];

[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0] @=> int p_5[];

// Used notes
 //63, 65, 67, 68, 70, 72, 73, 75
 //51, 53, 55, 56, 58, 60, 61, 63
 //39, 41, 43, 44, 46, 48, 49, 51
 
// Arrays with bass and chord patterns
[39,0,34,0] @=> int bass_p_1[];
[39,34,39,0] @=> int bass_p_1_1[];
[31,0,27,0] @=> int bass_p_1_2[];

[[0,0,0],[55,61,63],[0,0,0],[55,61,63]] @=> int chord_p_1[][];
[[0,0,0],[55,61,58],[55,61,63],[0,0,0]] @=> int chord_p_1_1[][];
[[55,61,58],[0,0,0],[55,51,0],[0,0,0]] @=> int chord_p_1_2[][];

[39,39,0,0,34,34,0,0,31,31,0,0,34,34,0,0] @=> int bass_p_4[];
[39,39,0,0,32,32,0,0,36,36,0,0,39,39,0,0] @=> int bass_p_4_2[];
[41,41,0,0,34,34,0,0,31,31,0,0,41,41,0,0] @=> int bass_p_4_3[];
[39,39,0,0,34,34,0,0,27,27,0,0,0,0,0,0] @=> int bass_p_4_4[];

[[0,0,75],[0,0,75],[55,61,75],[55,61,73],[0,0,75],[0,0,0],[55,61,75],[0,0,0],[0,0,0],[0,0,75],[55,61,73],[55,61,0],[0,0,75],[0,0,0],[55,61,70],[0,0,0]] @=> int chord_p_4_1[][];
[[0,0,68],[0,0,0],[56,60,0],[56,60,68],[0,0,0],[0,0,0],[56,60,68],[0,0,0],[0,0,0],[0,0,63],[56,60,0],[56,60,0],[0,0,65],[0,0,0],[56,60,0],[0,0,0]] @=> int chord_p_4_2[][];
[[0,0,70],[0,0,70],[53,58,70],[53,58,68],[0,0,70],[0,0,0],[53,58,68],[0,0,0],[0,0,0],[0,0,68],[53,58,0],[53,58,0],[0,0,75],[0,0,0],[53,58,73],[0,0,0]] @=> int chord_p_4_3[][];
[[0,0,70],[0,0,0],[51,58,0],[51,58,0],[0,0,67],[0,0,0],[51,58,63],[0,0,0],[0,0,0],[0,0,0],[0,0,67],[0,0,0],[63,58,70],[0,0,0],[0,0,0],[0,0,0]] @=> int chord_p_4_4[][];

0.3 => float eight;
0.15 => float sixth;

//Intro
Sequencer(kick_p_1,snare_p_1,hat_p_1,slnc,bass_p_1,chord_p_1,eight);
Sequencer(kick_p_1,snare_p_1,hat_p_1,slnc,bass_p_1,chord_p_1,eight);
Sequencer(kick_p_1,snare_p_1,hat_p_1,slnc,bass_p_1,chord_p_1,eight);
Sequencer(kick_p_1,snare_p_1_1,hat_p_1_1,bell_p_1,bass_p_1_1,chord_p_1_1,eight);
Sequencer(kick_p_1,snare_p_1,hat_p_1,slnc,bass_p_1,chord_p_1,eight);
Sequencer(kick_p_1,snare_p_1,hat_p_1,slnc,bass_p_1,chord_p_1,eight);
Sequencer(kick_p_1,snare_p_1,hat_p_1,slnc,bass_p_1,chord_p_1,eight);
Sequencer(kick_p_1,snare_p_1,hat_p_1_2,slnc,bass_p_1_2,chord_p_1_2,eight);

//Second Part - 8bit!!!
Sequencer(kick_p_4,snare_p_4,hat_p_4,slnc,bass_p_4,chord_p_4_1,sixth);
Sequencer(kick_p_4,snare_p_4,hat_p_4,slnc,bass_p_4_2,chord_p_4_2,sixth);
Sequencer(kick_p_4,snare_p_4,hat_p_4,slnc,bass_p_4_3,chord_p_4_3,sixth);
Sequencer(kick_p_4_4,snare_p_4_4,hat_p_4_4,slnc,bass_p_4_4,chord_p_4_4,sixth);
Sequencer(kick_p_4,snare_p_4,hat_p_4,slnc,bass_p_4,chord_p_4_1,sixth);
Sequencer(kick_p_4,snare_p_4,hat_p_4,slnc,bass_p_4_2,chord_p_4_2,sixth);
Sequencer(kick_p_4,snare_p_4,hat_p_4,slnc,bass_p_4_3,chord_p_4_3,sixth);
Sequencer(kick_p_4_4,snare_p_4_4,hat_p_4_4,slnc,bass_p_4_4,chord_p_4_4,sixth);


// Final Chord
float gain;

0.7 => bass.gain;

Std.mtof(36) => bass.freq;
Std.mtof(51) => chord[0].freq;
Std.mtof(58) => chord[1].freq;
Std.mtof(63) => chord[2].freq;

eight::second => now;

    for (0=>int i; i < 10; i++)
    {
        0.1*i => gain;
        0.7*gain=>chord[0].gain;
        0.01::second => now;
    }
      
    for (0=>int i; i < 10; i++)
    {
        1./10*i => gain;
        0.7*gain=>chord[1].gain;
        0.01::second => now;
    }
      
    for (0=>int i; i < 10; i++)
    {
        1./10*i => gain;
        0.7*gain=>chord[2].gain;
        0.01::second => now;
    }
    
    //Decay
    //          TRY TO SET HERE ! i-- SOUNDS GREAT!!!
        for (100=>int i; i > 0; i--)
    {
        0.01*i => gain;
        0.7*gain=>bass.gain;
        0.7*gain=>chord[0].gain;
        0.7*gain=>chord[1].gain;
        0.7*gain=>chord[2].gain;
        0.02::second => now;
    }
