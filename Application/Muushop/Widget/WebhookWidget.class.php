<?php
// +----------------------------------------------------------------------
// | OneThink [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2013 http://www.onethink.cn All rights reserved.
// +----------------------------------------------------------------------
// | Author: 麦当苗儿 <zuojiazi@vip.qq.com> <http://www.zjzit.cn>
// +----------------------------------------------------------------------

namespace Muushop\Widget;
use Think\Controller;

class WebhookWidget extends Controller{

	/**
	 * webhook支付成功后的处理
	 * @param  [type] $data [description]
	 * @return [type]       [description]
	 */
	public function charge($data)
    {
        //D('Pingpay/PingpayWebhook')->addData($data);
        
        $order=D('Muushop/MuushopOrder')->get_order_by_order_no($data['order_no']);
        if($order['paid']!=1){//未支付状态就执行
            
            $wdata['id']=$order['id'];
            $wdata['paid']=1;
            $wdata['pingid']=$data['id'];
            $wdata['paid_time'] = $data['time_paid'];
            $wdata['status'] = 2;

            $res=D('Muushop/MuushopOrder')->add_or_edit_order($wdata);
            if(!$res){
                
                echo '数据写入失败';
                http_response_code(500);
            }else{
                
            	//支付成功后的数据处理

            }
        }else{
        	echo '数据有误或已处理';
            http_response_code(500);
        }
    }
}


