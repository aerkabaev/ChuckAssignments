//Assignment_7_AE
// volume to all instrumets and samples

public class MIXER
{
    // global variables
    static float kick, snare, clap, hat, bass, piano, lead , master , bpm;
    
    1.0 => master;
    master*0.2=>kick;
    master*0.2=>snare;
    master*0.1=>clap;
    master*0.1=>hat;
    master*0.025=>bass;
    master*0.04=>piano;
    master*0.05=>lead;
    60/.65 => bpm;
}