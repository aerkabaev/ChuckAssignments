//Assignment_7_AE
public class Lead_Module 
{
    // clarintet sounds like real flute, unlicke Stk Flute
    Clarinet solo => JCRev rev => dac;
    solo => Delay d => d => rev;

    fun void set(float gain, float rev_mix,dur delay_time,float delay_feedback, float vibrato_freq, float vibrato_gain, float solo_rate)
    {
        rev_mix => rev.mix;
        delay_time => d.max => d.delay;
        delay_feedback => d.gain;
        vibrato_freq => solo.vibratoFreq;
        vibrato_gain => solo.vibratoGain;
        solo_rate => solo.rate;
        gain => solo.gain;
    }
    
    fun void noteOn(int MidiNote)
    {
        Std.mtof(MidiNote) => solo.freq;
        solo.noteOn(1);
    }   
    
    fun void noteOff()
    {
        solo.noteOff(1);
    }

}    
