# Overview
This is a mod for [Himeko Sutori](https://himekosutori.com/) that lets you do searches in the lance management screen (ie. the squad menu) via the command line. Characters that don't match your search are filtered and greyed out.

More Classes Mod depends on another Himeko Sutori mod, [Events Mod](https://github.com/solimodsthings/EventsMod).

# Usage
While in the lance management screen press ```F1``` or ``` ` ``` to open up the game console. Send commands to the this mod with the following command syntax: ``` TellMod Find <Keyword> ```. You can shorten ``` TellMod ``` to ``` Mod ``` and you also don't need to worry about case sensitivity. 

Examples below:

| Example | Description |
|:--|:--|
|``` mod find Aya ``` | Highlights all characters named 'Aya' |
|``` mod find Knight ``` | Highlights all characters whose current class is Knight |
|``` mod find "Healing Burst" ``` | Highlights all characters that have learned the reaction Healing Burst |
|``` mod find clear ``` | Clears and resets searches. Alternatively you can also do ``` mod find reset ``` |

# How do I install this mod?
1.  [Download the mod files from the releases page](https://github.com/solimodsthings/FindMod/releases) to your PC
2.	Open your Himeko Sutori steam folder by right-clicking on the game in Steam and choosing Manage > Browser Local Files.
3.	Place files <i>EventsMod.u</i> and <i>FindMod.u</i> in folder <b>…/Himeko Sutori/RPGTacGame/Script/</b>
4.	Open file <b>…/Himeko Sutori/RPGTacGame/Config/RPGTacMods.ini</b> and so the mod is loaded whenever you start the game – the file should look like this:

```
[rpgtacgame.RPGTacMutatorLoader]
MutatorsLoaded=EventsMod.EventsModStart,FindMod.FindModStart
```

(Note: Make sure there are no spaces in the mod list as whitespaces don’t get trimmed!)
