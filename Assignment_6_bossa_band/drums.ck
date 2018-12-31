//Assignment_6_AE_bossa_nova

// Sound Chain
Gain master[4];

SndBuf kick  =>  LPF lpf_k => master[0] => dac;
SndBuf snare => JCRev rev => master[1]=> dac;
SndBuf clap => rev => master[3]=> dac;
SndBuf hat => master[2] => JCRev rev2 => Pan2 sh_pan =>  dac;

sh_pan.pan(-0.5);
rev.mix(0.05);
rev2.mix(0.05);

master[0].gain(0.3);
master[1].gain(0.2);
master[2].gain(0.2);
master[3].gain(0.2);

3000 => lpf_k.freq;
3 => lpf_k.Q;

// me.dirUp 
["kick_01.wav","hihat_02.wav","snare_01.wav","clap_01.wav","cowbell_01.wav","stereo_fx_02.wav"] @=> string Files[];
me.dir(-1) + "/audio/" + Files[0] => kick.read;
me.dir(-1) + "/audio/" + Files[1] => hat.read;
me.dir(-1) + "/audio/" + Files[2] => snare.read;
me.dir(-1) + "/audio/" + Files[3] => clap.read;

//set all playheads to end
kick.samples() => kick.pos; 
hat.samples() => hat.pos; 
snare.samples() => snare.pos; 
clap.samples() => clap.pos;

0.65=> float quart;
quart/2=> float eight;
eight*3/2=> float eight_dot;
eight/2=> float sixth;
sixth*3/2=> float sixth_dot;

[[1,0,0,1,1,0,0,1,0,0,0,0,0,1,0,1],
 [0,0,1,0,0,1,0,0,0,1,0,1,0,0,1,0]] @=> int pattern[][];

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
        
        sixth::second => now;
    }
}


