﻿CS Pickup Game
==============
CS 1.6 Pickup Game Mod for Amx Mod X

.requeriments
=============
- MetaMod v1.21.1+
- AmxModX 1.8.3-dev-git4671+
- CS Dedicated server build 6153+

.features
=========
- Vote Map<br>
- Team Picker<br>
- Config chooser<br>
- Admin Commands<br>
- Client Commands<br>
- Automatic Overtime<br>
- Round Stats commands<br>
- Ready System<br>
- Auto Swap Teams<br>
- Teams balancer + Spectators management<br>
- AFK Kicker<br>
- Automatic LO3 config<br>
- Automatic Swap teams<br>
- Warmup Rounds<br>
- Weapon restrictions<br>
- Multi language support in execution time<br>
- Overtime chooser<br>
- Auto setup and configuration<br>
- Automatic Help system<br>
- Automatic Stats system with SQL Support<br>
- Easy Anti Cheat support<br>
- Anti-Flood system<br>
- In Game stats commands<br>
- SQL Ban System and register system<br>
- Auto messages in game<br>
- Custom admin system.<br>
- HLTV system<br>
- And more is incoming<br><br>

.installing
===========
- Download Last AMXX dev at amxmodx.org/snapshots.php<br>
- Download AMXX Base + AMXX CSTRIKE addons<br>
- Extract AMXX Base + AMXX CSTRIKE to same folder (Extract base, after cstrike)<br>
- Replace all folders and files<br>
- Now you can compile the Pug Plugins with scriptiong package downloaded from amxmodx<br>
- Install Plugins, configs and translations according addons folder<br>
- Install metamod and amxx in a server<br>
- Just start server (Or configure first)<br>
- (Need to make a video in YouTube :D)<br><br>

.commands (Acessible by console and chat commands)
=========
- User commands<br>
	.status		- Pug Status command<br>
	.score 		- Show the scores<br>
	.round 		- Display the current round<br>
	.ready 		- Player is ready to play<br>
	.notready 	- Player is not ready<br>
	.hp 		- Display the HP of enemy team<br>
	.dmg 		- Display the damage in done in each round<br>
	.rdmg 		- Display the damage recived in each round<br>
	.sum 		- Display the summary of eac round<br>
	.help 		- Pug Mod Help page<br>
	.eac		- Show EAC Shots in game (Need EAC plugin installed)<br>
	.stats 		- Show in game Stats (Need stats installed)<br>
	.rank 		- Show in game top15 (Need stats installed)<br>
	.match 		- Show in game matches played (Need stats installed)<br>
	.setup		- Control the setup menu for start pug<br>
	.start		- Start the pug after configure it.<br>
	.votekick 	- Vote to Kick a selected player<br><br>

- Adminstrator commands<br>
	!pause 					- Pause the Pug<br>
	!unpause 				- Unpause the pug<br>
	!togglepause 				- Pause / Unpause the Pug<br>
	!pugstart 				- Force the PUG to start<br>
	!pugstop 				- Stop the Pug<br>
	!pugreset 				- Reset the pug settings<br>
	!forceready <Player | All> 		- Force the Player to ready state<br>
	!forceunready <Player | All> 		- Force the Player to unready state<br>
	!votemap 				- Start a vote for the next map<br>
	!voteteams 				- Start a vote for team enforcement<br>
	!voteconfig 				- Start a vote for config type<br>
	!kill <Player>				- Kill the selected player<br>
	!map <Map>				- Change the map<br>
	!kick <Player> 				- Kick the given player<br>
	!rcon <Command> 			- Sends a rcon command to server<br>
	!ban <Steam|Player> [Minutes] [Reason] 	- Ban the given player (Need PugDB installed)<br>
	!unban <Steam> 				- Ban the given player (Need PugDB installed)<br>
	!help 					- Pug Mod Help Admin page<br><br>

.convars (Needs to be updated)
======
- CORE Convars<br>
pug_rounds_max 		"30" 	- Maximum of rounds to start Overtime<br>
pug_rounds_ot 		"6" 	- Overtime Rounds<br><br>
pug_allow_overtime 	"1" 	- Allow Overtime (if zero, game can end in a tie)<br>
pug_players_max 	"10" 	- Maximum of players in game<br>
pug_players_min 	"10" 	- Minimum of players in game to start<br>
pug_players_default_max "10" 	- Default Maximum players<br>
pug_players_default_min "10" 	- Default Minimum players<br><br>
pug_allow_spectators 	"1" 	- Allow Spectators in game<br>
pug_allow_hltv 		"1" 	- Alow HLTV proxy in game<br><br>

- CS Specific Convars<br>
pug_force_restart 	"1" 	- Force the game to restart in some stages<br>
pug_switch_delay 	"5.0" 	- Delay to swap teams in Half Time<br>
pug_allow_shield 	"0" 	- Allow ShieldGun into the game<br>
pug_allow_grenades 	"0" 	- Allow Grenades in Warmup period<br>
pug_allow_kill 		"1" 	- Allow Kill command<br><br>

- Menu Convars<br>
pug_vote_delay 		"15.0" 	- Delay Between Pug votes<br>
pug_vote_percent 	"0.7" 	- Minimum percentage to accept the vote results<br>
pug_vote_map 		"1" 	- Enable Vote Map between games<br>
pug_show_scores 	"1" 	- Show Scoreboard on each Pug changelevel<br>
pug_hlds_vote 		"0" 	- Allow HLDS Vote And VoteMap command<br><br>

- EAC Shots Convars<br>
pug_eac_url 		"http://eac.maxigames.com.br/shots/cstrike"<br>
pug_eac_url_format 	"<url>/<server>/<date>/<guid>"<br><br>

// If you not found a convar here, submit a bug :P