
SET NAMES utf8;

-- 区域销售 -------------------------

DROP TABLE IF EXISTS `0_areas`;

CREATE TABLE `0_areas` (
	`area_code` int(11) NOT NULL AUTO_INCREMENT,
	`description` varchar(60) NOT NULL DEFAULT '',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`area_code`,`description`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

INSERT INTO `0_areas` VALUES
('1', '全流域', '0');

-- 附件信息 -------------------------

DROP TABLE IF EXISTS `0_attachments`;

CREATE TABLE `0_attachments` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`description` varchar(60) NOT NULL DEFAULT '',
	`type_no` int(11) NOT NULL DEFAULT '0',
	`trans_no` int(11) NOT NULL DEFAULT '0',
	`unique_name` varchar(60) NOT NULL DEFAULT '',
	`tran_date` date NOT NULL DEFAULT '0000-00-00',
	`filename` varchar(60) NOT NULL DEFAULT '',
	`filesize` int(11) NOT NULL DEFAULT '0',
	`filetype` varchar(60) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	KEY `type_no` (`type_no`,`trans_no`)
) ENGINE=InnoDB;


-- 图标分析表 -------------------------

DROP TABLE IF EXISTS `0_chart_class`;

CREATE TABLE `0_chart_class` (
	`cid` varchar(3) NOT NULL,
	`class_name` varchar(60) NOT NULL DEFAULT '',
	`ctype` tinyint(1) NOT NULL DEFAULT '0',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`cid`)
) ENGINE=InnoDB ;


INSERT INTO `0_chart_class` VALUES
('1', '商品分布', '1', '0'),
('2', '库存分析', '2', '0'),
('3', '入库分析', '4', '0'),
('4', '成本分析', '6', '0');


DROP TABLE IF EXISTS `0_chart_master`;

CREATE TABLE `0_chart_master` (
	`account_code` varchar(15) NOT NULL DEFAULT '',
	`account_code2` varchar(15) NOT NULL DEFAULT '',
	`account_name` varchar(60) NOT NULL DEFAULT '',
	`account_type` varchar(10) NOT NULL DEFAULT '0',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`account_code`),
	KEY `account_name` (`account_name`),
	KEY `accounts_by_type` (`account_type`,`account_code`)
) ENGINE=InnoDB ;

INSERT INTO `0_chart_master` VALUES
('1060', '', '客户', '1', '0'),
('9990', '', '年报', '12', '0');


DROP TABLE IF EXISTS `0_chart_types`;

CREATE TABLE `0_chart_types` (
	`id` varchar(10) NOT NULL,
	`name` varchar(60) NOT NULL DEFAULT '',
	`class_id` varchar(3) NOT NULL DEFAULT '',
	`parent` varchar(10) NOT NULL DEFAULT '-1',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	KEY `name` (`name`),
	KEY `class_id` (`class_id`)
) ENGINE=InnoDB ;

INSERT INTO `0_chart_types` VALUES
('1', '客户', '1', '-1', '0'),
('12', '常规', '4', '-1', '0');

-- CRM -------------------------

DROP TABLE IF EXISTS `0_crm_categories`;

CREATE TABLE `0_crm_categories` (
	`id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
	`type` varchar(20) NOT NULL COMMENT '类型',
	`action` varchar(20) NOT NULL COMMENT '部门',
	`name` varchar(30) NOT NULL COMMENT '名称',
	`description` tinytext NOT NULL COMMENT '说明',
	`system` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否系统用户',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `type` (`type`,`action`),
	UNIQUE KEY `type_2` (`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 ;

INSERT INTO `0_crm_categories` VALUES
('1', 'cust_branch', 'general', 'General', 'General contact data for customer branch (overrides company setting)', '1', '0'),
('12', 'supplier', 'invoice', 'Invoices', 'Invoice posting', '1', '0');

-- CRM -------------------------

DROP TABLE IF EXISTS `0_crm_contacts`;

CREATE TABLE `0_crm_contacts` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`person_id` int(11) NOT NULL DEFAULT '0' COMMENT 'foreign key to crm_persons',
	`type` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
	`action` varchar(20) NOT NULL COMMENT 'foreign key to crm_categories',
	`entity_id` varchar(11) DEFAULT NULL COMMENT 'entity id in related class table',
	PRIMARY KEY (`id`),
	KEY `type` (`type`,`action`)
) ENGINE=InnoDB;

-- CRM -------------------------

DROP TABLE IF EXISTS `0_crm_persons`;

CREATE TABLE `0_crm_persons` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`ref` varchar(30) NOT NULL,
	`name` varchar(60) NOT NULL,
	`name2` varchar(60) DEFAULT NULL,
	`address` tinytext,
	`phone` varchar(30) DEFAULT NULL,
	`phone2` varchar(30) DEFAULT NULL,
	`fax` varchar(30) DEFAULT NULL,
	`email` varchar(100) DEFAULT NULL,
	`lang` char(5) DEFAULT NULL,
	`notes` tinytext NOT NULL,
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	KEY `ref` (`ref`)
) ENGINE=InnoDB;


-- 年底列表设置 -------------------------

DROP TABLE IF EXISTS `0_fiscal_year`;

CREATE TABLE `0_fiscal_year` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`begin` date DEFAULT '0000-00-00',
	`end` date DEFAULT '0000-00-00',
	`closed` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `begin` (`begin`),
	UNIQUE KEY `end` (`end`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

INSERT INTO `0_fiscal_year` VALUES
('1', '2022-01-01', '2022-12-31', '1');


-- 商品列表信息 -------------------------

DROP TABLE IF EXISTS `0_item_codes`;

CREATE TABLE `0_item_codes` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`item_code` varchar(20) NOT NULL,
	`item_name` varchar(200) NOT NULL,
	`item_factory` varchar(100) NOT NULL,
	`item_spec` varchar(100) NOT NULL,
	`item_unit` varchar(10) NOT NULL,
	`item_approval_no` varchar(40) NOT NULL,
	`description` varchar(200) NOT NULL DEFAULT '',
	`quantity` double NOT NULL DEFAULT '1',
	`def_price` double NOT NULL DEFAULT '0' COMMENT '默认售价',
	`item_category` double NOT NULL DEFAULT '' COMMENT '商品分类',
	`material_cost` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '材料成本',
	`labour_cost` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '人工成本', 
	`overhead_cost` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '间接成本',
	`inactive` tinyint(1) NOT NULL DEFAULT '0'

	PRIMARY KEY (`id`),
	KEY `item_code` (`item_code`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `0_stock_category`;

CREATE TABLE `0_stock_category` (
	`category_id` int(11) NOT NULL AUTO_INCREMENT,
	`description` varchar(60) NOT NULL DEFAULT '',
	`dflt_tax_type` int(11) NOT NULL DEFAULT '1',
	`dflt_units` varchar(20) NOT NULL DEFAULT 'each',
	`dflt_mb_flag` char(1) NOT NULL DEFAULT 'B',
	`dflt_sales_act` varchar(15) NOT NULL DEFAULT '',
	`dflt_cogs_act` varchar(15) NOT NULL DEFAULT '',
	`dflt_inventory_act` varchar(15) NOT NULL DEFAULT '',
	`dflt_adjustment_act` varchar(15) NOT NULL DEFAULT '',
	`dflt_wip_act` varchar(15) NOT NULL DEFAULT '',
	`dflt_dim1` int(11) DEFAULT NULL,
	`dflt_dim2` int(11) DEFAULT NULL,
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	`dflt_no_sale` tinyint(1) NOT NULL DEFAULT '0',
	`dflt_no_purchase` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`category_id`),
	UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;


DROP TABLE IF EXISTS `0_tax_group_items`;

CREATE TABLE `0_tax_group_items` (
	`tax_group_id` int(11) NOT NULL DEFAULT '0',
	`tax_type_id` int(11) NOT NULL DEFAULT '0',
	`tax_shipping` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`tax_group_id`,`tax_type_id`)
) ENGINE=InnoDB ;

-- Data of table `0_tax_group_items` --

INSERT INTO `0_tax_group_items` VALUES
('1', '1', '1');

-- Structure of table `0_tax_groups` --

DROP TABLE IF EXISTS `0_tax_groups`;

CREATE TABLE `0_tax_groups` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(60) NOT NULL DEFAULT '',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

-- Data of table `0_tax_groups` --

INSERT INTO `0_tax_groups` VALUES
('1', '普通税', '3'),
('2', '增值税', '13');


-- Structure of table `0_tax_types` --

DROP TABLE IF EXISTS `0_tax_types`;

CREATE TABLE `0_tax_types` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`rate` double NOT NULL DEFAULT '0',
	`sales_gl_code` varchar(15) NOT NULL DEFAULT '',
	`purchasing_gl_code` varchar(15) NOT NULL DEFAULT '',
	`name` varchar(60) NOT NULL DEFAULT '',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

-- Data of table `0_tax_types` --

INSERT INTO `0_tax_types` VALUES
('1', '13', '2150', '2150', '税率', '0');


DROP TABLE IF EXISTS `0_item_tax_type_exemptions`;

CREATE TABLE `0_item_tax_type_exemptions` (
	`item_tax_type_id` int(11) NOT NULL DEFAULT '0',
	`tax_type_id` int(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`item_tax_type_id`,`tax_type_id`)
) ENGINE=InnoDB;

-- Data of table `0_item_tax_type_exemptions` --

-- Structure of table `0_item_tax_types` --

DROP TABLE IF EXISTS `0_item_tax_types`;

CREATE TABLE `0_item_tax_types` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(60) NOT NULL DEFAULT '',
	`exempt` tinyint(1) NOT NULL DEFAULT '0',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

-- Data of table `0_item_tax_types` --

INSERT INTO `0_item_tax_types` VALUES
('1', '增值税', '0', '0');


DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
	`abbr` varchar(20) NOT NULL,
	`name` varchar(40) NOT NULL,
	`decimals` tinyint(2) NOT NULL,
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`abbr`),
	UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

-- Data of table `0_item_units` --

INSERT INTO `0_item_units` VALUES
('盒', '盒', '0', '0'),
('支', '支', '0', '0');


DROP TABLE IF EXISTS `0_comments`;

CREATE TABLE `0_comments` (
	`type` int(11) NOT NULL DEFAULT '0',
	`id` int(11) NOT NULL DEFAULT '0',
	`date_` date DEFAULT '0000-00-00',
	`memo_` tinytext,
	UNIQUE KEY `type_id_date` (`type`,`id`,`date_`),
	KEY `type_and_id` (`type`,`id`)
) ENGINE=InnoDB ;

--  潜在客户 -----------------------------

DROP TABLE `0_leads`;

CREATE TABLE `0_leads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT 0  COMMENT '父ID',
  `name` varchar(30) NOT NULL COMMENT '联系信息',
  `gender` varchar(10) NOT NULL COMMENT '性别',
  `birthday` varchar(10) NOT NULL COMMENT '生日',
  `works` varchar(200) NULL DEFAULT '' COMMENT '工作单位',
  `address` varchar(200) NULL DEFAULT '' COMMENT '地址',
  `phone` varchar(200) NULL DEFAULT '' COMMENT '电话',
  `email` varchar(200) NULL DEFAULT '' COMMENT 'email',
  `relation` varchar(200) NOT NULL DEFAULT '' COMMENT '关系',
  `brand` varchar(20) NOT NULL DEFAULT '' COMMENT '类型',
  `chance` int NOT NULL DEFAULT 0 COMMENT '合作机会',
  `pets` varchar(200) NOT NULL DEFAULT '' COMMENT '宠物信息',
  `food` varchar(200) NOT NULL DEFAULT '' COMMENT '食物偏好',
  `status` varchar(200) NOT NULL DEFAULT '' COMMENT '备注',
  `createtime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


-- 任务管理 ------------------------------

DROP TABLE IF EXISTS `0_tasks`;

CREATE TABLE `0_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) NOT NULL COMMENT '任务主题',
  `begin_at` datetime NOT NULL DEFAULT '2022-01-01' COMMENT '开始日期',
  `end_at` datetime NOT NULL DEFAULT '2022-01-01' COMMENT '截止日期',
  `priority` int NOT NULL DEFAULT '0' COMMENT '优先',
  `relatedto` int NOT NULL DEFAULT '0' COMMENT '关联',
  `status` varchar(200) NOT NULL DEFAULT '' COMMENT '备注',
  `isfinished` int(1) NOT NULL DEFAULT '0' COMMENT '是否完成',
  `createtime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- 商品计划表 ----------------------------

DROP TABLE IF EXISTS `0_item_plans`;

CREATE TABLE `0_item_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` varchar(30) NOT NULL COMMENT '商品编号',
  `customer_id` varchar(30) NOT NULL COMMENT '客商编号',
  `plan_at` datetime NOT NULL DEFAULT '2022-01-01' COMMENT '月份',
  `total` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  `qty` int(11) NOT NULL DEFAULT '0' COMMENT '数量',
  `description` varchar(200) NOT NULL DEFAULT '' COMMENT '备注',
  `isfinished` int(1) NOT NULL DEFAULT '0' COMMENT '是否完成',
  `createtime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `0_item_units`;

CREATE TABLE `0_item_units` (
	`abbr` varchar(20) NOT NULL,
	`name` varchar(40) NOT NULL,
	`decimals` tinyint(2) NOT NULL,
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`abbr`),
	UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB ;

INSERT INTO `0_item_units` VALUES
('盒', '盒', '0', '0'),
('支', '支', '0', '0');


DROP TABLE IF EXISTS `0_stock_category`;

CREATE TABLE `0_item_category` (
	`category_id` int(11) NOT NULL AUTO_INCREMENT,
	`description` varchar(60) NOT NULL DEFAULT '',
	`units` varchar(20) NOT NULL DEFAULT 'each',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`category_id`),
	UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

-- 客户设置列表 -------------------------

DROP TABLE IF EXISTS `0_customers`;

CREATE TABLE `0_customers` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`code` varchar(20) NOT NULL DEFAULT '',
	`name` varchar(100) NOT NULL DEFAULT '',
	`description` varchar(200) NOT NULL DEFAULT '',
	`area` varchar(50) NOT NULL DEFAULT '' COMMENT '客户区域',
	`address` tinytext NOT NULL,
	`phone` varchar(30) NOT NULL DEFAULT '',
	`phone2` varchar(30) NOT NULL DEFAULT '',
	`fax` varchar(30) NOT NULL DEFAULT '',
	`email` varchar(100) NOT NULL DEFAULT '',
	`contact` varchar(30) NOT NULL DEFAULT '',
	`sale_man` varchar(30) NOT NULL DEFAULT '' COMMENT '业务员',
	`sale_area` varchar(30) NOT NULL DEFAULT '' COMMENT '销售区域',
	`sale_area_code` varchar(30) NOT NULL DEFAULT '' COMMENT '销售区域ID',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	`createtime` timestamp NOT NULL default CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	KEY `name` (`name`)
) ENGINE=InnoDB ;



DROP TABLE IF EXISTS `0_bom`;

CREATE TABLE `0_bom` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`parent` char(20) NOT NULL DEFAULT '',
	`component` char(20) NOT NULL DEFAULT '',
	`workcentre_added` int(11) NOT NULL DEFAULT '0',
	`loc_code` char(5) NOT NULL DEFAULT '',
	`quantity` double NOT NULL DEFAULT '1',
	PRIMARY KEY (`parent`,`component`,`workcentre_added`,`loc_code`),
	KEY `component` (`component`),
	KEY `id` (`id`),
	KEY `loc_code` (`loc_code`),
	KEY `parent` (`parent`,`loc_code`),
	KEY `workcentre_added` (`workcentre_added`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `0_workcentres`;

CREATE TABLE `0_workcentres` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` char(40) NOT NULL DEFAULT '',
	`description` char(50) NOT NULL DEFAULT '',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;




DROP TABLE IF EXISTS `0_workorders`;

CREATE TABLE `0_workorders` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`wo_ref` varchar(60) NOT NULL DEFAULT '',
	`loc_code` varchar(5) NOT NULL DEFAULT '',
	`units_reqd` double NOT NULL DEFAULT '1',
	`stock_id` varchar(20) NOT NULL DEFAULT '',
	`date_` date NOT NULL DEFAULT '0000-00-00',
	`type` tinyint(4) NOT NULL DEFAULT '0',
	`required_by` date NOT NULL DEFAULT '0000-00-00',
	`released_date` date NOT NULL DEFAULT '0000-00-00',
	`units_issued` double NOT NULL DEFAULT '0',
	`closed` tinyint(1) NOT NULL DEFAULT '0',
	`released` tinyint(1) NOT NULL DEFAULT '0',
	`additional_costs` double NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `wo_ref` (`wo_ref`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `0_wo_costing`;

CREATE TABLE `0_wo_costing` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`workorder_id` int(11) NOT NULL DEFAULT '0',
	`cost_type` tinyint(1) NOT NULL DEFAULT '0',
	`trans_type` int(11) NOT NULL DEFAULT '0',
	`trans_no` int(11) NOT NULL DEFAULT '0',
	`factor` double NOT NULL DEFAULT '1',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

-- Data of table `0_wo_costing` --

-- Structure of table `0_wo_issue_items` --

DROP TABLE IF EXISTS `0_wo_issue_items`;

CREATE TABLE `0_wo_issue_items` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`stock_id` varchar(40) DEFAULT NULL,
	`issue_id` int(11) DEFAULT NULL,
	`qty_issued` double DEFAULT NULL,
	`unit_cost` double NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB ;

-- Data of table `0_wo_issue_items` --

DROP TABLE IF EXISTS `0_loc_stock`;

CREATE TABLE `0_loc_stock` (
	`loc_code` char(5) NOT NULL DEFAULT '',
	`stock_id` char(20) NOT NULL DEFAULT '',
	`reorder_level` double NOT NULL DEFAULT '0',
	PRIMARY KEY (`loc_code`,`stock_id`),
	KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB ;


DROP TABLE IF EXISTS `0_locations`;

CREATE TABLE `0_locations` (
	`loc_code` varchar(5) NOT NULL DEFAULT '',
	`location_name` varchar(60) NOT NULL DEFAULT '',
	`delivery_address` tinytext NOT NULL,
	`phone` varchar(30) NOT NULL DEFAULT '',
	`phone2` varchar(30) NOT NULL DEFAULT '',
	`fax` varchar(30) NOT NULL DEFAULT '',
	`email` varchar(100) NOT NULL DEFAULT '',
	`contact` varchar(30) NOT NULL DEFAULT '',
	`fixed_asset` tinyint(1) NOT NULL DEFAULT '0',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`loc_code`)
) ENGINE=InnoDB ;

-- Structure of table `0_wo_issues` --

DROP TABLE IF EXISTS `0_wo_issues`;

CREATE TABLE `0_wo_issues` (
	`issue_no` int(11) NOT NULL AUTO_INCREMENT,
	`workorder_id` int(11) NOT NULL DEFAULT '0',
	`reference` varchar(100) DEFAULT NULL,
	`issue_date` date DEFAULT NULL,
	`loc_code` varchar(5) DEFAULT NULL,
	`workcentre_id` int(11) DEFAULT NULL,
	PRIMARY KEY (`issue_no`),
	KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB ;

-- Data of table `0_wo_issues` --

-- Structure of table `0_wo_manufacture` --

DROP TABLE IF EXISTS `0_wo_manufacture`;

CREATE TABLE `0_wo_manufacture` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`reference` varchar(100) DEFAULT NULL,
	`workorder_id` int(11) NOT NULL DEFAULT '0',
	`quantity` double NOT NULL DEFAULT '0',
	`date_` date NOT NULL DEFAULT '0000-00-00',
	PRIMARY KEY (`id`),
	KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB;

-- Data of table `0_wo_manufacture` --

-- Structure of table `0_wo_requirements` --

DROP TABLE IF EXISTS `0_wo_requirements`;

CREATE TABLE `0_wo_requirements` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`workorder_id` int(11) NOT NULL DEFAULT '0',
	`stock_id` char(20) NOT NULL DEFAULT '',
	`workcentre` int(11) NOT NULL DEFAULT '0',
	`units_req` double NOT NULL DEFAULT '1',
	`unit_cost` double NOT NULL DEFAULT '0',
	`loc_code` char(5) NOT NULL DEFAULT '',
	`units_issued` double NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	KEY `workorder_id` (`workorder_id`)
) ENGINE=InnoDB;


-- Structure of table `0_bom` --

DROP TABLE IF EXISTS `0_bom`;

CREATE TABLE `0_bom` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`parent` char(20) NOT NULL DEFAULT '',
	`component` char(20) NOT NULL DEFAULT '',
	`workcentre_added` int(11) NOT NULL DEFAULT '0',
	`loc_code` char(5) NOT NULL DEFAULT '',
	`quantity` double NOT NULL DEFAULT '1',
	PRIMARY KEY (`parent`,`component`,`workcentre_added`,`loc_code`),
	KEY `component` (`component`),
	KEY `id` (`id`),
	KEY `loc_code` (`loc_code`),
	KEY `parent` (`parent`,`loc_code`),
	KEY `workcentre_added` (`workcentre_added`)
) ENGINE=InnoDB;


-- 客户销售开发推进计划表 -------------------------

DROP TABLE IF EXISTS `0_customers_plan`;

CREATE TABLE `0_customers_plan` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`customer_id` int(11) NOT NULL  COMMENT '客户编号',
    `description` varchar(200) NOT NULL DEFAULT ''  COMMENT '说明',
	`sale_man` varchar(30) NOT NULL DEFAULT ''  COMMENT '销售人员',
	`plan_type` varchar(30) NOT NULL DEFAULT '' COMMENT '开发性质',
	`channel` varchar(30) NOT NULL DEFAULT '' COMMENT '购进渠道',
	`amount` double NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB ;


-- 打印机配置表 -------------------------

DROP TABLE IF EXISTS `0_print_profiles`;

CREATE TABLE `0_print_profiles` (
	`id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
	`profile` varchar(30) NOT NULL,
	`report` varchar(5) DEFAULT NULL,
	`printer` tinyint(3) unsigned DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `profile` (`profile`,`report`)
) ENGINE=InnoDB AUTO_INCREMENT=10 ;

INSERT INTO `0_print_profiles` VALUES
('1', 'Out of office', NULL, '0'),
('2', 'Sales Department', NULL, '0'),
('9', 'Sales Department', '201', '2');


-- 打印机列表 -------------------------

DROP TABLE IF EXISTS `0_printers`;

CREATE TABLE `0_printers` (
	`id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
	`name` varchar(20) NOT NULL,
	`description` varchar(60) NOT NULL,
	`queue` varchar(20) NOT NULL,
	`host` varchar(40) NOT NULL,
	`port` smallint(11) unsigned NOT NULL,
	`timeout` tinyint(3) unsigned NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 ;

INSERT INTO `0_printers` VALUES
('1', 'QL500', 'Label printer', 'QL500', 'server', '127', '20'),
('2', 'Samsung', 'Main network printer', 'scx4521F', 'server', '515', '5'),
('3', 'Local', 'Local print server at user IP', 'lp', '', '515', '10');



DROP TABLE IF EXISTS `0_printers_json`;

CREATE TABLE `0_printers_json` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `bind_id` varchar(20) NOT NULL COMMENT '编号',
  `mod_id` int NOT NULL COMMENT '模块ID',
  `name` varchar(20) NOT NULL COMMENT '名称',
  `description` varchar(100) NOT NULL COMMENT '说明',
  `json` text NOT NULL COMMENT '模版',
  `sql_txt` text NOT NULL COMMENT 'SQL文',
  `sum_field` varchar(20) COMMENT '汇总字段',
  `field1` varchar(20) COMMENT '备用字段',
  `inactive` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=0;


--  联系方式  ----------------------------
DROP TABLE IF EXISTS `0_contacts`;

CREATE TABLE `0_contacts` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(20) NOT NULL DEFAULT '' COMMENT '姓名',
	`offce_phone` varchar(50) NOT NULL DEFAULT '' COMMENT '办公电话',
	`job_title` varchar(100) NOT NULL DEFAULT '' COMMENT '岗位',
	`mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '移动电话',
	`department` varchar(50) NOT NULL DEFAULT '' COMMENT '部门',
    `emall_address` varchar(100) NOT NULL DEFAULT '' COMMENT 'EMAIL',
    `primary_address` varchar(100) NOT NULL DEFAULT '' COMMENT '主要地址',
    `primary_city` varchar(30) NOT NULL DEFAULT '' COMMENT '主要城市',
    `alternate_address` varchar(100) NOT NULL DEFAULT '' COMMENT '次要地址',
    `alternate_city` varchar(30) NOT NULL DEFAULT '' COMMENT '次要城市',
	`lead_source` varchar(50) NOT NULL DEFAULT '' COMMENT '来源途径',
    `description` varchar(60) NOT NULL DEFAULT '',
	`date_created` timestamp default 0,
	`date_updated` timestamp default current_timestamp on update current_timestamp,
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 ;

-- 序号记录表  ---------------------------

DROP TABLE IF EXISTS `0_reflines`;

CREATE TABLE `0_reflines` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`trans_type` int(11) NOT NULL,
	`prefix` char(5) NOT NULL DEFAULT '',
	`pattern` varchar(35) NOT NULL DEFAULT '1',
	`description` varchar(60) NOT NULL DEFAULT '',
	`default` tinyint(1) NOT NULL DEFAULT '0',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `prefix` (`trans_type`,`prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=0 ;

INSERT INTO `0_reflines` VALUES
('1', '0', '', '{001}/{YYYY}', '', '1', '0');


-- 序号列表 ------------------------------

DROP TABLE IF EXISTS `0_refs`;

CREATE TABLE `0_refs` (
	`id` int(11) NOT NULL DEFAULT '0',
	`type` int(11) NOT NULL DEFAULT '0',
	`reference` varchar(100) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`,`type`),
	KEY `Type_and_Reference` (`type`,`reference`)
) ENGINE=InnoDB;

--  客户销售订单主表  -------------------- 

DROP TABLE IF EXISTS `0_sales_orders_master`;

CREATE TABLE `0_sales_orders_master` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`order_no` varchar(30) NOT NULL,
	`customer_id` int(11) NOT NULL DEFAULT '0',
	`total_row` int(11) NOT NULL DEFAULT '0',
	`comments` tinytext,
	`sale_man` varchar(30) NOT NULL DEFAULT '',
	`ord_date` date NOT NULL DEFAULT '2022-01-01',
	`order_type` int(11) NOT NULL DEFAULT '0',
	`amount` double  NOT NULL DEFAULT '0' COMMENT '金额',
	PRIMARY KEY (`id`),
	UNIQUE KEY `order_no` (`order_no`),
	UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB;


--  客户销售订单明细表  --------------------

DROP TABLE IF EXISTS `0_sales_orders_detail`;

CREATE TABLE `0_sales_orders_detail` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`order_no` varchar(30) NOT NULL,
	`customer_id` int(11) NOT NULL DEFAULT '0',
	`row_index` int(11) NOT NULL DEFAULT '0',
	`item_id`int NOT NULL DEFAULT '0',
	`item_code` varchar(30) NOT NULL DEFAULT '',
	`comments` tinytext,
	`sale_man` varchar(30) NOT NULL DEFAULT '',
	`ord_date` date NOT NULL DEFAULT '2022-01-01',
	`order_type` int(11) NOT NULL DEFAULT '0',
	`sale_price` double NOT NULL DEFAULT '0',
	`qty` double  NOT NULL DEFAULT '0' COMMENT '数量',
	`amount` double  NOT NULL DEFAULT '0' COMMENT '金额',
	PRIMARY KEY (`id`),
	UNIQUE KEY `order_no` (`order_no`),
	UNIQUE KEY `customer_id` (`customer_id`),
	UNIQUE KEY `item_code` (`item_code`)
	
) ENGINE=InnoDB;


--  客户采购订单主表  --------------------

DROP TABLE IF EXISTS `0_purchase_orders_master`;

CREATE TABLE `0_purchase_orders_master` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`purchase_no` varchar(30) NOT NULL,
	`customer_id` int(11) NOT NULL DEFAULT '0',
	`total_index` int(11) NOT NULL DEFAULT '0',
	`comments` tinytext,
	`ord_date` date NOT NULL DEFAULT '2022-01-01',
	`sale_man` varchar(30) NOT NULL DEFAULT '',
	`order_type` int(11) NOT NULL DEFAULT '0',
	`amount` double  NOT NULL DEFAULT '0' COMMENT '金额',
	PRIMARY KEY (`id`),
	UNIQUE KEY `purchase_no` (`purchase_no`),
	UNIQUE KEY `customer_id` (`customer_id`)

) ENGINE=InnoDB;



--  客户采购订单明细表  --------------------

DROP TABLE IF EXISTS `0_purchase_orders_detail`;

CREATE TABLE `0_purchase_orders_detail` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`purchase_no` varchar(30) NOT NULL,
	`customer_id` int(11) NOT NULL DEFAULT '0',
	`row_index` int(11) NOT NULL DEFAULT '0',
	`item_id` int(11) NOT NULL DEFAULT '0',
	`item_code` varchar(30) NOT NULL DEFAULT '',
	`sale_man` varchar(30) NOT NULL DEFAULT '',
	`comments` tinytext,
	`ord_date` date NOT NULL DEFAULT '2022-01-01',
	`order_type` int(11) NOT NULL DEFAULT '0',
	`sale_price` double NOT NULL DEFAULT '0',
	`qty` double  NOT NULL DEFAULT '0' COMMENT '数量',
	`amount` double  NOT NULL DEFAULT '0' COMMENT '金额',
	PRIMARY KEY (`id`),
	UNIQUE KEY `purchase_no` (`purchase_no`),
	UNIQUE KEY `customer_id` (`customer_id`),
	UNIQUE KEY `item_code` (`item_code`)
) ENGINE=InnoDB;


--  业务员期初数量和金额  --------------------

DROP TABLE IF EXISTS `0_first_product_qty`;

CREATE TABLE `0_first_product_qty` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`customer_id` int(11) NOT NULL DEFAULT '0',
	`item_code` varchar(30) NOT NULL DEFAULT '',
	`sale_man` varchar(30) NOT NULL DEFAULT '',
	`comments` tinytext,
	`ord_date` date NOT NULL DEFAULT '2022-01-01',
	`order_type` int(11) NOT NULL DEFAULT '0',
	`sale_price` double NOT NULL DEFAULT '0',
	`qty` double  NOT NULL DEFAULT '0' COMMENT '数量',
	`amount` double  NOT NULL DEFAULT '0' COMMENT '金额',
	PRIMARY KEY (`id`),
	UNIQUE KEY `customer_id` (`customer_id`),
	UNIQUE KEY `item_code` (`item_code`)
	
	
) ENGINE=InnoDB;


--   应收账款、实收账款  -----------

DROP TABLE IF EXISTS `0_receivable`;

CREATE TABLE `0_receivable` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`customer_id` int(11) NOT NULL DEFAULT '0',
	`item_code` varchar(30) NOT NULL DEFAULT '',
	`sale_man` varchar(30) NOT NULL DEFAULT '',
	`comments` tinytext,
	`ord_date` date NOT NULL DEFAULT '2022-01-01',
	`amount` double  NOT NULL DEFAULT '0' COMMENT '应收金额',
	`actual_amount` double  NOT NULL DEFAULT '0' COMMENT '实收金额',
	PRIMARY KEY (`id`),
	UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB;


-- 销售类型 -------------------------

DROP TABLE IF EXISTS `0_sales_types`;

CREATE TABLE `0_sales_types` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`sales_type` char(50) NOT NULL DEFAULT '',
	`tax_included` int(1) NOT NULL DEFAULT '0',
	`factor` double NOT NULL DEFAULT '1',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `sales_type` (`sales_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

INSERT INTO `0_sales_types` VALUES
('1', '一级', '1', '1', '0'),
('2', '商业', '1', '1', '0');


--  安全角色配置 -------------------------

DROP TABLE IF EXISTS `0_security_roles`;

CREATE TABLE `0_security_roles` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`role` varchar(30) NOT NULL,
	`description` varchar(50) DEFAULT NULL,
	`sections` text,
	`areas` text,
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `role` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=11 ;

INSERT INTO `0_security_roles` VALUES
('1', '管理员', '系统管理员', '256;512;768;1024;1280', '257;258;259;260;513;514;515;516;517;518;521;522;523;524;525;526;769;770;771;772;773;1025;1026;1027;1028;1029;1030;1281;1282;1283;1284;1285;1286;1287;1288', '0');


-- sql 日志 -------------------------

DROP TABLE IF EXISTS `0_sql_trail`;

CREATE TABLE `0_sql_trail` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`sql` text NOT NULL,
	`result` tinyint(1) NOT NULL,
	`msg` varchar(255) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB ;


-- 系统首选项 -------------------------
DROP TABLE IF EXISTS `0_sys_prefs`;

CREATE TABLE `0_sys_prefs` (
	`name` varchar(35) NOT NULL DEFAULT '',
	`category` varchar(30) DEFAULT NULL,
	`type` varchar(20) NOT NULL DEFAULT '',
	`length` smallint(6) DEFAULT NULL,
	`value` text NOT NULL,
	PRIMARY KEY (`name`),
	KEY `category` (`category`)
) ENGINE=InnoDB ;

-- Data of table `0_sys_prefs` --

INSERT INTO `0_sys_prefs` VALUES
('coy_name', 'setup.company', 'varchar', 60, 'Company name'),
('gst_no', 'setup.company', 'varchar', 25, ''),
('coy_no', 'setup.company', 'varchar', 25, ''),
('tax_prd', 'setup.company', 'int', 11, '1'),
('tax_last', 'setup.company', 'int', 11, '1'),
('postal_address', 'setup.company', 'tinytext', 0, 'N/A'),
('phone', 'setup.company', 'varchar', 30, ''),
('fax', 'setup.company', 'varchar', 30, ''),
('email', 'setup.company', 'varchar', 100, ''),
('coy_logo', 'setup.company', 'varchar', 100, ''),
('domicile', 'setup.company', 'varchar', 55, ''),
('curr_default', 'setup.company', 'char', 3, 'USD'),
('use_dimension', 'setup.company', 'tinyint', 1, '1'),
('f_year', 'setup.company', 'int', 11, '1'),
('shortname_name_in_list','setup.company', 'tinyint', 1, '0'),
('no_customer_list', 'setup.company', 'tinyint', 1, '0'),
('no_supplier_list', 'setup.company', 'tinyint', 1, '0'),
('base_sales', 'setup.company', 'int', 11, '1'),
('time_zone', 'setup.company', 'tinyint', 1, '0'),
('add_pct', 'setup.company', 'int', 5, '-1'),
('round_to', 'setup.company', 'int', 5, '1'),
('login_tout', 'setup.company', 'smallint', 6, '600'),
('past_due_days', 'glsetup.general', 'int', 11, '30'),
('profit_loss_year_act', 'glsetup.general', 'varchar', 15, '9990'),
('retained_earnings_act', 'glsetup.general', 'varchar', 15, '3590'),
('bank_charge_act', 'glsetup.general', 'varchar', 15, '5690'),
('exchange_diff_act', 'glsetup.general', 'varchar', 15, '4450'),
('tax_algorithm', 'glsetup.customer', 'tinyint', 1, '1'),
('default_credit_limit', 'glsetup.customer', 'int', 11, '1000'),
('accumulate_shipping', 'glsetup.customer', 'tinyint', 1, '0'),
('legal_text', 'glsetup.customer', 'tinytext', 0, ''),
('freight_act', 'glsetup.customer', 'varchar', 15, '4430'),
('debtors_act', 'glsetup.sales', 'varchar', 15, '1200'),
('default_sales_act', 'glsetup.sales', 'varchar', 15, '4010'),
('default_sales_discount_act', 'glsetup.sales', 'varchar', 15, '4510'),
('default_prompt_payment_act', 'glsetup.sales', 'varchar', 15, '4500'),
('default_delivery_required', 'glsetup.sales', 'smallint', 6, '1'),
('default_receival_required', 'glsetup.purchase', 'smallint', 6, '10'),
('default_quote_valid_days', 'glsetup.sales', 'smallint', 6, '30'),
('default_dim_required', 'glsetup.dims', 'int', 11, '20'),
('pyt_discount_act', 'glsetup.purchase', 'varchar', 15, '5060'),
('creditors_act', 'glsetup.purchase', 'varchar', 15, '2100'),
('po_over_receive', 'glsetup.purchase', 'int', 11, '10'),
('po_over_charge', 'glsetup.purchase', 'int', 11, '10'),
('allow_negative_stock', 'glsetup.inventory', 'tinyint', 1, '0'),
('default_inventory_act', 'glsetup.items', 'varchar', 15, '1510'),
('default_cogs_act', 'glsetup.items', 'varchar', 15, '5010'),
('default_adj_act', 'glsetup.items', 'varchar', 15, '5040'),
('default_inv_sales_act', 'glsetup.items', 'varchar', 15, '4010'),
('default_wip_act', 'glsetup.items', 'varchar', 15, '1530'),
('default_workorder_required', 'glsetup.manuf', 'int', 11, '20'),
('version_id', 'system', 'varchar', 11, '0.1'),
('auto_curr_reval', 'setup.company', 'smallint', 6, '1'),
('grn_clearing_act', 'glsetup.purchase', 'varchar', 15, '1550'),
('bcc_email', 'setup.company', 'varchar', 100, ''),
('deferred_income_act', 'glsetup.sales', 'varchar', '15', '2105'),
('gl_closing_date','setup.closing_date', 'date', 8, ''),
('alternative_tax_include_on_docs','setup.company', 'tinyint', 1, '0'),
('no_zero_lines_amount','glsetup.sales', 'tinyint', 1, '1'),
('show_po_item_codes','glsetup.purchase', 'tinyint', 1, '0'),
('accounts_alpha','glsetup.general', 'tinyint', 1, '0'),
('loc_notification','glsetup.inventory', 'tinyint', 1, '0'),
('print_invoice_no','glsetup.sales', 'tinyint', 1, '0'),
('allow_negative_prices','glsetup.inventory', 'tinyint', 1, '1'),
('print_item_images_on_quote','glsetup.inventory', 'tinyint', 1, '0'),
('suppress_tax_rates','setup.company', 'tinyint', 1, '0'),
('company_logo_report','setup.company', 'tinyint', 1, '0'),
('barcodes_on_stock','setup.company', 'tinyint', 1, '0'),
('print_dialog_direct','setup.company', 'tinyint', 1, '0'),
('ref_no_auto_increase','setup.company', 'tinyint', 1, '0'),
('default_loss_on_asset_disposal_act', 'glsetup.items', 'varchar', '15', '5660'),
('depreciation_period', 'glsetup.company', 'tinyint', '1', '1'),
('use_manufacturing','setup.company', 'tinyint', 1, '1'),
('dim_on_recurrent_invoice','setup.company', 'tinyint', 1, '0'),
('long_description_invoice','setup.company', 'tinyint', 1, '0'),
('max_days_in_docs','setup.company', 'smallint', 5, '180'),
('use_fixed_assets','setup.company', 'tinyint', 1, '1');


-- 上线记录日志  -------------------------

DROP TABLE IF EXISTS `0_useronline`;

CREATE TABLE `0_useronline` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`timestamp` int(15) NOT NULL DEFAULT '0',
	`ip` varchar(40) NOT NULL DEFAULT '',
	`file` varchar(100) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	KEY `timestamp` (`timestamp`),
	KEY `ip` (`ip`)
) ENGINE=InnoDB ;


-- 用户表 ---------------------------

DROP TABLE IF EXISTS `0_users`;

CREATE TABLE `0_users` (
	`id` smallint(6) NOT NULL AUTO_INCREMENT,
	`user_id` varchar(60) NOT NULL DEFAULT '',
	`password` varchar(100) NOT NULL DEFAULT '',
	`real_name` varchar(100) NOT NULL DEFAULT '',
	`role_id` int(11) NOT NULL DEFAULT '1',
	`phone` varchar(30) NOT NULL DEFAULT '',
	`email` varchar(100) DEFAULT NULL,
	`language` varchar(20) DEFAULT NULL,
	`date_format` tinyint(1) NOT NULL DEFAULT '0',
	`date_sep` tinyint(1) NOT NULL DEFAULT '0',
	`tho_sep` tinyint(1) NOT NULL DEFAULT '0',
	`dec_sep` tinyint(1) NOT NULL DEFAULT '0',
	`theme` varchar(20) NOT NULL DEFAULT 'default',
	`page_size` varchar(20) NOT NULL DEFAULT 'A4',
	`prices_dec` smallint(6) NOT NULL DEFAULT '2',
	`qty_dec` smallint(6) NOT NULL DEFAULT '2',
	`rates_dec` smallint(6) NOT NULL DEFAULT '4',
	`percent_dec` smallint(6) NOT NULL DEFAULT '1',
	`show_gl` tinyint(1) NOT NULL DEFAULT '1',
	`show_codes` tinyint(1) NOT NULL DEFAULT '0',
	`show_hints` tinyint(1) NOT NULL DEFAULT '0',
	`last_visit_date` datetime DEFAULT NULL,
	`query_size` tinyint(1) unsigned NOT NULL DEFAULT '10',
	`graphic_links` tinyint(1) DEFAULT '1',
	`pos` smallint(6) DEFAULT '1',
	`print_profile` varchar(30) NOT NULL DEFAULT '',
	`rep_popup` tinyint(1) DEFAULT '1',
	`sticky_doc_date` tinyint(1) DEFAULT '0',
	`startup_tab` varchar(20) NOT NULL DEFAULT '',
	`transaction_days` smallint(6) NOT NULL DEFAULT '30',
	`save_report_selections` smallint(6) NOT NULL DEFAULT '0',
	`use_date_picker` tinyint(1) NOT NULL DEFAULT '1',
	`def_print_destination` tinyint(1) NOT NULL DEFAULT '0',
	`def_print_orientation` tinyint(1) NOT NULL DEFAULT '0',
	`sale_area` varchar(50) NOT NULL DEFAULT '',
	`inactive` tinyint(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

INSERT INTO `0_users` VALUES
('1', 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', '管理员', '1', '', 'adm@foutbrother.cn', 'C', '0', '0', '0', '0', 'default', 'Letter', '2', '2', '4', '1', '1', '0', '0', '2021-05-07 13:58:33', '10', '1', '1', '1', '1', '0', 'system', '30', '0', '1', '0', '0', '0');



-- 作废记录 ----------------------------
DROP TABLE IF EXISTS `0_voided`;

CREATE TABLE `0_voided` (
	`type` int(11) NOT NULL DEFAULT '0',
	`id` int(11) NOT NULL DEFAULT '0',
	`date_` date NOT NULL DEFAULT '0000-00-00',
	`memo_` tinytext NOT NULL,
	UNIQUE KEY `id` (`type`,`id`)
) ENGINE=InnoDB ;


