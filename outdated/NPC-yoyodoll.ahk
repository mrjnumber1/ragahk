SetBatchLines -1
SetKeyDelay -1,-1,-1
#MaxThreadsPerHotkey 1

^S::
{
	ExitApp
	return
}


#S::
{
	ATTEMPTS := 39
	DELAY_NPC := 350
	DELAY_CHANGECHOICE := 200
	
	Loop %ATTEMPTS%
	{
		Click
		Sleep %DELAY_NPC%
		Loop 2 
		{ 
			Send {Enter} 
			Sleep %DELAY_NPC%
		}
		Send {Down}
		Sleep %DELAY_CHANGECHOICE%
		Loop 3 
		{ 
			Send {Enter} 
			Sleep %DELAY_NPC%
		}
		Loop 8
		{
			Send {Down} 
			Sleep %DELAY_CHANGECHOICE%
		}
		Loop 6
		{ 
			Send {Enter} 
			Sleep %DELAY_NPC%
		}
	}
		

	return
}