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
$page_security = $_POST['PARAM_0'] == $_POST['PARAM_1'] ?
	'SA_BUSSINESS_ORDER_LIST' : 'SA_BUSSINESS_ORDER_LIST';
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
include_once($path_to_root . '/bussiness/db/order_list_db.inc');

//----------------------------------------------------------------------------------------------------

print_salesman_list();


function GetSalesmanTrans($from, $to,$p1,$p2,$p3,$p4)
{
    $sql = get_order_master_data();

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

	$sql .= " order by months,name";

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

	//if ($summary == 0)/
//		$sum = _('No');
//	else
//		$sum = _('Yes');

	$dec = user_price_dec();

	$cols = array(0, 50, 250, 300, 380,430, 680, 800,950,1030,1130,1230,1330,1430,1530,1630,1730,1830);

	$headers = array(_('月份'), _('客商名称'), _('类型'), _('销售区域'), _('业务员'),	_('商品名称'),	_('规格'),_('生产企业'),	_('单价'),	_('上月库存'),	_('上月库存金额'),
	 	_('月度库存'),	_('月度库存金额'),	_('本月购进'),	_('本月购进金额'),	_('本月库存'),	_('本月库存金额'));

	$aligns = array('left',	'left',	'left', 'left', 'left', 'left',	'left','left',	'left',	'right', 'left', 'right', 'left',	'right', 'left',	'right','left','right');

	$headers2 = [];// array(_('Salesman'), ' ',	_('Phone'), _('Email'),	_('Provision'), _('Break Pt.'), _('Provision').' 2');

	$params =  [];//  array( 	0 => $comments,
				//		1 => array(  'text' => _('Period'), 'from' => $from, 'to' => $to),
			//			2 => array(  'text' => _('Summary Only'),'from' => $sum,'to' => ''));

	$aligns2 = $aligns;

	$rep = new FrontReport(_('销售产品进销存管理'), 'SalesmanListing', user_pagesize(), 48, $orientation);

	//if ($orientation == 'L')
	//	recalculate_cols($cols);

	$cols2 = $cols;
	$rep->Font();
	$rep->Info($params, $cols, $headers, $aligns, $cols2, $headers2, $aligns2);

	$rep->NewPage();
	//$salesman = 0;
	//$subtotal = $total = $subprov = $provtotal = 0;

	$result = GetSalesmanTrans($from, $to,$p1,$p2,$p3,$p4);

	$_fields = array('months','name','sales_type','sale_area','sale_man','item_name','item_spec','item_factory',
	'sale_price','last_month_qty','last_month_amount','out_qty','month_sale_amount',
	'qty','amount','month_stock_qty','month_stock_amount');
	
	$rep->SetFontSize(24);

	while ($myrow=db_fetch($result)) {
		foreach ($_fields as $key=> $_field) {
			if (in_array($key,[8,10,12,14,16])) {
				$rep->AmountCol($key, $key+1,$myrow[$_field],$dec);
			}
			else
			if (in_array($key,[9,11,13,15])) {
				$rep->TextCol($key, $key+1,number_format2($myrow[$_field],user_percent_dec()));	
			}
			else {
				$rep->TextCol($key, $key+1,$myrow[$_field]);
			} 
        }
		$rep->NewLine();

		/*if ($salesman != $myrow['salesman_code']) {
			if ($salesman != 0) {
				$rep->Line($rep->row - 8);
				$rep->NewLine(2);
				$rep->TextCol(0, 3, _('Total'));
				$rep->AmountCol(5, 6, $subtotal, $dec);
				$rep->AmountCol(6, 7, $subprov, $dec);
				$rep->Line($rep->row  - 4);
				$rep->NewLine(2);
			}
			$rep->TextCol(0, 2,	$myrow['salesman_code'].' '.$myrow['salesman_name']);
			$rep->TextCol(2, 3,	$myrow['salesman_phone']);
			$rep->TextCol(3, 4,	$myrow['salesman_email']);
			$rep->TextCol(4, 5,	number_format2($myrow['provision'], user_percent_dec()) .' %');
			$rep->AmountCol(5, 6, $myrow['break_pt'], $dec);
			$rep->TextCol(6, 7,	number_format2($myrow['provision2'], user_percent_dec()) .' %');
			$rep->NewLine(2);
			$salesman = $myrow['salesman_code'];
			$total += $subtotal;
			$provtotal += $subprov;
			$subtotal = 0;
			$subprov = 0;
		}
		$rate = $myrow['rate'];
		$amt = $myrow['InvoiceTotal'] * $rate;
		if ($myrow['provision2'] == 0)
			$prov = $myrow['provision'] * $amt / 100;
		else {
			$amt1 = min($amt, max(0, $myrow['break_pt']-$subtotal));
			$amt2 = $amt - $amt1;

			$prov = $amt1*$myrow['provision']/100 + $amt2*$myrow['provision2']/100;
		}
		if (!$summary) {
			$rep->TextCol(0, 1,	$myrow['trans_no']);
			$rep->TextCol(1, 2,	$myrow['DebtorName']);
			$rep->TextCol(2, 3,	$myrow['br_name']);
			$rep->TextCol(3, 4,	$myrow['customer_ref']);
			$rep->DateCol(4, 5,	$myrow['tran_date'], true);
			$rep->AmountCol(5, 6, $amt, $dec);
			$rep->AmountCol(6, 7, $prov, $dec);
			$rep->NewLine();
		}
		$subtotal += $amt;
		$subprov += $prov;*/
	}
	/*if ($salesman != 0) {
		$rep->Line($rep->row - 4);
		$rep->NewLine(2);
		$rep->TextCol(0, 3, _('Total'));
		$rep->AmountCol(5, 6, $subtotal, $dec);
		$rep->AmountCol(6, 7, $subprov, $dec);
		$rep->Line($rep->row  - 4);
		$rep->NewLine(2);
		$total += $subtotal;
		$provtotal += $subprov;
	} */
	//$rep->fontSize += 2;
	//$rep->TextCol(0, 3, _('Grand Total'));
	//$rep->fontSize -= 2;
	//$rep->AmountCol(5, 6, $total, $dec);
	//$rep->AmountCol(6, 7, $provtotal, $dec);
	//$rep->Line($rep->row  - 4);
	//$rep->NewLine();
	$rep->End();
}