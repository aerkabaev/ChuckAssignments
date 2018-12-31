//Assignment_Final_AE

MIXER mix;

// paths to files
me.dir() + "/piano.ck" => string pianoPath;
me.dir() + "/bass.ck" => string bassPath;
me.dir() + "/bass_end.ck" => string bass2Path;
me.dir() + "/drums.ck" => string drumsPath;
me.dir() + "/drums2.ck" => string drums2Path;
me.dir() + "/sit.ck" => string leadPath;

Machine.add(pianoPath) => int pianoID;
Machine.add(drumsPath) => int drumsID;
Machine.add(bassPath) => int bassID;
24::second => now;
Machine.add(leadPath) => int leadID;
24::second => now;

// uncomment this to hear more lead melody
24::second => now;

Machine.remove(leadID);
Machine.remove(bassID);
Machine.add(bass2Path) => int bass2ID;
mix.set(0);
6::second => now;
Machine.remove(drumsID);
4.125::second => now;
Machine.remove(pianoID);
1.875::second => now;
Machine.remove(bass2ID);
