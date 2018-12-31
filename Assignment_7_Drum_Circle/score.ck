//Assignment_7_AE

// paths to files
me.dir() + "/piano.ck" => string pianoPath;
me.dir() + "/bass.ck" => string bassPath;
me.dir() + "/drums.ck" => string drumsPath;
me.dir() + "/drums2.ck" => string drums2Path;
me.dir() + "/lead.ck" => string leadPath;

// start bass
Machine.add(bassPath) => int bassID;
5.2::second => now;
// add all
Machine.add(drumsPath) => int drumsID;
Machine.add(pianoPath) => int pianoID;
10.4::second => now;
Machine.add(leadPath) => int leadID;
5.2::second => now;
// remove drums and bass
Machine.remove(drumsID);
Machine.remove(bassID);
5.2::second => now;
//add lead
Machine.add(leadPath) => int lead2ID;
5.2::second => now;
// remove piano
Machine.remove(pianoID);
