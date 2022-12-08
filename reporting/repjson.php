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
$page_security = 'SA_PRINT_DESIGNER';
$path_to_root = '..';

include_once $path_to_root . '/includes/session.php';

include_once $path_to_root . '/includes/date_functions.inc';
include_once $path_to_root . '/includes/data_checks.inc';
include_once $path_to_root . '/reporting/includes/print_config.inc';


//----------------------------------------------------------------------------------------------------

$id = $_GET['print_id'];

$_POST['print_id']= $id;

function get_json($id)
{
    $sql = "SELECT name,json,sql_txt,sum_field from " . TB_PREF . "printers_json WHERE id = ".$id;
    $result = db_query($sql, 'No transactions were returned');  
    return db_fetch_assoc($result);
}

print_custom_print();
//----------------------------------------------------------------------------------------------------

function get_keys($arr,$find) {
    
        static $temp = array(); 
         foreach ($arr as $key => $val) {
                 if (is_array($val)||is_object($val)) {
                    
                    if ($key==$find){
                        $temp[$key] = $val;
                    }
                    else 
                      get_keys($val,$find);
                 } 
        }
       return $temp;
}


function print_custom_print()
{
    global $path_to_root, $systypes_array,$id;

    $json =  get_json($id);

    $name = $json['name'];
    $sql =  $json['sql_txt'];
    $sum_field = $json['sum_field']; 
    $json = json_decode(htmlspecialchars_decode($json['json']));
    $json = $json->panels[0];
    
    $from = $_POST['PARAM_0'];
    $to = $_POST['PARAM_1'];
    $fromcust = $_POST['PARAM_2'];
    $show_balance = $_POST['PARAM_3'];
    $currency = $_POST['PARAM_4'];
    $no_zeros = $_POST['PARAM_5'];
    $comments = $_POST['PARAM_6'];
    $orientation = $_POST['PARAM_7']; 
    $destination = isset($_POST['PARAM_8'])?$_POST['PARAM_8']:false;

    if ($destination) {
        include_once $path_to_root . '/reporting/includes/excel_report.inc';
    } else {
        include_once $path_to_root . '/reporting/includes/pdf_custom_report.inc';
    }
    
    $pagewidth = (int)$json->width*2.834;
    $pageheight = (int)$json->height*2.834;
   

    $paperHeader = $json->paperHeader;

    $orientation = $pageheight > $pagewidth;

    $orientation = ($orientation ? 'P' : 'L');

    $pagesize = isset($json->paperType)?$json->paperType:array($pageheight,  $pagewidth );

    // 纸张边距设置 top,bottom,left,right
    $margins = get_pager_margin($pagesize,$orientation);

    $margins['bottom'] = isset($json->bottomMargin)?$json->bottomMargin: $margins['bottom'];
    $margins['left'] = isset($json->leftMargin)?$json->leftMargin: $margins['left'];
    $margins['right'] = isset($json->rightMargin)?$jon->rightMargin: $margins['right'];
    $margins['top'] = isset($json->topMargin)?$json->topMargin: $margins['top'];

    $margins['width'] = $pagewidth;
    $margins['height'] = $pageheight;
    $margins['paperHeader'] = $json->paperHeader;
    
    
    $printElements =  $json->printElements;
  
    
    $headers=array();

    $params=[];
    
    $showTitle = true;
   

    foreach ($printElements as $key=>$value) {


        if (is_object($value)) {
          if (strpos($value->tid,'Text')>0) {
              $params['text'][]= $value->options;
          }  
          if (strpos($value->tid,'vline')>0) {
             $params['vline'][]= $value->options;
          }  
          if (strpos($value->tid,'hline')>0) {
            $params['hline'][]= $value->options;
          }  
    
          if (strpos($value->tid,'pages')>0 || strtoupper($value->tid)=='PAGES') {
            $params['pages'][]= $value->options;
          } 

          if (strpos($value->tid,'table')>0) {
            $params['table'][]= $value->options;
          } 

          if (strpos($value->tid,'barcode')>0 || strpos($value->tid,'qrcode')>0) {
            $params['barcode'][]= $value->options;
          } 

          if (strtoupper($value->tid)=='TOTAL') {
            $params['total'][]= $value->options;
          } 

          if (strtoupper($value->tid)=='SUBTOTAL') {
            $params['subtotal'][]= $value->options;
          } 

        }
    }

    $pages = isset($params['pages'])?$params['pages']:null;
    $total = isset($params['total'])?$params['total']:null;
    $subtotal = isset($params['subtotal'])?$params['subtotal']:null;

    $barcode = isset($params['barcode'])?$params['barcode']:null;
    $vline = isset($params['vline'])?$params['vline']:null;
    $hline = isset($params['hline'])?$params['hline']:null;
    $text = isset($params['text'])?$params['text']:null;
    $table = isset($params['table'])?$params['table']:null;
    

    $header = array('customer'=>'****药店','docno'=>'100023');
    
    $rep = new CustomReport(_('定制报表'), 'CustomerBalances', $pagesize, 9, $orientation,$margins);
    $rep->Font();
    $rep->info($header,$pages,$barcode,$vline,$hline,$text,$total,$subtotal);
    $rep->newPage();

    /*$data = array(
        array('A'=>'A0','B'=>'A','C'=>100,'D'=>200,'E'=>'E'),
        array('A'=>'A1','B'=>'A','C'=>200,'D'=>200,'E'=>'E'),
        array('A'=>'姐啊看风景的卅饭店啊发的卅饭店范德萨范德萨风的鬼斧神工方式鬼斧神工负担工费多少功夫都','B'=>'A','C'=>500,'D'=>200,'E'=>'E'),
        array('A'=>'A','B'=>'A2','A','C'=>300,'D'=>200,'E'=>'E'),
        array('A'=>'A3','B'=>'A','C'=>400,'D'=>200,'E'=>'E'),
        array('A'=>'A4','B'=>'A','C'=>500,'D'=>200,'E'=>'E'),
        array('A'=>'A5','B'=>'A','C'=>500,'D'=>200,'E'=>'E'),
        array('A'=>'A6','B'=>'A','C'=>500,'D'=>200,'E'=>'E'),
        array('A'=>'A7','B'=>'A','C'=>500,'D'=>200,'E'=>'E'),
        array('A'=>'A8','B'=>'A','C'=>500,'D'=>200,'E'=>'E'),
        array('A'=>'A9','B'=>'A','C'=>500,'D'=>200,'E'=>'E'),
    );  */ 



    $result = db_query($sql);
    $totals = 0;
    while ($rows= db_fetch($result)) {
        extract($rows);
        $data[] = $rows;
        $totals += $rows[$sum_field];
    };

    // 合计总额，小计字段，其它信息
    $total_info = array('total'=>$totals,'field'=>$sum_field,'info'=>array('单据合计：','小计：'));
    
    if ($table)
      $rep->DrawTable($params['table'],$data,$total_info);
    
    $rep->End();
    
	
}
