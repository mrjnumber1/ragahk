<?php

$mobs = [];

// they must be loaded in this order ok
ReadMobDb('mob_db.txt');
ReadBranchList('mob_branch.txt');
ReadClassChangeList('mob_classchange.txt');
ReadMobSkillDb('mob_skill_db.txt');

function ReadClassChangeList($where)
{
	global $mobs;
	$file = file_get_contents($where);
	$lines = explode(PHP_EOL, $file);
	$bad_drops = [1039, 1112, 1157, 1190, 1272, 1418]; // screw it, good enough for now
	foreach ($lines as $line)
	{
		if (strlen($line) == 0 || ($line[0] == "/" && $line[1] == "/"))
			continue;
		$data = str_getcsv($line);
		
		if (strcasecmp(trim($data[0]), 'MOBG_ClassChange') || intval($data[1]) == 0)
			continue;
		
		$mid = intval($data[1]);
		$mobs[$mid]['is_classchange'] = true;
		$mobs[$mid]['worth_kill'] = !in_array($mid, $bad_drops);
	}
}

function ReadBranchList($where)
{
	global $mobs;
	$file = file_get_contents($where);
	$lines = explode(PHP_EOL, $file);
	
	$bad_drops = [1089, 1090, 1091, 1092, 1093, 1259, 1262, 1295, 1302, 1703, 1720, 1783, 1833];
	foreach ($lines as $line)
	{
		if (strlen($line) == 0 || ($line[0] == "/" && $line[1] == "/"))
			continue;	
		$data = str_getcsv($line);
		
		if (strcasecmp(trim($data[0]), 'MOBG_Branch_Of_Dead_Tree') || intval($data[1]) == 0)
			continue;
		
		$mid = intval($data[1]);
		$mobs[$mid]['is_branch'] = true;
		if ($mobs[$mid]['is_boss'])
		{
			$mobs[$mid]['worth_kill'] = !in_array($mid, $bad_drops);
		}
	}
}
function ReadMobDb($where)
{
	global $mobs;
	
	$file = file_get_contents($where);
	$lines = explode(PHP_EOL, $file);
	
	$bad_elements = [28, 48, 68, 88];
	$good_kills = [1096, 1034, 1045, 1056, 1117, 1120, 1130, 1163, 1178, 1203, 1204, 1205, 1219, 1271, 1275, 1278, 1283, 1289, 1293, 1306, 1374, 1582, 1620, 1631, 1638, 1681, 1717, 1736, 1830, 1976];
	$dangerous = [1268, 1297, 1320, 1376, 1379, 1382, 1438, 1474, 1477, 1622, 1634, 1635, 1636, 1637, 1639,1664, 1665, 1666, 1667, 1668, 1669, 1670, 1671, 1672, 1673, 1699, 1704, 1705, 1706, 1707, 1713, 1714, 1715, 1754, 1755, 1770, 1773, 1774, 1777, 1778, 1737, 1738, 1752, 1753, 1796, 1797, 1829, 1833, 1837, 1839, 1864, 1867, 1870, 1872, 1883, 1974, 1975, 1977, 1918, 1919, 1920, 1921, 1978, 1979, 1986, 1987, 1989, 1990, 1991, 1992, 1993, 1994, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2023, 2024];
	foreach ($lines as $line)
	{
		if (strlen($line) == 0 
			|| ($line[0] == "/" && $line[1] == "/"))
			continue;
			
		$mob = str_getcsv($line);
		
		$mid = intval($mob[0]);
		$name = strval(trim($mob[1]));
		$element = intval($mob[24]);
		$mode = intval($mob[25], 0);
		$is_ghost = in_array($element, $bad_elements);
		$is_boss = boolval($mode&0x4000000);
		$is_plant = boolval($mode&0x010000);
		
		$mobs[$mid]['mob_id'] = $mid;
		$mobs[$mid]['name'] = $name;
		
		$mobs[$mid]['is_ghost'] = $is_ghost;
		$mobs[$mid]['is_boss'] = $is_boss;
		$mobs[$mid]['is_plant'] = $is_plant;
		$mobs[$mid]['is_classchange'] = false;
		$mobs[$mid]['is_branch'] = false;
		$mobs[$mid]['is_slave'] = false;
		$mobs[$mid]['has_slaves'] = false;
		$mobs[$mid]['is_cc_slave'] = false;
		$mobs[$mid]['worth_kill'] = in_array($mid, $good_kills);
		$mobs[$mid]['dangerous'] = in_array($mid, $dangerous);
	}
}
function ReadMobSkillDb($where)
{
	global $mobs;
		
	$file = file_get_contents($where);
	$lines = explode(PHP_EOL, $file);

	$hide_skills = [25, 51, 135, 353];
	$summon_skills = [196, 209];

	foreach ($lines as $line)
	{
		if (strlen($line) == 0 
			|| ($line[0] == "/" && $line[1] == "/"))
			continue;
			
		$data = str_getcsv($line);

		$mid = intval($data[0]);
		$skid = intval($data[3]);
		
		if (in_array($skid, $hide_skills))
			$mobs[$mid]['is_hider'] = true;
		
		
		if (in_array($skid, $summon_skills))
		{
			if ($mobs[$mid]['is_branch'] || $mobs[$mid]['is_classchange'])
			{
				$mobs[$mid]['has_slaves'] = true;
				$slaves = [intval($data[12]), intval($data[13]), intval($data[14]), intval($data[15]), intval($data[16])];
				foreach ($slaves as $slave)
					if ($slave)
					{
						if ($mobs[$mid]['is_classchange'])
							$mobs[$slave]['is_cc_slave'] = true;
						$mobs[$slave]['is_slave'] = true;
					}
			}
		}
		
	}
	
}
function TimeStr($sec)
{
	$hr = floor($sec / 3600);
	$min = floor(($sec/60)%60);
	$sec = $sec%60;
	$str = "";
	if ($hr) $str = sprintf("%2dh",$hr);
	if ($min) $str = sprintf("%s%2dm", $str, $min);
	if ($sec) $str = sprintf("%s%2ds", $str, $sec);	
	
	return sprintf("%-9s", $str);
}

$i=0;

$creo_ignore = [];
$onlynpc_kill = []; // dangerous fags
$boltnpc_kill = []; // mvps who are ghost
$bombnpc_kill = [];
$bomb_kill = []; // mvps and guys worth killing who aren't ghost
$bolt_kill = []; // guys worth killing who are ghosts

/*$mobs[$mid]['is_ghost'] = $is_ghost;
$mobs[$mid]['is_boss'] = $is_boss;
$mobs[$mid]['is_plant'] = $is_plant;
$mobs[$mid]['is_classchange'] = false;
$mobs[$mid]['is_branch'] = false;
$mobs[$mid]['is_slave'] = false;
$mobs[$mid]['is_cc_slave'] = false;*/
foreach ($mobs as &$mob)
{
	if (!$mob['is_branch'] && !$mob['is_classchange'] && !$mob['is_slave']) // can't summon them? then ignore
		continue;
	extract($mob);

	// first mark any dangerous monsters as an npc kill
	if (	$dangerous 
		|| ($is_slave && $is_boss && !$worth_kill) 
		|| (!$is_boss && $has_slaves && !$worth_kill)
		|| ($is_boss && !$worth_kill && !$is_classchange))
	{
		$onlynpc_kill[] = $mob_id;
		$mob['kill'] = 'wipe';
		continue;
	}
	
	if ($is_classchange && !$worth_kill)
	{
		if ($is_ghost)
		{
			$boltnpc_kill[] = $mob_id;
			$mob['kill'] = 'BOLT, THEN WIPE';
		}
		else
		{
			$bombnpc_kill[] = $mob_id;
			$mob['kill'] = 'ACID, THEN WIPE';
		}
		continue;
	}

	// OK, now to determine how to kill it, if necessary
	if ($worth_kill)
	{
		if ($is_ghost) // ghosts must be bolted 
		{
			$bolt_kill[] = $mob_id;
			$mob['kill'] = 'BOLT';
		}
		else
		{
			$bomb_kill[] = $mob_id;
			$mob['kill'] = 'ACID';
		}
		
		continue;
	}
	
	if (!$is_boss)
	{
		if ($is_branch)
		{
			$mob['available'] = true;
		}
	}

}

$kl_ignore = [];
foreach ($mobs as $mob)
{
	$name = $mob['name'];
	$id = $mob['mob_id'];
	if (key_exists('available', $mob) || $mob['is_branch'] || $mob['is_classchange'])
	{
		$kl_ignore[] = $id;
	}
}

sort($boltnpc_kill);
sort($bombnpc_kill);
sort($onlynpc_kill);
sort($bomb_kill);
sort($bolt_kill);
sort($kl_ignore);

$arr = [	['kl_npcacid.txt', &$bombnpc_kill],
			['kl_npcbolt.txt', &$boltnpc_kill],
			['kl_npc.txt', &$onlynpc_kill], 
			['kl_acid.txt', &$bomb_kill], 
			['kl_bolt.txt', &$bolt_kill], 
			['kl_ignore.txt', &$kl_ignore], 
];
	
foreach ($arr as $k => $v)
{
	$fp = fopen($v[0], 'w');
	foreach ($v[1] as $mobid)
		fputs($fp, $mobid.PHP_EOL);
	fclose($fp);
}
/*
$fp = fopen('creo_npclist.txt', 'w')
echo "NPC Kills ".PHP_EOL;
foreach ($onlynpc_kill as $id)
{
	$name = $mobs[$id]['name'];
	echo "  {$name} ({$id})".PHP_EOL;
}

echo "Acid, then NPC kills: ".PHP_EOL;
foreach ($bombnpc_kill as $id)
{
	$name = $mobs[$id]['name'];
	echo "  {$name} ({$id})".PHP_EOL;
	fputs(
}

echo "Bolt, then NPC kills: ".PHP_EOL;
foreach ($boltnpc_kill as $id)
{
	$name = $mobs[$id]['name'];
	echo "  {$name} ({$id})".PHP_EOL;
}

echo "Acid Demo Kill: ".PHP_EOL;
foreach ($bomb_kill as $id)
{
	$name = $mobs[$id]['name'];
	echo "  {$name} ({$id})".PHP_EOL;
}

echo "Bolt Kill".PHP_EOL;
foreach ($bolt_kill as $id)
{
	$name = $mobs[$id]['name'];
	echo "  {$name} ({$id})".PHP_EOL;
}


echo "Safe to leave for CC: ".PHP_EOL;
foreach ($mobs as $mob)
{
	if (!key_exists('kill', $mob) && key_exists('available', $mob))
		echo "  {$mob['name']} ({$mob['mob_id']})".PHP_EOL;
}

echo PHP_EOL.PHP_EOL.PHP_EOL.'in mob id order: '.PHP_EOL;

foreach ($mobs as $mob)
{
	$name = $mob['name'];
	$id = $mob['mob_id'];
	if (key_exists('available', $mob) || $mob['is_branch'] || $mob['is_classchange'])
	{
		$kill = '';
		if (key_exists('kill', $mob))
			$kill = $mob['kill'];
		echo "{$name} ({$id}) - {$kill}".PHP_EOL;
	}
}

*/