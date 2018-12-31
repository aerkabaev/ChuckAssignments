//Assignment_Final_AE
public class Bass_Synth_Module  
{
    BPM tempo;
    
    Gain master => dac;
    // sound chain
    TriOsc vib => SawOsc bazz => LPF lpf_b => ADSR env_g => master;
    vib => SawOsc bazz_oct => lpf_b => env_g => master;
    // filter envelope
    Step s => ADSR env_f => blackhole;
    
    float Env_freq1;
    float Env_freq2;
    
    0.0 => vib.freq; 
    2 => bazz.sync;
    2 => bazz_oct.sync;
    0. => vib.gain;    
    
    //set parameters from outer function
    fun void set(float gain, float mix,float freq1,float freq2, float Q, float v_adsr[], float env_adsr[])
    {
        gain => master.gain;
        
        1-mix => bazz.gain;
        mix => bazz_oct.gain;
        (v_adsr[0]::second,v_adsr[1]::second,v_adsr[2],v_adsr[3]::second) => env_g.set;
        
        1.0 => lpf_b.Q;
        (env_adsr[0]::second,env_adsr[1]::second,env_adsr[2],env_adsr[3]::second) => env_f.set;
        freq1 => Env_freq1;
        freq2 => Env_freq2;
    }
    
    fun void noteOn(int MidiNote)
    {
        Std.mtof(MidiNote-12) => bazz.freq;
        Std.mtof(MidiNote-24) => bazz_oct.freq;
        env_g.keyOn(1);
        env_f.keyOn(1);
        spork ~ filter_env(Env_freq1, Env_freq2);
    }
    
    fun void noteOn(int MidiNote, dur btime)
    {
        Std.mtof(MidiNote-12) => bazz.freq;
        Std.mtof(MidiNote-24) => bazz_oct.freq;
        env_g.keyOn(1);
        env_f.keyOn(1);
        spork ~ filter_env(Env_freq1, Env_freq2);
        
        btime-0.001::second => now;
        env_g.keyOff(1);
        env_f.keyOff(1);
        0.001::second => now;
    }    
        
    fun void noteOn(int MidiNote, dur btime,string key)
    {
        Std.mtof(MidiNote-12) => bazz.freq;
        Std.mtof(MidiNote-24) => bazz_oct.freq;
        env_g.keyOn(1);
        env_f.keyOn(1);
        spork ~ filter_env(Env_freq1, Env_freq2);
        btime/2 => now;
        
        if (key == "v")
        {
            4.0 => vib.freq; 
            //1. => bazz.sync;
            //1. => bazz_oct.sync;
            1. => vib.gain;
        }
                    
        btime/2-0.001::second => now;
        
        env_g.keyOff(1);
        env_f.keyOff(1);
        0.0 => vib.freq; 
        //0. => bazz.sync;
        //0. => bazz_oct.sync;
        0. => vib.gain;
        0.001::second => now;
    }    
    
    fun void noteOn(int MidiNote,int MidiSlideNote, dur btime)
    {
        Std.mtof(MidiNote-12) => bazz.freq;
        Std.mtof(MidiNote-24) => bazz_oct.freq;
        env_g.keyOn(1);
        env_f.keyOn(1);
        spork ~ filter_env(Env_freq1, Env_freq2);
        btime/2 => now;
        
        100 => int grainNum;
        for( 0 => int j; j < grainNum-2; j++ )
        {
            //Std.mtof(MidiNote-12) - ( Std.mtof(MidiNote-12) - Std.mtof(MidiSlideNote-12))*0.01 => bazz.freq();
            Std.mtof(MidiNote-12) -(Std.mtof(MidiNote-12)-Std.mtof(MidiSlideNote-12))*0.01*j => bazz.freq;
            0.5*bazz.freq() => bazz_oct.freq;
            0.01/2*btime => now;     
        }
        env_g.keyOff(1);
        env_f.keyOff(1);
        0.01*btime => now;
        
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
