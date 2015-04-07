#include <amxmodx>
#include <fakemeta>
#include <sockets>

#include <PugConst>
#include <PugForwards>
#include <PugStocks>

new bool:g_bRecording;

new g_pHost;
new g_pPort;
new g_pPass;

new g_pNetAddress;
new g_pSvProxies;
new g_pAllowHLTV;

new g_iSocket;
new g_iForward;

enum RconDataArray
{
	Host[32],
	Port,
	Password[32],
	Command[128]
};

stock RconData[RconDataArray];

public plugin_init()
{
	register_plugin("Pug MOD (HLTV System)",PUG_MOD_VERSION,PUG_MOD_AUTHOR);
	
	g_pHost = create_cvar("pug_hltv_host","192.168.1.2");
	g_pPort = create_cvar("pug_hltv_port","27020");
	g_pPass = create_cvar("pug_hltv_pass","mypassword");
	
	g_pNetAddress = get_cvar_pointer("net_address");
	g_pSvProxies = get_cvar_pointer("sv_proxies");
	g_pAllowHLTV = get_cvar_pointer("pug_allow_hltv");
}

public plugin_end()
{
	if(g_bRecording)
	{
		PugEventEnd();
	}
}

public PugEventFirstHalf()
{
	if(get_pcvar_num(g_pAllowHLTV))
	{
		g_bRecording = true;

		if(!get_pcvar_num(g_pSvProxies))
		{
			set_pcvar_num(g_pSvProxies,1);
		}
		
		new sAddress[32];
		get_pcvar_string(g_pNetAddress,sAddress,charsmax(sAddress));
		
		new sCommand[64];
		format(sCommand,charsmax(sCommand),"connect %s;record HLTV_DEMOS/pug;autoretry 1",sAddress);
		
		new sHost[32],sPass[32];
		get_pcvar_string(g_pHost,sHost,charsmax(sHost));
		get_pcvar_string(g_pPass,sPass,charsmax(sPass));
		
		Rcon_Command(sHost,get_pcvar_num(g_pPort),sPass,sCommand);
	}
}

public PugEventEnd()
{
	g_bRecording = false;

	new sHost[32],sPass[32];
	get_pcvar_string(g_pHost,sHost,charsmax(sHost));
	get_pcvar_string(g_pPass,sPass,charsmax(sPass));
		
	Rcon_Command(sHost,get_pcvar_num(g_pPort),sPass,"stop;disconnect;autoretry 0");
}

Rcon_Command(const sHost[],const iPort,const sPassword[],const sCommand[])
{
	new iError;
	g_iSocket = socket_open(sHost,iPort,SOCKET_UDP,iError);
	
	if(iError > 0)
	{
		socket_close(g_iSocket);
		server_print("* Error #%i on open the socket.",iError);
	}
	else
	{
		new sSend[256];
		
		formatex(sSend,sizeof(sSend),"%c%c%c%cchallenge rcon",0xFF,0xFF,0xFF,0xFF);
		socket_send2(g_iSocket,sSend,charsmax(sSend));
		
		copy(RconData[Host],charsmax(RconData[Host]),sHost);
		
		RconData[Port] = iPort;
	
		copy(RconData[Password],charsmax(RconData[Password]),sPassword);
		copy(RconData[Command],charsmax(RconData[Command]),sCommand);
		
		g_iForward = register_forward(FM_StartFrame,"RconStartFrame",true);
	}
}  

public RconStartFrame()
{
	if(socket_change(g_iSocket))
	{
		new sCmd[256],sRcon[32],sNone[64];
	
		socket_recv(g_iSocket,sCmd,charsmax(sCmd));
		parse(sCmd,sNone,charsmax(sNone),sNone,charsmax(sNone),sRcon,charsmax(sRcon));
		
		formatex(sCmd,sizeof(sCmd),"%c%c%c%crcon %s ^"%s^" %s",0xFF,0xFF,0xFF,0xFF,sRcon,RconData[Password],RconData[Command]);
		socket_send2(g_iSocket,sCmd,charsmax(sCmd));
		
		if(socket_change(g_iSocket))
		{
			new sBuffer[1024];
			socket_recv(g_iSocket,sBuffer,charsmax(sBuffer));
			
			server_print(sBuffer);
		}
		
		socket_close(g_iSocket);
		
		unregister_forward(FM_StartFrame,g_iForward,true);
	}
}