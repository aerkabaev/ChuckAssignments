//Assignment_Final_AE
// names of variables were changed and dot notes were added

public class BPM
{
    // global variables
    dur myDuration[6];
    static dur quart, eight, eight_dot, sixth, sixth_dot, thirtyseconds;
    
    fun void tempo(float beat)  {
        // beat is BPM, example 120 beats per minute
        
        60.0/(beat) => float SPB; // seconds per beat
        SPB :: second => quart;
        quart*0.5 => eight;
        eight*0.5 => sixth;
        sixth*0.5 => thirtyseconds;
        eight*1.5 => eight_dot;
        sixth*1.5 => sixth_dot;
        
        // store data in array
        [quart, eight, eight_dot, sixth, sixth_dot, thirtyseconds] @=> myDuration;
    }
}