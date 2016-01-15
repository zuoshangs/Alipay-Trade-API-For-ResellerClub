<%
' 功能：标准双接口接入页
' 版本：3.3
' 日期：2012-07-17
' 说明：
' 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
' 该代码仅供学习和研究支付宝接口使用，只是提供一个参考。
	
' /////////////////注意/////////////////
' 如果您在接口集成过程中遇到问题，可以按照下面的途径来解决
' 1、商户服务中心（https://b.alipay.com/support/helperApply.htm?action=consultationApply），提交申请集成协助，我们会有专业的技术工程师主动联系您协助解决
' 2、商户帮助中心（http://help.alipay.com/support/232511-16307/0-16307.htm?sh=Y&info_type=9）
' 3、支付宝论坛（http://club.alipay.com/read-htm-tid-8681712.html）
' /////////////////////////////////////

%>
<html>
<head>
	<META http-equiv=Content-Type content="text/html; charset=gb2312">
<title>支付宝标准双接口</title>
</head>
<body>

<!--#include file="class/alipay_submit.asp"-->
<%
'/////////////////////请求参数/////////////////////
		transid=Request.Form("transid")
		'付款金额
        price = Request.Form("WIDprice")
		sellingcurrencyamount=price
		sellingcurrencyamount_from_session = Session("sellingcurrencyamount_session")
		If sellingcurrencyamount_from_session <>sellingcurrencyamount Then
			Response.Write("请不要修改支付金额!")
		Else
			Response.Write("请稍候,正在跳转到支付宝......")
		accountingcurrencyamount=Request.Form("accountingcurrencyamount")
		Session("redirecturl") = Request.Form("redirecturl")
		Session("transid") = transid
		Session("sellingcurrencyamount")=sellingcurrencyamount
		Session("accountingcurrencyamount")=accountingcurrencyamount
		
		rc_extra_params=transid&"|"&sellingcurrencyamount&"|"&accountingcurrencyamount
		extra_common_param =rc_extra_params
        '支付类型
        payment_type = "1"
        '必填，不能修改
        '服务器异步通知页面路径
        notify_url = "http://xxx.com/alipay/notify_url.asp"
        '需http://格式的完整路径，不能加?id=123这类自定义参数
        '页面跳转同步通知页面路径
        return_url = "http://xxx.com/alipay/return_url.asp"
        '需http://格式的完整路径，不能加?id=123这类自定义参数，不能写成http://localhost/
        '卖家支付宝帐户
        'seller_email = Request.Form("WIDseller_email")
		seller_email = "xxx@xxx.com"
        '必填
        '商户订单号
        out_trade_no = Request.Form("WIDout_trade_no")
        '商户网站订单系统中唯一订单号，必填
        '订单名称
        subject = Request.Form("WIDsubject")
        '必填
        
        '必填
        '商品数量
        quantity = "1"
        '必填，建议默认为1，不改变值，把一次交易看成是一次下订单而非购买一件商品
        '物流费用
        logistics_fee = "0.00"
        '必填，即运费
        '物流类型
        logistics_type = "EXPRESS"
        '必填，三个值可选：EXPRESS（快递）、POST（平邮）、EMS（EMS）
        '物流支付方式
        logistics_payment = "SELLER_PAY"
        '必填，两个值可选：SELLER_PAY（卖家承担运费）、BUYER_PAY（买家承担运费）
        '订单描述
        body = Request.Form("WIDbody")
        '商品展示地址
        show_url = Request.Form("WIDshow_url")
        '需以http://开头的完整路径，如：http://www.xxx.com/myorder.html
        '收货人姓名
        receive_name = Request.Form("WIDreceive_name")
        '如：张三
        '收货人地址
        receive_address = Request.Form("WIDreceive_address")
        '如：XX省XXX市XXX区XXX路XXX小区XXX栋XXX单元XXX号
        '收货人邮编
        receive_zip = Request.Form("WIDreceive_zip")
        '如：123456
        '收货人电话号码
        receive_phone = Request.Form("WIDreceive_phone")
        '如：0571-88158090
        '收货人手机号码
        receive_mobile = Request.Form("WIDreceive_mobile")
        '如：13312341234

'/////////////////////请求参数/////////////////////

'构造请求参数数组
sParaTemp = Array("service=create_partner_trade_by_buyer","partner="&partner,"_input_charset="&input_charset  ,"payment_type="&payment_type   ,"notify_url="&notify_url   ,"return_url="&return_url   ,"seller_email="&seller_email   ,"out_trade_no="&out_trade_no   ,"subject="&subject   ,"price="&price   ,"quantity="&quantity   ,"logistics_fee="&logistics_fee   ,"logistics_type="&logistics_type   ,"logistics_payment="&logistics_payment   ,"body="&body   ,"show_url="&show_url   ,"receive_name="&receive_name   ,"receive_address="&receive_address   ,"receive_zip="&receive_zip   ,"receive_phone="&receive_phone   ,"receive_mobile="&receive_mobile ,"extra_common_param="&extra_common_param )

'建立请求
Set objSubmit = New AlipaySubmit
sHtml = objSubmit.BuildRequestForm(sParaTemp, "get", "确认")
response.Write sHtml
End If

%>
</body>
</html>
