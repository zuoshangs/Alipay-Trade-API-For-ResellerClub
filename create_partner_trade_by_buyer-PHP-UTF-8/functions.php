<?php

	function generateChecksum($transId,$sellingCurrencyAmount,$accountingCurrencyAmount,$status, $rkey,$key)
	{	
		$str = "$transId|$sellingCurrencyAmount|$accountingCurrencyAmount|$status|$rkey|$key";
        $generatedCheckSum = md5($str);
		return $generatedCheckSum;
	}

	function verifyChecksum($paymentTypeId, $transId, $userId, $userType, $transactionType, $invoiceIds, $debitNoteIds, $description, $sellingCurrencyAmount, $accountingCurrencyAmount, $key, $checksum)
	{
		$str = "$paymentTypeId|$transId|$userId|$userType|$transactionType|$invoiceIds|$debitNoteIds|$description|$sellingCurrencyAmount|$accountingCurrencyAmount|$key";
        $generatedCheckSum = md5($str);
//		echo $str."<BR>";
//		echo "Generated CheckSum: ".$generatedCheckSum."<BR>";
//		echo "Received Checksum: ".$checksum."<BR>";
		if($generatedCheckSum == $checksum)
			return true ;
		else
			return false ;
	}	
?>