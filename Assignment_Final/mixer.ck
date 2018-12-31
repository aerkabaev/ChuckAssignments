//Assignment_Final_AE
// volume to all instrumets and samples

public class MIXER
{
    // global variables
    static float kick, snare, clap, hat, bass, piano, sit , master , bpm;
    
    // feel free to change the values
    // to get more comfortable sound
    1.0 => master;
    master*0.3=>kick;
    master*0.2=>snare;
    master*0.15=>clap;
    master*0.1=>hat;
    master*0.03=>bass;
    master*0.05=>piano;
    master*0.4=>sit;
    80 => bpm;
    
    // only to mute kick at the end
    fun void set(float kck)
    {
        kck => kick;
    }
}