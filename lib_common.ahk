#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Warn
PACKETVER := 20151104

#include skidlist.ahk
#include joblist.ahk
#include efstlist.ahk
#include itemlist.ahk
#include tmpragaddr.ahk
#include ragmemory.ahk

SINGER := GEM := PALLY := TANK := LINKER := ASSTLINK := BOMBER := PROF := PRIEST := []
; config begin!

DELAY_ITEMUSE := 150

; main musician
SINGER["DELAY_ONLOOP"] := 500
SINGER["DELAY_SONGSWITCH"] := 2000
SINGER["SONGS"] := [SKID["BA_POEMBRAGI"], SKID["BA_ASSASSINCROSS"], SKID["BA_APPLEIDUN"], SKID["DC_SERVICEFORYOU"]]
SINGER["song_idx"] := 0
SINGER["AllySkillEfst"] := [EFST["ASSUMPTIO"], EFST["BLESSING"], EFST["INC_AGI"], EFST["SOULLINK"], EFST["KAAHI"], EFST["KAIZEL"]]
SINGER["SkillEfst"] := ; hard coded self-ac, to make sure he uses it between songs 
SINGER["ItemEfst"] := [EFST["FOOD_AGI_CASH"], EFST["FOOD_VIT_CASH"], EFST["FOOD_INT_CASH"]]
; gem song musician 
GEM["DELAY_ONLOOP"] := 10000
GEM["AllySkillEfst"] := [EFST["ASSUMPTIO"], EFST["KAIZEL"], EFST["KAAHI"]]
GEM["SkillEfst"] := [EFST["FOOD_VIT_CASH"]]
GEM["ItemEfst"] := 
; gospel guy
PALLY["DELAY_ONLOOP"] := 10000
PALLY["AllySkillEfst"] :=  [EFST["ASSUMPTIO"], EFST["BLESSING"]]
PALLY["SkillEfst"] := [EFST["GOSPEL"]]
PALLY["ItemEfst"] := [EFST["FOOD_VIT_CASH"], EFST["FOOD_INT_CASH"]]
; ms champ
TANK["DELAY_ONLOOP"] := 5000
TANK["AllySkillEfst"] := [EFST["ASSUMPTIO"], EFST["PROTECTWEAPON"], EFST["KAIZEL"], EFST["KAAHI"]]
TANK["SkillEfst"] := [] ; hard coded to self-steel body, as well
TANK["ItemEfst"] :=  [EFST["PLUSAVOIDVALUE"], EFST["ATTHASTE_POTION2"], EFST["FOOD_VIT_CASH"], EFST["FOOD_DEX_CASH"], EFST["FOOD_LUK_CASH"]]
; main linker
LINKER["DELAY_ONLOOP"] := 10000
LINKER["AllySkillEfst"] := [EFST["BLESSING"], EFST["ASSUMPTIO"]] ; EFST_SOULLINK will be applied by the asstlinker with a hard coded
LINKER["SkillEfst"] := [EFST["KAAHI"], EFST["KAIZEL"]]
LINKER["ItemEfst"] := [EFST["FOOD_VIT_CASH"], EFST["FOOD_DEX_CASH"]]
; asst linker, just links the main linker
ASSTLINK["DELAY_ONLOOP"] := 15000
ASSTLINK["AllySkillEfst"] := []
ASSTLINK["SkillEfst"] := [EFST["KAAHI"], EFST["KAIZEL"]]	
ASSTLINK["ItemEfst"] := []
;
PRIEST["DELAY_ONLOOP"] := 2000
PRIEST["AllySkillEfst"] := [EFST["KAAHI"], EFST["KAIZEL"]]
PRIEST["SkillEfst"] := [EFST["ASSUMPTIO"], EFST["BLESSING"], EFST["INC_AGI"]]
PRIEST["ItemEfst"] := [EFST["FOOD_VIT_CASH"], EFST["FOOD_DEX_CASH"]]
; 
BOMBER["DELAY_ONLOOP"] := 500
BOMBER["AllySkillEfst"] := [EFST["BLESSING"], EFST["INC_AGI"], EFST["ASSUMPTIO"], EFST["KAAHI"], EFST["KAIZEL"]]
BOMBER["ItemEfst"] := [EFST["CASH_RECEIVEITEM"], EFST["FOOD_VIT_CASH"], EFST["FOOD_DEX_CASH"], EFST["FOOD_INT_CASH"], EFST["FOOD_AGI_CASH"], EFST["ATTHASTE_POTION3"]]
BOMBER["SkillEfst"] := [] ; no self buffs
; professor!
PROF["DELAY_ONLOOP"] := 100
PROF["AllySkillEfst"] := [EFST["BLESSING"], EFST["INC_AGI"], EFST["ASSUMPTIO"], EFST["KAAHI"], EFST["KAIZEL"], EFST["STEELBODY"], EFST["COUNTER"]] ; counter and steel body here so allies can dispel them
PROF["SkillEfst"] := [EFST["ENERGYCOAT"]]
PROF["ItemEfst"] := [EFST["FOOD_VIT_CASH"], EFST["FOOD_INT_CASH"], EFST["FOOD_AGI_CASH"], EFST["ATTHASTE_POTION2"], EFST["PLUSAVOIDVALUE"]]


SHORTCUT_KEYS := ["{F1}", "{F2}", "{F3}", "{F4}", "{F5}", "{F6}", "{F7}", "{F8}", "{F9}", "q", "w", "e", "r", "t", "y", "u", "i", "o", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m", "`,", "."]

; change them to a single hotkey please, instead of alt+1/2/3
MACRO_KEYS := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

; config end !



if (_ClassMemory.__Class != "_ClassMemory")
{
	MsgBox "class memory not correctly installed. Or the (global class) variable '_ClassMemory' has been overwritten"
	ExitApp
}

if (RagMemory.__Class != "RagMemory")
{
	MsgBox "RagMemory not correctly installed. Or the (global class) variable 'RagMemory' has been overwritten"
	ExitApp
}

Assert(cond, info := "")
{
	if (!!cond)
		return 
	
	MsgBox % "Assert failed: " info
	ExitApp
}
NEED_EFSTLIST := []


EFST_TO_SKID := []
EFST_TO_SKID[EFST["BLESSING"]] := SKID["AL_BLESSING"]
EFST_TO_SKID[EFST["INC_AGI"]] := SKID["AL_INCAGI"]
EFST_TO_SKID[EFST["ASSUMPTIO"]] := SKID["HP_ASSUMPTIO"]
EFST_TO_SKID[EFST["PROTECTWEAPON"]] := SKID["CR_FULLPROTECTION"] 
EFST_TO_SKID[EFST["SOULLINK"]] := SKID["SL_BARDDANCER"] ; hard coded to do SL_SOULLINKER for the asst linker ..
EFST_TO_SKID[EFST["KAIZEL"]] := SKID["SL_KAIZEL"]
EFST_TO_SKID[EFST["KAAHI"]] := SKID["SL_KAAHI"]
EFST_TO_SKID[EFST["GOSPEL"]] := SKID["PA_GOSPEL"]
EFST_TO_SKID[EFST["BD_PLAYING"]] := SKID["BD_ENCORE"]
; not technically so but its useful to keep hocus dicks going ..
EFST_TO_SKID[EFST["AUTOCOUNTER"]] := SKID["SA_CASTCANCEL"]
EFST_TO_SKID[EFST["STEELBODY"]] := SKID["SA_DISPELL"] 
EFST_TO_SKID[EFST["BLADESTOP"]] := SKID["SA_DISPELL"]

EFST_TO_SRC := []
EFST_TO_SRC[EFST["BLESSING"]] := JT["PRIEST_H"]
EFST_TO_SRC[EFST["INC_AGI"]] := JT["PRIEST_H"]
EFST_TO_SRC[EFST["ASSUMPTIO"]] := JT["PRIEST_H"]
EFST_TO_SRC[EFST["PROTECTWEAPON"]] := JT["ALCHEMIST_H"]
EFST_TO_SRC[EFST["SOULLINK"]] := JT["LINKER"]
EFST_TO_SRC[EFST["KAIZEL"]] := JT["LINKER"]
EFST_TO_SRC[EFST["KAAHI"]] := JT["LINKER"]
; but again not really you know
EFST_TO_SRC[EFST["AUTOCOUNTER"]] := JT["SAGE_H"]
EFST_TO_SRC[EFST["STEELBODY"]] := JT["SAGE_H"]
EFST_TO_SKID[EFST["BLADESTOP"]] := SKID["SAGE_H"]

EFST_TO_II := []
EFST_TO_II[EFST["CASH_RECEIVEITEM"]] := II["GUM"]
EFST_TO_II[EFST["ATTHASTE_POTION1"]] :=  II["CONCPOT"] 
EFST_TO_II[EFST["ATTHASTE_POTION2"]] :=  II["AWAKEPOT"] 
EFST_TO_II[EFST["ATTHASTE_POTION3"]] :=  II["ZERKPOT"] 
EFST_TO_II[EFST["FOOD_STR_CASH"]] :=  II["STR10"] 
EFST_TO_II[EFST["FOOD_AGI_CASH"]] :=  II["AGI10"] 
EFST_TO_II[EFST["FOOD_VIT_CASH"]] :=  II["VIT10"] 
EFST_TO_II[EFST["FOOD_DEX_CASH"]] :=  II["DEX10"] 
EFST_TO_II[EFST["FOOD_INT_CASH"]] :=  II["INT10"] 
EFST_TO_II[EFST["FOOD_LUK_CASH"]] :=  II["LUK10"] 
EFST_TO_II[EFST["PLUSAVOIDVALUE"]] :=  II["PINEAPPLEJUICE"]


ENUMS := []
MakeEnum("KILLTYPE", "IGNORE, ACID, BOLT, NPC, NPCACID, NPCBOLT")
Populate_Mobdb()=


InitCharacters(pids)
{
	global SINGER, GEM, PALLY, TANK, LINKER, ASSTLINK, BOMBER, PROF, PRIEST
		
	for src, procid in pids
	{
		%src%["exe"] := MakeMemory(procid)
		%src%["exe"].SetAllySkillEfst(%src%["AllySkillEfst"])
		%src%["exe"].SetItemEfst(%src%["ItemEfst"])
		%src%["exe"].SetSkillEfst(%src%["SkillEfst"])
	}
	
}
RunMyDicks(pids)
{
	
	tank_exe := singer_exe := gem_exe := pally_exe := 0
	if (tank_proc)
		tank_exe := MakeMemory(tank_proc)
	if (singer_proc)
		singer_exe := MakeMemory(singer_proc)
	if (gem_proc)
		gem_exe := MakeMemory(gem_proc)
	if (paladin_proc)
		pally_exe := MakeMemory(paladin_proc)

	tank_nexttick := 0
	singer_nexttick := 0
	gem_nexttick := 0
	pally_nexttick := 0
	
	Loop
	{
		g_tick := A_TickCount
		
		if (tank_proc && g_tick > tank_nexttick)
		{
			Tank_OnLoop(tank_exe)
			tank_nexttick := g_tick + TANK_DELAY_ONLOOP
		}
		if (singer_proc && g_tick > singer_nexttick)
		{
			Singer_OnLoop(singer_exe)
			singer_nexttick := g_tick + SINGER_DELAY_ONLOOP
		}
		if (gem_proc && g_tick > gem_nexttick)
		{
			Gem_OnLoop(gem_exe)
			gem_nexttick := g_tick + GEM_DELAY_ONLOOP
		}
		if (paladin_proc && g_tick > pally_nexttick)
		{
			Pally_OnLoop(pally_exe)
			pally_nexttick := g_tick + PALLY_DELAY_ONLOOOP
		}
		
	}
}


MakeMemory(procid)
{
	global PACKETVER, OFFSET
	
	memo := new RagMemory(PACKETVER, procid, "", proccopy)
	if (ErrorLevel)
		MsgBox % "ClassMemory errorlevel: " . ErrorLevel
	if (A_LastError)
		MsgBox % "ClassMemory LastError: " . A_LastError
	if !isObject(memo) 
	{
		MsgBox % "Failed to open a handle"
		if (proccopy = 0)
			MsgBox % "The program isn't running (not found) or you passed an incorrect program identifier parameter. In some cases _ClassMemory.setSeDebugPrivilege() may be required. "
		else if (proccopy = "")
			MsgBox % "OpenProcess failed. If the target process has admin rights, then the script also needs to be ran as admin. _ClassMemory.setSeDebugPrivilege() may also be required. Consult A_LastError for more information."
		ExitApp
	}
	return memo
}

AddBuffNeed(gid, efstid)
{
	global NEED_EFSTLIST, EFST
	
	Assert(InArray(efstid, EFST), "AddBuffNeed Invalid EFST requrested " . efstid)
	
	; if we're in the list already, let's add it
	if (NEED_EFSTLIST.HasKey(gid))
	{
		NEED_EFSTLIST[gid].Insert(efstid)
	}
	else
	{
		NEED_EFSTLIST.Insert(gid)
		NEED_EFSTLIST[gid].Insert(efstid)
	}
	return
}

RemoveBuffNeed(gid, efstid)
{
	global NEED_EFSTLIST, EFST
	
	ASSERT(InArray(efstid, EFST), "RemoveBuffNeed requesting remove efst of gid " . gid . " of invalid efst " . efstid)
	Assert(NEED_EFSTLIST.HasKey(gid), "RemoveBuffNeed requesting remove of efst " . efst . " from invalid gid " . gid)
	
	NEED_EFSTLIST[gid].Remove(efstid)
	if (!NEED_EFSTLIST[gid].Count())
		NEED_EFSTLIST.Remove(gid)
		
	return
}

Bomb_OnLoop(exe)
{
	global ADDR, OFFSET, JT, II, EFST, SKID, KILLTYPE
	
	exe.ReupAllySkillEfst()
	exe.ReupItemEfst()
	exe.BuffAlliesInNeed()
	
	exe.RunMedic(90, 25)
	
	allyList := exe.GetAllyList()
	rezzed := false
	for idx, ally in allyList
	{
		if (!ally["is_dead"])
			continue
		if (ally["jobid"] != JT["BARD_H"] && ally["jobid"] != JT["PRIEST_H"])
			continue
		exe.PushKey(exe.FindItemHotkey(II["YGGLEAF"]))
		Sleep 200
		exe.ClickScreen(ally["xpos"], ally["ypos"])
		Sleep 500
		
		AddBuffNeed(ally["gid"], EFST["BLESSING"])
		AddBuffNeed(ally["gid"], EFST["INC_AGI"])
		AddBuffNeed(ally["gid"], EFST["ASSUMPTIO"])
		
		rezzed := true
	}
	
	CoordMode Mouse, Client
	if (rezzed)
	{
		Loop 3
			this.UseSelfSkill(SKID["CR_SLIMPITCHER"])
	}
	
	
	mobList := exe.GetLivingMonsterList()
	
	; maybe some for loop shit lets me restart i dunno
	restart_monster_check := true
	while (restart_monster_check )
	{
		restart_monster_check := false
		for index, mob in mobList
		{
			actorP := mob["ptr"]
			killtype := mob["killtype"]
			if (killtype = KILLTYPE["IGNORE"])
				continue
				
			npc_wipe := false
			attack_skill := SKID["CR_ACIDDEMONSTRATION"]
			if (killtype = KILLTYPE["ACID"])
			{
				; already set, ok
			}
			else if (killtype = KILLTYPE["BOLT"])
			{
				attack_skill := II["BOLT"]
			}
			
			if (killtype = KILLTYPE["NPC"])
			{
				npc_wipe := true
				attack_skill := 0
			}
			else if (killtype = KILLTYPE["NPCACID"])
			{
				npc_wipe := true
			}
			else if (killtype = KILLTYPE["NPCBOLT"])
			{
				npc_wipe := true
				attack_skill := II["BOLT"]
			}
			
			is_itemskill := (attack_skill = SKID["CR_ACIDDEMONSTRATION"])

			if (attack_skill)
			{
				if (is_itemskill)
					attack_skill := exe.FindItemHotkey(attack_skill)
				else
					attack_skill := exe.FindSkillHotkey(attack_skill)
				
				mob_action := exe.read(actorP + OFFSET["CRenderObject"]["m_curAction"])
				while (mob_action != 32)
				{
					mobX := exe.read(actorP + OFFSET["CRenderObject"]["m_lastTlvertX"])
					mobY := exe.read(actorP + OFFSET["CRenderObject"]["m_lastTlvertY"])
					
					; manually do the click (for now) in case it is an item skill
					exe.PushKey(attack_skill)
					Sleep 100+200*(is_itemskill) ; have to sleep longer for bolts.
					CoordMode Mouse, Client
					WinActivate % "ahk_pid " this.PID
					MouseMove %mobX%, %mobY%, 1
					Click %mobX%, %mobY%
					Sleep exe.GetAspdDelay()
					
					if (npc_wipe) ; break after 1 use with npc_wipe
						break 

					mob_action := exe.read(actorP + OFFSET["CRenderObject"]["m_curAction"])
				}
			}
			
			if (npc_wipe)
			{
				npcList := exe.GetNpcList()
				exe.PushKey(exe.FindMacro("@refresh"))
				Sleep 1000
				for idx, npc in npcList
				{
					job := npc["jobid"]
					if (job = JT["4_F_KAFRA2"])
					{
						exe.ClickScreen(npc["xpos"], npc["ypos"])
						Sleep 400
						exe.PushKey("{Enter}")
						Sleep 400
						exe.PushKey("{Down}")
						Sleep 400
						exe.PushKey("{Enter}")
						Sleep 400
						exe.PushKey("{Enter}")
						; and get buffs too, why not?
						Sleep 400
						exe.ClickScreen(npc["xpos"], npc["ypos"])
						Sleep 400
						exe.PushKey("{Enter}")
						Sleep 400
						exe.PushKey("{Enter}")
						Sleep 400
						exe.PushKey("{Enter}")
					}
				}
			}
			
			; we killed someone, and must restart-loop
			restart_monster_check := false
			break
		}
	}
	return
}

Priest_OnLoop(exe)
{
	global EFST, SKID

	exe.ReupAllySkillEfst()
	exe.ReupSkillEfst()
	exe.ReupItemEfst()
	
	allyList := exe.GetAllyList()
	
	; res dead guys!
	for idx, ally in allyList
	{
		if (!ally["is_dead"])
			continue
		exe.UseNonTargetSkill(SKID["PR_REDEMPTIO"])
		AddBuffNeed(ally["gid"], EFST["BLESSING"])
		AddBuffNeed(ally["gid"], EFST["INC_AGI"])
		AddBuffNeed(ally["gid"], EFST["ASSUMPTIO"])
	}
	
	exe.RunMedic(80, 20)
	
	exe.BuffAlliesInNeed()
	
	return
}

MainLink_OnLoop(exe)
{
	exe.ReupAllySkillEfst()
	exe.ReupItemEfst()
	exe.BuffAlliesInNeed()
	
	exe.RunMedic(80, 20)
	return
}
AsstLink_OnLoop(exe)
{
	global II, SKID, JT

	exe.ReupAllySkillEfst()
	exe.ReupItemEfst()
	exe.BuffAlliesInNeed()
	
	exe.RunMedic(50, 50)
	
	; hard coded to link the other linker
	allyList := exe.GetAllyList()
	for idx, ally in allyList
	{
		if (ally["jobid"] = JT["LINKER"])
		{
			exe.UseSkill(SKID["SL_SOULLINKER"], ally["xpos"], ally["ypos"], false, false)
			break
		}
	}
	return
}

Tank_OnLoop(exe)
{
	global EFST, SKID, II, 

	exe.RunMedic(90, 25)
	medic := exe.GetMedicStats()

	exe.ReupAllySkillEfst()
	exe.ReupItemEfst()
	
	; hard coded self buff because of the spheres requirement. fix later
	if (!exe.HasEfst(EFST["STEELBODY"]))
	{
		exe.UseNonTargetSkill(SKID["CH_SOULCOLLECT"])
		exe.UseNonTargetSkill(SKID["MO_STEELBODY"])
	}
	
	monsters := exe.GetLivingMonsterList()
	if (!monsters.Count())
		exe.UseItem(II["DEADBRANCH"])
	return
}

Singer_OnLoop(exe)
{
	global EFST, II, SKID, SINGER
	
	exe.RunMedic(70, 30)
	exe.ReupAllySkillEfst()
	exe.ReupItemEfst()
	; hard-coded self-ac to cancel songs
	; exe.ReupSkillEfst()
	if (!exe.HasEfst(EFST["CONCENTRATION"]))
	{
		if (exe.HasEfst(EFST["BDPLAYING"]))
			exe.UseItem(II["CELLO"])
		
		exe.UseSkill(SKID["AC_CONCENTRATION"])
		
		SINGER["song_index"] := 1 ; starts back from bragi
		SINGER["tick_nextsong"] := 0
	}
	
	if (A_TickCount >= SINGER["tick_nextsong"])
	{
		; time to sing!
		if (exe.HasEfst(EFST["BDPLAYING"]))
			exe.UseItem(II["CELLO"], true)
		
		exe.UseSkill(SINGER["SONGS"][SINGER["song_index"]])
		SINGER["tick_nextsong"] := A_TickCount + SINGER["DELAY_SONGSWITCH"]
		
		++SINGER["song_index"]
		if (SINGER["song_index"] > SINGER["SONGS"].Count)
			SINGER["song_index"] := 1
	}
	return
}

Gem_OnLoop(exe)
{	
	exe.RunMedic(50, 20)
	exe.ReupAllySkillEfst()
	exe.ReupItemEfst()
	exe.ReupSkillEfst()
	return
}

Pally_OnLoop(exe)
{
	exe.RunMedic(50, 20)	
	exe.ReupAllySkillEfst() 
	exe.ReupItemEfst() 
	exe.ReupSkillEfst()
	return
}

Hocus_OnLoop(exe)
{
	global SKID, EFST, KILLTYPE
	
	exe.ReupAllySkillEfst()
	exe.ReupItemEfst()
	exe.ReupSkillEfst()
	
	exe.RunMedic(50, 10)
	
	; hard coded here because there is no efst for sight
	if (!exe.IsSight())
		exe.UseNonTargetSkill(SKID["MG_SIGHT"])
	
	exe.UseNonTargetSkill(SKID["SA_ABRACADABRA"])
	
	Sleep 150
	
	if (exe.IsCasting())
	{
		exe.UseNonTargetSkill(SKID["SA_CASTCANCEL"], false)
		if (!exe.HasEfst(EFST["AUTOCOUNTER"]))
			Sleep exe.GetAspdDelay()
	}
	
	if (exe.GetTargetingSkill() == SKID["SA_CLASSCHANGE"])
	{
		mobList := exe.GetLivingMonsterList()
		for idx, mob in mobList
		{
			if (mob["killtype"] = KILLTYPE["IGNORE"])
			{
				exe.UseSkill(SKID["SL_SOULLINKER"], mob["xpos"], mob["ypos"], false, false)
				return
			}
		}
	}
	; if shit opened up, let's close them
	exe.CloseOpenWindows()
	
	return

}

ReadKillList(filename)
{
	data := []
	Loop read, %filename%
		data.Insert(A_LoopReadLine)
	return data
}

KeyInArray(needle, haystack)
{
	Assert(IsObject(haystack), "KeyInArray bad object passed")
	;Assert(haystack.Length() != 0, "KeyInArray Empty array passed")
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

InArray(needle, haystack)
{
	Assert(IsObject(haystack), "InArray bad object passed")
	;Assert(haystack.Length() != 0, "InArray Empty array passed")
	return KeyInArray(needle, haystack) != 0
}

ObjToString(obj, depth=0)
{
	if (!IsObject(obj))
		return obj
	prefix := ""
	Loop % depth
	{
		prefix .= "  "
	}
	str := prefix . "{"
	for key, value in obj
		str .= "`n" prefix "  " key ": " ObjToString(value, depth+1) ","
	return str "`n" prefix "}"
}

VarDump(obj)
{
	str := ObjToString(obj)
	if (A_DefaultGui)
		Gui Destroy
	Gui Font,,Consolas
	Gui Add, Edit, R20 W300, %str%
	Gui Show
	return
}

MakeEnum(typename, values)
{
	Global
	
	%typename% := []
	Loop parse, values, CSV
	{
		;ENUMS[Trim(typename), A_Index] := varname
		%typename%[Trim(A_LoopField)] := A_Index
	}
	return
}

Populate_Mobdb()
{
	Global MOB_DB, KILLTYPE
	KL_IGNORE := ReadKillList("kl_ignore.txt")
	KL_ACID := ReadKillList("kl_acid.txt")
	KL_BOLT := ReadKillList("kl_bolt.txt")
	KL_NPC := ReadKillList("kl_npc.txt")
	KL_NPC_ACID := ReadKillList("kl_npcacid.txt")
	KL_NPC_BOLT := ReadKillList("kl_npcbolt.txt")
	MOB_DB := []

	Loop % KL_IGNORE.MaxIndex()
	{
		mid := KL_IGNORE[A_Index]
		MOB_DB[mid] := KILLTYPE["IGNORE"]
	}
	Loop % KL_ACID.MaxIndex()
	{
		mid := KL_ACID[A_Index]
		MOB_DB[mid] := KILLTYPE["ACID"]
	}
	Loop % KL_BOLT.MaxIndex()
	{
		mid := KL_BOLT[A_Index]
		MOB_DB[mid] := KILLTYPE["BOLT"]
	}
	Loop % KL_NPC.MaxIndex()
	{
		mid := KL_NPC[A_Index]
		MOB_DB[mid] := KILLTYPE["NPC"]
	}
	Loop % KL_NPC_ACID.MaxIndex()
	{
		mid := KL_NPC_ACID[A_Index]
		MOB_DB[mid] := KILLTYPE["NPCACID"]
	}
	Loop % KL_NPC_BOLT.MaxIndex()
	{
		mid := KL_NPC_BOLT[A_Index]
		MOB_DB[mid] := KILLTYPE["NPCBOLT"]
	}
	return
}
