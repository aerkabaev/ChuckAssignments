//Assignment_Final_AE

// A little sad melody.
// Go to the score.ck and uncomment one time string to do it more longer and more sad.
// i hope you like it!!!
// And thanks for your attention!!!

// bpm class
me.dir() + "/BPM.ck" => string BPMPath;
Machine.add(BPMPath);

//mixer class
me.dir() + "/mixer.ck" => string mixerPath;
Machine.add(mixerPath);

//bass synth module
me.dir() + "/bass_synth_module.ck" => string bassPath;
Machine.add(bassPath);

//lead module
me.dir() + "/sitar_module.ck" => string leadPath;
Machine.add(leadPath);

// add score.ck
me.dir() + "/score.ck" => string scorePath;
Machine.add(scorePath);


