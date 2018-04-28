<?php
/***************************************************************************
 *
 *   NewPoints Ref Payout Plugin (/inc/plugins/newpoints/newpoints_refpayout.php)
 *	 Author: jacktheking (aka inTech https://keybase.io/intech)
 *   Copyright: © 2015 jacktheking
 *   
 *   Website: https://keybase.io/intech
 *
 *   A referral payout plugin for NewPoints.
 *
 ***************************************************************************/
 
/****************************************************************************
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
****************************************************************************/

// Disallow direct access to this file for security reasons
if(!defined("IN_MYBB"))
{
	die("Direct initialization of this file is not allowed.<br /><br />Please make sure IN_MYBB is defined.");
}

$plugins->add_hook("datahandler_post_insert_post", "newpoints_refpayout_post");
$plugins->add_hook("datahandler_post_insert_thread", "newpoints_refpayout_thread");

function newpoints_refpayout_info()
{
	/**
	 * Array of information about the plugin.
	 * name: The name of the plugin
	 * description: Description of what the plugin does
	 * website: The website the plugin is maintained at (Optional)
	 * author: The name of the author of the plugin
	 * authorsite: The URL to the website of the author (Optional)
	 * version: The version number of the plugin
	 * guid: Unique ID issued by the MyBB Mods site for version checking
	 * compatibility: A CSV list of MyBB versions supported. Ex, "121,123", "12*". Wildcards supported.
	 */
	return array(
		"name"			=> "Ref Payout",
		"description"	=> "A plugin that give referral payout only if certain requirement is met.",
		"website"		=> "",
		"author"		=> "jacktheking",
		"authorsite"	=> "https://keybase.io/intech",
		"version"		=> "1.1",
		"guid" 			=> "",
		"compatibility" => "*"
	);
}

function newpoints_refpayout_activate()
{
	global $db, $mybb;
	// add settings
	// take a look at inc/plugins/newpoints.php to know exactly what each parameter means
	newpoints_add_setting('newpoints_refpayout_show', 'newpoints_refpayout', 'Enable Plugin', 'Set to yes if you want to enable this plugin.', 'yesno', 1, 1);
	newpoints_add_setting('newpoints_refpayout_postReq', 'newpoints_refpayout', 'Post Requirement', 'Set the amount of posts as requirement (number only).', 'text', 25, 2);
	newpoints_add_setting('newpoints_refpayout_amount', 'newpoints_refpayout', 'Amount', 'Set the amount of Points to give out if the requirement is met (number only).', 'text', 50, 3);
	newpoints_add_setting('newpoints_refpayout_startTime', 'newpoints_refpayout', 'Start Time', 'Referrer referred user who registered before the timestamp given will not be credited with credit for the referrer even whe post requirement is met. Set to 0 to disable. Do not change if you do not understand (number only).', 'text', time(), 4);
	rebuild_settings();
	
	global $db, $mybb;
	// insert newpoints_refpayout_paid row into the user database
	$db->write_query("ALTER TABLE ".TABLE_PREFIX."users ADD `newpoints_refpayout_paid` BOOLEAN NOT NULL DEFAULT FALSE");
}

function newpoints_refpayout_deactivate()
{
	global $db, $mybb;
	// delete settings
	// take a look at inc/plugins/newpoints.php to know exactly what each parameter means
	newpoints_remove_settings("'newpoints_refpayout_show'");
	newpoints_remove_settings("'newpoints_refpayout_postReq'");
	newpoints_remove_settings("'newpoints_refpayout_amount'");
	newpoints_remove_settings("'newpoints_refpayout_startTime'");
	rebuild_settings();
	
	global $db, $mybb;
	// delete newpoints_refpayout_paid row into the user database
	$db->write_query("ALTER TABLE ".TABLE_PREFIX."users DROP `newpoints_refpayout_paid`");
}

function newpoints_refpayout_post()
{
	global $db, $mybb, $post;
	
	if ($mybb->user['referrer'] == NULL)
		return;
	
	if ($mybb->user['newpoints_refpayout_paid'] == 1)
		return;
		
	if ($mybb->input['action'] != "do_newreply" || $post['savedraft'])
		return;
		
	if (!$mybb->user['uid'])
		return;
		
	if ($mybb->settings['newpoints_refpayout_show'] != 1)
		return;
	
	if (!ctype_digit($mybb->settings['newpoints_refpayout_postReq']))
		return;
	
	if (!ctype_digit($mybb->settings['newpoints_refpayout_amount']))
		return;
	
	if ($mybb->user['regdate'] >= $mybb->settings['newpoints_refpayout_startTime'])
	{
		if ($mybb->user['postnum']+1 == $mybb->settings['newpoints_refpayout_postReq'])
		{
			newpoints_addpoints($mybb->user['referrer'], $mybb->settings['newpoints_refpayout_amount'], $forumrate = 1, $grouprate = 1, $isstring = false, $immediate = false);
			$db->write_query("UPDATE ".TABLE_PREFIX."users SET `newpoints_refpayout_paid` = '1' WHERE ".TABLE_PREFIX."users.uid = ".$mybb->user['uid']."");
		}
		else
		{
			return;
		}
	}
	else
	{
		return;
	}
}

function newpoints_refpayout_thread()
{
	global $db, $mybb, $thread;
	
	if ($mybb->user['referrer'] == NULL)
		return;
	
	if ($mybb->user['newpoints_refpayout_paid'] == 1)
		return;
		
	if ($mybb->input['action'] != "do_newthread" || $mybb->input['savedraft'])
		return;
		
	if (!$mybb->user['uid'])
		return;
		
	if ($mybb->settings['newpoints_refpayout_show'] != 1)
		return;
	
	if (!ctype_digit($mybb->settings['newpoints_refpayout_postReq']))
		return;
	
	if (!ctype_digit($mybb->settings['newpoints_refpayout_amount']))
		return;
	
	if ($mybb->user['regdate'] >= $mybb->settings['newpoints_refpayout_startTime'])
	{
		if ($mybb->user['postnum']+1 == $mybb->settings['newpoints_refpayout_postReq'])
		{
			newpoints_addpoints($mybb->user['referrer'], $mybb->settings['newpoints_refpayout_amount'], $forumrate = 1, $grouprate = 1, $isstring = false, $immediate = false);
			$db->write_query("UPDATE ".TABLE_PREFIX."users SET `newpoints_refpayout_paid` = '1' WHERE ".TABLE_PREFIX."users.uid = ".$mybb->user['uid']."");
		}
		else
		{
			return;
		}
	}
	else
	{
		return;
	}
}