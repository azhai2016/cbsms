<?php


function get_pager_margin($size,$orientation) {
   
  $result = array(
     'top'=>30,
     'bottom'=>30,
     'left'=>30,
     'right'=>30
   ); 

   if (is_string($size)) {	
   switch (strtoupper($size)) {
			default:
			case 'A4':
				// Portrait
				if ($orientation == 'P') {
					$result['top']=40;
					$result['bottom']=30;
					$result['left']=40;
					$result['right']=30;
				}
				else { // Landscape
			        $result['top']=30;
                    $result['bottom']=40;
                    $result['left']=40;
                    $result['right']=30;
			  }
			  break;
			case 'A3':
                if ($orientation == 'P') {
					$result['top']=50;
					$result['bottom']=60;
					$result['left']=50;
					$result['right']=40;
				}
				else { // Landscape
			        $result['top']=50;
                    $result['bottom']=50;
                    $result['left']=50;
                    $result['right']=40;
			    }
				break;
			case 'LETTER':
                if ($orientation == 'P') {
					$result['top']=30;
					$result['bottom']=30;
					$result['left']=30;
					$result['right']=25;
				}
				else { // Landscape
			        $result['top']=50;
                    $result['bottom']=50;
                    $result['left']=50;
                    $result['right']=40;
			    }
				break;
			
		}

	}

        return $result;

    }