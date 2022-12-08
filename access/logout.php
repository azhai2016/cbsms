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

define('FA_LOGOUT_PHP_FILE', '');

$page_security = 'SA_OPEN';
$path_to_root = '..';

include $path_to_root . '/includes/session.php';
add_js_file('login.js');
include $path_to_root . '/includes/page/header.inc';

page_header(_('注销'), true, false, '');

echo "<table width='100%' border='0'>
	<tr>
		<td align='center'><img src='" . $path_to_root . "/themes/default/images/fourbro.png' alt='CBSMS' width='250' onload='fixPNG(this)' ></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><div align='center'><font size=2>";
echo _('感谢您使用') . ' ';

echo '<strong>' . $SysPrefs->app_title . ' ' . $version . '</strong>';

echo "</font></div></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td><div align='center'>";

echo "<a href='" . $path_to_root . "/index.php'><b>" . _('重新登录') . '</b></a>';
echo "</div></td>
	</tr>
</table><br>\n";

end_page(false, true);
session_unset();
@session_destroy();