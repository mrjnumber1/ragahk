ADDR := []
OFFSET := []
SIZE := []

	ADDR["g_windowMgr"] :=   0xCA89C8
	ADDR["g_renderer"] :=   0xBE24B0

	ADDR["g_session"] :=  0xE47FF0

	OFFSET["CSession", "m_shortCutList"] :=   0x474 ; ShortCutKey[MAX_SHORTCUTS] 
	OFFSET["CSession", "m_shortcutText"] :=   0xBFC ; std::vector<std::string> of length 10
	OFFSET["CSession", "m_curMap"] :=   0x618
	OFFSET["CSession", "m_healthState"] :=   0xB2C
	OFFSET["CSession", "m_effectState"] :=   OFFSET["CSession"]["m_healthState"]+0x4
	OFFSET["CSession", "JobID"] :=   0x1214 ; JOBTYPE
	OFFSET["CSession", "m_ASPD"] :=   0x1284
	OFFSET["CSession", "m_itemDefPower"] :=    OFFSET["CSession"]["m_ASPD"]+0x10
	OFFSET["CSession", "m_hp"] :=    0x4B04
	OFFSET["CSession", "m_maxhp"] :=    0x4B08
	OFFSET["CSession", "m_sp"] :=    0x4B0C
	OFFSET["CSession", "m_maxsp"] :=    0x4B10
	OFFSET["CSession", "CharName"] :=    0x5778


	ADDR["g_modeMgr"] :=   0xBC4DA8
	OFFSET["CModeMgr", "m_curMode"] :=    0x4
	OFFSET["CModeMgr", "m_curModeType"] :=    0x58

	OFFSET["SKILL_USE_INFO", "m_skillId"] :=    0x4


	ADDR["g_actorPickNode"] :=   0xBC4F4C
	
	ADDR["stateId_first"] :=    0xCA89BC
	ADDR["stateId_last"] :=   ADDR["stateId_first"] + 0x4
	SIZE["CBuffInfo"] :=   0x14
	
	OFFSET["CGameActor", "m_bodyLight"] :=    0xE8
	OFFSET["CGameActor", "m_gid"] :=    0x110
	OFFSET["CGameActor", "m_skillRechargeGage"] :=    0x258
	OFFSET["CGameActor", "m_job"] :=    OFFSET["CGameActor"]["m_skillRechargeGage"]- 0x14
	
	OFFSET["CGameMode", "m_world"] :=    0xCC
	OFFSET["CGameMode", "m_view"] :=    OFFSET["CGameMode"]["m_world"]+4
	OFFSET["CGameMode", "m_skillUseInfo"] :=    0x3EC
	OFFSET["CGameMode", "m_SkillBallonSkillId"] :=    0x440

	OFFSET["CWorld", "m_player"] :=    0x2C
	
	OFFSET["UIMessengerGroupWnd", "m_itemList"] :=   0xc0
	OFFSET["UIMessengerGroupWnd", "m_gageList"] :=   0xec ; UIPcGage[40]
	OFFSET["UIMessengerGroupWnd", "m_curRadioBtn"] := OFFSET["UIMessengerGroupWnd"]["m_gageList"] + 40*4
	
	OFFSET["UIPcGage", "m_hpAmount"] :=   0x84
	OFFSET["UIPcGage", "m_hpTotalAmount"] :=   OFFSET["UIPcGage"]["m_hpAmount"] + 4
	OFFSET["UIPcGage", "m_spAmount"] :=   OFFSET["UIPcGage"]["m_hpAmount"] + 8
	OFFSET["UIPcGage", "m_spTotalAmount"] :=   OFFSET["UIPcGage"]["m_hpAmount"] + 12
	
	OFFSET["UIWindow", "m_w"] :=    0x8
	OFFSET["UIWindow", "m_h"] :=    OFFSET["UIWindow"]["m_w"]+0x4
	OFFSET["UIWindow", "m_x"] :=    OFFSET["UIWindow"]["m_h"]+0x4
	OFFSET["UIWindow", "m_y"] :=    OFFSET["UIWindow"]["m_x"]+0x4
	
	OFFSET["UIWindowMgr", "m_chooseWarpWnd"] :=    0x1E8
	OFFSET["UIWindowMgr", "m_messengerGroupWnd"] :=    0x2AC
	OFFSET["UIWindowMgr", "m_merchantShopMakeWnd"] :=    0x2E0
	OFFSET["UIWindowMgr", "m_makingArrowListWnd"] :=    0x358
	OFFSET["UIWindowMgr", "m_spellListWnd"] :=    0x360
	
	
	OFFSET["std::list", "Head"] :=    0x0
	OFFSET["std::list", "Size"] :=    0x4
	OFFSET["std::list::node", "Next"] :=    0x0
	OFFSET["std::list::node", "Prev"] :=    0x4
	OFFSET["std::list::node", "Value"] :=    0x8
	OFFSET["std::vector", "start"] :=    0x0
	OFFSET["std::vector", "end"] :=    0x4
	OFFSET["std::string", "ptr"] :=    0x0 ; default res seems to be 15
	OFFSET["std::string", "len"] :=    16 ; if the lenght exceeds the default res, the ptr is to a dynamically allocated buffer of len length
	OFFSET["std::string", "res"] :=    OFFSET["std::string"]["len"]+4
	SIZE["std::string"] :=   OFFSET["std::string"]["res"]+4

	OFFSET["CRenderObject", "m_pos"] :=    0x10
	OFFSET["CRenderObject", "m_curAction"] :=    0x34
	OFFSET["CRenderObject", "m_lastTlvertX"] :=    0xAC
	OFFSET["CRenderObject", "m_lastTlvertY"] :=    OFFSET["CRenderObject"]["m_lastTlvertX"]+4
	OFFSET["CRenderObject", "m_isPc"] :=    OFFSET["CRenderObject"]["m_lastTlvertX"]-4
	OFFSET["CRenderer", "m_hpc"] :=    0x0
	OFFSET["CRenderer", "m_vpc"] :=    OFFSET["CRenderer"]["m_hpc"]+4
	OFFSET["CRenderer", "m_xoffset"] :=    0x1c
	OFFSET["CRenderer", "m_yoffset"] :=    OFFSET["CRenderer"]["m_xoffset"]+4
	OFFSET["CView", "m_viewMatrix"] :=    0xC8
	OFFSET["CWorld", "m_gameObjectList"] :=    0x8
	OFFSET["CWorld", "m_actorList"] :=    0x10
	OFFSET["CWorld", "m_itemList"] :=    0x18
	OFFSET["CWorld", "m_skillList"] :=    0x20

	OFFSET["CActorPickNode", "m_region"] :=    0x4
	OFFSET["CActorPickNode", "m_child"] :=    0x14
	OFFSET["CActorPickNode", "m_pickInfoList"] :=    0x24
	OFFSET["CActorPickInfo", "m_vectors"] :=    0x0
	OFFSET["CActorPickInfo", "m_gid"] :=    4*3*2
	OFFSET["CActorPickInfo", "m_job"] :=    OFFSET["CActorPickInfo"]["m_gid"] + 4
	OFFSET["CActorPickInfo", "m_classType"] :=   OFFSET["CActorPickInfo"]["m_job"] + 4
	OFFSET["CActorPickInfo", "m_isPkState"] :=    OFFSET["CActorPickInfo"]["m_classType"] +4

	OFFSET["matrix", "v11"] :=    0x0
	OFFSET["matrix", "v12"] :=    0x4
	OFFSET["matrix", "v13"] :=    0x8
	OFFSET["matrix", "v21"] :=    0xc
	OFFSET["matrix", "v22"] :=    0x10
	OFFSET["matrix", "v23"] :=    0x14
	OFFSET["matrix", "v31"] :=    0x18
	OFFSET["matrix", "v32"] :=    0x1c
	OFFSET["matrix", "v33"] :=    0x20
	OFFSET["matrix", "v41"] :=    0x24
	OFFSET["matrix", "v42"] :=    0x28
	OFFSET["matrix", "v43"] :=    0x2c
	OFFSET["vector3d", "x"] :=    0x0
	OFFSET["vector3d", "y"] :=    0x4
	OFFSET["vector3d", "z"] :=    0x8

	OFFSET["FRIEND_INFO", "isValid"] :=   0
	OFFSET["FRIEND_INFO", "AID"] :=   4
	OFFSET["FRIEND_INFO", "GID"] :=   8
	OFFSET["FRIEND_INFO", "characterName"] :=   0xc
	OFFSET["FRIEND_INFO", "mapName"] :=   OFFSET["FRIEND_INFO"]["characterName"] + SIZE["std::string"]
	OFFSET["FRIEND_INFO", "role"] :=   OFFSET["FRIEND_INFO"]["mapName"] + SIZE["std::string"]
	OFFSET["FRIEND_INFO", "state"] :=   OFFSET["FRIEND_INFO"]["role"] + 4
	OFFSET["FRIEND_INFO", "color"] :=   OFFSET["FRIEND_INFO"]["role"] + 8
	
	OFFSET["ShortCutKey", "isSkill"] :=    0 ; len = 1 byte
	OFFSET["ShortCutKey", "ID"] :=    1 ; len = 4 byte..
	OFFSET["ShortCutKey", "count"] :=    5
	SIZE["ShortCutKey"] := OFFSET["ShortCutKey"]["count"]+2
