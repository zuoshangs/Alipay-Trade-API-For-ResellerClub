<!--#include file="functions.asp"-->
<html>
<head><title>Post Payment</title><META http-equiv=Content-Type content="text/html; charset=utf-8">
</head>
<body bgcolor="white">
<font size=4>
<%
		key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 'replace ur 32 bit secure key , Get your secure key from your Reseller Control panel

		'Below are the passed from foundation 
		
		redirectUrl = session("redirecturl")'redirectUrl received from foundation
		transId = session("transid")   'Pass the same transid which was passsed to your Gateway URL at the beginning of the transaction.
		sellingCurrencyAmount = session("sellingcurrencyamount")
		accountingCurrencyAmount = session("accountingcurrencyamount")

		status = Session("status")'Transaction status received from your Payment Gateway
        'This can be either 'Y' or 'N'. A 'Y' signifies that the Transaction went through SUCCESSFULLY and that the amount has been collected.
        'An 'N' on the other hand, signifies that the Transaction FAILED.		
		
				

	    '==========================================================================================
	    'HERE YOU HAVE TO VERIFY THAT THE STATUS PASSED FROM YOUR PAYMENT GATEWAY IS VALID.
	    ' And it has not been tampered with. The data has not been changed since it can * easily be done with HTTP request. 
		'==========================================================================================

		 Randomize
		rkey = rnd()   
		


		checksum = generateChecksum(transId,sellingCurrencyAmount,accountingCurrencyAmount,status, rkey, key)


	Response.write "请不要关闭此页面<br>"
	Response.write "请务必点击继续按钮以通知商家，否则商家可能不会收到您的款项!<br>"


	'==========================================================================================
	' Once your Payment Gateway response is verified, you can redirect the Customer to the Foundation server for processing the Order.
	'==========================================================================================

%>
		<form name="f1" action="<%=redirectUrl%>">		
				
		<input type="hidden" name="transid" value="<%=transId%>">
        <input type="hidden" name="status" value="<%=status%>">
		<input type="hidden" name="rkey" value="<%=rkey%>">
        <input type="hidden" name="checksum" value="<%=checksum%>">
        <input type="hidden" name="sellingamount" value="<%=sellingCurrencyAmount%>">
		<input type="hidden" name="accountingamount" value="<%=accountingCurrencyAmount%>">

		<input type="submit" value="点击继续">

		</form>

</font>
</body>
</html>