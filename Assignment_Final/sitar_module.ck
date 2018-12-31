//Assignment_7_AE
public class Sitar_Module  
{
    BPM tempo;
    
    Gain master => dac;
    // sound chain
    StifKarp sit => LPF lpf_b => ADSR env_g => Gain dd=> master;
    dd => Delay d => d => dd;
    // filter envelope
    Step s => ADSR env_f => blackhole;
    
    float Env_freq1;
    float Env_freq2;
    
    //set parameters from outer function
    fun void set(float gain, dur delay_time,float delay_feedback, float freq1,float freq2, float Q, float v_adsr[], float env_adsr[])
    {
        gain => master.gain;
        
        delay_time => d.max => d.delay;
        delay_feedback => d.gain;
        
        (v_adsr[0]::second,v_adsr[1]::second,v_adsr[2],v_adsr[3]::second) => env_g.set;
        
        1.0 => lpf_b.Q;
        (env_adsr[0]::second,env_adsr[1]::second,env_adsr[2],env_adsr[3]::second) => env_f.set;
        freq1 => Env_freq1;
        freq2 => Env_freq2;
    }

    fun void noteOn(int MidiNote, dur btime)
    {
        Std.mtof(MidiNote+12) => sit.freq;
        env_g.keyOn(1);
        env_f.keyOn(1);
        Math.random2f(0.5,0.8) => sit.pickupPosition;
        Math.random2f(0.5,0.8) => sit.pluck;
        sit.noteOn(1.0);
        
        spork ~ filter_env(Env_freq1, Env_freq2);
        
        btime-0.001::second => now;
        env_g.keyOff(1);
        env_f.keyOff(1);
        sit.noteOff(1.0);
        0.001::second => now;
    }    
        
    fun void noteOn(int MidiNote, dur btime,string key)
    {
        Std.mtof(MidiNote+12) => sit.freq;
        env_g.keyOn(1);
        env_f.keyOn(1);
        spork ~ filter_env(Env_freq1, Env_freq2);
        Math.random2f(0.5,0.8) => sit.pickupPosition;
        Math.random2f(0.5,0.8) => sit.pluck;
        sit.noteOn(1.0);
        
        btime/2 => now;
        
        if (key == "v")
        {
            //6.0 => vib.freq; 
            //1. => bazz.sync;
            //1. => bazz_oct.sync;
            //1. => vib.gain;
        }
        
        btime/2-0.001::second => now;
        
        env_g.keyOff(1);
        env_f.keyOff(1);
        sit.noteOff(1.0);
        //0.0 => vib.freq; 
        //0. => bazz.sync;
        //0. => bazz_oct.sync;
        //0. => vib.gain;
        0.001::second => now;
    }    
    
    fun void noteOn(int MidiNote,int MidiSlideNote, dur btime)
    {
        Std.mtof(MidiNote+12) => sit.freq;
        env_g.keyOn(1);
        env_f.keyOn(1);        
        spork ~ filter_env(Env_freq1, Env_freq2);
        Math.random2f(0.5,0.8) => sit.pickupPosition;
        Math.random2f(0.5,0.8) => sit.pluck;
        sit.noteOn(1.0);
        btime/2 - 0.001::second => now;
        
        
        100 => int grainNum;
        for( 0 => int j; j < grainNum-1; j++ )
        {
            //Std.mtof(MidiNote-12) - ( Std.mtof(MidiNote-12) - Std.mtof(MidiSlideNote-12))*0.01 => bazz.freq();
            Std.mtof(MidiNote+12) -(Std.mtof(MidiNote+12)-Std.mtof(MidiSlideNote+12))*0.01*j => sit.freq;
            0.01/2*btime => now;     
        }
        env_g.keyOff(1);
        env_f.keyOff(1);
        sit.noteOff(1.0);
        0.001::second => now;
        
    }        
    
    fun void noteOff()
    {
        env_g.keyOff(1);
        env_f.keyOff(1);
    }    

// bass envelope function 
    fun void filter_env(float Env_freq1,float Env_freq2)
    {
        1000 => int grainNum;
        for( 0 => int j; j < grainNum-1; j++ )
        {
            env_f.last()*Env_freq2 + Env_freq1 => lpf_b.freq; 
            0.001 => float timequant;
            timequant :: second => now;
        }
    }
    
    
}
