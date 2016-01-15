<!--#include file="functions.asp"-->

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

<%
		key = "31O4EMvHA1KIxrz6PvLHcBwAaZJSSqZW" 'replace ur 32 bit secure key , Get your secure key from your Reseller Control panel

		'---------------------------
		'Below are the  parameters which will be passed from foundation as http GET request
		'---------------------------
		
		paymentTypeId = Request.QueryString("paymenttypeid")	'payment id 
		transId = Request.QueryString("transid")	'This refers to a unique transaction ID which we generate for each transaction
		userId = Request.QueryString("userid")	'userid of the user who is trying to make the payment
		userType = Request.QueryString("usertype")  		  'This refers to the type of user perofrming this transaction. The possible values are "Customer" or "Reseller"
        transactionType = Request.QueryString("transactiontype")'Type of transaction (ResellerAddFund/CustomerAddFund/ResellerPayment/CustomerPayment)
		invoiceIds = Request.QueryString("invoiceids")	'comma separated Invoice Ids, This will have a value only if the transactiontype is "ResellerPayment" or "CustomerPayment"        
        debitNoteIds = Request.QueryString("debitnoteids")	'comma separated DebitNotes Ids, This will have a value only if the transactiontype is "ResellerPayment" or "CustomerPayment"
		
		description = Request.QueryString("description")	'description of the transaction
		sellingCurrencyAmount = Request.QueryString("sellingcurrencyamount")	 'This refers to the amount of transaction in your Selling Currency
        accountingCurrencyAmount = Request.QueryString("accountingcurrencyamount")	'This refers to the amount of transaction in your Accounting Currency
		 
		
		redirectUrl = Request.QueryString("redirecturl")	'This is the URL on our server, to which you need to send the user once you have finished charging him
		
		
		checksum = Request.QueryString("checksum") 'checksum for validation 

		 Response.write "File paymentpage.asp<br>"
         Response.write "Checksum Verification.............."
		 

		if(verifyChecksum(paymentTypeId, transId, userId, userType, transactionType, invoiceIds, debitNoteIds, description, sellingCurrencyAmount, accountingCurrencyAmount, key, checksum)) then			

			'YOUR CODE GOES HERE
		'==========================================================================================
		' Since all this data has to be passed back to Foundation after making the payment you need to save this data
		'	
		' You can make a database entry with all the required details which has been passed from foundation.  
		'
		'							OR
		'	
		' Keep the data in the session which will be available in postpayment.jsp as we have done here.
		'
		' It is recommended that you make a database entry.
		'==========================================================================================
			session("transid") = transId
			session("sellingcurrencyamount") = sellingCurrencyAmount
			session("accountingcurencyamount") = accountingCurrencyAmount
			session("redirecturl") = redirectUrl	  			

			
            Response.write "Verified<br>"
            Response.write "List of Variables Received as follows<br>"
            Response.write "paymenttypeid : "+ paymentTypeId+"<br>"
            Response.write "transid : "+transId+"<br>"
            Response.write "userid : "+ userId+"<br>"
            Response.write "usertype : "+ userType+"<br>"
            Response.write "transactiontype : "+transactionType+"<br>"
            Response.write "invoiceids : "+invoiceIds+"<br>"
            Response.write "debitnoteids : "+debitNoteIds+"<br>"
            Response.write "description : "+description+"<br>"
            Response.write "sellingcurrencyamount : "+sellingCurrencyAmount+"<br>"
            Response.write "accountingcurrencyamount : "+accountingCurrencyAmount+"<br>"
            Response.write "redirecturl : "+redirectUrl+"<br>"
            Response.write "checksum : "+checksum+"<br><br>" %>

<form name="paymentpage" action="postpayment.asp">
    <input type="hidden" name="status" value="Y">
    <input type="button" name="btnSuccess" onClick="successClicked();" value="Continue Test of a Successful Transaction"><br>
    <input type="button" name="btnPending" onClick="pendingClicked();" value="Continue Test of a Pending Transaction"><br>
    <input type="button" name="btnFailed" onClick="failClicked();" value="Continue Test of a Failed Transaction"><br>
</form>
			
		<% else
			'==========================================================================================
			' This message will be dispayed in any of the following case 
			'
			' 1. You are not using a valid 32 bit secure key from your Reseller Control panel
			' 2. The data passed from foundation has been tampered.
			'
			' In both these cases the customer has to be shown error message and shound not 
			' be allowed to proceed  and do the payment.
			' 
			'==========================================================================================
			Response.write "ERROR: Checksum Mismatch"	 
			
		end if
%>
</body> </html>