<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="com.itrus.util.sign.*" %>

<%
///////////////////////////////////  接收请求参数  ////////////////////////////////////
		
		// 接收表单提交参数
		request.setCharacterEncoding("UTF-8");			
		String merchant_code = request.getParameter("merchant_code");	
		String service_type = request.getParameter("service_type");
		String interface_version = request.getParameter("interface_version");		
		String input_charset = request.getParameter("input_charset");				
		String notify_url = request.getParameter("notify_url");
		String sign_type = request.getParameter("sign_type");		
		String order_no = request.getParameter("order_no");		
		String order_time = request.getParameter("order_time");		
		String order_amount = request.getParameter("order_amount");		
		String product_name = request.getParameter("product_name");		
		String return_url = request.getParameter("return_url");
		String bank_code = request.getParameter("bank_code");		
		String redo_flag = request.getParameter("redo_flag");			
		String pay_type = request.getParameter("pay_type");			

		/** 数据签名
		签名规则定义如下：
		（1）参数列表中，除去sign_type、sign两个参数外，其它所有非空的参数都要参与签名，值为空的参数不用参与签名；
		（2）签名参数排序按照参数名a到z的顺序排序，若遇到相同首字母，则看第二个字母，以此类推，组成规则如下：
		参数名1=参数值1&参数名2=参数值2&……&参数名n=参数值n		*/
		
		StringBuffer signSrc= new StringBuffer();	
		if (null != bank_code && !"".equals(bank_code)) {
			signSrc.append("bank_code=").append(bank_code).append("&");	
		}
		signSrc.append("input_charset=").append(input_charset).append("&");			
		signSrc.append("interface_version=").append(interface_version).append("&");
		signSrc.append("merchant_code=").append(merchant_code).append("&");
		signSrc.append("notify_url=").append(notify_url).append("&");					
		signSrc.append("order_amount=").append(order_amount).append("&");
		signSrc.append("order_no=").append(order_no).append("&");		
		signSrc.append("order_time=").append(order_time).append("&");
		if (!"".equals(pay_type)) {
			signSrc.append("pay_type=").append(pay_type).append("&");	
		}	
		signSrc.append("product_name=").append(product_name).append("&");
		if (null != redo_flag && !"".equals(redo_flag)) {
			signSrc.append("redo_flag=").append(redo_flag).append("&");	
		}
		if (null != return_url && !"".equals(return_url)) {
			signSrc.append("return_url=").append(return_url).append("&");	
		}		
		signSrc.append("service_type=").append(service_type);
		
			
		String signInfo = signSrc.toString();
		String sign = "" ;
		if("RSA-S".equals(sign_type)){ // sign_type = "RSA-S"
			
			/** 
			1)merchant_private_key，商户私钥，商户按照《密钥对获取工具说明》操作并获取商户私钥；获取商户私钥的同时，也要获取商户公钥（merchant_public_key）；调试运行
			代码之前首先先将商户公钥上传到商家后台"支付管理"->"公钥管理"（如何获取和上传请查看《密钥对获取工具说明》），不上传商户公钥会导致调试运行代码时报错。
  			2)demo提供的merchant_private_key是测试商户号800003004321的商户私钥，请自行获取商户私钥并且替换	*/	
  			
			String merchant_private_key ="MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANilQBp9xg6KdgB+6jVnIFnMl34jR3sGguvDjAgTLTqYd/FhkSbNl24rbRKDjZ4jqDKxFFUbFlqMd0YuSzhE+Utb1jNcBROTyIn/2O0cCmN0tPFaSgL/ywYhXSjT1FlAWuFbBV+bggj8CLDUpTGm31BofJA/qmg9Kn/wW2aF8QjNAgMBAAECgYEAyALgiNSfeqM4SELjxcPc6SrqngjCIIGlczbI3FegBR3odlBmatWaPZsYCuSrZVl0GsDDjcMBQz21jHSG+38qS0WTxWrMgw/k88ygbfDXWEZQd1v8Em7CDIFN5rZ7InS2GZsDDl5HhBHFKp6eoGug+Xo7Z5O8GokYaGKCdOuVcUECQQD9NRF05NTp0BzGxfVkcWmJeYI23vH+No8nPed4OZSA2gNtpz7mZ2NE7lw05skznf4bVxWTanlynorYD32fejfdAkEA2wjzKggsxfiy4FkPpq9Q04FooQt+W8efD4EOWuYMOVNoOAJYmjzE8YY2XUkaEZ80NHnCJcEZ/UtSX4OqL/f9sQJBANcazTCr8cCL/tZSd8yTmF+krR1mOtiGiwiAS3LUH7dy/jSaPxJHRIrbn9OFN+o0zxl02qx4aKIZ08QHLOZdUrUCQQDagA4a8va/Mv42QYIUdLV7mI+of8+4fOWW0NZiJTUyhprjrKt4iYCps4pN+tuvkpLAemoLwZtMi7QLpkvC+G+xAkAtOkom2PugToM5QiM4MS7puinFV89SEsVQuGvHyyJ/iH8O6igd5XrH1AR7kL879onPTvARTz+Ai7bHq3mUD3Wr";
			sign = RSAWithSoftware.signByPrivateKey(signInfo, merchant_private_key);	// 签名   signInfo签名参数排序，  merchant_private_key商户私钥
			System.out.println("RSA-S签名参数排序：" + signInfo.length() + " -->" + signInfo);
			System.out.println("RSA-S签名：" + sign.length() + " -->" + sign + "\n");
		}
		
		if("RSA".equals(sign_type)){ // 数字证书加密方式  sign_type = "RSA"
		
			// 请在商家后台"支付管理"->"证书下载"处申请和下载pfx数字证书，一般要1~3个工作日才能获取到，800003004321.pfx是测试商户号800003004321的数字证书
			String webRootPath = request.getSession().getServletContext().getRealPath("/");
			String merPfxPath = webRootPath + "pfx/800003004321.pfx";						// 商家的pfx证书文件路径
			String merPfxPass = "800003004321";											// 商家的pfx证书密码，初始密码是商户号
			RSAWithHardware mh = new RSAWithHardware();						
			mh.initSigner(merPfxPath, merPfxPass);		  
			sign = mh.signByPriKey(signInfo);											// 签名   signInfo签名参数排序
			System.out.println("RSA商户pfx证书文件路径：" + merPfxPath.length() + " -->" + merPfxPath);
			System.out.println("RSA签名参数排序：" + signInfo.length() + " -->" + signInfo);
			System.out.println("RSA签名：" + sign.length() + " -->" + sign + "\n");
		}
		 
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
</head>
<body onLoad="document.dinpayForm.submit();">
  <form name="dinpayForm" method="post" action="https://pay.yuanruic.com/gateway?input_charset=<%=input_charset%>" >
	<input type="hidden" name="sign" value="<%=sign%>" />
	<input type="hidden" name="merchant_code" value="<%=merchant_code%>" />
	<input type="hidden" name="service_type" value="<%=service_type%>" />	
	<input type="hidden" name="pay_type" value="<%=pay_type%>" />	
	<input type="hidden" name="interface_version" value="<%=interface_version%>" />			
	<input type="hidden" name="input_charset" value="<%=input_charset%>" />	
	<input type="hidden" name="notify_url" value="<%=notify_url%>"/>
	<input type="hidden" name="sign_type" value="<%=sign_type%>" />		
	<input type="hidden" name="order_no" value="<%=order_no%>"/>
	<input type="hidden" name="order_time" value="<%=order_time%>" />	
	<input type="hidden" name="order_amount" value="<%=order_amount%>"/>
	<input type="hidden" name="product_name" value="<%=product_name%>" />	
	<input type="hidden" name="return_url" value="<%=return_url%>"/>	
	<input type="hidden" name="bank_code" value="<%=bank_code%>" />	
	<input type="hidden" name="redo_flag" value="<%=redo_flag%>"/>
  </form>
</body>
</html>
