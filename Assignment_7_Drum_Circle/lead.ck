//Assignment_7_AE

// used classes
MIXER mix;
BPM tempo;

// set volume from mixer
//mix.lead => solo.gain;

//set tempo
mix.bpm => tempo.tempo;
tempo.quart => dur quart;
tempo.eight => dur eight;
tempo.eight_dot => dur eight_dot;
tempo.sixth => dur sixth;
tempo.sixth_dot => dur sixth_dot;

Lead_Module solo;

solo.set(mix.lead,0.05,eight,0.2, 6, 0.2, 0.3);

solo.noteOn(84);
sixth => now;
solo.noteOff();
eight => now;

solo.noteOn(83);
sixth => now;
solo.noteOff();
eight => now;

solo.noteOn(77);
sixth => now;
solo.noteOff();
eight => now;

solo.noteOn(76);
sixth => now;
solo.noteOff();
eight => now;

solo.noteOn(76);
sixth => now;
solo.noteOff();
sixth => now;

solo.noteOn(77);
sixth => now;
solo.noteOff();
sixth => now;

solo.noteOn(83);
sixth => now;
solo.noteOff();
eight => now;

solo.noteOn(81);
sixth => now;
solo.noteOff();
eight => now;

solo.noteOn(76);
sixth => now;
solo.noteOff();
eight => now;

solo.noteOn(74);
sixth => now;
solo.noteOff();
eight => now;
