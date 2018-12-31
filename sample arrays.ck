//16-Nov-2013
<<< "Assignment_4_CAT_FunExperiment" >>>;

//--------------------------------------------------------------------
//Global Variables

Gain gain => dac;
//Creates the drum machine sounds
//One for HiHat with panning control
SndBuf hiHat => Pan2 ph => gain;
//Another one for kick drum
SndBuf kick => gain;
//Another one for snare drum with panning control
SndBuf snare => Pan2 ps => gain;

//Another one for fx sounds
SndBuf2 fx => gain;

//Setup the bass melodic sound
SinOsc bass => Pan2 pb => gain;

//Eb Mixolydian Mode
[51,53,55,56,58,60,61,63] @=> int dorian[];

//--------------------------------------------------------------------
//This function fills the sample array with the audio files references
fun string[] fillSamples(int n,string type){
    string samples[n];
    for(1 => int i;i <= samples.cap();i++){
        me.dir()+"/audio/"+type+"_0"+i+".wav" => samples[i-1];
    }
    return samples;
}

//--------------------------------------------------------------------
//This function plays the sample with some randomness
fun void playBeat(int beat[],string samples[],SndBuf buf,int m,float rateMin,float rateMax,float gainMin,float gainMax){
    if(beat[m-1]==1){
        Math.random2(0,samples.cap()-1) => int which;
        samples[which] => buf.read;
        0 => buf.pos;
        Math.random2f(rateMin,rateMax) => buf.rate;
        Math.random2f(gainMin,gainMax) => buf.gain;
    }
}

//--------------------------------------------------------------------
//This function setup some global variables
fun void setup(){
    //Setup the panning controls
    //To the left for hiHat
    -.5 => ph.pan;
    //To the right for snare
    .3 => ps.pan;
    
    //Start it in silence
    0 => bass.gain;
}

//--------------------------------------------------------------------
//The big loop controles the melody introduction and the end of the song
fun void mainLoop(){
    //setup the samples for hiHat
    fillSamples(4,"hihat") @=> string hiHatSamples[];
    
    //setup the samples for snare
    fillSamples(3,"snare") @=> string snareSamples[];
    
    //setup the samples for snare
    fillSamples(5,"kick") @=> string kickSamples[];
    
    //setup the samples for fx
    fillSamples(5,"stereo_fx") @=> string fxSamples[];
    
    //Setup the hiHat rhythm string
    [1,1,1,1,1,1,1,1] @=> int hiHatBeat[];

    //Setup the kick rhythm string
    [1,0,0,1,0,1,0,1] @=> int kickBeat[];

    //Setup the snare rhythm string
    [0,0,1,0,0,0,1,0] @=> int snareBeat[];

    //play, controles the big loop
    1 => int play;
    //times, controles the instruments introduction
    1 => int times;
    //variable to control the fx duration;
    now => time fxDur;

    //The complete unity of music (measure) has 2.5 seconds
    2.5::second => dur measure;
    //Each measure for drums has 8 beats
    measure/8 => dur beat;

    //Start, captures the initial time to setup the end over 30 seconds
    now => time start;

    //Control for panning the melody
    .1 => float pControl;
    0 => float pan;

    //variable for fadeOut
    1 => float g;
    g => gain.gain;

    while(play==1){
        //Over 9 measure the melody goes on
        if(times == 5){
            .2 => bass.gain;
        }
        //Over 13 measure the melody goes off
        if(times == 13){
            0 => bass.gain;
        }

        //In each measure subdivide in to 8 beats
        for(1 => int m;m <= 8;m++){

            //Set the panning for the melody
            pan+pControl => pan;
            //Change the direction for the panning
            if(pan < -1.0){
                -1 => pan;
                .1 => pControl;
            }
            if(pan > 1){
                1 => pan;
                -.1 => pControl;
            }
            pan => pb.pan;
            
            //Change is a random variable to jump the melody
            0 => int change;
            
            //Try to modify the melody with more weight over odd beats
            if((m-1)%2==0){
                //Try to modify the tone on the even beats with 50% probability
                if(Math.random2(0,100)>50)
                    1 => change;
            }else{
                //Try to modify the tone on the odd beats with 80% probability
                if(Math.random2(0,100)>20)
                    1 => change;
            }
            //if the randomly choose the modification way
            if(change){
                //change the tone over Dorian randomly
                //It can be one octave high
                0 => int octave;
                //Try to up the octave with 90% probability
                if(Math.random2(0,100)>10)
                    12=>octave;
                //Generates the sound with the dorian and octave
                Std.mtof(dorian[Math.random2(0,7)]+octave) => bass.freq;
            }

            //This section reads the string and play the beat
            //The hiHat has not sound on the first 4 measures
            if(times>2)
                playBeat(hiHatBeat,hiHatSamples,hiHat,m,.7,1.3,.05,.15);
            playBeat(kickBeat,kickSamples,kick,m,.8,1.2,.4,.6);
            playBeat(snareBeat,snareSamples,snare,m,1.0,1.2,.4,.6);

            //Validates the last fx has finished
            if(now>fxDur){
                Math.random2(0,fxSamples.cap()-1) => int which;
                fxSamples[which] => fx.read;
                Math.random2f(.3,.5) => fx.gain;
                //Try to put fx reverse with 50% probability
                if(Math.random2(0,100)>50){
                    Math.random2f(-4.0,-2.0) => fx.rate;
                }else{
                    Math.random2f(2.0,4.0) => fx.rate;
                }
                if(fx.rate()>0)
                    0 => fx.pos;
                else
                    fx.samples() => fx.pos;
                //calculate the fx time
                fx.length()/fx.rate() => dur aux;
                if(aux<0::ms)
                    aux*-1 => aux;
                now + aux => fxDur;
            }
            
            //Wait the time for each drum instrument
            beat => now;
            
            //validates when the music has more of 25 seconds to fadeOut
            if(now>(start+25::second)){
                g - 1.0/17 => g;
                g => gain.gain;
            }
            
            //Validates when the music has more of 30 seconds to stop it
            if(now>(start+30::second)){
                //Setting play to '0', the big loop is breaked out
                0=>play;
                break;
            }
        }
        
        //Increments the number of measures played
        times++;
    }
}

//MAIN FUNCTION
//Setup the components
setup();
//Main loop
mainLoop();
//Finish
<<< "finish the experiment!" >>>;