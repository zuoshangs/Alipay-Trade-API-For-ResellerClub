<%
' 类名：AlipaySubmit
' 功能：支付宝各接口请求提交类
' 详细：构造支付宝各接口表单HTML文本，获取远程HTTP数据
' 版本：3.3
' 修改日期：2012-07-13
' 说明：
' 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
' 该代码仅供学习和研究支付宝接口使用，只是提供一个参考
%>

<!--#include file="alipay_config.asp"-->
<!--#include file="alipay_core.asp"-->

<%

'支付宝网关地址（新）
GATEWAY_NEW = "https://mapi.alipay.com/gateway.do?"

Class AlipaySubmit

	''
	' 生成签名结果
	' param sParaSort 待签名的数组
	' return 签名结果字符串
	Private Function BuildRequestMysign(sParaSort)
			
		'把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
		prestr = CreateLinkstring(sParaSort)
		
		'获得签名结果
		 Select Case sign_type
		 	Case "MD5" BuildRequestMysign = Md5Sign(prestr,key,input_charset)
			Case Else BuildRequestMysign = ""
		 End Select
	End Function

	''
	' 生成要请求给支付宝的参数数组
	' param sParaTemp 请求前的参数数组
	' return 要请求的参数数组
	Private Function BuildRequestPara(sParaTemp)
		Dim mysign
		'过滤签名参数数组
		sPara = FilterPara(sParaTemp)
		
		'对请求参数数组排序
		sParaSort = SortPara(sPara)
		
		'获得签名结果
		mysign = BuildRequestMysign(sParaSort)
		
		'签名结果与签名方式加入请求提交参数组中
		nCount = ubound(sParaSort)
		Redim Preserve sParaSort(nCount+1)
		sParaSort(nCount+1) = "sign="&mysign
		Redim Preserve sParaSort(nCount+2)
		sParaSort(nCount+2) = "sign_type="&sign_type

		BuildRequestPara = sParaSort
	End Function
	
	''
	' 生成要请求给支付宝的参数数组字符串
	' param sParaTemp 请求前的参数数组
	' return 要请求的参数数组字符串
	Private Function BuildRequestParaToString(sParaTemp)
		Dim sRequestData
		'待签名请求参数数组
		sPara = BuildRequestPara(sParaTemp)
		'把参数组中所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串，并且对其做urlencode编码处理
		sRequestData = CreateLinkStringUrlEncode(sPara)
		
		BuildRequestParaToString = sRequestData
	End Function

	''
	' 建立请求，以表单HTML形式构造（默认）
	' param sParaTemp 请求前的参数数组
	' param sMethod 提交方式。两个值可选：post、get
	' param sButtonValue 确认按钮显示文字
	' return 提交表单HTML文本
	Public Function BuildRequestForm(sParaTemp, sMethod, sButtonValue)
		Dim sHtml, nCount
		'待请求参数数组
		sPara = BuildRequestPara(sParaTemp)
		
		sHtml = "<form id='alipaysubmit' name='alipaysubmit' action='"& GATEWAY_NEW &"_input_charset="&input_charset&"' method='"&sMethod&"'>"
		
		nCount = ubound(sPara)
		For i = 0 To nCount
			'把sPara的数组里的元素格式：变量名=值，分割开来
			iPos = Instr(sPara(i),"=")			'获得=字符的位置
			nLen = Len(sPara(i))				'获得字符串长度
			sItemName = left(sPara(i),iPos-1)	'获得变量名
			sItemValue = right(sPara(i),nLen-iPos)'获得变量的值
		
			sHtml = sHtml & "<input type='hidden' name='"& sItemName &"' value='"& sItemValue &"'/>"
		next

		'submit按钮控件请不要含有name属性
		'submit按钮默认设置为不显示
		sHtml = sHtml & "<input type='submit' value='"&sButtonValue&"' style='display:none;'></form>"
		
		sHtml = sHtml & "<script>document.forms['alipaysubmit'].submit();</script>"
		
		BuildRequestForm = sHtml
	End Function
	
	''
	' 建立请求，以模拟远程HTTP的GET请求方式构造并获取支付宝XML类型处理结果
	' param sParaTemp 请求前的参数数组
	' param sParaNode 要输出的XML节点名
	' return 支付宝返回XML指定节点内容
	Public Function BuildRequestHttpXml(sParaTemp, sParaNode)
		Dim sUrl, objHttp, objXml, nCount, sParaXml()
		nCount = ubound(sParaNode)
		
		'待请求参数数组字符串
		sRequestData = BuildRequestParaToString(sParaTemp)
		'构造请求地址
		sUrl = GATEWAY_NEW & sRequestData

		'获取远程数据
		Set objHttp=Server.CreateObject("Microsoft.XMLHTTP")
		'如果Microsoft.XMLHTTP不行，那么请替换下面的两行行代码尝试
		'Set objHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		'objHttp.setOption 2, 13056
		objHttp.open "GET", sUrl, False, "", ""
		objHttp.send()
		Set objXml=Server.CreateObject("Microsoft.XMLDOM")
		objXml.Async=true
		objXml.ValidateOnParse=False
		objXml.Load(objHttp.ResponseXML)
		Set objHttp = Nothing
		
		set objXmlData = objXml.getElementsByTagName("alipay").item(0)
		If Isnull(objXmlData.selectSingleNode("alipay")) Then
			Redim Preserve sParaXml(1)
			sParaXml(0) = "错误：非法XML格式数据"
		Else
			If objXmlData.selectSingleNode("is_success").text = "T" Then
				For i = 0 To nCount
					Redim Preserve sParaXml(i+1)
					sParaXml(i) = objXmlData.selectSingleNode(sParaNode(i)).text
				Next
			Else
				Redim Preserve sParaXml(1)
				sParaXml(0) = "错误："&objXmlData.selectSingleNode("error").text
			End If
		End If
		
		BuildRequestHttpXml = sParaXml
	End Function
	
	''
	' 建立请求，以模拟远程HTTP的GET请求方式构造并获取支付宝纯文字类型处理结果
	' param sParaTemp 请求前的参数数组
	' return 支付宝处理结果
	Public Function BuildRequestHttpWord(sParaTemp)
		Dim sUrl, objHttp, sResponseTxt
		
		'待请求参数数组字符串
		sRequestData = BuildRequestParaToString(sParaTemp)
		'构造请求地址
		sUrl = GATEWAY_NEW & sRequestData

		'获取远程数据
		Set objHttp=Server.CreateObject("Microsoft.XMLHTTP")
		'如果Microsoft.XMLHTTP不行，那么请替换下面的两行行代码尝试
		'Set objHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		'objHttp.setOption 2, 13056
		objHttp.open "GET", sUrl, False, "", ""
		objHttp.send()
		sResponseTxt = objHttp.ResponseText
		Set objHttp = Nothing
		
		BuildRequestHttpWord = sResponseTxt
	End Function

	''
	' 用于防钓鱼，调用支付宝防钓鱼接口(query_timestamp)来获取时间戳的处理函数
	' 注意：远程解析XML出错，与IIS服务器配置有关
	' return 时间戳字符串
	Public Function Query_timestamp()
		Dim sUrl, encrypt_key
		sUrl = GATEWAY_NEW &"service=query_timestamp&partner="&partner&"&_input_charset="&input_charset
		encrypt_key = ""
		
		Dim objHttp, objXml
		Set objHttp=Server.CreateObject("Microsoft.XMLHTTP")
		'如果Microsoft.XMLHTTP不行，那么请替换下面的两行行代码尝试
		'Set objHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")
		'objHttp.setOption 2, 13056
		objHttp.open "GET", sUrl, False, "", ""
		objHttp.send()
		Set objXml=Server.CreateObject("Microsoft.XMLDOM")
		objXml.Async=true
		objXml.ValidateOnParse=False
		objXml.Load(objHttp.ResponseXML)
		Set objHttp = Nothing
		
		Set objXmlData = objXml.getElementsByTagName("encrypt_key")  '节点的名称
		If Isnull(objXml.getElementsByTagName("encrypt_key")) Then
			encrypt_key = ""
		Else
			encrypt_key = objXmlData.item(0).childnodes(0).text
		End If

		Query_timestamp = encrypt_key
	End Function

End Class

%>