<<< "Assignment_5_AE_STK_metal" >>>;
// Thank you for your review!!!

// Sound Chain
Gain master [10];
// kick
master[0] => dac;
// snare + some reverb
master[1] => JCRev rev => dac;
// hat
master[2] => Pan2 hat_pan => dac;
// shakers + reverb
master[3] => JCRev rev2 => Pan2 sh_pan =>  dac;
// bass
master[5] => dac;
// tubebell
master[6] => dac;
// guitars
master[7] => dac;

// Mixer
//kick
0.4 => master[0].gain;
// snare
0.7 => master[1].gain;
// hat
0.15 => master[2].gain;
// shakers
1.0 => master[3].gain;

//bass
0.08 => master[5].gain;
// tubebell
0.03 => master[6].gain;
// guitars
0.2 => master[7].gain;

-0.8 => hat_pan.pan;
0.8=> sh_pan.pan;
rev.mix(0.02);
rev2.mix(0.06);

//Filters to kick and bass

LPF lpf_k;
LPF lpf_b;

3000 => lpf_k.freq;
3 => lpf_k.Q;

//2000 => lpf_b.freq;
2.0 => lpf_b.Q;

//our sound generators
//Bass
SawOsc bass => lpf_b => ADSR env_b => master[5];
Step s => ADSR env_f => blackhole;
(0.01::second,0.15::second,0.6,0.0::second) => env_b.set;
(0.2::second,0.05::second,0.5,0.0::second) => env_f.set;

// bells with delay
TubeBell bells => Gain bellG => master[6];
bellG => Gain fdbk => Echo echo => bellG;
//0.75=>echo.max;
//0.5=>echo.mix;
0.9 => fdbk.gain;

// other shaker parameters are in sequensor
Shakers shakers => master[3];
shakers.preset(7);
//shakers.energy(0.9);
shakers.decay(0.9);
//shakers.objects(100);
shakers.freq(1000);

// Guitar
HevyMetl guit[2];
guit[0] => master[7];
guit[1] => master[7];

// drums
SndBuf kick => lpf_k => master[0];
SndBuf hat => master[2];
SndBuf snare => master[1];

// load soundfiles
["kick_01.wav","hihat_02.wav","snare_01.wav","clap_01.wav","cowbell_01.wav","stereo_fx_02.wav"] @=> string Files[];
me.dir() + "/audio/" + Files[0] => kick.read;
me.dir() + "/audio/" + Files[1] => hat.read;
me.dir() + "/audio/" + Files[2] => snare.read;
//me.dir() + "/audio/" + Files[5] => fx.read;

//set all playheads to end
kick.samples() => kick.pos; 
hat.samples() => hat.pos; 
snare.samples() => snare.pos; 

// This function recalculates all input sound patterns to unified rythm grid.
// Input data is arrays with notes, it's durations and beattime (grid value).
// Note durations should be a multiple of beattime.
fun int[] PatternReload(int in_notes_pattern[],float in_dur_pattern[], float beattime)
{   
    // Calculate number of beats
    int beatnumber;
    for(0=> int i; i < in_dur_pattern.cap(); i++ )
    {
        (in_dur_pattern[i] / beattime) $ int +=> beatnumber;
    }
    
    // output pattern
    int out_pattern[beatnumber];
    
    0 => int d;
    for(0=> int i; i < in_notes_pattern.cap(); i++ )
    {
        //Number of beats of i'th note.
        (in_dur_pattern[i] / beattime) $ int=> int n;
        
        // Zero means silence
        if (in_notes_pattern[i]==0)
        {
            for(0=> int j; j < n; j++ )
            {
                0 => out_pattern[d];
                d++;
            }
        }
        else
        {
            // Number means note on.
            in_notes_pattern[i] => out_pattern[d];
            d++;
            for(1=> int j; j < n; j++ )
            {
                // -1 means continuation of note
                -1 => out_pattern[d];
                d++;
            }
        }
    }
    return out_pattern;
}

// Main play function. Get patterns with any dimension
// Restriction to patterns - Sum duration of each pattern should be MUST be the same!!!
// Beattime must be the smallest divisor of patterns notes duration.
fun void Sequencer(int in_kick_n[], float in_kick_d[], int in_snare_n[], float in_snare_d[],int in_hat_n[], float in_hat_d[],int in_bass_n[], float in_bass_d[], int in_bells_n[], float in_bells_d[],int in_guit_n[], float in_guit_d[],int in_shakers_n[],float in_shakers_d[], float beattime)
{
    // To be honest, automatic calculation of beat time should be written. But I did not have time to do it(((
    
    // Reload all input patterns
    PatternReload(in_kick_n,in_kick_d,beattime) @=> int kick_p[];
    PatternReload(in_snare_n,in_snare_d,beattime) @=> int snare_p[];
    PatternReload(in_hat_n,in_hat_d,beattime) @=> int hat_p[];
    PatternReload(in_bass_n,in_bass_d,beattime) @=> int bass_p[];
    PatternReload(in_guit_n,in_guit_d,beattime) @=> int guit_p[];
    PatternReload(in_bells_n,in_bells_d,beattime) @=> int bells_p[];
    PatternReload(in_shakers_n,in_shakers_d,beattime) @=> int shakers_p[];
    
    for(0 => int i; i < kick_p.cap();i++)
    {
        // drums. 1 means sound, 0 means silence

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
        
    // Notes On
        
        // play bass
        if (bass_p[i] > 0 )
        {
            env_b.keyOn(1);
            env_f.keyOn(1);
            Std.mtof(bass_p[i]) => bass.freq;
        }
        
        //play bells
        if (bells_p[i] > 0 )
        {
            1=>bells.noteOn;
            Std.mtof(bells_p[i]) => bells.freq;
        }
        
        //play guitars
            if (guit_p[i] > 0 )
            {
                guit[0].noteOn(1);
                guit[1].noteOn(1);
                // guitar plays power chord only
                Std.mtof(guit_p[i]) => guit[0].freq;
                Std.mtof(guit_p[i]+7) => guit[1].freq;
            }   
        
        //play shakers

            if (shakers_p[i] > 0 )
            {
                
                // increasing of energy during pattern
                0.5 + 0.5*i/kick_p.cap() => shakers.energy;
                Math.random2(50,100)=>shakers.objects;
                1=>shakers.noteOn;
                
            }
        
        // envelope to bass filter
        // tnx to William Dilworth for this code
        float timequant;
        50 => int grainNum;
        for( 0 => int j; j < grainNum-1; j++ )
        {
            env_f.last()*3000 + 400 => lpf_b.freq; 
       
            beattime/grainNum => timequant;
            timequant :: second => now;      
        }

// Note Offs

if (i==bass_p.cap()-1)
{
    env_f.keyOff(1);
    guit[0].noteOff(1);
    guit[1].noteOff(1);
    shakers.noteOff(1);
    bells.noteOff(1);
}
else
{
    if (bass_p[i+1]!=-1)
    {
        env_f.keyOff(1);
    }
    if (bells_p[i+1]!=-1)
    {
        bells.noteOff(1);
    }
    
    if (guit_p[i+1]!=-1)
    {
        guit[0].noteOff(1);
        guit[1].noteOff(1);
    }
    
    if (shakers_p[i+1]!=-1)
    {
        shakers.noteOff(1);
    }    
    
}

        //beattime::second => now;
        timequant :: second => now; 
    }
}

// time variables
0.75 => float quart;
quart/2 => float eight;
quart/4*3 => float eight_dot;
quart/4 => float sixth;
quart/8*3 => float sixth_dot;

sixth::second=>echo.delay;

// All patterns

[1,0,1,1,1,0] @=> int kick_n_1[];
[quart,quart,sixth_dot,sixth_dot,sixth,quart] @=> float kick_d_1[];

[1,0,1,1] @=> int kick_n_2[];
[quart,quart*2+sixth_dot,sixth_dot,sixth] @=> float kick_d_2[];

[1,0,1] @=> int kick_n_2v[];
[quart,quart*2+sixth_dot,sixth_dot+sixth] @=> float kick_d_2v[];

[0,1,0,1] @=> int snare_n_1[];
[quart,quart,quart,quart] @=> float snare_d_1[];

[1,1,1,1,1,1,1,1] @=> int hat_n_1[];
[eight,eight,eight,eight,eight,eight,eight,eight] @=> float hat_d_1[];

[0,0,0,0] @=> int slnc_n[];
[quart,quart,quart,quart] @=> float slnc_d[];

[37,37,37,37,49,49,44,45,44,45,38,38] @=> int bass_n_1[];
[sixth_dot,sixth_dot,sixth,sixth_dot,sixth_dot,sixth,sixth_dot,sixth_dot,sixth,sixth_dot,sixth_dot,sixth] @=> float bass_d_1[];

[0,1,1,1,1,1,1] @=> int shake_n[];
[quart+sixth_dot,sixth_dot,sixth,sixth_dot,sixth_dot,sixth,eight,eight] @=> float shake_d[];

[85,92,88] @=> int bells_n[];
[quart*2,quart,quart] @=> float bells_d[];

// Guitar plays only power chords, so only main notes needs to be selected
[37,37,37,37,0,38,38] @=> int guit_n_1[];
[sixth_dot,sixth_dot,sixth,sixth_dot,quart*2,sixth_dot,sixth] @=> float guit_d_1[];

[37,37,37,37,0,38] @=> int guit_n_1v[];
[sixth_dot,sixth_dot,sixth,sixth_dot,quart*2,sixth_dot+sixth] @=> float guit_d_1v[];

[1,0] @=> int drum_n_end[];
[quart,quart] @=> float drum_d_end[];

[37] @=> int bass_n_end[];
[quart*2] @=> float bass_d_end[];

[85] @=> int bells_n_end[];
[quart*2] @=> float bells_d_end[];

// Start
Sequencer(kick_n_1,kick_d_1,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,slnc_n,slnc_d,slnc_n,slnc_d,slnc_n,slnc_d,sixth/2);
Sequencer(kick_n_1,kick_d_1,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,slnc_n,slnc_d,slnc_n,slnc_d,slnc_n,slnc_d,sixth/2);
// + guitar
Sequencer(kick_n_2,kick_d_2,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,slnc_n,slnc_d,guit_n_1,guit_d_1,slnc_n,slnc_d,sixth/2);
Sequencer(kick_n_2v,kick_d_2v,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,slnc_n,slnc_d,guit_n_1v,guit_d_1v,slnc_n,slnc_d,sixth/2);
// + shakers
Sequencer(kick_n_2,kick_d_2,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,slnc_n,slnc_d,guit_n_1,guit_d_1,shake_n,shake_d,sixth/2);
Sequencer(kick_n_2v,kick_d_2v,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,slnc_n,slnc_d,guit_n_1v,guit_d_1v,shake_n,shake_d,sixth/2);
// + bells
Sequencer(kick_n_2,kick_d_2,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,bells_n,bells_d,guit_n_1,guit_d_1,shake_n,shake_d,sixth/2);
Sequencer(kick_n_2v,kick_d_2v,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,bells_n,bells_d,guit_n_1v,guit_d_1v,shake_n,shake_d,sixth/2);
Sequencer(kick_n_2,kick_d_2,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,bells_n,bells_d,guit_n_1,guit_d_1,shake_n,shake_d,sixth/2);
Sequencer(kick_n_2v,kick_d_2v,snare_n_1,snare_d_1,hat_n_1,hat_d_1,bass_n_1,bass_d_1,bells_n,bells_d,guit_n_1v,guit_d_1v,shake_n,shake_d,sixth/2);
// End
Sequencer(drum_n_end,drum_d_end,slnc_n,slnc_d,drum_n_end,drum_d_end,bass_n_end,bass_d_end,bells_n_end,bells_d_end,bass_n_end,bass_d_end,slnc_n,slnc_d,quart);



