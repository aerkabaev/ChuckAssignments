
// Sound Chain
Gain master[2];

SndBuf clap => JCRev rev => master[0]=> dac;
SndBuf hat => master[1] => JCRev rev2 => Pan2 sh_pan =>  dac;

sh_pan.pan(-0.5);
rev.mix(0.05);
rev2.mix(0.05);

master[0].gain(0.2);
master[1].gain(0.2);

// me.dirUp 
["kick_01.wav","hihat_02.wav","snare_01.wav","clap_01.wav","cowbell_01.wav","stereo_fx_02.wav"] @=> string Files[];
me.dir(-1) + "/audio/" + Files[1] => hat.read;
me.dir(-1) + "/audio/" + Files[3] => clap.read;

//set all playheads to end
hat.samples() => hat.pos; 
clap.samples() => clap.pos;

0.65=> float quart;
quart/2=> float eight;
eight*3/2=> float eight_dot;
eight/2=> float sixth;
sixth*3/2=> float sixth_dot;

[0,0,1,0,0,1,0,0,0,1,0,1,0,0,1,0] @=> int pattern[];

// loop 
while( true )  
{
    for(0 => int i; i < pattern.cap();i++)
        {
        // drums. 1 means sound, 0 means silence

        if ( pattern[i] == 1 )
        {
            0 => clap.pos;
        }
        
        // play hat on each beat
        0 => hat.pos;
        if (i%2==0)
        {
            hat.gain(1.0);
        }
        else
        {
            hat.gain(0.6);
        }
        
        sixth::second => now;
    }
}


