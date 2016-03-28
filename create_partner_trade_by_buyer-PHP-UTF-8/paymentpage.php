<?php
	session_start();
	require("functions.php");	//file which has required functions
	require("alipay.config.php");
	$_SESSION['status']="N";
?>	 	
		
<html>
<head><title>Payment Page </title>
<script language="JavaScript">
        function successClicked()
        {
            document.paymentpage.submit();
        }
        function failClicked()
        {
            document.paymentpage.status.value = "N";
            document.paymentpage.submit();
        }
        function pendingClicked()
        {
            document.paymentpage.status.value = "P";
            document.paymentpage.submit();
        }
</script>
</head>
<body bgcolor="white">

<?php
		
		$key = $alipay_config['rc_key']; //replace ur 32 bit secure key , Get your secure key from your Reseller Control panel
		
		//This filter removes data that is potentially harmful for your application. It is used to strip tags and remove or encode unwanted characters.
		$_GET = filter_var_array($_GET, FILTER_SANITIZE_STRING);
		
		//Below are the  parameters which will be passed from foundation as http GET request
		$paymentTypeId = $_GET["paymenttypeid"];  //payment type id
		$transId = $_GET["transid"];			   //This refers to a unique transaction ID which we generate for each transaction
		$userId = $_GET["userid"];               //userid of the user who is trying to make the payment
		$userType = $_GET["usertype"];  		   //This refers to the type of user perofrming this transaction. The possible values are "Customer" or "Reseller"
		$transactionType = $_GET["transactiontype"];  //Type of transaction (ResellerAddFund/CustomerAddFund/ResellerPayment/CustomerPayment)

		$invoiceIds = $_GET["invoiceids"];		   //comma separated Invoice Ids, This will have a value only if the transactiontype is "ResellerPayment" or "CustomerPayment"
		$debitNoteIds = $_GET["debitnoteids"];	   //comma separated DebitNotes Ids, This will have a value only if the transactiontype is "ResellerPayment" or "CustomerPayment"

		$description = $_GET["description"];
		
		$sellingCurrencyAmount = $_GET["sellingcurrencyamount"]; //This refers to the amount of transaction in your Selling Currency
        $accountingCurrencyAmount = $_GET["accountingcurrencyamount"]; //This refers to the amount of transaction in your Accounting Currency

		$redirectUrl = $_GET["redirecturl"];  //This is the URL on our server, to which you need to send the user once you have finished charging him

						
		$checksum = $_GET["checksum"];	 //checksum for validation

		 echo "File paymentpage.php<br>";
         echo "Checksum Verification..............";

		if(verifyChecksum($paymentTypeId, $transId, $userId, $userType, $transactionType, $invoiceIds, $debitNoteIds, $description, $sellingCurrencyAmount, $accountingCurrencyAmount, $key, $checksum))
		{
			//YOUR CODE GOES HERE	

		/** 
		* since all these data has to be passed back to foundation after making the payment you need to save these data
		*	
		* You can make a database entry with all the required details which has been passed from foundation.  
		*
		*							OR
		*	
		* keep the data to the session which will be available in postpayment.php as we have done here.
		*
		* It is recommended that you make database entry.
		**/

			

			
			$_SESSION['redirecturl']=$redirectUrl;
			$_SESSION['transid']=$transId;
			$_SESSION['sellingcurrencyamount']=$sellingCurrencyAmount;
			$_SESSION['accountingcurencyamount']=$accountingCurrencyAmount;
		
		?>
		<?php
		require_once("alipay.config.php");
		require_once("lib/alipay_submit.class.php");
		$payment_type = "1";
		$notify_url = $alipay_config['notify_url'];
        $return_url = $alipay_config['return_url'];
		$logistics_type = "EXPRESS";
		$logistics_payment = "SELLER_PAY";
		
		$parameter = array(
		"service" => "create_partner_trade_by_buyer",
		"partner" => trim($alipay_config['partner']),
		"seller_email" => trim($alipay_config['seller_email']),
		"payment_type"	=> $payment_type,
		"notify_url"	=> $notify_url,
		"return_url"	=> $return_url,
		"out_trade_no"	=> $transId,
		"subject"	=> 'cz_'.$transId,
		"price"	=> $sellingCurrencyAmount,
		"quantity"	=> 1,
		"logistics_fee"	=> '0.00',
		"logistics_type"	=> $logistics_type,
		"logistics_payment"	=> $logistics_payment,
		"body"	=> 'goods_description'.$description,
		"show_url"	=> 'http://www.yidc.info',
		"receive_name"	=> 'zhangsan',
		"receive_address"	=> 'beijing',
		"receive_zip"	=> '100000',
		"receive_phone"	=> '010-59699896',
		"receive_mobile"	=> '13800138000',
		"_input_charset"	=> trim(strtolower($alipay_config['input_charset']))
		);
		//建立请求
		$alipaySubmit = new AlipaySubmit($alipay_config);
		$html_text = $alipaySubmit->buildRequestForm($parameter,"get", "确认");
		echo $html_text;
			/**
            echo "Verified<br>";
            echo "List of Variables Received as follows<br>";
            echo "Paymenttypeid : ".$paymentTypeId."<br>";
            echo "transid : ".$transId."<br>";
            echo "userid : ".$userId."<br>";
            echo "usertype : ".$userType."<br>";
            echo "transactiontype : ".$transactionType."<br>";
            echo "invoiceids : ".$invoiceIds."<br>";
            echo "debitnoteids : ".$debitNoteIds."<br>";
            echo "description : ".$description."<br>";
            echo "sellingcurrencyamount : ".$sellingCurrencyAmount."<br>";
            echo "accountingcurrencyamount : ".$accountingCurrencyAmount."<br>";
            echo "redirecturl : ".$redirectUrl."<br>";
            echo "checksum : ".$checksum."<br><br>";
			**/
?>

<form name="paymentpage" action="postpayment.php">
    <input type="hidden" name="status" value="Y">
    <input type="button" name="btnSuccess" onClick="successClicked();" value="Continue Test of a Successful Transaction"><br>
    <input type="button" name="btnPending" onClick="pendingClicked();" value="Continue Test of a Pending Transaction"><br>
    <input type="button" name="btnFailed" onClick="failClicked();" value="Continue Test of a Failed Transaction"><br>
</form>

<?php

		}
		else
		{
			/**This message will be dispayed in any of the following case
			*
			* 1. You are not using a valid 32 bit secure key from your Reseller Control panel
			* 2. The data passed from foundation has been tampered.
			*
			* In both these cases the customer has to be shown error message and shound not
			* be allowed to proceed  and do the payment.
			*
			**/

			echo "Checksum mismatch !";			

		}
?>
</body>
</html>
