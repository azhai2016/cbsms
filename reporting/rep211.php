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
$page_security = 'SA_ANALYSIS_FLLOW_PLAN';
// ----------------------------------------------------------------
// $ Revision:	2.0 $
// Creator:	Joe Hunt
// date_:	2005-05-19
// Title:	Print Sales Quotations
// ----------------------------------------------------------------
$path_to_root='..';

include_once($path_to_root . '/includes/session.php');
include_once($path_to_root . '/includes/date_functions.inc');
include_once($path_to_root . '/includes/data_checks.inc');
include_once($path_to_root . '/statistice/db/plan_db.inc');

//----------------------------------------------------------------------------------------------------

print_salesman_list();


function GetSalesmanTrans($from, $to,$p1,$p2,$p3,$p4)
{
    $sql = get_plan_list_data();

	if ($p1) {
      $sql.= " and item_name like ".db_escape('%'.$p1.'%');
	}

	if ($p2) {
      $sql.= " and c.name like ".db_escape('%'.$p2.'%');
	}

	if ($p3) {  
	  $sql.= " and c.sale_man =".db_escape($p3);
	}

	if ($p4) {  
		$sql.= " and c.sale_area_code =".db_escape($p4);
	}

	$sql .= " order by item_name";


	$result = db_query($sql, 'No transactions were returned');
	
    return $result;
}

function print_salesman_list() {
	global $path_to_root;

	$from = $_POST['PARAM_0'];
	$to = $_POST['PARAM_1'];
	$p1 = urldecode($_POST['PARAM_2']);
	$p2 = urldecode($_POST['PARAM_3']);
	$p3 = urldecode($_POST['PARAM_4']);
	$destination = $_POST['PARAM_5'];
	$p4 = urldecode($_POST['PARAM_6']);
	if ($destination)
		include_once($path_to_root . '/reporting/includes/excel_report.inc');
	else
		include_once($path_to_root . '/reporting/includes/pdf_report.inc');

	$orientation ='L'; //($orientation ? 'L' : 'P');
	$dec = user_price_dec();

	$cols = array(0, 50, 250, 400, 500,600, 680, 780,980,1080,1180);


	$headers = array(_('计划日期'), _('商品信息'), _('客户名称'),	_('销售区域'),	_('片区'),_('客户地址'), _('业务员'),_('计划数量'),_('计划金额'),	_('备注'));

	$aligns = array('left',	'left',	'left', 'left', 'left', 'left',	'left', 'left', 'right','right');

	$headers2 = [];// array(_('Salesman'), ' ',	_('Phone'), _('Email'),	_('Provision'), _('Break Pt.'), _('Provision').' 2');

	$params =  [];//  array( 	0 => $comments,
				//		1 => array(  'text' => _('Period'), 'from' => $from, 'to' => $to),
			//			2 => array(  'text' => _('Summary Only'),'from' => $sum,'to' => ''));

	$aligns2 = $aligns;

	$rep = new FrontReport(_('采购商品计划表'), 'SalesmanListing', user_pagesize(), 48, $orientation);

	//if ($orientation == 'L')
	//	recalculate_cols($cols);

	$cols2 = $cols;
	$rep->Font();
	$rep->Info($params, $cols, $headers, $aligns, $cols2, $headers2, $aligns2);

	$rep->NewPage();
	//$salesman = 0;
	//$subtotal = $total = $subprov = $provtotal = 0;

	$result = GetSalesmanTrans($from, $to,$p1,$p2,$p3,$p4);

	$_fields = array('plan_at','item_name','customer_name','sale_area','area','address','sale_man','qty','total','description');
	
	$rep->SetFontSize(24);

	while ($myrow=db_fetch($result)) {
		foreach ($_fields as $key=> $_field) {
			$rep->TextCol($key, $key+1,$myrow[$_field]);
	    }
		$rep->NewLine();
	}
	
	$rep->End();
}