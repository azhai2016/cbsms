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
//----------------------------------------------------------------------------------
//    CbSMS global system names. They have to be stored separate from
//    sys types defines to enable inclusion after every language change
//    (which happens for multilanguage bulk reports)
//
global $print_actions,$systypes_array, $bank_account_types, $bank_transfer_types, $payment_person_types, $wo_types_array, $wo_cost_types, $class_types, $quick_actions, $quick_entry_types, $stock_types, $tag_types, $bank_owner;

$systypes_array = array(
    ST_ORDER_ID => _('供货单编号'),
    ST_PRODUCT_ID => _('商品编号'),
    ST_CUSTOMER_ID => _('客户编号'),
    ST_SALE_ORDER_ID => _('客销订单号'),
    ST_RECEIVABLE_ID => _('应收账款编号'),
    ST_ACTUAL_ID => _('应付账款编号'),
    ST_PLAN_ID => _('计划单号'),
    ST_WORKORDER => _('工单单号'),
    ST_MANURECEIVE => _('生产单号'),
    ST_MANUISSUE => _('发布单号')

);

$type_shortcuts = array(
    ST_ORDER_ID => _('OR'),
    ST_PRODUCT_ID => _('PI'),
    ST_CUSTOMER_ID => _('CI'),
    ST_SALE_ORDER_ID => _('SO'),
    ST_RECEIVABLE_ID => _('RV'),
    ST_ACTUAL_ID => _('AT'),
    ST_PLAN_ID => _('PN'),
    ST_WORKORDER => _('WO'),
    ST_MANURECEIVE => _('MR'),
    ST_MANUISSUE =>  _('MI')
);

$print_actions = array(
   SP_SALEORDER => _('销售单打印'),
   SP_SALEREPORT => _('销售报表'),
   SP_WORKORDER => _('未完成工单打印')  
);

//----------------------------------------------------------------------------------
//    Quick entry types
//
$quick_actions = array(
    '=' => _('Remainder'), // post current base amount to GL account
    'a' => _('Amount'), // post amount to GL account
    'a+' => _('Amount, increase base'), // post amount to GL account and increase base
    'a-' => _('Amount, reduce base'), // post amount to GL account and reduce base
    '%' => _('% amount of base'), // store acc*amount% to GL account
    '%+' => _('% amount of base, increase base'), // ditto & increase base amount
    '%-' => _('% amount of base, reduce base'), // ditto & reduce base amount
    'T' => _('Taxes added'), // post taxes calculated on base amount
    'T+' => _('Taxes added, increase base'), // ditto & increase base amount
    'T-' => _('Taxes added, reduce base'), // ditto & reduce base amount
    't' => _('Taxes included'), // post taxes calculated on base amount
    't+' => _('Taxes included, increase base'), // ditto & increase base amount
    't-' => _('Taxes included, reduce base'), // ditto & reduce base amount
);

// This month array is for use with the last 3 dateformats.
$tmonths = array('', _('一'), _('二'), _('三'), _('四'), _('五'), _('六'), _('七'), _('八'), _('九'), _('十'), _('十一'), _('十二'));


//----------------------------------------------------------------------------------
// Types of stock items
$item_types = array(
	'M' => _('生产制造类'),
	'B' => _('订单类'),
	'D' => _('服务类'),
  'T' => _('交易类')
);


$supported_collations = array(
	'utf8' => _('Unicode(多语言)')
);

//----------------------------------------------------------------------------------
//	Manufacturing types
//
$wo_types_array = array (
	WO_ASSEMBLY => _('装配'),
	WO_UNASSEMBLY => _('取消装配'),
	WO_ADVANCED => _('先进制造')
);

$wo_cost_types = array(
	WO_LABOUR => _('人工成本'),
	WO_OVERHEAD => _('间接费用'),
	WO_MATERIALS => _('材料')
);


$genders = array('保密','男','女');

$relationships = array(
    RELA_LOVE=>array(
      '%s的情侣',
      '%s的配偶',
      '%s的约会对象',
      '%s的情人',
      '%s喜欢的人',
      '%s的追求者',
      '%s前女友',
      '%s前妻'
    ),
    RELA_FAMILY=>array(
       '%s的母亲',
       '%s的女儿',
       '%s的姐妹',
       '%s的祖母',
       '%s的孙女',
       '%s的叔叔/阿姨',
       '%s的外甥/外甥女',
       '%s的堂兄弟/堂姐妹',
       '%s的继母',
       '%s的继女'  
    ),
    RELA_OTHER =>array(
      '%s的朋友',
      '%s的基友/闺密',
      '%s的同事',
      '%s的上司',
      '%s的下属',
      '%s的老师'
    ),

);