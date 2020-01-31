#include classMemory.ahk
class RagMemory extends _ClassMemory
{
	exever := 0
	ADDR := []
	OFFSET := []
	SIZE := []
	
	
	__New(clientver, procid, desiredaccess := "", byref handle := "", windowmatchmode := 3)
	{
		this := base.__New(procid, desiredaccess, handle, windowmatchmode)
		
		this.exever := clientver
		
		this._setupPointers(this.exever)

		return this
	}
	
	; private pls
	_setupPointers(clientversion)
	{
		/*
		if (clientver = 20151104)
		{
			ADDR["g_windowMgr"] :=  0xCA89C8
			ADDR["g_renderer"] :=  0xBE24B0

			ADDR["g_session"] := 0xE47FF0

			OFFSET["CSession"]["m_shortCutList"] :=  0x474 ; ShortCutKey[MAX_SHORTCUTS] 
			OFFSET["CSession"]["m_shortcutText"] :=  0xBFC ; std::vector<std::string> of length 10
			OFFSET["CSession"]["m_curMap"] :=  0x618
			OFFSET["CSession"]["m_healthState"] :=  0xB2C
			OFFSET["CSession"]["m_effectState"] :=  OFFSET["CSession"]["m_healthState"]+0x4
			OFFSET["CSession"]["JobID"] :=  0x1214 ; JOBTYPE
			OFFSET["CSession"]["m_ASPD"] :=  0x1284
			OFFSET["CSession"]["m_itemDefPower"] :=  OFFSET["CSession"]["m_ASPD"]+0x10
			OFFSET["CSession"]["m_hp"] :=  0x4B04
			OFFSET["CSession"]["m_maxhp"] :=  0x4B08
			OFFSET["CSession"]["m_sp"] :=  0x4B0C
			OFFSET["CSession"]["m_maxsp"] :=  0x4B10
			OFFSET["CSession"]["CharName"] :=  0x5778


			ADDR["g_modeMgr"] :=  0xBC4DA8
			OFFSET["CModeMgr"]["m_curMode"] :=  0x4
			OFFSET["CModeMgr"]["m_curModeType"] :=  0x58

			OFFSET["SKILL_USE_INFO"]["m_skillId"] :=  0x4


			ADDR["g_actorPickNode"] :=  0xBC4F4C
			
			ADDR["stateId_first"] :=   0xCA89BC
			ADDR["stateId_last"] :=  ADDR["stateId_first"] + 0x4
			SIZE["CBuffInfo"] :=  0x14
			
			OFFSET["CGameActor"]["m_bodyLight"] :=  0xE8
			OFFSET["CGameActor"]["m_gid"] :=  0x110
			OFFSET["CGameActor"]["m_skillRechargeGage"] :=  0x258
			OFFSET["CGameActor"]["m_job"] :=  OFFSET["CGameActor"]["m_skillRechargeGage"]- 0x14
			
			OFFSET["CGameMode"]["m_world"] :=  0xCC
			OFFSET["CGameMode"]["m_view"] :=  OFFSET["CGameMode"]["m_world"]+4
			OFFSET["CGameMode"]["m_skillUseInfo"] :=  0x3EC
			OFFSET["CGameMode"]["m_SkillBallonSkillId"] :=  0x440

			OFFSET["CWorld"]["m_player"] :=  0x2C
			
			OFFSET["UIWindow"]["m_w"] :=  0x8
			OFFSET["UIWindow"]["m_h"] :=  OFFSET["UIWindow"]["m_w"]+0x4
			OFFSET["UIWindow"]["m_x"] :=  OFFSET["UIWindow"]["m_h"]+0x4
			OFFSET["UIWindow"]["m_y"] :=  OFFSET["UIWindow"]["m_x"]+0x4
			
			OFFSET["UIWindowMgr"]["m_chooseWarpWnd"] :=  0x1E8
			OFFSET["UIWindowMgr"]["m_merchantShopMakeWnd"] :=  0x2E0
			OFFSET["UIWindowMgr"]["m_makingArrowListWnd"] :=  0x358
			OFFSET["UIWindowMgr"]["m_spellListWnd"] :=  0x360
			
			
			OFFSET["std::list"][""]["Head"] :=  0x0
			OFFSET["std::list"]["Size"] :=  0x4
			OFFSET["std::list::node"]["Next"] :=  0x0
			OFFSET["std::list::node"]["Prev"] :=  0x4
			OFFSET["std::list::node"]["Value"] :=  0x8
			OFFSET["std::vector"]["start"] :=  0x0
			OFFSET["std::vector"]["end"] :=  0x4
			OFFSET["std::string"]["ptr"] :=  0x0 ; default res seems to be 15
			OFFSET["std::string"]["len"] :=  16 ; if the lenght exceeds the default res, the ptr is to a dynamically allocated buffer of len length
			OFFSET["std::string"]["res"] :=  OFFSET["std::string"]["len"]+4
			SIZE["std::string"] :=  OFFSET["std::string"]["res"]+4

			OFFSET["CRenderObject"]["m_pos"] :=  0x10
			OFFSET["CRenderObject"]["m_curAction"] :=  0x34
			OFFSET["CRenderObject"]["m_lastTlvertX"] :=  0xAC
			OFFSET["CRenderObject"]["m_lastTlvertY"] :=  OFFSET["CRenderObject"]["m_lastTlvertX"]+4
			OFFSET["CRenderObject"]["m_isPc"] :=  OFFSET["CRenderObject"]["m_lastTlvertX"]-4
			OFFSET["CRenderer"]["m_hpc"] :=  0x0
			OFFSET["CRenderer"]["m_vpc"] :=  OFFSET["CRenderer"]["m_hpc"]+4
			OFFSET["CRenderer"]["m_xoffset"] :=  0x1c
			OFFSET["CRenderer"]["m_yoffset"] :=  OFFSET["CRenderer"]["m_xoffset+4"]
			OFFSET["CView"]["m_viewMatrix"] :=  0xC8
			OFFSET["CWorld"]["m_gameObjectList"] :=  0x8
			OFFSET["CWorld"]["m_actorList"] :=  0x10
			OFFSET["CWorld"]["m_itemList"] :=  0x18
			OFFSET["CWorld"]["m_skillList"] :=  0x20

			OFFSET["CActorPickNode"]["m_region"] :=  0x4
			OFFSET["CActorPickNode"]["m_child"] :=  0x14
			OFFSET["CActorPickNode"]["m_pickInfoList"] :=  0x24
			OFFSET["CActorPickInfo"]["m_vectors"] :=  0x0
			OFFSET["CActorPickInfo"]["m_gid"] :=  4*3*2
			OFFSET["CActorPickInfo"]["m_job"] :=  OFFSET["CActorPickInfo"]["m_gid"]+4
			OFFSET["CActorPickInfo"]["m_classType"] := OFFSET["CActorPickInfo"]["m_job+4"]
			OFFSET["CActorPickInfo"]["m_isPkState"] :=  OFFSET["CActorPickInfo"]["m_classType+4"]

			OFFSET["matrix"]["v11"] :=  0x0
			OFFSET["matrix"]["v12"] :=  0x4
			OFFSET["matrix"]["v13"] :=  0x8
			OFFSET["matrix"]["v21"] :=  0xc
			OFFSET["matrix"]["v22"] :=  0x10
			OFFSET["matrix"]["v23"] :=  0x14
			OFFSET["matrix"]["v31"] :=  0x18
			OFFSET["matrix"]["v32"] :=  0x1c
			OFFSET["matrix"]["v33"] :=  0x20
			OFFSET["matrix"]["v41"] :=  0x24
			OFFSET["matrix"]["v42"] :=  0x28
			OFFSET["matrix"]["v43"] :=  0x2c
			OFFSET["vector3d"]["x"] :=  0x0
			OFFSET["vector3d"]["y"] :=  0x4
			OFFSET["vector3d"]["z"] :=  0x8

			OFFSET["ShortCutKey"]["isSkill"] :=  0 ; len = 1 byte
			OFFSET["ShortCutKey"]["ID"] :=  1 ; len = 4 byte..
			OFFSET["ShortCutKey"]["count"] :=  5
			SIZE["ShortCutKey"] :=  OFFSET["ShortCutKey"]["count"]+2
		}
		*/
	}
	
	PushKey(key)
	{
		ControlSend ,,% key,% "ahk_pid " this.PID
	}
	
	; array of chp/mhp/hpr/csp/msp/spr based on the player's hp/sp
	_getMedicStats()
	{
		global ADDR, OFFSET
		g_session := ADDR["g_session"]
		offset_chp := OFFSET["CSession"]["m_hp"]
		
		cur_hp := this.read(g_session+offset_chp)
		max_hp := this.read(g_session+offset_chp+4)
		cur_sp := this.read(g_session+offset_chp+8)
		max_sp := this.read(g_session+offset_chp+12)
		hp_rate := Floor(100*cur_hp/max_hp)
		sp_rate := Floor(100*cur_sp/max_sp)
		
		return { "chp":cur_hp, "mhp": max_hp, "hpr": hp_rate, "csp": cur_sp, "msp": max_sp, "spr": sp_rate }
	}
	
	; find which hotkey the player has "macro" set to
	; the hotkey MUST exist!
	
	FindMacro(macro)
	{
		global ADDR, OFFSET, SIZE, MACRO_KEYS
		
		i := 0
		
		g_session := ADDR["g_session"]
		offset_shortcuttext := OFFSET["CSession"]["m_shortcutText"]
		size_stdstring := SIZE["std::string"]
		offset_stringlen := OFFSET["std::string"]["len"]
		
		for i, key in MACRO_KEYS
		{
			string_ptr := this.read(g_session + offset_shortcuttext + (i-1)*size_stdstring)
			string_len := this.read(string_ptr + offset_stringlen)
			
			msg := ""
			
			if (string_len < 15)
				msg := this.readString(string_ptr)
			else
				msg := this.readString(this.read(string_ptr))
			
			if (InStr(msg, macro, false))
				return key
		}
		
		Assert(false, "FindMacro requested " . macro . " but it was not hotkeyed!")
	}
	
	_findHotkey(skitemid, is_skill = true) ; private (usually, probably)
	{
		global SHORTCUT_KEYS, ADDR, OFFSET, SIZE
		
		g_session := ADDR["g_session"]
		offset_shortcutlist := OFFSET["CSession"]["m_shortcutList"]
		size_shortcutkey := SIZE["ShortCutKey"]
		offset_isSkill := OFFSET["ShortCutKey"]["isSkill"] ; char
		offset_id := OFFSET["ShortCutKey"]["ID"]
		
		info := []
		for i, key in SHORTCUT_KEYS
		{
			key_ptr := g_session+offset_shortcutlist+(i-1)*size_shortcutkey
			
			hk_isSkill := this.read(key_ptr+offset_isSkill, "Char")
			hk_id := this.read(key_ptr+offset_id)
			hk_count := this.read(key_ptr+OFFSET["ShortCutKey"]["count"], "Short")
			info.Insert({"id":hk_id, "isSkill": hk_isSkill, "count": hk_count})
			; m_shortcutList[i].Count only refers to skill level, not item count. boo

			if ((is_skill = hk_isSkill) && (hk_id = skitemid))
				return key
		}
		
		VarDump(info)
		Assert(false, "_findHotkey requested " . skitemid . " (isSkill: " . is_skill . ") but it was not hotkeyed!")
	}
	
	FindSkillHotkey(skid)
	{
		return this._findHotkey(skid)
	}
	
	FindItemHotkey(itemid)
	{
		return this._findHotkey(itemid, false)
	}
	
	GetEfstList()
	{
		global ADDR, SIZE
		data := []
	
		efstlist_start := this.read(ADDR["stateId_first"])
		efstlist_end := this.read(ADDR["stateId_last"])
		
		buffinfolen := SIZE["CBuffInfo"]
		efstlist_count := Floor((efstlist_end - efstlist_start) / buffinfolen)
		i := 0

		while (i < efstlist_count)
		{
			current_efst := this.read(efstlist_start+i*buffinfolen)
			data.Insert(current_efst)
			i++
		}

		return data
	}
	
	HasEfst(efstid)
	{
		global EFST
		Assert(InArray(efstid, EFST), "HasEfst Invalid EFST " . efstid) 
		
		return InArray(efstid, this.GetEfstList())
	}
	
	ReupItemEfst(efstlist)
	{
		global EFST, EFST_TO_II, DELAY_ITEMUSE
		
		Assert(IsObject(efstlist), "ReupItemEfst invalid efst list passed!")
		
		for i, efstid in efstlist
		{
			Assert(InArray(efstid, EFST), "ReupItemEfst Bad EFST " . efstid . " passed in efstlist!")
			
			this.UseItem(EFST_TO_II[efstid])
		}
		
	}
	
	ReupSkillEfst(efstlist)
	{
		global EFST, EFST_TO_SKID, DELAY_ITEMUSE
		
		Assert(IsObject(efstlist), "ReupSkillEfst invalid efst list passed!")
		
		playerP := this.GetPlayerP()
		
		for idx, efstid in efstlist
		{
			Assert(InArray(efstid, EFST), "ReupSkillEfst Bad EFST " . efstid . " passed in efstlist!")
			
			if (!this.HasEfst(efstid))
				this.UseSelfSkill(EFST_TO_SKID[efstid])
		}
		
	}
	
	; note to the rest of the script that this player needs this buff
	ReupAllySkillEfst(efstlist)  
	{
		global EFST, EFST_TO_SKID, EFST_TO_SRC, ADDR, OFFSET, SIZE
		
		Assert(IsObject(efstlist), "ReupAllySkillEfst invalid efst list passed!")

		gid := this.read(this.GetPlayerP() + OFFSET["CGameActor"]["m_gid"])
		
		for idx, efstid in efstlist
		{
			Assert(InArray(efstid, EFST), "ReupAllySkillEfst Bad EFST " . effect . " passed in efstlist!")
			if (!this.HasEfst(efstid))
				AddBuffNeed(gid, efstid)
		}
	}
	
	; Use an item, and optionally wait till the item use delay finishes
	UseItem(nameid, wait_usedelay := true)
	{
		global DELAY_ITEMUSE, II
		
		Assert(InArray(nameid, II), "UseItem requested bad nameid " . nameid)
		
		this.PushKey(this.FindItemHotkey(nameid))
		
		if (wait_usedelay)
			Sleep DELAY_ITEMUSE
	}
	
	; get the skill id that the character is hovering
	GetTargetingSkill()
	{
		global ADDR, OFFSET
		; g_modeMgr->m_curMode->m_skillUseInfo->m_skillId
		return this.read(this.read(ADDR["g_modeMgr"] + OFFSET["CModeMgr"]["m_curMode"]) + OFFSET["CGameMode"]["m_skillUseInfo"] + OFFSET["SKILL_USE_INFO"]["m_skillId"])
	}
	
	ClickScreen(xpos, ypos)
	{
		CoordMode Mouse, Client
		WinActivate % "ahk_pid " this.PID
		MouseMove %xpos%, %ypos%, 1
		Sleep 50
		Click %xpos% %ypos%
	}
	
	CloseOpenWindows()
	{
		global ADDR, OFFSET
		
		POSSIBLE_WINDOWS := ["m_chooseWarpWnd", "m_merchantShopMakeWnd", "m_makingArrowListWnd", "m_spellListWnd", "m_itemIdentifyWnd"]
		
		for i, wnd in POSSIBLE_WINDOWS
		{
			wndP := this.read(ADDR["g_windowMgr"] + OFFSET["UIWindowMgr"][wnd])
			
			if (wndP)
			{
				wndX := this.read(wndP+OFFSET["UIWindow"]["m_x"])
				wndY := this.read(wndP+OFFSET["UIWindow"]["m_y"])
				wndW := this.read(wndP+OFFSET["UIWindow"]["m_w"])
				wndH := this.read(wndP+OFFSET["UIWindow"]["m_h"])
				
				xpos := wndX + wndW - 25
				ypos := wndY + wndH - 10
				
				this.ClickScreen(xpos, ypos)
			}
		}
	
	}
	
	UseSkill(skill_id, xpos := 0, ypos := 0, wait_aspd := true, wait_for_castbar := true)
	{
		global SKID
		Assert(InArray(skill_id, SKID), "UseSkill requested bad skill_id " . skill_id)
		
		this.PushKey(this.FindSkillHotkey(skill_id))
		
		if (xpos || ypos) ; actually a target skill!
		{
			this.ClickScreen(xpos, ypos)
		}
		
		if (wait_for_castbar)
			while (this.IsCasting())
				Sleep 100
		
		if (wait_aspd)
			Sleep this.GetAspdDelay()
	}
	
	UseSelfSkill(skill_id, wait_aspd := true, wait_for_castbar := true)
	{
		global SKID
		Assert(InArray(skill_id, SKID), "UseSelfSkill requested bad skill_id " . skill_id)
		
		WinActivate % "ahk_pid " this.PID
		WinGetPos ,,,xpos, ypos,% "ahk_pid " this.PID
		xpos /= 2
		ypos /= 2
		
		this.UseSkill(skill_id, xpos, ypos, wait_aspd, wait_for_castbar)
	}
	
	UseNonTargetSkill(skill_id, wait_aspd := true, wait_for_castbar := true)
	{
		global SKID
		Assert(InArray(skill_id, SKID), "UseNonTargetSkill requested bad skill_id " . skill_id)
		
		this.UseSkill(skill_id, 0, 0, wait_aspd, wait_for_castbar)
	}
	
	RunMedic(hp_rate := 99, sp_rate := 30, ygg_rate := 0)
	{
		global II
		if (hp_rate)
			Assert(hp_rate < 100, "RunMedic observed an hp rate of " hp_rate "which is more than 100%!")
		if (sp_rate)
			Assert(sp_rate < 100, "RunMedic observed an sp rate of " sp_rate "which is more than 100%!")
			
		if (ygg_rate)
			Assert(ygg_rate > hp_rate, "RunMedic determined you have a higher ygg% use than hp% use. This means the character will only want to use yggs!")
		
		medic := this._getMedicStats()
		if (ygg_rate && medic["hpr"] < ygg_rate)
		{
			this.UseItem(II["YGGITEM"])
			medic := this._getMedicStats()
		}
		while (hp_rate && medic["hpr"] < hp_rate
			||	sp_rate && medic["spr"] < sp_rate)
		{
			
			if (medic["hpr"] < hp_rate)
				this.UseItem(II["HPPOT"])
			if (medic["spr"] < sp_rate)
				this.UseItem(II["SPPOT"])
				
			medic := this._getMedicStats()
		}
	}
	
	BuffAlliesInNeed()
	{
		global EFST, NEED_EFSTLIST, EFST_TO_SKID, EFST_TO_SRC, ADDR, OFFSET
		
		if (!NEED_EFSTLIST.Length())
			return

		my_job := this.read(ADDR["g_session"] + OFFSET["CSession"]["m_job"])
		allyList := this.GetAllyList()
		
		; it would be better to have the ally info sorted out before going to do it but.. oh well
		for gid, efstlist in NEED_EFSTLIST
		{
			for idx, efstid in efstlist
			{
				if (EFST_TO_SRC[efstid] != my_job) ; THAT IS NOT MY JOB!
					continue
				for allyidx, ally in allyList
				{
					if (ally["gid"] != gid)
						continue
					actorP := ally["ptr"]
					actorX := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlvertX"])
					actorY := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlvertY"])
					
					while (this.IsCasting())
						Sleep 100
						
					this.PushKey(this.FindSkillHotkey(EFST_TO_SKID[efstid]))
					Sleep 100
					
					this.ClickScreen(actorX, actorY)
					Sleep this.GetAspdDelay()
					
					RemoveBuffNeed(gid, efstid)
				}
			}
		}
	}
	
	IsCasting()
	{	
		global ADDR, OFFSET
		return this.read(this.GetPlayerP()+OFFSET["CGameActor"]["m_skillRechargeGage"]) != 0
	}
	
	GetAspdDelay()
	{
		global ADDR, OFFSET
		return 100 + 2 * this.read(ADDR["g_session"]+OFFSET["CSession"]["m_ASPD"])
	}

	GetPlayerP()
	{
		global ADDR, OFFSET
		; g_modeMgr->m_curMode->m_world->m_player
		return this.read(this.read(this.read(ADDR["g_modeMgr"] + OFFSET["CModeMgr"]["m_curMode"]) + OFFSET["CGameMode"]["m_world"]) + OFFSET["CWorld"]["m_player"])
		
	}
	
	GetNpcList()
	{
		global JT, ADDR, OFFSET, SIZE
		data := []
		
		gamemodeP := this.read(ADDR["g_modeMgr"] + OFFSET["CModeMgr"]["m_curMode"])
		worldP := this.read(gamemodeP + OFFSET["CGameMode"]["m_world"])
		actorlistP := worldP + OFFSET["CWorld"]["m_actorList"]
		actorlist_count := this.read(actorlistP + OFFSET["std::list"]["Size"])
		actorlistP := this.read(this.read(actorlistP) + OFFSET["std::list::node"]["Next"])
		
		i := 0
		
		while (i < actorlist_count)
		{
			actorP := this.read(actorlistP + OFFSET["std::list::node"]["Value"])
			job := this.read(actorP + OFFSET["CGameActor"]["m_job"])
			
			if ( (job >= JT["USER_LAST"] && job < JT["SAFETYWALL"]) || (job >= JT["NEW_NPC_START"] && job < JT["MON_BEGIN"]) || (job >= JT["NEW_NPC_3RD_BEGIN"] && job < JT["EVENT_NPC_END"]) )
			{
				gid := this.read(actorP + OFFSET["CGameActor"]["m_gid"])
				xoffset := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlVertX"])
				yoffset := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlVertY"])
				
				data.Push({"ptr": Format("0x{:X}", actorP), "gid": gid, "jobid": job, "xpos": xoffset, "ypos": yoffset})
			}
			
			actorlistP := this.read(actorlistP + OFFSET["std::list::node"]["Next"])
			i++
		}
	
		return data
	}
	
	GetLivingMonsterList()
	{
		global JT, MOB_DB, ADDR, OFFSET, SIZE
		data := []
		
		gamemodeP := this.read(ADDR["g_modeMgr"] + OFFSET["CModeMgr"]["m_curMode"])
		worldP := this.read(gamemodeP + OFFSET["CGameMode"]["m_world"])
		actorlistP := worldP + OFFSET["CWorld"]["m_actorList"]
		actorlist_count := this.read(actorlistP + OFFSET["std::list"]["Size"])
		actorlistP := this.read(this.read(actorlistP) + OFFSET["std::list::node"]["Next"])
		
		while (i < actorlist_count)
		{
			actorP := this.read(actorlistP + OFFSET["std::list::node"]["Value"])
			job := this.read(actorP + OFFSET["CGameActor"]["m_job"])
			
			if (job > JT["MON_BEGIN"] && job < JT["MONSTER_LAST"])
			{
				gid := this.read(actorP + OFFSET["CGameActor"]["m_gid"])
				xoffset := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlVertX"])
				yoffset := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlVertY"])
				action := this.read(actorP + OFFSET["CRenderObject"]["m_curAction"])
				
				if (action != 32)
				{
					kill_type := MOB_DB[job]
					data.Push({"ptr": Format("0x{:X}", actorP), "gid": gid, "jobid": job, "xpos": xoffset, "ypos": yoffset, "killtype": kill_type})
				}
				
				
			}
			
			actorlistP := this.read(actorlistP + OFFSET["std::list::node"]["Next"])
			i++
		}
	
		return data
	}
	
	GetAllyList()
	{
		global JT, OFFSET, ADDR
		
		data := []
		
		gamemodeP := this.read(ADDR["g_modeMgr"] + OFFSET["CModeMgr"]["m_curMode"])
		worldP := this.read(gamemodeP + OFFSET["CGameMode"]["m_world"])
		actorlistP := worldP + OFFSET["CWorld"]["m_actorList"]
		actorlist_count := this.read(actorlistP + OFFSET["std::list"]["Size"])
		actorlistP := this.read(this.read(actorlistP) + OFFSET["std::list::node"]["Next"])
		
		i := 0
		
		while (i < actorlist_count)
		{
			actorP := this.read(actorlistP + OFFSET["std::list::node"]["Value"])
			job := this.read(actorP + OFFSET["CGameActor"]["m_job"])
			
			if (job < JT["USER_LAST"] || (job > JT["2004_JOB_BEGIN"] && job < JT["2004_JOB_LAST"]))
			{
				gid := this.read(actorP + OFFSET["CGameActor"]["m_gid"])
				xoffset := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlVertX"])
				yoffset := this.read(actorP + OFFSET["CRenderObject"]["m_lastTlVertY"])
				bodylight := this.read(actorP + OFFSET["CGameActor"]["m_bodyLight"])
				action := this.read(actorP + OFFSET["CRenderObject"]["m_curAction"])
				
				data.Push({"ptr": Format("0x{:X}", actorP), "gid": gid, "jobid": job, "xpos": xoffset, "ypos": yoffset, "bodylight": bodylight, "is_dead": (action = 64)})
			}
			
			actorlistP := this.read(actorlistP + OFFSET["std::list::node"]["Next"])
			i++
		}
		
		return data
	}
	
}