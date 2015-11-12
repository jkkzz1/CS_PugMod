#include <amxmodx>
#include <amxmisc>
#include <time>

#include <PugConst>
#include <PugForwards>
#include <PugStocks>
#include <PugNatives>
#include <PugCS>

#pragma semicolon 1

#define PUG_TASK_AUTO 1901

new bool:g_bReadySystem;
new g_bReady[33];

new g_pAutoReadyTime;
new g_pAutoReadyKick;
new g_pAutoStartHalf;

new g_pPlayersMin;
new g_pRoundsMax;
new g_pHandleTime;

public plugin_init()
{
	register_plugin("Pug MOD (Ready System)",PUG_MOD_VERSION,PUG_MOD_AUTHOR);

	register_dictionary("PugCore.txt");
	register_dictionary("PugReady.txt");
	register_dictionary("time.txt");
	
	g_pAutoReadyTime = create_cvar("pug_force_ready_time","0.0",FCVAR_NONE,"Force a player to be ready in that time (If zero, this function will be inactive)");
	g_pAutoReadyKick = create_cvar("pug_force_ready_kick","0",FCVAR_NONE,"Kick Un-Ready players (If zero, the players will be put as ready automatically");
	g_pAutoStartHalf = create_cvar("pug_force_auto_swap","1",FCVAR_NONE,"Auto Swap teams without Ready-System if the teams are complete");
	
	g_pPlayersMin = get_cvar_pointer("pug_players_min");
	g_pRoundsMax = get_cvar_pointer("pug_rounds_max");
	g_pHandleTime = get_cvar_pointer("pug_intermission_time");
	
	PugRegisterCommand("ready","PugReadyUp",ADMIN_ALL,"PUG_DESC_READY");
	PugRegisterCommand("notready","PugReadyDown",ADMIN_ALL,"PUG_DESC_NOTREADY");
	
	PugRegisterAdminCommand("forceready","PugForceReady",PUG_CMD_LVL,"PUG_DESC_FORCEREADY");
	
	register_event("ResetHUD","PugKeepMenu","b");
	
	hook_cvar_change(g_pPlayersMin,"PugConvarChange");
}

public client_putinserver(id)
{
	g_bReady[id] = false;
	PugKeepMenu();
}

public client_disconnect(id)
{
	set_task(0.1,"PugKeepMenu");
	
	if(task_exists(id + PUG_TASK_AUTO))
	{
		remove_task(id + PUG_TASK_AUTO);
	}
}

public client_infochanged(id)
{
	set_task(0.1,"PugKeepMenu");
}

public PugPlayerJoined(id,iTeam)
{
	if(g_bReadySystem)
	{
		new Float:fReadyTime = get_pcvar_float(g_pAutoReadyTime);
	
		if(fReadyTime && !is_user_bot(id))
		{
			set_task(fReadyTime,"PugCheckReadyPlayer",id + PUG_TASK_AUTO); 
			
			new sTime[32];
			get_time_length(id,floatround(fReadyTime),timeunit_seconds,sTime,charsmax(sTime));
	
			client_print_color(id,print_team_red,"%s %L",g_sHead,LANG_SERVER,get_pcvar_num(g_pAutoReadyKick) ? "PUG_SAY_READY_KICK" : "PUG_SAY_READY_AUTO",sTime);
		}
	}
}

public PugEventWarmup()
{
	PugReadySystem(true);
}

public PugEventStart()
{
	if(g_bReadySystem)
	{
		PugReadySystem(false);
	}
}

public PugEventHalfTime()
{
	if(get_pcvar_num(g_pAutoStartHalf) && (PugGetPlayers() >= get_pcvar_num(g_pPlayersMin)))
	{
		arrayset(g_bReady,true,sizeof(g_bReady));
		set_task(get_pcvar_float(g_pHandleTime),"PugCheckReady",PUG_TASK_AUTO);
	}
	else
	{
		PugReadySystem(true);
	}
}

public PugEventSecondHalf()
{
	if(g_bReadySystem)
	{
		PugReadySystem(false);
	}
}

public PugEventOvertime()
{
	if(g_bReadySystem)
	{
		PugReadySystem(false);
	}
}

PugReadySystem(bool:bActive)
{
	switch(g_bReadySystem = bActive)
	{
		case true:
		{
			arrayset(g_bReady,0,sizeof(g_bReady));
			PugKeepMenu();
	
			client_print_color(0,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_SAY_READY");
		}
		case false:
		{
			PugReadyDisPlay(0.0);
			arrayset(g_bReady,0,sizeof(g_bReady));
			
			client_print_color(0,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_ALL_READY");
		}
	}
}

public PugConvarChange()
{
	PugKeepMenu();
}

public PugKeepMenu()
{
	if(g_bReadySystem)
	{
		PugReadyDisPlay(9999.0);
	}
}

PugReadyDisPlay(Float:fHoldTime)
{
	new iPlayers[32],iNum,iPlayer;
	get_players(iPlayers,iNum,"ch");
	
	new sReady[256],sNotReady[256],sName[MAX_NAME_LENGTH];
	
	new iPlayersNum,iReadys;
	
	for(new i;i < iNum;i++)
	{
		iPlayer = iPlayers[i];
		
		if(!PugIsTeam(iPlayer))
		{
			continue;
		}
		
		iPlayersNum++;
		get_user_name(iPlayer,sName,charsmax(sName));

		if(g_bReady[iPlayer])
		{
			iReadys++;
			format(sReady,charsmax(sReady),"%s%s^n",sReady,sName);
		}
		else
		{
			format(sNotReady,charsmax(sNotReady),"%s%s^n",sNotReady,sName);
		}
	}
	
	new iMinPlayers = get_pcvar_num(g_pPlayersMin);

	set_hudmessage(0,255,0,0.23,0.02,0,0.0,fHoldTime,0.0,0.0,3);
	show_hudmessage(0,"%L",LANG_SERVER,"PUG_HUD_UNREADY",(iPlayersNum - iReadys),iMinPlayers);

	set_hudmessage(0,255,0,0.58,0.02,0,0.0,fHoldTime,0.0,0.0,2);
	show_hudmessage(0,"%L",LANG_SERVER,"PUG_HUD_READY",iReadys,iMinPlayers);

	set_hudmessage(255,255,225,0.58,0.02,0,0.0,fHoldTime,0.0,0.0,1);
	show_hudmessage(0,"^n%s",sReady);

	set_hudmessage(255,255,225,0.23,0.02,0,0.0,fHoldTime,0.0,0.0,4);
	show_hudmessage(0,"^n%s",sNotReady);
}

public PugReadyUp(id)
{
	new iStage = GET_PUG_STAGE();
	
	if((iStage == PUG_STAGE_WARMUP) || (iStage == PUG_STAGE_HALFTIME))
	{
		if(PugIsTeam(id))
		{
			if(!g_bReady[id])
			{
				g_bReady[id] = true;
				
				if(task_exists(id + PUG_TASK_AUTO))
				{
					remove_task(id + PUG_TASK_AUTO);
				}
				
				new sName[MAX_NAME_LENGTH];
				get_user_name(id,sName,charsmax(sName));
				
				client_print_color(0,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_READY",sName);
				
				PugKeepMenu();
				PugCheckReady();
			}
			else
			{
				client_print_color(id,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_READYED");
			}
		}
		else
		{
			client_print_color(id,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_TEAM");
		}
	}
	else
	{
		client_print_color(id,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_NEEDED");
	}
	
	return PLUGIN_HANDLED;
}

public PugReadyDown(id)
{
	new iStage = GET_PUG_STAGE();
	
	if((iStage == PUG_STAGE_WARMUP) || (iStage == PUG_STAGE_HALFTIME))
	{
		if(PugIsTeam(id))
		{
			if(g_bReady[id])
			{
				g_bReady[id] = false;
				
				new Float:fReadyTime = get_pcvar_float(g_pAutoReadyTime);
				
				if(fReadyTime && get_pcvar_num(g_pAutoReadyKick))
				{
					set_task(fReadyTime,"PugCheckReadyPlayer",id + PUG_TASK_AUTO);
				}
				
				new sName[MAX_NAME_LENGTH];
				get_user_name(id,sName,charsmax(sName));
				
				client_print_color(0,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_UNREADY",sName);
				
				PugKeepMenu();
				PugCheckReady();
			}
			else
			{
				client_print_color(id,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_NOTREADY");
			}
		}
		else
		{
			client_print_color(id,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_TEAM");
		}
	}
	else
	{
		client_print_color(id,print_team_red,"%s %L",g_sHead,LANG_SERVER,"PUG_PLAYER_NEEDED");
	}
	
	return PLUGIN_HANDLED;
}

public PugForceReady(id,iLevel)
{
	if(!access(id,PUG_CMD_LVL) && (id != 0))
	{
		PugMessage(id,"PUG_CMD_NOTALLOWED");
	}
	else
	{
		new sArg[32];
		read_argv(1,sArg,charsmax(sArg));
		
		new iPlayer = cmd_target(id,sArg,CMDTARGET_NO_BOTS);
		
		if(!iPlayer)
		{
			return PLUGIN_HANDLED;
		}
		
		PugAdminCommandClient(id,"Force .ready","PUG_FORCE_READY",iPlayer,PugReadyUp(iPlayer));
	}
	
	return PLUGIN_HANDLED;
}

public PugCheckReady()
{
	if(PugGetReadyNum() >= get_pcvar_num(g_pPlayersMin))
	{
		PugReadySystem(false);
		
		switch(GET_PUG_STAGE())
		{
			case PUG_STAGE_WARMUP:
			{
				PugStart();
			}
			case PUG_STAGE_HALFTIME:
			{
				if(GET_PUG_ROUND() <= get_pcvar_num(g_pRoundsMax))
				{
					PugSecondHalf();
				}
				else
				{
					PugOvertime();
				}
			}
		}
	}
}

public PugCheckReadyPlayer(id)
{
	id -= PUG_TASK_AUTO;
	
	if(g_bReadySystem && is_user_connected(id))
	{
		if(PugIsTeam(id))
		{
			switch(get_pcvar_num(g_pAutoReadyKick))
			{
				case 0: PugReadyUp(id);
				case 1:
				{
					new iReadyTime = get_pcvar_num(g_pAutoReadyTime);
					
					new sTime[32];
					get_time_length
					(
						id,
						iReadyTime,
						timeunit_seconds,
						sTime,
						charsmax(sTime)
					);

					PugDisconnect(id,"%L",LANG_SERVER,"PUG_FORCE_READY_KICK",sTime);
				}
			}
		}
	}
}

PugGetReadyNum()
{
	new iReady = 0;
	
	for(new i;i < sizeof(g_bReady);i++)
	{
		if(g_bReady[i])
		{
			iReady++;
		}
	}
	
	return iReady;
}
