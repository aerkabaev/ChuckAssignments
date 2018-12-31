//Assignment_2_AE_Arp_Melody
//In this example I set the chord sequence, the arpegio type and the bass sequence.
// Arpegiated chords randomly jumps in panorama, while the bass is in the center

<<< "Assignment_2_AE_Arp_Melody" >>>;

//our sound generators
TriOsc chord => Pan2 p => dac;
SawOsc bass => dac;

// used notes, 3 octaves is enough
[ 50, 52, 53, 55, 57, 59, 60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83, 84, 86] @=> int Notes[];
// its names (not names of chords!)
["D","E","F","G","A","B","C","D","E","F","G","A","B","C","D","E","F","G","A","B","C","D"] @=> string Note_Names[];

// Set sequence of chord notes
[1,3,5,1,3,5,7,9] @=> int Arpegio[];
// Set sequence of chords. it can be chosen randomly in code
[8,7,5,2,8,7,2,5] @=> int Melody[];
// Set bass sequence, it's gain, bass playes only root note
[1,1,0,0,0,1,0,0] @=> int Bass[];

// 
int note_to_play;
int lead_note_to_play;
int chord_note;

// for loops
0 => int i;
0 => int j;
0 => int k;

.0 => p.pan;

// Outer loop is only to repeat the composition twice
for(0=>k;k<2;k++)
{
// This loop is to chords
for(0=>i;i<8;i++)
{
    // choose chord
    Melody[i] - 1 => chord_note;
    
    // to randomize the chords, just uncomment this string:
    //Math.random2(1,6) => chord_note;
    
    // print chord to console
    <<< "Chord - ", Note_Names[chord_note] >>>;
    
    // loop to notes from chord
    for(0=>j;j<8;j++)
    {
        // choose note
        Notes[chord_note + Arpegio[j]-1] => note_to_play;
        
        // i wanted to print note to console, but it doesn't work((
        //<<< "Note - ",  Note_Names[note_to_play]  >>>;
        
        0.4 => chord.gain;
        
        // accent on the root note
        if (Arpegio[j] == 1)
        {
            0.8 => chord.gain;
        }
        
        // and accent on the 7th note
        if ( Arpegio[j] == 7)
        {
            0.6 => chord.gain;
        }
        
        // random pan to chords
        // How to remove this fckn clicks from sound?
        Math.random2f(-1.,1.) => p.pan;
        Std.mtof(note_to_play) => chord.freq;
        
        // bass is 2 octaves lower the melody
        Std.mtof(Notes[chord_note]-24) => bass.freq;
        0.13 * Bass[j] => bass.gain;
        
        .25::second => now;
    }    
   
}
}    