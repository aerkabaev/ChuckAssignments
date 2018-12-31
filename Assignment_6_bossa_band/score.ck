// score.ck

// paths to chuck file
me.dir() + "/piano.ck" => string pianoPath;
me.dir() + "/bass.ck" => string bassPath;
me.dir() + "/drums.ck" => string drumsPath;
me.dir() + "/drums2.ck" => string drums2Path;
me.dir() + "/lead.ck" => string leadPath;

// start piano
Machine.add(drums2Path) => int drumsID;
Machine.add(pianoPath) => int pianoID; 
Machine.add(leadPath) => int leadID;
10.4::second => now;
Machine.remove(drumsID);

// start drums+bass
Machine.add(drumsPath) => int drumsID2;
Machine.add(bassPath) => int bassID;
10.4::second => now;

Machine.remove(pianoID);
Machine.remove(drumsID2);
Machine.add(leadPath) => int leadsID2;
Machine.add(drums2Path) => int drumsID3;
10.4::second => now;

Machine.remove(bassID);
Machine.remove(drumsID3);

