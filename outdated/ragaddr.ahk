#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if (PACKETVER = 20151104)
{
	ADDR_g_windowMgr:=  0xCA89C8
	ADDR_g_renderer:=  0xBE24B0

	ADDR_g_session:= 0xE47FF0

	OFFSET_CSession__m_shortCutList:=  0x474 ; ShortCutKey[MAX_SHORTCUTS] 
	OFFSET_CSession__m_shortcutText:=  0xBFC ; std_vector<std_string> of length 10
	OFFSET_CSession__m_curMap:=  0x618
	g_addrMapName := ADDR_g_session+OFFSET_CSession__m_curMap
	OFFSET_CSession__m_healthState:=  0xB2C
	OFFSET_CSession__m_effectState:=  OFFSET_CSession__m_healthState+0x4
	OFFSET_CSession__JobID:=  0x1214 ; JOBTYPE
	OFFSET_CSession__m_ASPD:=  0x1284
	OFFSET_CSession__m_itemDefPower:=  OFFSET_CSession__m_ASPD+0x10
	OFFSET_CSession__m_hp:=  0x4B04
	OFFSET_CSession__m_maxhp:=  0x4B08
	OFFSET_CSession__m_sp:=  0x4B0C
	OFFSET_CSession__m_maxsp:=  0x4B10
	g_addrDelayASPD := ADDR_g_session+OFFSET_CSession__m_ASPD
	g_addrJobID := ADDR_g_session+OFFSET_CSession__JobID
	g_addrOption := ADDR_g_session+OFFSET_CSession__m_effectState
	g_addrOPT2 := ADDR_g_session+OFFSET_CSession__m_healthState
	g_addrCHP := ADDR_g_session+OFFSET_CSession__m_hp
	g_addrMHP := ADDR_g_session+OFFSET_CSession__m_hp+4
	g_addrCSP := ADDR_g_session+OFFSET_CSession__m_hp+8
	g_addrMSP := ADDR_g_session+OFFSET_CSession__m_hp+12
	OFFSET_CSession__CharName:=  0x5778


	ADDR_g_modeMgr:=  0xBC4DA8
	OFFSET_CModeMgr__m_curMode:=  0x4
	OFFSET_CModeMgr__m_curModeType:=  0x58

	OFFSET_SKILL_USE_INFO__m_skillId:=  0x4


	ADDR_g_actorPickNode:=  0xBC4F4C
	
	ADDR_stateId_first:=   0xCA89BC
	ADDR_stateId_last:=  ADDR_stateId_first+ 0x4
	DIFF_CBuffInfo:=  0x14
	DIFF_Efst:=  0x14
	
	OFFSET_CGameActor__m_bodyLight:=  0xE8
	OFFSET_CGameActor__m_gid:=  0x110
	OFFSET_CGameActor__m_skillRechargeGage:=  0x258
	OFFSET_CGameActor__m_job:=  OFFSET_CGameActor__m_skillRechargeGage- 0x14
	
	OFFSET_CGameMode__m_world:=  0xCC
	OFFSET_CGameMode__m_view:=  OFFSET_CGameMode__m_world+4
	OFFSET_CGameMode__m_skillUseInfo:=  0x3EC
	OFFSET_CGameMode__m_SkillBallonSkillId:=  0x440

	OFFSET_CWorld__m_player:=  0x2C
	
	OFFSET_UIWindow__m_w:=  0x8
	OFFSET_UIWindow__m_h:=  OFFSET_UIWindow__m_w+0x4
	OFFSET_UIWindow__m_x:=  OFFSET_UIWindow__m_h+0x4
	OFFSET_UIWindow__m_y:=  OFFSET_UIWindow__m_x+0x4
	
	OFFSET_UIWindowMgr__m_chooseWarpWnd:=  0x1E8
	OFFSET_UIWindowMgr__m_merchantShopMakeWnd:=  0x2E0
	OFFSET_UIWindowMgr__m_makingArrowListWnd:=  0x358
	OFFSET_UIWindowMgr__m_spellListWnd:=  0x360
	
	
	OFFSET_std_list____Head:=  0x0
	OFFSET_std_list__Size:=  0x4
	OFFSET_std_list_node__Next:=  0x0
	OFFSET_std_list_node__Prev:=  0x4
	OFFSET_std_list_node__Value:=  0x8
	OFFSET_std_vector__start:=  0x0
	OFFSET_std_vector__end:=  0x4
	OFFSET_std_string__ptr:=  0x0 ; default res seems to be 15
	OFFSET_std_string__len:=  16 ; if the lenght exceeds the default res, the ptr is to a dynamically allocated buffer of len length
	OFFSET_std_string__res:=  OFFSET_std_string__len+4
	DIFF_std_string:=  OFFSET_std_string__res+4

	OFFSET_CRenderObject__m_pos:=  0x10
	OFFSET_CRenderObject__m_curAction:=  0x34
	OFFSET_CRenderObject__m_lastTlvertX:=  0xAC
	OFFSET_CRenderObject__m_lastTlvertY:=  OFFSET_CRenderObject__m_lastTlvertX+4
	OFFSET_CRenderObject__m_isPc:=  OFFSET_CRenderObject__m_lastTlvertX-4
	OFFSET_CRenderer__m_hpc:=  0x0
	OFFSET_CRenderer__m_vpc:=  OFFSET_CRenderer__m_hpc+4
	OFFSET_CRenderer__m_xoffset:=  0x1c
	OFFSET_CRenderer__m_yoffset:=  OFFSET_CRenderer__m_xoffset+4
	OFFSET_CView__m_viewMatrix:=  0xC8
	OFFSET_CWorld__m_gameObjectList:=  0x8
	OFFSET_CWorld__m_actorList:=  0x10
	OFFSET_CWorld__m_itemList:=  0x18
	OFFSET_CWorld__m_skillList:=  0x20

	OFFSET_CActorPickNode__m_region:=  0x4
	OFFSET_CActorPickNode__m_child:=  0x14
	OFFSET_CActorPickNode__m_pickInfoList:=  0x24
	OFFSET_CActorPickInfo__m_vectors:=  0x0
	OFFSET_CActorPickInfo__m_gid:=  4*3*2
	OFFSET_CActorPickInfo__m_job:=  OFFSET_CActorPickInfo__m_gid+4
	OFFSET_CActorPickInfo__m_classType:= OFFSET_CActorPickInfo__m_job+4
	OFFSET_CActorPickInfo__m_isPkState:=  OFFSET_CActorPickInfo__m_classType+4

	OFFSET_matrix__v11:=  0x0
	OFFSET_matrix__v12:=  0x4
	OFFSET_matrix__v13:=  0x8
	OFFSET_matrix__v21:=  0xc
	OFFSET_matrix__v22:=  0x10
	OFFSET_matrix__v23:=  0x14
	OFFSET_matrix__v31:=  0x18
	OFFSET_matrix__v32:=  0x1c
	OFFSET_matrix__v33:=  0x20
	OFFSET_matrix__v41:=  0x24
	OFFSET_matrix__v42:=  0x28
	OFFSET_matrix__v43:=  0x2c
	OFFSET_vector3d__x:=  0x0
	OFFSET_vector3d__y:=  0x4
	OFFSET_vector3d__z:=  0x8

	OFFSET_ShortCutKey__isSkill:=  0 ; len = 1 byte
	OFFSET_ShortCutKey__ID:=  1 ; len = 4 byte..
	OFFSET_ShortCutKey__count:=  5
	DIFF_ShortCutKey:=  OFFSET_ShortCutKey__count+2

	
}
else if (PACKETVER = 20181104)
{
	ADDR_MapName:=0x10D856C ; +3 == xxxg_cax##
	ADDR_OPT2:=  0x10D8CF0
	ADDR_JobID:=  0x010D93D8
	ADDR_DelayASPD:=  0x010D9464
	ADDR_CHP :=  0x10DCE10
	ADDR_CharName:=  0x10DF5D8

	ADDR_g_modeMgr:=  0xE43F40
	ADDR_g_windowMgr:=  0xF33B28

	ADDR_stateId_first:=  0xF33B1C
	ADDR_stateId_last:=  ADDR_stateId_first+ 0x4
	DIFF_CBuffInfo:=  0x14

	OFFSET_CGameMode__m_world:=  0xCC
	OFFSET_CGameMode__m_skillUseInfo:=  0x3FC
	OFFSET_CGameMode__m_SkillBallonSkillId:=  0x450

	OFFSET_CWorld__m_player:=  0x2C

	OFFSET_CGameActor__m_skillRechargeGage:=  0x268

	OFFSET_UIWindowMgr__m_chooseWarpWnd:=  0x1E4
	OFFSET_UIWindowMgr__m_merchantShopMakeWnd:=  0x2D8
	OFFSET_UIWindowMgr__m_makingArrowListWnd:=  0x34C
	OFFSET_UIWindowMgr__m_spellListWnd:=  0x354
	OFFSET_UIWindowMgr__m_merchantShopBuyWnd:=  0x3CF
	
	
	OFFSET_UIWindow__m_w:=  0x14
	OFFSET_UIWindow__m_h:=  OFFSET_UIWindow__m_w+0x4
	OFFSET_UIWindow__m_x:=  OFFSET_UIWindow__m_h+0x4
	OFFSET_UIWindow__m_y:=  OFFSET_UIWindow__m_x+0x4
}
else if (PACKETVER = 20100730)
{
	ADDR_OPT2		:= 0x0083BE10
	ADDR_MapName	:= 0x00814290
	ADDR_Option	:= 0x0083BE14
	ADDR_DelayASPD:=  0x0083C504
	ADDR_CHP		:= 0x0083E1B4
	ADDR_JobID		:= 0x0083C494
}


