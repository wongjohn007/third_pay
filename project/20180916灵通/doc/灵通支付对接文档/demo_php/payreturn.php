<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<?php
/**
 * ---------------------支付成功，用户会跳转到这里-------------------------------
 * 
 * 此页就是您之前传给支付页的returnURL页的网址
 * 支付成功，我们会把用户跳转回这里。
 * 
 * --------------------------------------------------------------
 */

    $merchantOrderNo = $_GET["merchantOrderNo"];

    //此处在您数据库中查询：此笔订单号是否已经异步通知给您付款成功了。如成功了，就给他返回一个支付成功的展示。
    echo "恭喜，支付成功!，订单号：".$merchantOrderNo;
 ?>