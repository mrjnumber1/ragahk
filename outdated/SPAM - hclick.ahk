#ifWinActive https://nostalgy
#HotkeyInterval 2000 ; This is the default value (milliseconds).
#MaxHotkeysPerInterval 1000000000
SetBatchLines -1
SetKeyDelay -1,-1,-1

$h::

Loop
{
	if not GetKeyState("h", "P")
		break
	Send h
	Click
}
Return
