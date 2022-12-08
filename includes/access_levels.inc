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
/*
Security sections groups various areas on both functionality and privilege levels.
Often analytic inquires are available only for management, and configuration
for administration or management staff. This is why we have those three
section type inside near every FA module.

Section codes 0-99 are reserved for core FA functionalities.
Every security section can contain up to 256 different areas.
External modules can extend security roles system by adding rows to
$security_sections and $security_areas using section codes >=100.
Security areas and sections created by extension modules/plugins
have dynamically assigned 3-byte integer codes. The highest byte is zero
for sections/areas defined in this file, and extid+1 for those defined
by extensions
 */
define('SS_SADMIN', 1 << 8); // 系统管理
define('SS_SETUP', 2 << 8); // 设置
define('SS_SPEC', 3 << 8); // 属性

define('SS_ANALYSIS', 4 << 8); // 统计分析
define('SS_BUSSINESS', 5 << 8); // 业务管理
define('SS_CUSTOMER', 6 << 8); // 客户管理
define('SS_MAUNF', 7 << 8); // 客户管理

define('RELA_PETS', 95);
define('RELA_FOOD', 96);
define('RELA_OTHER', 97); 
define('RELA_LOVE', 98); // 客户管理
define('RELA_FAMILY', 99); // 客户管理

$security_sections = array(
    SS_SADMIN => _('系统管理'),
    SS_SETUP => _('功能设置'),
    SS_SPEC => _('其他设置'), 
    
    SS_ANALYSIS => _('统计分析'),
    SS_BUSSINESS => _('业务管理'),
    SS_CUSTOMER => _('客户管理'),
    SS_MAUNF => _('生产制造管理')
   
);

/*
This table stores security areas available in FA.
Key is area identifier used to check user rights, values are
codes stored for each role in security_roles table and description used
in roles editor.

Set of allowed access areas codes is retrieved during user login from
security_roles table, and cached in user profile.

Special value 'SA_OPEN' is used for publicly available pages like login/logout.

 $this->add_rapp_function(0, _('潜在客户'), 'customers/leads.php', 'SA_CUTSTOMER_LEADS', MENU_BPGL);
        $this->add_rapp_function(0, _('机会业务'), 'customers/opportunity.php', 'SA_CUTSTOMER_OPPORTUNITY', MENU_BPGL);
       
        $this->add_module(_('日历管理'));
        $this->add_lapp_function(1, _('创建任务'), 'customers/task.php', 'SA_CUTSTOMER_TASK', MENU_BPGL);
        $this->add_lapp_function(1, _('安排活动'), 'customers/campaign.php', 'SA_CUTSTOMER_CAPMPAIGN', MENU_BPGL);
       
 */
$security_areas = array(
//
    //    Site administration
    //
    'SA_CREATECOMPANY' => array(SS_SADMIN | 1, _('安装组件')),
    'SA_CREATELANGUAGE' => array(SS_SADMIN | 2, _('安装语言')),
    'SA_CREATEMODULES' => array(SS_SADMIN | 3, _('安装更新')),
    'SA_SOFTWAREUPGRADE' => array(SS_SADMIN | 4, _('系统升级')),
    'SA_FISCALYEARS' => array(SS_SADMIN | 5, _('账务年度')),
//
    //    Company setup
    //


    'SA_SETUPCOMPANY' => array(SS_SETUP | 1, _('创建公司')),
    
    'SA_SECROLES' => array(SS_SETUP | 2, _('角色权限')),
    'SA_USERS' => array(SS_SETUP | 3, _('用户设置')),
    'SA_PRINTERS' => array(SS_SETUP | 4, _('打印机设置')),
    'SA_PRINTPROFILE' => array(SS_SETUP | 5, _('打印属性')),
    
    'SA_CREATEYEARACCOUNT'=> array(SS_SETUP | 6, _('创建财务帐套')),
    
    'SA_SYSRP'=> array(SS_SETUP | 9, _('设置收付项目')),
    'SA_BASEINFO_CUSTOMER' => array(SS_SETUP | 10, _('客户信息')),
    'SA_BASEINFO_PRODUCT' => array(SS_SETUP | 11, _('商品信息')),
    'SA_BASEINFO_AREA' => array(SS_SETUP | 12, _('销售区域')),
    'SA_BASEINFO_LEVEL' => array(SS_SETUP | 13, _('客户级别')),
    'SA_FORMSETUP' => array(SS_SETUP | 14, _('序号设置')),
    
    'SA_ITEM_CATEGORIES'=> array(SS_SETUP | 15, _('商品分类')),
    'SA_ITEM_LOCATION'=>array(SS_SETUP | 16, _('仓库货位')),
    'SA_ITEM_UNITS'=>array(SS_SETUP | 17, _('包装单位')),
    'SA_ITEM_TAX_TYPE'=>array(SS_SETUP | 18,_('税率分类')),
    'SA_TAX_TYPE'=>array(SS_SETUP | 19,_('税率')),
    //  -------------
    //  客户管理
    //  -------------

    'SA_CUSTOMER_INFO' => array(SS_CUSTOMER | 1, _('创建客户')),
    'SA_CUSTOMER_CONTACT' => array(SS_CUSTOMER | 2, _('创建联系')),
    'SA_CUSTOMER_OPPORTUNITY' => array(SS_CUSTOMER | 3, _('潜在客户')),
    'SA_CUSTOMER_CAPMPAIGN' => array(SS_CUSTOMER | 4, _('计划活动')),
    'SA_CUSTOMER_LEADS' => array(SS_CUSTOMER | 5, _('潜在客户')),
    'SA_CUSTOMER_TASK' => array(SS_CUSTOMER | 6, _('任务安排')),


    //  -------------
    //  业务管理
    //  -------------

    'SA_BUSSINESS_ORDER' => array(SS_BUSSINESS | 1, _('供货单/客商销售单录入')),
    'SA_BUSSINESS_RECEIVABLE' => array(SS_BUSSINESS | 2, _('应收账款录入')),
    'SA_BUSSINESS_ACTUAL_RECEIVABLE' => array(SS_BUSSINESS | 3, _('应付返利录入')),

    'SA_BUSSINESS_ORDER_LIST' => array(SS_BUSSINESS | 4,_('销售订单查询')),
    'SA_BUSSINESS_RECEIVABLE_LIST' => array(SS_BUSSINESS | 5, _('应收账款查询')),
    'SA_BUSSINESS_ACTUAL_RECEIVABLE_LIST' => array(SS_BUSSINESS | 6, _('应付返利查询')),
  
    'SA_BUSSINESS_SALE_PLAN' => array(SS_BUSSINESS | 7,_('销售计划录入')),
    'SA_BUSSINESS_SALE_LIST' => array(SS_BUSSINESS | 8,_('销售计划完成情况')),


     // ----------------
     //   生产制造管理
     // ----------------
    'SA_MANUF_ORDER' => array(SS_MAUNF | 1, _('工单处理')),
    'SA_MANUF_BOM_FIND' => array(SS_MAUNF | 2,_('成本物料查询')),
    'SA_MANUF_BOM_STOCK' => array(SS_MAUNF | 3,_('库存报表')),
    'SA_MANUF_ORDER_FIND' => array(SS_MAUNF | 4,_('工单查询')),
    'SA_MANUF_REPORT' => array(SS_MAUNF | 5,_('生产报告')),
    'SA_BOM' => array(SS_MAUNF | 6,_('物料清单')),
    'SA_WORK_CENTER' => array(SS_MAUNF | 6,_('工作中心')),
    'SA_MANUF_RELEASE' => array(SS_MAUNF | 7,_('发布工单')),
    'SA_MANUF_ISSUE' =>array(SS_MAUNF | 8,_('查看工单问题')),
    'SA_MANUF_RECEIVE' =>array(SS_MAUNF | 9,_('查看工单商品')),
    'SA_BOMREP' =>array(SS_MAUNF | 10,_('报表打印')),
    

     // ----------------
     //   统计分析
     // ----------------
     'SA_ANALYSIS_CUSTOMER' => array(SS_ANALYSIS | 1, _('每月新增客户销售统计')),
     'SA_ANALYSIS_FLLOW_CUSTOMER' => array(SS_ANALYSIS | 2,_('重点客户月销统计')),
     'SA_ANALYSIS_FLLOW_PRODUCT' => array(SS_ANALYSIS | 3,_('重点商品月统计')),
     'SA_ANALYSIS_FLLOW_PLAN' => array(SS_ANALYSIS | 4,_('商品采购计划统计')),
     'SA_ANALYSIS_RECEIVABLE' => array(SS_ANALYSIS | 5,_('应收账款统计')),
     'SA_ANALYSIS_ACTUAL_RECEIVABLE' => array(SS_ANALYSIS | 6,_('实收账款统计')),
 

    //
    // Special and common functions
    //
    'SA_BACKUP' => array(SS_SPEC | 1, _('备份/还原')),
    'SA_SETUPDISPLAY' => array(SS_SPEC | 2, _('显示属性')),
    'SA_CHGPASSWD' => array(SS_SPEC | 3, _('更换密码')),
    'SA_DESIGNER' => array(SS_SPEC | 4, _('报表设计器')),
    'SA_ATTACHDOCUMENT'=>array(SS_SPEC | 5, _('附件管理')),
    'SA_MULTIFISCALYEARS' => array(SS_SPEC|6, _('允许在非结束会计年度输入')),
    'SA_PRINT_DESIGNER' => array(SS_SPEC | 7, _('报表设置')),
   
);

if (!@$SysPrefs->allow_gl_reopen) {
    unset($security_areas['SA_GLREOPEN']);
}

/*
This function should be called whenever we want to extend core access level system
with new security areas and/or sections i.e.:
. on any page with non-standard security areas
. in security roles editor
The call should be placed between session.php inclusion and page() call.
Up to 155 security sections and 155 security areas for any extension can be installed.
 */
function add_access_extensions()
{
    global $security_areas, $security_sections, $installed_extensions;

    foreach ($installed_extensions as $extid => $ext) {
        $accext = hook_invoke($ext['package'], 'install_access', $dummy);
        if ($accext == null) {
            continue;
        }

        $scode = 100;
        $acode = 100;
        $extsections = $accext[1];
        $extareas = $accext[0];
        $extcode = $extid << 16;

        $trans = array();
        foreach ($extsections as $code => $name) {
            $trans[$code] = $scode << 8;
            // reassign section codes
            $security_sections[$trans[$code] | $extcode] = $name;
            $scode++;
        }
        foreach ($extareas as $code => $area) {
            $section = $area[0] & 0xff00;
            // extension modules:
            // if area belongs to nonstandard section
            // use translated section codes and
            // preserve lower part of area code
            if (isset($trans[$section])) {
                $section = $trans[$section];
            }

            // otherwise assign next available
            // area code >99
            $area[0] = $extcode | $section | ($acode++);
            $security_areas[$code] = $area;
        }
    }
}

function check_edit_access($name)
{
    global $input_security;

    $access = @$input_security[$name];

    if (!$access) {
        $access = @$input_security[''];
    }
    // default access level

    if (!$access) {
        return true;
    }
    // if constraint is not defined edit access is allowed

    return user_check_access($access);
}
/*
Returns POST value or null if edit access to $name control is forbidden.
 */
function access_post($name, $dflt = null)
{
    if (!check_edit_access($name)) {
        return $dflt;
    } else {
        return get_post($name, $dflt);
    }

}

/*
Returns numeric input value or null if edit access to $name control is forbidden.
 */
function access_num($name, $dflt = null)
{
    if (!check_edit_access($name)) {
        return $dflt;
    } else {
        return input_num($name, $dflt);
    }

}
