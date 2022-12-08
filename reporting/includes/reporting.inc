<?php
/**********************************************************************
	Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
	See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
// Link to printing single document with bulk report template file.
// Ex. label_cell(print_document_link($myrow['order_no'], _('Print')), $type);
// or display_note(print_document_link($order_no, _('Print this order')));
// You only need full parameter list for invoices/credit notes

function print_document_link($doc_no, $link_text, $type_no, $icon=false, $class='printlink', $id='', $email=0, $extra=0) {
	global $path_to_root;
	include_once($path_to_root . '/includes/types.inc');
	include_once($path_to_root . '/admin/db/designer_db.inc');

	$url = $path_to_root.'/reporting/prn_redirect.php?';
	$def_orientation = (user_def_print_orientation() == 1 ? 1 : 0);

	switch ($type_no) {
		case ST_ORDER_ID :
			$rep = 111;
			$ar = array(
				'PARAM_0' => $id['from'], 
				'PARAM_1' => $id['to'], 
				'PARAM_2' => urlencode($id['pname']), 
				'PARAM_3' => urlencode($id['cname']), 
				'PARAM_4' => urlencode($id['sname']),
				'PARAM_5' =>1,// $def_orientation);
				'PARAM_6' =>$id['area_code']);
			break;
		case ST_PLAN_ID:
				$rep = 211;
				$ar = array(
					'PARAM_0' => $id['from'], 
					'PARAM_1' => $id['to'], 
					'PARAM_2' => urlencode($id['pname']), 
					'PARAM_3' => urlencode($id['cname']), 
					'PARAM_4' => urlencode($id['sname']),
					'PARAM_5' =>1,// $def_orientation);
					'PARAM_6' =>$id['area_code']);
				break;	
		case SP_WORKORDER:
			$rep = 'json';
			$id = get_mod_id(SP_WORKORDER);
			log_b($id);
			$id = $id['id'];
			$ar = array(
				'PARAM_0' => '', 
				'PARAM_1' => '', 
				'PARAM_2' => '', 
				'PARAM_3' => '', 
				'PARAM_4' => '',
				'PARAM_5' =>1,
				'PARAM_6' => '',
				'PARAM_7' => '',
				'PARAM_8' => '',
				'print_id'=>$id,
				'doc_no'=>$doc_no
			);   
			break;	
		default:
			return null;
	}

	return print_link($link_text, $rep, $ar, '', $icon, $class, $id);
}

//
//	Universal link to any kind of report.
//
function print_link($link_text, $rep, $pars = array(), $dir = '', $icon=false, $class='printlink', $id='') {
	global $path_to_root, $SysPrefs;

	$url = $dir == '' ?  $path_to_root.'/reporting/prn_redirect.php?' : $dir;

	$id = default_focus($id);
	$parm = array();
	foreach($pars as $par => $val) {
		if ($val != "")
			$parm[] = "$par=".urlencode($val);
	}
	$parm[] = 'REP_ID='.urlencode($rep);
	$url .= implode ('&', $parm);
	

	if ($class != '')
		$class = $SysPrefs->pdf_debug ? '' : " class='$class'";
	
	$pars = access_string($link_text);

	if (user_graphic_links() && $icon)
		$pars[0] = set_icon($icon, $pars[0]);

	return "<a target='_blank' onclick='if(confirm('是否真的导出吗？')==false) return false;' style='text-decoration:none;color:#000' href='$url'$class $pars[1]>$pars[0]$link_text</a>";
}




function print_url($doc_no, $link_text, $type_no, $icon=false, $class='printlink', $id='', $email=0, $extra=0){
	global $path_to_root;
	include_once($path_to_root . '/includes/types.inc');

	$url = $path_to_root.'/reporting/prn_redirect.php?';
	$def_orientation = (user_def_print_orientation() == 1 ? 1 : 0);

	switch ($type_no) {
		case ST_ORDER_ID :
			$rep = 111;
			// from, to, currency, email, comments, orientation
			$ar = array(
				'PARAM_0' => $doc_no, 
				'PARAM_1' => $doc_no, 
				'PARAM_2' => '', 
				'PARAM_3' => $email, 
				'PARAM_4' => '',
				'PARAM_5' =>1);// $def_orientation);
			break;	
		case ST_PLAN_ID:
				
			break;
	}
	
	return _print_link_url($link_text, $rep, $ar, '', $icon, $class, $id);
}

function _print_link_url($link_text, $rep, $pars = array(), $dir = '', $icon=false, $class='printlink', $id='') {
	global $path_to_root, $SysPrefs;

	$url = $dir == '' ?  $path_to_root.'/reporting/prn_redirect.php?' : $dir;

	$id = default_focus($id);
	foreach($pars as $par => $val) {
		$pars[$par] = "$par=".urlencode($val);
	}
	$pars[] = 'REP_ID='.urlencode($rep);
	$url .= implode ('&', $pars);

	if ($class != '')
		$class = $SysPrefs->pdf_debug ? '' : " class='$class'";
	if ($id != '')
		$id = " id='$id'";
	$pars = access_string($link_text);
	if (user_graphic_links() && $icon)
		$pars[0] = set_icon($icon, $pars[0]);
    
	return "location:'$url'";
}



/*
// Purpose: Function to parse a string into parameters
// Release Date: 2014-12-26
// Author: ApMuthu <apmuthu@usa.net>
// Usage:
$str = "PPFrt#2000 CID#6378465 TaxEx#2345-038 abcde ertrgdert COD#4253 jdegtd PIN#6473654";
$p = parse_notes_params($str);
echo print_r($p, true);

An example of usage will be in the reporting/rep110.php file at near the end just before the last $rep-Font(); statement: 


	$notes_params = parse_notes_params($branch['notes']);
	if ($packing_slip == 0 && array_key_exists('CID', $notes_params)) {
		$rep->NewLine(1);
		$rep->TextCol(1, 7, "Old Customer# : " . $notes_params['CID'], - 2);
	}
*/

function parse_notes_params($str, $sep=" ", $delim="#") {
	$str_params = explode($sep, $str);
	$param_array=Array('notes' => '');
	foreach ($str_params AS $str_param) {
		$param_set=explode($delim, trim($str_param));
		$key = (array_key_exists(0, $param_set) ? trim($param_set[0]) : '');
		$val = (array_key_exists(1, $param_set) ? trim($param_set[1]) : '');
		if (strlen($key) > 0 && strlen($val) > 0)
			$param_array[$key]=$val;
		else {
			// stop at first missing parameter set
			// break;
			// Collect the rest into notes
			$param_array['notes'] .= (' ' .  $str_param);
		}
	}
	$param_array['notes'] = trim($param_array['notes']);
	return $param_array;
}
