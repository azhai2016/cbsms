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
	TODO:
	. add StartReport/EndReport handlers for better bulk report support, with
	. email/printer destination option should be selected on class creation instead
	 of End()
	. add/use setter function for Header2 parameters (currently passed globally)
	. in report files pass already prepared options to SetCommonData() to avoid need for
	 selection inside FrontReport generic class.
*/
include_once(dirname(__FILE__).'/class.pdf.inc');
include_once(dirname(__FILE__).'/printer_class.inc');
include_once($path_to_root . '/reporting/includes/reporting.inc');
include_once($path_to_root . '/admin/db/company_db.inc');
include_once($path_to_root . '/admin/db/printers_db.inc');
include_once($path_to_root . '/includes/ui/ui_globals.inc');
include_once($path_to_root . '/config.php');

class CustomReport extends Cpdf {
	var $size;
	var $company;
	var $user;
	var $host;
	var $fiscal_year;
	var $title;
	var $filename;
	var $pageWidth;
	var $pageHeight;

	var $topMargin;
	var $bottomMargin;
	var $leftMargin;
	var $rightMargin;
	var $endLine;
	var $lineHeight;
	//var $rtl;

	var $row;
	var $cols;
	var $params;
	var $headers;
	var $aligns;
	var $headers2;
	var $aligns2;
	var $cols2;
	var $pageNumber;
	var $fontSize;
	var $oldFontSize;
	var $currency;
	var $companyLogoEnable;  // select whether to use a company logo graphic in some header templates
	var $scaleLogoWidth;
	var $footerEnable;  // select whether to print a page footer or not
	var $footerText;  // store user-generated footer text
	var $headerTmpl;  // store the name of the currently selected header template
	var $tmplSize; // pdf header template size in pages
	var $pageNumberParams;
	
	var $rep_id;
	var $formData; // common data used for printing headers footers etc.
	var $contactData; // contact data for sending emials/reportlanguage selection
	var $barcodes;
	var $vlines;
	var $hlines;
	var $texts;
	var $Totals;
	var $SubTotals;
	var $showLine;
	
	var $dest;	// destination: email or printer
	
	function __construct($title, $filename, $size = 'A4', $fontsize = 9, $orientation = 'P', $margins = NULL, $excelColWidthFactor = NULL) {
		global $page_security;

		//$this->rep_id = $_POST['REP_ID'];	// FIXME
		
		if (!$_SESSION['wa_current_user']->can_access_page($page_security)) {
			display_error(_('The security settings on your account do not permit you to print this report'));
			end_page();
			exit;
		}
		// Page margins - if user-specified, use those.  Otherwise, use defaults below.
		$this->pageWidth = $margins['width'];
		$this->pageHeight = $margins['height'];

		

		$this->topMargin = $margins['top'];
		$this->bottomMargin = $margins['bottom'];
		$this->leftMargin = $margins['left'];
		$this->rightMargin = $margins['right'];
		
		// Page orientation - P: portrait, L: landscape
		$orientation = strtoupper($orientation);
		
		$this->size = array(0, 0, $this->pageWidth, $this->pageHeight);
		$this->title = $title;
		$this->filename = $filename.'.pdf';
		$this->pageNumber = 0;
		$this->endLine = $this->pageWidth - $this->rightMargin;
		$this->lineHeight = $margins['paperHeader'];
		$this->fontSize = $fontsize;
		$this->oldFontSize = 0;
		$this->row = (int)($this->pageHeight - $this->topMargin);
		$this->currency = '';
		$this->scaleLogoWidth = false; // if Logo, scale on width (else height).
		parent::__construct($size, $_SESSION['language']->code, $orientation);

		$this->setPrintHeader(false);
		$this->setPrintFooter(false);
		//$this->setCellPaddings(0,0,0,0);
		

	}

	function info($header,$pages,$barcodes,$vlines,$hlines,$texts,$total,$subtotal) {
		$this->headers = $header;
        $this->pageNumberParams = $pages;
		$this->Totals = $total;
		$this->SubTotals = $subtotal;
		$this->barcodes = $barcodes;
		$this->vlines= $vlines;
		$this->hlines= $hlines;
		$this->texts= $texts;

	}

    function Font($style = '', $fontname = '') {
		$this->selectFont($fontname, $style);
	}


	// --- 文本 ---
	function DrawText($params,$content=null) {
         if (!isset($params)) return;

		foreach ($params as $key=>$value){ 
			$align= isset($value->textAlign)?$value->textAlign:null;
			$fontWeight = isset($value->fontWeight) ? $value->fontWeight : null;
	
			$fontSize = isset($value->fontSize)?$value->fontSize:null;
			$testData = isset($value->testData)?$value->testData:null;
			$title = isset($value->title)?$value->title:null;
			$field = isset($value->field)?$value->field:null;

			if (!$this->showLine) $title='';

			//（宽,高,内容,边框,是否换行,文字对齐,文字底色,链接,变宽）
			$this->SetFont('', $fontWeight,$fontSize); 
			$this->SetXY($value->left,$value->top);
    
			$txt = $title.$testData;

			if ($content)  {
				if (is_array($content)) {
				 if ($field) {	
                   $txt = $content[$field];
				 }
				}
				else 
				  $txt = $content;
			}
			else if (is_array($this->headers))
			{
				if (isset($this->headers[$field])) {
				  $txt = $title.$this->headers[$field];
				}
				else {
				  $txt = $title.$testData;
				}
			}

			$txt = parent::unhtmlentities($txt);
			$txt = iconv($this->encoding, "UTF-8", $txt);
			$this->Cell($value->width,$value->height,$txt, 0, false, 'L', 0, '', 0, false, 'T', 'M');
			$this->SetFont('', '',$this->fontSize); 
		}


	}

	// --- 条码/二维码 ---
	function DrawBarcode($params,$barcode=null) {

		foreach ($params as $key=>$value){ 
			$align= isset($value->textAlign)?$value->textAlign:'left';
			$fontWeight = isset($value->fontWeight) ? $value->fontWeight : null;
	
			$fontSize = isset($value->fontSize)?$value->fontSize:$this->fontSize;
			$testData = isset($value->testData)?$value->testData:null;
			$title = isset($value->title)?$value->title:null;

			$barcodeMode = isset($value->barcodeMode)?$barcodeMode->barcodeMode:'CODE39';
		
			//（宽,高,内容,边框,是否换行,文字对齐,文字底色,链接,变宽）
			$this->SetFont('', $fontWeight,$fontSize); 
			$txt = $title.$testData;
			if ($barcode) $txt = $barcode;
			
        //  $align= isset($value->align)?$value->align:'left';
			$_ary = array('L'=>'left','R'=>'right','C'=>'center');
			$align = array_search($align,$_ary);
			
			$bm = array(
				'C128A'=>'CODE128A',
			    'C128B'=>'CODE128B',
				'C128C'=>'CODE128C',
				'C39'=>'CODE39',
				'EAN13'=>'EAN-13',
				'EAN8'=>'EAN-8',
				'EAN5'=>'EAN-5',
				'EAN2'=>'EAN-2',
				'UPCA'=>'UPC（A）',
				'MSI'=>'MSI',
				'MSI+'=>'MSI10',
				'MSI+'=>'MSI11',
				'PHARMA'=>'Pharmacode');

			$barcodeMode=array_search($barcodeMode,$bm);
			
			$style = array(
				'position' => 'L',
				//'align' => $align,
				//'stretch' => false,
				//'fitwidth' => true,
				//'cellfitalign' => '',
				'border' => false,
				//'hpadding' => 'auto',
				//'vpadding' => 'auto',
				'fgcolor' => array(0,0,0),
				'bgcolor' => false, //array(255,255,255),
				'text' => true,
				//'font' => 'helvetica',
				'fontsize' => 8,
				'stretchtext' => 4
			);

			if ($value->textType=='barcode') {
				$this->write1DBarcode($txt, $barcodeMode, $value->left, $value->top, $value->width, $value->height, 1, $style, 'N');
			}
			else {
				$style['position']='';
			    $this->write2DBarcode($txt, 'QRCODE,H', $value->left, $value->top, $value->width, $value->height, $style, 'N');
			}
	
		}

		  $this->SetFont('', '',$this->fontSize); 
	}

    // ---- 竖线 ----
    function DrawVLine($params) {
		
	  foreach($params as $key=>$value){
	    $x1 =  $value->left;
	    $y1 =  $value->top;
		$y2 =  $value->height;
		parent::Line($x1, $this->h-$y1, $x1 , $this->h-($y1 + $y2) ,array('width'=>0.5));
	  }   
	} 

	// ---- 横线 ----
	function DrawHLine($params) {
     	foreach($params as $key=>$value){ 
	      $style= array('width'=>0.5);	
		  $x1 = $value->left;
		  $y1 = $this->h - $value->top;
		  $x2 = $value->width+$value->left;
		  parent::Line($x1, $y1, $x2 , $y1 ,$style);
		  
		}  
		$this->SetFont('', '',$this->fontSize);
	} 

    function Header($show) {
		
		if ($this->texts) 
		    $this->DrawText($this->texts);

       if ($show) {
	    if ($this->vlines) 
		    $this->DrawVLine($this->vlines);

		if ($this->hlines) 
		    $this->DrawHLine($this->hlines);
	   }

		if ($this->barcodes) 
		    $this->DrawBarcode($this->barcodes);
    }

	public function printPage($txt){
	    $this->DrawText($this->pageNumberParams,$txt);
	}

	public function Footer() {
	  $this->printPage('页码: '.$this->pageNumber.'/'.$this->getAliasNbPages());
	}

	function printTotal($txt){
		$this->DrawText($this->Totals,$txt);
	}
    
	function printSubTotal($txt){ 
		$this->DrawText($this->SubTotals,$txt);
	}

    public function Custom_Header($params,$left,$top,$row_height,$show=false) {
      
        $this->header($show); 

		$this->SetFillColor(204, 204, 204);
        $this->SetTextColor(0);
		$this->SetFont('', '',10);
		$this->SetXY($left,$top);

     	$ws = [];  

	    foreach($params as $col_key => $col_value) {
		 $i=0;
		   foreach($col_value as $k => $v) {
			 $w = $v->width; 
			 $a = array('L'=>'left','R'=>'right','C'=>'center');
			 $align= isset($v->align)?array_search($v->align,$a):'L';
             $text_align= isset($v->align)?$v->align:'left';
			 $field = $v->field;
			 //（宽,高,内容,边框,是否换行,文字对齐,文字底色,链接,变宽）
			 $ws[$i++]= array('width'=>$w,'align'=>$align,'field'=>$field);
			 if ($show) 
			 $this->Cell($w,$row_height, $v->title, 1, 0, 'C', 1); 
		   }
	     }

		 $this->AliasNbPages();

		 $this->Footer($show);

		 $this->SetFont('', '',$this->fontSize);

	     return $ws;
    }

	function DrawTable($params,$data=array(),$total=null) {

		$this->SetFillColor(255, 255, 255);
        $this->SetTextColor(0);
        $this->SetLineWidth(0.3); 
		$this->fontSize = 9;
		$this->SetFont('', '', $this->fontSize);
	
		foreach($params as $key=>$value){  

		 $row_height = isset($value->tableBodyRowHeight)?$value->tableBodyRowHeight:19;
		 $left = $value->left;
		 $top = $value->top;
		 $show= isset($value->hideTitle)?!$value->hideTitle:true;
		 $this->showLine =  $show;
		 $line = $show?1:0; 
		 
		 $header = $this->Custom_Header($value->columns, $left, $top, $row_height,$show);

		 $rp = $show ? $top+$row_height : $top;

		 if (isset($total)) {
            $total_sum  = $total['total'];
			$total_field = $total['field'];
			$total_info = $total['info'];

			
		}
		
		 $this->SetFillColor(224, 235, 255);
         $this->SetTextColor(0);

		 $this->SetXY($left,$rp);
   
        // Data
        $fill = 0;
	    $hg =2;

	

		$ws = $header;
	
		$lt = $left;
		$width = 0;
		$i=0;
		$sub_total = 0;
		foreach($data as $key=> $row) {	
			
			if (isset($total)) {
				$sub_total+=$row[$total_field];	
			}

			foreach ($ws as $k=>$v) {
				$field = $ws[$k]['field'];
				$text = $row[$field];

				
				$width = $ws[$k]['width'];
				$align = $ws[$k]['align'];
				$txt = $this->calcTextWrap($text, $width,true);
				$ret = isset($txt[1])?$txt[1]:'';
				$txt = $txt[0];
				if ($ret) {
					$this->SetFont('', '', $this->fontSize-1);
					$len = $this->MultiCell($width,$row_height,$text,$line,$align,$fill, 0, '','', true, false,false); 
					$this->SetFont('', '', $this->fontSize);
                    if ($len>2) {
		 	            $rp += $row_height;
					}
				}
				else {
				  $this->customTextWrap($width,$row_height,$txt, $align, $line, $fill, NULL, 1, true); 
				}
		
		    }
			//打印合计内容
			if ($line) {
		      	$fill=!$fill;
			}	
			$i++;
			$rp += $row_height;

			
			if ($this->row < $this->bottomMargin + $rp){
				if (isset($total)) {
					$this->printTotal($total_info[0].$total_sum);
					$this->printSubTotal($total_info[1].$sub_total);
				}
				$this->newPage();
				$this->SetXY($left,$rp);
				$this->Custom_Header($value->columns, $left, $top, $row_height,$show);
				$this->SetFillColor(255, 255, 255);
                $this->SetTextColor(0);

				$i=0;
				$rp = $show ? $top+$row_height : $top;
				$sub_total=0;
				$this->SetXY($left,$rp);
				
			}

			$this->SetFillColor(224, 235, 255);
            $this->SetTextColor(0);
			$this->SetXY($left,$rp);

        }

		if (isset($total)) {
			$this->printTotal($total_info[0].$total_sum);
			$this->printSubTotal($total_info[1].$sub_total);
		}

		

		
	
	  } 

	
		
	} 

	function customTextWrap($w, $h, $txt, $align='left', $border=0, $fill=0, $link=NULL, $stretch=1, $spacebreak=false) {
		$ret = "";
		if (!$this->rtl) {
			if ($align == 'right')
				$align = 'R';
			elseif ($align == 'left')
				$align = 'L';
			elseif ($align == 'center')
				$align = 'C';
			elseif ($align == 'justify')
				$align = 'J';
		}
		else {
			if ($align == 'right')
				$align = 'R';// This may need to be 'L'
			elseif ($align == 'left')
				$align = 'R';
			elseif ($align == 'center')
				$align = 'C';
			elseif ($align == 'justify')
				$align = 'J';
		}

		$txt = parent::unhtmlentities($txt);
		// If horizontal scaling was requested, check to see if we're trying to scale
		// too much.  If so, cut back string first and then scale it.
		$maxScaleFactor = 1.4;
		if ($stretch == 1 || $stretch == 2)
			$txt = $this->calcTextWrap($txt, $w * $maxScaleFactor, $spacebreak);
		// Wrap text if stretching isn't turned on
		else
			$txt = $this->calcTextWrap($txt, $w, $spacebreak);
		
		$ret = $txt[1];
		$txt = $txt[0];
		//$this->SetXY($xb, $this->h - $yb - $h);

		if ($this->isunicode && $this->encoding != "UTF-8")
			$txt = iconv($this->encoding, "UTF-8", $txt);
		
		$this->Cell($w, $h, $txt, $border, 0, $align, $fill, $link, $stretch);
		return $ret;
	}

	
	

	function Text($c, $txt, $n=0, $corr=0, $r=0, $align='left', $border=0, $fill=0, $link=NULL, $stretch=1) {
		if ($n == 0)
			$n = $this->pageWidth - $this->rightMargin;

     	return $this->TextWrap($c, $this->row - $r, $n - $c + $corr, $txt, $align, $border, $fill, $link, $stretch);
	}

	function TextWrap($xpos, $ypos, $len, $str, $align = 'left', $border = 0, $fill = 0, $link = NULL, $stretch = 1, $spacebreak=false) {
		$str = strtr($str, array("\r"=>''));

		if ($this->fontSize != $this->oldFontSize) {
			$this->SetFontSize($this->fontSize);
			$this->oldFontSize = $this->fontSize;
		}
		return $this->addTextWrap($xpos, $ypos, $len, $this->fontSize, $str, $align, $border, $fill, $link, $stretch, $spacebreak);
	}

	function TextCol($c, $n, $txt, $corr=0, $r=0, $border=0, $fill=0, $link=NULL, $stretch=1) {
		return $this->TextWrap($this->cols[$c], $this->row - $r, $this->cols[$n] - $this->cols[$c] + $corr, $txt, $this->aligns[$c], $border, $fill, $link, $stretch);
	}

	function NewLine($l=1, $np=0, $h = NULL) {
		// If the line height wasn't specified, use the current setting
		if ($h == NULL)
			$h = $this->lineHeight;

		// Move one line down the page
		$this->row -= ($l * $h);

		// Check to see if we're at the bottom and should insert a page break
		if ($this->row < $this->bottomMargin + ($np * $h))
			$this->NewPage();
	}

	function NewPage() {
		if ($this->pageNumber==0) {
			// check if there is pdf header template for this report
			// and set if it is found
			$tmpl_pdf = find_custom_file('/reporting/forms/'.$this->headerTmpl.'.pdf');
			if ($tmpl_pdf)
				$this->tmplSize = $this->setSourceFile($tmpl_pdf);
		}

		$this->pageNumber++;
		parent::newPage();
	}

	function SetLineStyle($style) {
		parent::SetLineStyle($style);
	}

	/**
	 * Sets the line drawing width.
	 */
	function SetLineWidth($width) {
		parent::SetLineWidth($width);
	}
	
	function LineTo($from, $row, $to, $row2) {
		parent::line($from, $row, $to, $row2);
	}

	function Line($row, $height = 0, $dummy1=null, $dummy2=null, $dummy3=null) {
		$oldLineWidth = $this->GetLineWidth();
		$this->SetLineWidth($height + 1);
		parent::line($this->pageWidth - $this->rightMargin, $row ,$this->leftMargin, $row);
		$this->SetLineWidth($oldLineWidth);
	}

	function End($email=0, $subject='') {
		global $SysPrefs, $path_to_root;

		if (!empty($SysPrefs->prefs['print_dialog_direct']))		
			$this->includeJS('print();'); // force to open print dialog

		if ($SysPrefs->pdf_debug == 1) {
			$pdfcode = $this->Output('','S');
			$pdfcode = str_replace("\n", "\n<br>", html_specials_encode($pdfcode));
			echo '<html><body>';
			echo trim($pdfcode);
			echo '</body></html>';
		}
		else {
			$dir =  company_path(). '/pdf_files';
		
			//save the file
			if (!file_exists($dir))
				mkdir ($dir,0777);
			
			// do not use standard filenames or your sensitive company data 
			// are world readable
		
			$fname = $dir.'/'.random_id().'.pdf';
			
			$this->Output($fname, 'F');

			//$this->IncludeJS("print();");

				$printer = get_report_printer(user_print_profile(), $this->rep_id);
		
				if ($printer == false) {
					if (in_ajax()) {
						global $Ajax;

						if (user_rep_popup()) 
							$Ajax->popup($fname); // when embeded pdf viewer used
						else
							$Ajax->redirect($fname); // otherwise use faster method
					}
					else {
						header('Content-type: application/pdf');
						header('Content-Disposition: inline; filename='.$this->filename);
						header('Expires: 0');
						header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
						header('Pragma: public');
						$this->Stream($this->filename);
					}
				}
				else { // send report to network printer
					$prn = new remote_printer($printer['queue'],$printer['host'],
						$printer['port'], $printer['timeout']);
			
						
					$error = $prn->print_file($fname);
					if ($error)
						display_error($error);
					else
						display_notification(_('Report has been sent to network printer ').$printer['name']);
				}
			
			// first have a look through the directory, 
			// and remove old temporary pdfs
			if ($d = @opendir($dir)) {
				while (($file = readdir($d)) !== false) {
					if (!is_file($dir.'/'.$file) || $file == 'index.php') continue;
				// then check to see if this one is too old
					$ftime = filemtime($dir.'/'.$file);
				// seems 3 min is enough for any report download, isn't it?
					if (time()-$ftime > 180){
						unlink($dir.'/'.$file);
					}
				}
				closedir($d);
			}
		}
	}

}


?>