#SingleInstance Force
#MaxThreadsPerHotkey 1
#NoEnv
#Warn All
SetWorkingDir %A_ScriptDir% 
SetKeyDelay -1,-1,-1
SetBatchLines -1
#Include lib_common.ahk

; WIN+P..riest
#P::
{
	WinGet myPID, PID, A
	
	RunSoloPriest(myPID)
}


	
RunSoloPriest(priestpid)
{
	global ADDR, OFFSET, SIZE, SKID, JT, EFST, II
	exe := MakeMemory(priestpid)
	
	Loop
	{
		SoloPriest_OnLoop(exe)
		Sleep 2000
	}
	
}

SoloPriest_OnLoop(exe)
{
	global CFG, ADDR, OFFSET, SIZE, SKID, JT, EFST, II
	
	exe.RunMedic(90, 30)
	
	partywndOffset := ADDR["g_windowMgr"]+OFFSET["UIWindowMgr"]["m_messengerGroupWnd"]
	partywnd := []
	
	partywnd["ptr"] := exe.read(partywndOffset)
	
	Assert(partywnd["ptr"], "The party window did not read correctly! It must be visible and open!")
	
	partywnd["x"] := exe.read(partywnd["ptr"]+OFFSET["UIWindow"]["m_x"])
	partywnd["y"] := exe.read(partywnd["ptr"]+OFFSET["UIWindow"]["m_y"])
	partywnd["w"] := exe.read(partywnd["ptr"]+OFFSET["UIWindow"]["m_w"])
	partywnd["h"] := exe.read(partywnd["ptr"]+OFFSET["UIWindow"]["m_h"])
	
	startx := partywnd["x"] + 35
	starty := partywnd["y"] + 30
	step := 32
	
	playerP := exe.GetPlayerP()
	my_gid := exe.read(playerP + Offset["CGameActor"]["m_gid"])
	my_assump := (exe.read(playerP + Offset["CGameActor"]["m_bodyLight"]) & 0x8) == 0x8
	pclist := exe.GetAllyList()

	gagelistP := partywnd["ptr"] + OFFSET["UIMessengerGroupWnd"]["m_gageList"]
	friendlistP := exe.read(partywnd["ptr"] + OFFSET["UIMessengerGroupWnd"]["m_itemList"])
	itemlist_count := exe.read(partywnd["ptr"] + OFFSET["UIMessengerGroupWnd"]["m_itemList"]+OFFSET["std::list"]["Size"])
	
	
	detected_spb := false
	
	has_member_online := exe.read(partywnd["ptr"] + OFFSET["UIMessengerGroupWnd"]["m_curRadioBtn"])
	i := 0
	partywnd["member"] := []
	
	; so, the order is not sequential. annoyingly.
	while (i < itemlist_count)
	{
		member := []
		friendlistP := exe.read(friendlistP + OFFSET["std::list::node"]["Next"])
		friendinfoP := friendlistP + OFFSET["std::list::node"]["Value"]
		
		member["aid"] := 0
		member["is_leader"] := false
		member["is_online"] := false
		member["chp"] := 0
		member["mhp"] := 0
		member["name"] := ""
		member["map"] := ""
		member["has_assump"] := false
		member["has_bless"] := false
		member["has_incagi"] := false
		
		member["aid"] := exe.read(friendinfoP+OFFSET["FRIEND_INFO"]["AID"])
		member["is_leader"] := (exe.read(friendinfoP+OFFSET["FRIEND_INFO"]["role"]) != 1)
		member["is_online"] := (exe.read(friendinfoP+OFFSET["FRIEND_INFO"]["state"]) != 1)
		
		nameP := friendinfoP+OFFSET["FRIEND_INFO"]["characterName"]
		nameLen := exe.read(nameP + OFFSET["std::string"]["len"])
		member["name"] := (nameLen < 15) ? exe.readString(nameP) : exe.readString(exe.read(nameP))

		nameP := friendinfoP+OFFSET["FRIEND_INFO"]["mapName"]
		nameLen := exe.read(nameP + OFFSET["std::string"]["len"])
		member["map"] := (nameLen < 15) ? exe.readString(nameP) : exe.readString(exe.read(nameP))
			
			
		; makes an assert easier to handle
		if (!detected_spb)
			detected_spb := InStr(member["name"], "[") && InStr(member["name"], "]")

		if (member["aid"] = my_gid)
			member["has_assump"] := my_assump
		else
		{
			; this sucks to have to do but oh well
			for idx, pc in pclist
			{
				if (pc["gid"] != member["aid"])
					continue
				member["has_assump"] := (pc["bodylight"]&0x8 == 0x8)
			}
		}
		
		xpos := startx 
		ypos := starty + i * step
		exe.ClickScreen(xpos, ypos)
		Sleep 1000
		; now if the player is actually on screen, we can buff/heal/res them! yay!
		gageP := exe.read(gagelistP+i*4)
		if (member["is_online"] && has_member_online && exe.read(gageP+OFFSET["UIWindow"]["m_x"]) != -100)
		{
			if (detected_spb)
			{
				member["has_bless"] := SubStr(member["name"], 2, 1) = "B"
				member["has_incagi"] := SubStr(member["name"], 3, 1) = "A"
			}
			
			
			member["chp"] := exe.read(gageP+OFFSET["UIPcGage"]["m_hpAmount"])
			member["mhp"] := exe.read(gageP+OFFSET["UIPcGage"]["m_hpTotalAmount"])
			
			if (member["chp"] <= 1)
				exe.UseSkill(SKID["ALL_RESURRECTION"], xpos, ypos)
			if (member["chp"] < member["mhp"]) 
				exe.UseSkill(SKID["AL_HEAL"], xpos, ypos)
			if (!member["has_bless"])
				exe.UseSkill(SKID["AL_BLESSING"], xpos, ypos)
			if (!member["has_incagi"])
				exe.UseSkill(SKID["AL_INCAGI"], xpos, ypos)
			if (!member["has_assump"])
				exe.UseSkill(SKID["HP_ASSUMPTIO"], xpos, ypos)
		}

		++i
	}
	
	
	Assert(detected_spb, "@SPB must be working! the party may need fixed if this happens") 	
}
