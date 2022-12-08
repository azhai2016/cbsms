<?php

//----------------------------------------------------------------------------------
//    CbSMS system transaction types
//
define('ST_JOURNAL', 0);

define('ST_ORDER_ID', 1);
define('ST_SALE_ORDER_ID', 2);
define('ST_RECEIVABLE_ID', 3);
define('ST_ACTUAL_ID', 4);
define('ST_PRODUCT_ID', 5);
define('ST_CUSTOMER_ID', 6);
define('ST_PLAN_ID', 7);
define('ST_WORKORDER', 8);
define('ST_MANUISSUE', 9);
define('ST_LOCTRANSFER', 10);
define('ST_INVADJUST', 11);
define('ST_COSTUPDATE', 12);
define('ST_MANURECEIVE', 13);


//------------------------------------------------------------------------------------
// print
define('SP_WORKORDER', 101);
define('SP_SALEORDER', 201);
define('SP_SALEREPORT', 202);








//----------------------------------------------------------------------------------
//    Special option values for various list selectors.
//
define('ANY_TEXT', '');
define('ANY_NUMERIC', -1);
define('ALL_TEXT', '');
define('ALL_NUMERIC', -1);

//----------------------------------------------------------------------------------
// Special class values for tables (start_table())
define('TABLESTYLE', 1);
define('TABLESTYLE2', 2);
define('TABLESTYLE_NOBORDER', 3);


include_once($path_to_root . '/manufacturing/includes/manufacturing_db.inc');

//----------------------------------------------------------------------------------
//	Manufacturing types
//
define('WO_ASSEMBLY', 0);
define('WO_UNASSEMBLY', 1);
define('WO_ADVANCED', 2);

define('WO_LABOUR', 0);
define('WO_OVERHEAD', 1);
define('WO_MATERIALS', 2);




include_once $path_to_root . '/includes/sysnames.inc';

// Constants optionally redefined locally
//
defined('ICON_EDIT') || define('ICON_EDIT', 'btn_warning fas fa-pen');
defined('ICON_DELETE') || define('ICON_DELETE', 'btn_danger fas fa-trash-alt');
defined('ICON_ADD') || define('ICON_ADD', 'btn_ok fas fa-check-circle');
defined('ICON_UPDATE') || define('ICON_UPDATE', 'btn_ok fas fa-check-circle');
defined('ICON_OK') || define('ICON_OK', 'btn_ok fas fa-check-circle');
defined('ICON_CANCEL') || define('ICON_CANCEL', 'btn_danger fas fa-times-circle');
defined('ICON_GL') || define('ICON_GL', 'fas fa-book');
defined('ICON_PRINT') || define('ICON_PRINT', 'btn_grey fas fa-print');
defined('ICON_PDF') || define('ICON_PDF', 'fas fa-file-pdf');
defined('ICON_DOC') || define('ICON_DOC', 'btn_ok fas fa-file-export');
defined('ICON_CREDIT') || define('ICON_CREDIT', 'btn_green fas fa-file-import');
defined('ICON_RECEIVE') || define('ICON_RECEIVE', 'btn_ok fas fa-file-import');
defined('ICON_DOWN') || define('ICON_DOWN', 'btn_ok fas fa-cloud-download-alt');
defined('ICON_MONEY') || define('ICON_MONEY', 'btn_green far fa-money-bill-alt');
defined('ICON_REMOVE') || define('ICON_REMOVE', 'btn_danger fas fa-trash-alt');
defined('ICON_REPORT') || define('ICON_REPORT', 'fas fa-file-pdf');
defined('ICON_VIEW') || define('ICON_VIEW', 'fas fa-search');
defined('ICON_SUBMIT') || define('ICON_SUBMIT', 'btn_ok fas fa-check-circle');
defined('ICON_ESCAPE') || define('ICON_ESCAPE', 'btn_danger fas fa-times-circle');
defined('ICON_ALLOC') || define('ICON_ALLOC', 'fas fa-exchange-alt');
defined('ICON_CLOSED') || define('ICON_CLOSED', 'btn_danger fas fa-times-circle');
defined('ICON_PLUS') || define('ICON_PLUS', 'btn_ok fas fa-plus');
defined('ICON_PLUS_SQUARE') || define('ICON_PLUS_SQUARE', 'btn_ok fas fa-plus-square');
defined('ICON_ARROW_UP') || define('ICON_ARROW_UP', 'btn_ok fas fa-arrow-up');
defined('ICON_ARROW_RIGHT') || define('ICON_ARROW_RIGHT', 'btn_ok fas fa-arrow-right');
defined('ICON_ARROW_DOWN') || define('ICON_ARROW_DOWN', 'btn_ok fas fa-arrow-down');
defined('ICON_ARROW_LEFT') || define('ICON_ARROW_LEFT', 'btn_ok fas fa-arrow-left');

defined('ICON_CHEVRON_RIGHT') || define('ICON_CHEVRON_RIGHT', 'btn_ok fas fa-chevron-right');
defined('ICON_CHEVRON_DOWN') || define('ICON_CHEVRON_DOWN', 'btn_ok fas fa-chevron-down');
defined('ICON_CHEVRON_LEFT') || define('ICON_CHEVRON_LEFT', 'btn_ok fas fa-chevron-left');
defined('ICON_CHEVRON_UP') || define('ICON_CHEVRON_UP', 'btn_ok fas fa-chevron-up');

defined('ICON_ANGLE_DOUBLE_RIGHT') || define('ICON_ANGLE_DOUBLE_RIGHT', 'btn_ok fas fa-angle-double-right');
defined('ICON_ANGLE_DOUBLE_DOWN') || define('ICON_ANGLE_DOUBLE_DOWN', 'btn_ok fas fa-angle-double-down');
defined('ICON_ANGLE_DOUBLE_LEFT') || define('ICON_ANGLE_DOUBLE_LEFT', 'btn_ok fas fa-angle-double-left');
defined('ICON_ANGLE_DOUBLE_UP') || define('ICON_ANGLE_DOUBLE_UP', 'btn_ok fas fa-angle-double-up');


