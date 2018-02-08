<?php
/*
热卖商品
 */

namespace Muushop\Widget;

use Think\Controller;

class HotWidget extends Controller{
    /* 显示指定分类的同级分类或子分类列表 */
    public function lists($cat_id=0, $order='click_cnt desc',$limit = 8 )
    {
        if ($cat_id != 0) {
            $cates=D('Muushop/MuushopProductCats')->get_product_cats(array('parent_id'=>$cat_id,'status'=>1));
            $cates=array_column($cates,'id');
            $map['cat_id']=array('in',array_merge(array($cat_id),$cates));
        }
        $map['status']=1;
        $lists = D('Muushop/MuushopProduct')->getList($map,'click_cnt desc',$limit,'*');
        foreach($lists as &$v){
            $v['price'] = price_convert('yuan',$v['price']);
        }
        unset($v);
        $this->assign('lists', $lists);
        $this->assign('cat_id',$cat_id);
        $this->display('Widget/hot');
    }
} 