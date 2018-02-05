<?php

namespace Muushop\Controller;

use Think\Controller;
use Com\TPWechat;
use Com\WechatAuth;

class IndexController extends PublicController {
	protected $product_cats_model;
	protected $product_model;
	protected $coupon_model;
	protected $coupon_logic;
	protected $message_model;
	protected $user_coupon_model;
	protected $product_comment_model;
	protected $list_num;


	function _initialize()
	{
		parent::_initialize();
		$this->product_cats_model = D('Muushop/MuushopProductCats');
		$this->product_model      = D('Muushop/MuushopProduct');
		$this->coupon_model       = D('Muushop/MuushopCoupon');
		$this->message_model      = D('Muushop/MuushopMessage');
		$this->user_coupon_model  = D('Muushop/MuushopUserCoupon');
		$this->coupon_logic       = D('Muushop/MuushopCoupon', 'Logic');
		$this->order_model        = D('Muushop/MuushopOrder');
		$this->product_comment_model = D('Muushop/MuushopProductComment');
		//列表页每页显示商品数
		$this->list_num = modC('MUUSHOP_LIST_NUM',16,'Muushop');

		//分类
		$map['status'] = 1;
		$items = $this->product_cats_model->getList($map,$order='sort asc');
		foreach($items as &$v){
			$v['link'] = U('Muushop/Index/cats',array('id'=>$v['id']));
		}
		unset($v);
		$items = list_to_tree($items,$pk = 'id', 'parent_id', $child = 'items');
		
		$this->assign('cats',$items);
	}

	public function index($page = 1, $r = 20)
	{

		$map['status']=1;
        /* 获取当前分类下列表 */
        list($list,$totalCount) = $this->product_model->getListByPage($map,$page,'id desc,create_time desc','*',$r);

		//dump($menu);exit;
		$this->assign('list', $list);
        $this->assign('totalCount',$totalCount);
		$this->display();

	}

	public function cats()
	{
		$page = I('page',1,'intval');;
		$r = $this->list_num;
		$id = I('id',0,'intval');
		$all_son_id = $this->product_cats_model->get_all_cat_id_by_pid($id);
		//dump($all_son_id);exit;
		$map['cat_id'] = array('in',$all_son_id);
		$map['status']=1;
        /* 获取当前分类下列表 */
        list($list,$totalCount) = $this->product_model->getListByPage($map,$page,'id desc,create_time desc','*',$r);
        foreach($list as &$val){
        	$val['price'] = price_convert('yuan',$val['price']);
    		$val['ori_price'] = price_convert('yuan',$val['ori_price']);
        }
        unset($val);

		$this->assign('list', $list);
        $this->assign('totalCount',$totalCount);
        $this->assign('r',$r);
		$this->display();

	}
	/**
	 * 商品搜索
	 * @param  integer $page [description]
	 * @param  integer $r    [description]
	 * @return [type]        [description]
	 */
	public function search($page = 1, $r = 24){

		$key = I('post.key','','text');



		$map['title'] = array('LIKE',$key);
		$map['status']=1;

		/* 获取当前分类下列表 */
        list($list,$totalCount) = $this->product_model->getListByPage($map,$page,'id desc,create_time desc','*',$r);

        foreach($list as &$val){
        	$val['price'] = price_convert('yuan',$val['price']);
        }
        unset($val);

        $this->assign('list', $list);
        $this->assign('totalCount',$totalCount);
		$this->display();
	}


	public function product()
	{
		$id = I('id', '', 'intval');
		$product = $this->product_model->get_product_by_id($id);
		$sharedata = array(
			'title'=>$product['title'],
			'imgUrl'=>'http://'.$_SERVER['HTTP_HOST'].pic($product['main_img']),
		);

		if($product['sku_table']){
			$minPrice= intval($product['price']);
			$maxPrice= intval($product['price']);
			//dump($product['sku_table']['info']);exit;
			foreach($product['sku_table']['info'] as $val){
				if($val['price']==''){
					$val['price']= intval($product['price']);
				}
				//dump($val['price']);
				if($val['price']<=$minPrice){
					$minPrice = $val['price'];
				}
				if($val['price']>=$maxPrice){
					$maxPrice = $val['price'];
				}
			}
			unset($val);
			if($minPrice==$maxPrice){
					$product['price']=$minPrice;
					$product['price'] = $product['price'];
			}else{
					$minPrice = sprintf("%.2f",$minPrice/100);
					$maxPrice = sprintf("%.2f",$maxPrice/100);
					$product['price']=$minPrice.'-'.$maxPrice;
			}

			foreach($product['sku_table']['info'] as &$val){
				$val['price'] = sprintf("%.2f",$val['price']/100);
				$val['ori_price'] = sprintf("%.2f",$val['ori_price']/100);
			}
			unset($val);

			$product['ori_price'] = sprintf("%.2f",$product['ori_price']/100);
		}else{
			$product['price'] = sprintf("%.2f",$product['price']/100);
			$product['ori_price'] = sprintf("%.2f",$product['ori_price']/100);
		}

		//处理商品图片
		$product['main_pic'] = getThumbImageById($product['main_img'],800,800);
		//处理预览图
		if($product['images']){
			$thumbArr = explode(',',$product['images']);
			$product['thumb'] = array();
			$product['thumb100'] = array();
			$product['thumb500'] = array();
			foreach($thumbArr as &$v){
				$product['thumb100'][] = getThumbImageById($v,100,100);
				$product['thumb500'][] = getThumbImageById($v,500,500);
			}
			unset($v);
		}
		$product_sku = json_encode($product['sku_table']);
		//售后保障
		$service = modC('MUUSHOP_SHOW_SERVICE','','Muushop');

		$this->assign('product',$product);
		$this->assign('product_sku',$product_sku);
		$this->assign('service',$service);
		$this->assign('sharedata', $sharedata);
		$this->display();
	}

	/*
	 * 商城建议
	 */
	public function suggest()
	{
		$this->init_user();
		if (IS_POST)
		{
			//提交处理
			$message = $this->message_model->create();
			if (!$message)
			{
				$this->error($this->message_model->getError());
			}
			$message['user_id'] = $this->user_id;
			$ret                = $this->message_model->add_or_edit_shop_message($message);
			if ($ret)
			{
				$this->success('提交成功。');
			}
			else
			{
				$this->error('提交失败。');
			}
		}
		else
		{
			$this->display();
		}
	}

	/**
	 *
	 * jsApi微信支付示例
	 * 注意：
	 * 1、微信支付授权目录配置如下  http://test.hoomuu.com/addon/Wxpay/Index/jsApiPay/mp_id/
	 * 2、支付页面地址需带mp_id参数
	 * 3、管理后台-基础设置-公众号管理，微信支付必须配置的参数都需填写正确
	 * @param array $mp_id 公众号在系统中的ID
	 * @return 将微信支付需要的参数写入支付页面，显示支付页面
	 *
	 *
	 *
	 *  参数 mp_id 微信公众号id
	 *      order_id 订单id
	 */

	public function jsApiPay(){
		$this->init_user();
		empty($this->mp_id) && $this->error('支付暂不可使用,还未配置收款公众号');//没配置收款公众号
		//$mid = get_weuser_mid();//获取粉丝用户mid，一个神奇的函数，没初始化过就初始化一个粉丝
//		if($mid === false){
//			$this->error('只可在微信中访问');
//		}
		//$user = get_mid_weuser($mid);//获取本地存储公众号粉丝用户信息
		//$this->assign('user', $user);

		//$surl = get_shareurl();
		//if(!empty($surl)){
		//	$this->assign ( 'share_url', $surl );
		//}

		$order_id = I('order_id',0,'intval');
		if(empty($order_id)) $this->error('缺少订单号'); //没订单号

		$odata = $this->order_logic->BeforePayOrder($order_id,$this->user_id,$this->mp_id);
		if(!$odata)
		{
			$this->error('订单初始化失败,'.$this->order_logic->error_str);
		}
		$info     = get_mpid_appinfo($this->mp_id);
		if (!($jsApiParameters = S('wshop_order_' . $order_id . '_jsApiParameters')))
		{
			//获取公众号信息，jsApiPay初始化参数
			$cfg = array(
				'APPID'      => $info['appid'],
				'MCHID'      => $info['mchid'],
				'KEY'        => $info['mchkey'],
				'APPSECRET'  => $info['appsecret'],
				'NOTIFY_URL' => $info['notify_url'],
			);
			//dump($cfg);exit;
			WxPayConfig::setConfig($cfg);

			//①、初始化JsApiPay
			$tools    = new JsApiPay();
			$wxpayapi = new WxPayApi();
			//检查订单状态 微信回调延迟或出错时 保证订单状态
			$inputs = new WxPayOrderQuery();
			$inputs->SetOut_trade_no($odata);
			$result = $wxpayapi->orderQuery($inputs);
			if(array_key_exists("return_code", $result)
				&& array_key_exists("result_code", $result)
				&& array_key_exists("trade_state", $result)
				&& $result["return_code"] == "SUCCESS"
				&& $result["result_code"] == "SUCCESS"
				&& $result["trade_state"] == "SUCCESS"
				)
			{
				$this->order_logic->AfterPayOrder($result,$odata);
				redirect(U('Muushop/index/orderdetail',array('id'=>$order_id)));
			}
			//②、统一下单
			$input = new WxPayUnifiedOrder();           //这里带参数初始化了WxPayDataBase
			$input->SetBody($odata['product_name']);
			$input->SetAttach($odata['product_sku']);
			$input->SetOut_trade_no($odata['order_id']);
			$input->SetTotal_fee($odata['order_total_price']);
			$input->SetTime_start(date("YmdHis"));
			$input->SetTime_expire(date("YmdHis", time() + 600));
			$input->SetTrade_type("JSAPI");
			$input->SetOpenid($user['openid']);

			$order = $wxpayapi->unifiedOrder($input);
			$jsApiParameters = $tools->GetJsApiParameters($order);
//			$editAddress = $tools->GetEditAddressParameters();
//			//③、在支持成功回调通知中处理成功之后的事宜，见 notify.php
			S('wshop_order_' . $order_id . '_jsApiParameters', $jsApiParameters, 575);//设置缓存 缓存过期时间 稍微比微信支付过期短点
		}
		$this->assign ( 'order', $odata );
		$this->assign ( 'jsApiParameters', $jsApiParameters );
//		$this->assign ( 'editAddress', $editAddress );
		$this->display ();
	}

	/*
 * 取扫描支付二维码
 */
	public function nativepay()
	{
		$this->init_user();
		empty($this->mp_id) && $this->error('支付暂不可使用');//没配置收款公众号
		$info     = get_mpid_appinfo($this->mp_id);
		$order_id = I('order_id', '', 'intval');
		empty($order_id) && $this->error('缺少订单号');

		$odata = $this->order_logic->BeforePayOrder($order_id,$this->user_id,$this->mp_id);
		if(!$odata)
		{
			$this->error($this->order_logic->error_str);
		}

		if (!($result["code_url"] = S('wshop_order_' . $order_id . '_code_url')))
		{
			//获取公众号信息，jsApiPay初始化参数
			$cfg = array(
				'APPID'      => $info['appid'],
				'MCHID'      => $info['mchid'],
				'KEY'        => $info['mchkey'],
				'APPSECRET'  => $info['secret'],
				'NOTIFY_URL' => $info['notify_url'],
			);
			WxPayConfig::setConfig($cfg);
			$notify = new NativePay();
			$input  = new WxPayUnifiedOrder();
			$input->SetBody($odata['product_name']);
			$input->SetOut_trade_no($odata['order_id']);
			$input->SetTotal_fee($odata['product_price']);
			$input->SetTime_start(date("YmdHis"));
			$input->SetTime_expire(date("YmdHis", time() + 600));
			$input->SetTrade_type("NATIVE");
			$input->SetProduct_id($odata['product_id']);
			$result = $notify->GetPayUrl($input);
			S('wshop_order_' . $order_id . '_code_url',$result["code_url"],575);
		}
		$this->assign ( 'order', $odata );
		$this->assign ( 'isWeixinBrowser', isWeixinBrowser() );
		$this->assign ( 'code_url', $result["code_url"] );
		$this->display ();
	}


	public function preview_delivery()
	{

//		var_dump(__file__.' line:'.__line__,$_REQUEST);exit;
		$address = array(
			'province' => I('province', '','text'),
			'city'     => I('city', '','text'),
			'town'     => I('town', '','text'),
		);

		$products = I('products','');
		if(empty($products))
		{
			$products = array(
				array(
					'id'   => I('id','','intval'), //商品id
					'count' => I('quantity', 1,'intval'), //商品数目
				));
		}
		else
		{
			is_array($products) || $this->error();
			foreach ($products as $k => &$p)
			{
				($p['id'] = I('data.id','','intval',$p)) || $this->error(1);
				($p['quantity'] = I('data.quantity','','intval',$p)) || $this->error(2);
				$products[$k]['count'] = $products[$k]['quantity'];
			}
		}
		$ret = $this->order_logic->precalc_delivery($products, $address);
		if($ret)
		{
			$this->success($ret);
		}
		else
		{
			$this->error();
		}

	}
}
