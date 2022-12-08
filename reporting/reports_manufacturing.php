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
$path_to_root='..';
$page_security = 'SA_OPEN';
include_once($path_to_root . '/includes/session.php');

include_once($path_to_root . '/includes/date_functions.inc');
include_once($path_to_root . '/includes/data_checks.inc');
include_once($path_to_root . '/includes/ui.inc');
include_once($path_to_root . '/reporting/includes/reports_classes.inc');

$js = '';
if ($SysPrefs->use_popup_windows && $SysPrefs->use_popup_search)
	$js .= get_js_open_window(900, 500);
if (user_use_date_picker())
	$js .= get_js_date_picker();

add_js_file('reports.js');

page(_($help_context = '报表打印'), false, false, '', $js);

$reports = new BoxReports;

	$reports->addReportClass(_('生产制造'), RC_MANUFACTURE);
	$reports->addReport(RC_MANUFACTURE, 401, _('&BOM列表'),
		array(	_('从') => 'ITEMS',
				_('到') => 'ITEMS',
				_('说明') => 'TEXTBOX',
				_('方向') => 'ORIENTATION',
				_('目标文件') => 'DESTINATION'));
	$reports->addReport(RC_MANUFACTURE, 402, _('工单列表'),
		array(	_('商品') => 'ITEMS_ALL',
				_('货位') => 'LOCATIONS',
				_('完成状态') => 'YES_NO',
				//_('Show GL Rows') => 'YES_NO',
				_('备注') => 'TEXTBOX',
				_('打印方向') => 'ORIENTATION',
				_('目标文件') => 'DESTINATION'));
	$reports->addReport(RC_MANUFACTURE, 409, _('打印工单'),
		array(	_('From') => 'WORKORDER',
				_('To') => 'WORKORDER',
				_('Email Locations') => 'YES_NO',
				_('Comments') => 'TEXTBOX',
				_('Orientation') => 'ORIENTATION'));


add_custom_reports($reports);

echo $reports->getDisplay();

end_page();