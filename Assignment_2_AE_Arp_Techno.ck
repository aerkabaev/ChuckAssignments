// sequencer// sound chain 
Gain master [3];
master[0] => dac.left;
master[1] => dac; 
master[2] => dac.right;


// hook sndbufs to pan positions and dac
SndBuf kick => master[1]; 
SndBuf hihat => master[0];
SndBuf snare => master[2];
SndBuf clap => master[0]; 
SinOsc bass =>  dac;


.6 => bass.gain; 




// load soundfiles int o sndbuf
me.dir() + "/audio/kick_05.wav" => kick.read;
me.dir() + "/audio/hihat_02.wav" => hihat.read;
me.dir() + "/audio/snare_01.wav" => snare.read;
me.dir() + "/audio/clap_01.wav" => clap.read;


//set all playheads to end so no sound is made
kick.samples() => kick.pos; 
hihat.samples() => hihat.pos; 
snare.samples() => snare.pos; 
clap.samples() => clap.pos; 


// seting scale and duration of bass
[52,53,57,62,60,50,55,59] @=> int melodies2[]; 
[0.5,0.5,0.25,0.25,0.25,0.25,1.0] @=> float durs2[];
0 => int index2;
durs2[index2] => float time2; 


//initialize counter variable 
0 => int counter; 




30::second + now => time later; 


// drums, infinite loop 
while ( now < later )
{
        Std.mtof(melodies2[index2]) => bass.freq; 
        
    
    // beat goes from 0 to 7 ,8 positions 
    counter % 8 => int beat; 
    
    // bass drum on 0 and 4
    if ((beat == 0 ) || (beat == 4))
    {
        0 => kick.pos;
     
    }
    
    // snare drum on 1 and 7
    if ((beat == 1 ) || (beat == 7))
    {
        0 => snare.pos;
        Math.random2f(.2,1.8) => snare.rate;
        
    }
    
    // snare drum on 3 and 6 and 2 
    if ((beat == 3 ) || (beat == 6))  
    {
        0 => clap.pos;
        .5 => clap.rate; 
      .6 => clap.gain; 
        
    }
    
    
   //hihat
    0 => hihat.pos; 
    .2 => hihat.gain; 
    Math.random2f(.2,1.8) => hihat.rate;
    
    <<< "counter:" , counter, "Beat: ", beat >>>;
    counter++; // counter + 1 => counter 
 
    .25::second => now; // tempo of tune 
    
    
}