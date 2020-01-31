SetBatchLines -1
SetKeyDelay -1,-1,-1
#MaxThreadsPerHotkey 1

#C::
{
	WinGet cPID, PID, A
	
	return  
}
#A::
{
	WinGet rPID, PID, A
	return  
}
#G::
{
	WinGet gPID, PID, A
	return
}

#P::
{
	WinGet pPID, PID, A
	return
}

#S::
{
	tickPala := 0
	Loop
	{
		if ( cPID )
		{
			ControlSend ,,n, ahk_pid %cPID%	
			Sleep 500
		}
		if ( rPID)
		{
			ControlSend ,,n, ahk_pid %rPID%	
			Sleep 500
		}
		
		if ( gPID )
		{
			ControlSend ,,n, ahk_pid %gPID%
			Sleep 500
		}
		
		if ( pPID && (A_TickCount - tickPala) >= 60000 )
		{
			ControlSend ,,n,ahk_pid %pPID%
			tickPala := A_TickCount
		}

		
		Sleep 1000
	}
	
	
	return
}
