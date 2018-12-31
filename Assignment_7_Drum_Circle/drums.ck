//Assignment_7_AE

// used classes
MIXER mix;
BPM tempo;

//set tempo
mix.bpm => tempo.tempo;
tempo.quart => dur quart;
tempo.eight => dur eight;
tempo.eight_dot => dur eight_dot;
tempo.sixth => dur sixth;
tempo.sixth_dot => dur sixth_dot;

// Sound Chain
Gain master[4];

SndBuf kick  =>  LPF lpf_k => master[0] => dac;
SndBuf snare => JCRev rev => master[1]=> dac;
SndBuf clap => rev => master[3]=> dac;
SndBuf hat => master[2] => JCRev rev2 => Pan2 sh_pan =>  dac;dac;

sh_pan.pan(-0.5);
rev.mix(0.05);
rev2.mix(0.05);


// set volumes from mixer
mix.kick => master[0].gain;
mix.snare => master[1].gain;
mix.clap => master[3].gain;
mix.hat => master[2].gain;

3000 => lpf_k.freq;
3 => lpf_k.Q;

// me.dirUp 
["kick_01.wav","hihat_02.wav","snare_01.wav","clap_01.wav"] @=> string Files[];
me.dir(-1) + "/audio/" + Files[0] => kick.read;
me.dir(-1) + "/audio/" + Files[1] => hat.read;
me.dir(-1) + "/audio/" + Files[2] => snare.read;
me.dir(-1) + "/audio/" + Files[3] => clap.read;

//set all playheads to end
kick.samples() => kick.pos; 
hat.samples() => hat.pos; 
snare.samples() => snare.pos; 
clap.samples() => clap.pos;

[[1,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0],
 [0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0]] @=> int pattern[][];

// loop 
while( true )  
{
    for(0 => int i; i < pattern[1].cap();i++)
        {
        // drums. 1 means sound, 0 means silence

        if ( pattern[0][i] == 1 )
        {
            0 => kick.pos;
        }
            
        if ( pattern[1][i] == 1 )
        {
            0 => snare.pos;
        }

        if ( pattern[1][i] == 1 )
        {
            0 => clap.pos;
        }
        
        // play hat on each beat

        // accents
        if (i%2==0)
        {
            hat.gain(1.0);
        }
        else
        {
            hat.gain(0.6);
        }
        0 => hat.pos;        
        
        sixth => now;
    }
}


