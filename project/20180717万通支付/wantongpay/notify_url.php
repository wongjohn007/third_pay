<? header("content-Type: text/html; charset=UTF-8"); ?>
<?php
include_once("../../../database/mysql.php");//现数据库的连接方式
include_once("../moneyfunc.php");
#//write_log("notify");

#接收资料
#input方法
$input_data = file_get_contents("php://input");
//write_log($input_data);
$res = json_decode($input_data, 1);//json回传资料

foreach ($res as $key => $value) {
	$data[$key] = $value;
	//write_log($key . "=" . $value);
}

#设定固定参数
$order_no = $data['orderid']; //订单号
$mymoney = number_format($data['price'] / 100, 2, '.', ''); //订单金额
$sign = $data['key'];//签名
$echo_msg = '{"code":"1","msg":"处理成功"}';//回调讯息

#根据订单号读取资料库
$params = array(':m_order' => $order_no);
$sql = "select operator from k_money where m_order=:m_order";
$stmt = $mysqlLink->sqlLink("write1")->prepare($sql);//现数据库的连接方式
$stmt->execute($params);
$row = $stmt->fetch();

#获取该订单的支付名称
$pay_type = substr($row['operator'], 0, strripos($row['operator'], "_"));
$params = array(':pay_type' => $pay_type);
$sql = "select * from pay_set where pay_type=:pay_type";
$stmt = $mysqlLink->sqlLink("write1")->prepare($sql);//现数据库的连接方式
$stmt->execute($params);
$payInfo = $stmt->fetch();
$pay_mid = $payInfo['mer_id'];
$pay_mkey = $payInfo['mer_key'];
$pay_account = $payInfo['mer_account'];
if ($pay_mid == "" || $pay_mkey == "") {
	echo "非法提交参数";
	//write_log("非法提交参数");
	exit;
}

#验签方式
ksort($data);
$noarr = array('key');//不加入签名的array key值
$signtext = '';
foreach ($data as $arr_key => $arr_val) {
	if (!in_array($arr_key, $noarr)) {
		$signtext .= $arr_key . '=' . $arr_val . '&';
	}
}
$signtext = substr($signtext, 0, -1) . $pay_mkey;//验签字串
//write_log("signtext=" . $signtext);
$mysign = md5($signtext);//签名
//write_log("mysign=" . $mysign);

// #到账判断
if ($mysign == $sign) {
	$result_insert = update_online_money($order_no, $mymoney);
	if ($result_insert == -1) {
		echo ("会员信息不存在，无法入账");
		//write_log("会员信息不存在，无法入账");
		exit;
	} else if ($result_insert == 0) {
		echo ($echo_msg);
		//write_log($echo_msg . 'at 0');
		exit;
	} else if ($result_insert == -2) {
		echo ("数据库操作失败");
		//write_log("数据库操作失败");
		exit;
	} else if ($result_insert == 1) {
		echo ($echo_msg);
		//write_log($echo_msg . 'at 1');
		exit;
	} else {
		echo ("支付失败");
		//write_log("支付失败");
		exit;
	}
} else {
	echo ('签名不正确！');
	//write_log("签名不正确！");
	exit;
}

?>
