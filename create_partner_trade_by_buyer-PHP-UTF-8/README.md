# ResellerClub支付宝担保交易接口使用说明
ResellerClub支付宝担保交易接口，只支持同步返回，不支持异步回调，因为目前ResellerClub官方似乎没有提供异步回调的方式。

因此，目前只支持PC支付，用户不能使用电脑创建订单后自行在手机客户端支付。

目前用户支付完成后一定要等待页面自动跳转回网站的支付成功页面，否则商家会收到支付宝的款但用户账户不会加款。

使用方法：

1、编辑alipay.config.php中的参数。

   partner是合作身份者id，以2088开头的16位纯数字;
   
   seller_email是收款支付宝账号，一般情况下收款账号就是签约账号;
   
   key是安全检验码，以数字和字母组成的32位字符;
   
   notify_url是支付宝异步回调地址，把xxx.com换成自己的域名即可;
   
   return_url是支付宝同步返回地址，把xxx.com换成自己的域名即可;
   
   rc_key是ResellerClub的支付key，就是在ResellerClub后台创建支付接口的时候看到的"密匙";
   
       其余参数无需改动。
       
2、把整个文件夹传到自己的服务器空间上。

3、在ResellerClub后台支付方式中填写网关名称为支付宝，URL网址为http://自己的域名/alipay/create_partner_trade_by_buyer-PHP-UTF-8/paymentpage.php
