-- -----------------------------
-- 表结构 `muucmf_muushop_cart`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_cart` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '顾客id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `sku_id` varchar(128) NOT NULL COMMENT '格式 pruduct_id;尺寸:X;颜色:红色',
  `quantity` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '件数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `us` (`user_id`,`sku_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='购物车';


-- -----------------------------
-- 表结构 `muucmf_muushop_coupon`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_coupon` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '优惠券id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `duration` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '有效期, 单位为秒, 0表示长期有效',
  `publish_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总发放数量',
  `used_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '已发放数量',
  `title` varchar(32) NOT NULL DEFAULT '' COMMENT '优惠券名称',
  `img` varchar(255) NOT NULL DEFAULT '' COMMENT '优惠券图片',
  `brief` varchar(256) NOT NULL DEFAULT '' COMMENT '优惠券说明',
  `valuation` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '类型, 0 现金券, 1 折扣券',
  `rule` text NOT NULL COMMENT '计费json {discount: 1000}',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='优惠券';


-- -----------------------------
-- 表结构 `muucmf_muushop_delivery`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_delivery` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '运费模板id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `title` varchar(32) NOT NULL DEFAULT '' COMMENT '模板名称',
  `brief` varchar(256) NOT NULL DEFAULT '' COMMENT '模板说明',
  `valuation` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '计费方式, 0 固定邮费, 1 计件',
  `rule` text NOT NULL COMMENT '计费json {express: {normal:{start:2,start_fee:10,add:1, add_fee:12}, custom:{location:[{}],}}}',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


-- -----------------------------
-- 表结构 `muucmf_muushop_messages`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '留言id',
  `parent_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '父级id',
  `reply_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '评论数',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户id, 0表示商户回复',
  `extra_info` varchar(255) NOT NULL DEFAULT '' COMMENT '其他信息',
  `brief` varchar(255) NOT NULL DEFAULT '' COMMENT '留言',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 待审核, 1 审核成功,  2 审核失败',
  PRIMARY KEY (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- -----------------------------
-- 表结构 `muucmf_muushop_nav`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_nav` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '导航ID',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级导航ID',
  `title` char(30) NOT NULL COMMENT '导航标题',
  `url` char(100) NOT NULL COMMENT '导航链接[如果是分类即显示分类ID]',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '导航排序',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `target` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '新窗口打开',
  `color` varchar(30) NOT NULL,
  `band_color` varchar(30) NOT NULL,
  `band_text` varchar(30) NOT NULL,
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


-- -----------------------------
-- 表结构 `muucmf_muushop_order`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `pingid` varchar(128) NOT NULL COMMENT 'ping++ID',
  `order_no` varchar(22) NOT NULL COMMENT '商家订单号 唯一',
  `client_ip` varchar(255) NOT NULL COMMENT '用户下单ip',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '顾客id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '下单时间',
  `paid_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '支付时间',
  `paid` int(1) NOT NULL DEFAULT '0' COMMENT '0未支付 1已支付',
  `send_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '发货时间',
  `recv_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '收货时间',
  `paid_fee` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最终支付的总价, 单位为分',
  `discount_fee` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '已优惠的价格, 是会员折扣, 现金券,积分抵用 之和',
  `delivery_fee` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '邮费',
  `use_point` varchar(255) NOT NULL DEFAULT '0' COMMENT '使用了积分情况{score1:100,score2:500}',
  `back_point` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '返了多少积分',
  `pay_type` varchar(36) NOT NULL COMMENT '0 未设置, ''onlinepay'':''在线支付'',''balance'':''余额'',''delivery'':''货到付款''',
  `pay_info` varchar(512) NOT NULL DEFAULT '' COMMENT '根据pay_type有不同的数据',
  `channel` varchar(64) NOT NULL COMMENT '在线支付的支付类型',
  `address` varchar(512) NOT NULL DEFAULT '' COMMENT '收货信息json {province:广东,city:深圳,town:南山区,address:工业六路,name:猴子,phone:15822222222, delivery:express}',
  `delivery_info` varchar(512) NOT NULL DEFAULT '' COMMENT '发货信息 {name:顺丰快递, order:12333333}',
  `info` text NOT NULL COMMENT '信息 {remark: 买家留言, fapiao: 发票抬头}',
  `products` text NOT NULL COMMENT '商品信息[{sku_id:"pruduct_id;尺寸:X;颜色:红色", paid_price:100, quantity:2, title:iphone,main_img:xxxxxx}]',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1 待付款, 2 待发货, 3 已发货, 4 已收货, 5 退货中, 6，退货完成 9 卖家取消 10 已取消 11 等待卖家确认 12 已评论',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8 COMMENT='订单';


-- -----------------------------
-- 表结构 `muucmf_muushop_product`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_product` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `cat_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '分类id',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '商品标题',
  `description` varchar(255) NOT NULL COMMENT '简短描述',
  `content` text NOT NULL COMMENT '商品详情',
  `main_img` int(11) NOT NULL DEFAULT '0' COMMENT '商品主图',
  `images` text NOT NULL COMMENT '商品图片,分号分开多张图片',
  `like_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点赞数',
  `fav_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '收藏数',
  `comment_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '评论数',
  `click_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '点击数',
  `sell_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总销量',
  `score_cnt` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '评分次数',
  `score_total` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '总评分',
  `price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '价格,单位为分',
  `ori_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '原价,单位为分',
  `quantity` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '库存',
  `product_code` varchar(64) NOT NULL DEFAULT '' COMMENT '商家编码,可用于搜索',
  `info` varchar(32) NOT NULL DEFAULT '0' COMMENT '从低到高默认 0 不货到付款, 1不包邮 2不开发票 3不保修 4不退换货 5不是新品 6不是热销 7不是推荐',
  `position` varchar(32) NOT NULL COMMENT '展示位',
  `back_point` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购买返还积分',
  `point_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '积分换购所需分数',
  `buy_limit` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '限购数,0不限购',
  `sku_table` text NOT NULL COMMENT 'sku表json字符串,空表示没有sku, 如{table:[{尺寸:[X,M,L]}], info: }',
  `location` varchar(255) NOT NULL DEFAULT '' COMMENT '货物所在地址json {country:中国,province:广东,city:深圳,town:南山区,address:工业六路}',
  `delivery_id` int(11) NOT NULL DEFAULT '0' COMMENT '运费模板id, 不设置将免运费',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `modify_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '编辑时间',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序,从大到小',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '1 正常, 0 下架',
  PRIMARY KEY (`id`),
  KEY `cat_id` (`cat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;


-- -----------------------------
-- 表结构 `muucmf_muushop_product_cats`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_product_cats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '父分类id',
  `title` varchar(64) NOT NULL DEFAULT '' COMMENT '分类名称',
  `title_en` varchar(128) NOT NULL DEFAULT '' COMMENT '分类名称英文',
  `image` int(11) NOT NULL DEFAULT '0' COMMENT '图片id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序,从大到小',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 正常, 1 隐藏',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;


-- -----------------------------
-- 表结构 `muucmf_muushop_product_comment`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_product_comment` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '评论id',
  `product_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `order_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '订单id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '0 未审核, 1 审核成功, 20 审核失败',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `images` varchar(256) NOT NULL DEFAULT '' COMMENT '晒图,分号分开多张图片',
  `score` decimal(3,2) unsigned NOT NULL DEFAULT '5.00' COMMENT '用户打分, 1 ~ 5 星',
  `brief` varchar(256) NOT NULL DEFAULT '' COMMENT '回复内容',
  `sku_id` varchar(64) NOT NULL DEFAULT '' COMMENT '商品 sku_id',
  PRIMARY KEY (`id`),
  KEY `po` (`product_id`,`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='评论';


-- -----------------------------
-- 表结构 `muucmf_muushop_product_extra_info`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_product_extra_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序,从大到小',
  `ukey` varchar(32) NOT NULL COMMENT '键',
  `data` varchar(512) NOT NULL COMMENT '值',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品更多信息表';


-- -----------------------------
-- 表结构 `muucmf_muushop_product_sell`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_product_sell` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '交易id',
  `product_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '商品id',
  `order_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '订单id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `paid_price` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '下单价格',
  `quantity` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '下单数目',
  `detail` text NOT NULL COMMENT '商品信息{sku_id:"pruduct_id;尺寸:X;颜色:红色"}',
  PRIMARY KEY (`id`),
  KEY `po` (`product_id`,`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='交易记录';


-- -----------------------------
-- 表结构 `muucmf_muushop_user_address`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_user_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '顾客id',
  `modify_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '最后使用时间',
  `name` varchar(64) NOT NULL COMMENT '收货人姓名',
  `phone` varchar(16) NOT NULL DEFAULT '' COMMENT '电话',
  `province` int(10) NOT NULL COMMENT '省',
  `city` int(10) NOT NULL COMMENT '市',
  `district` int(10) NOT NULL COMMENT '地区',
  `address` varchar(64) NOT NULL DEFAULT '' COMMENT '详细地址',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='收货地址';


-- -----------------------------
-- 表结构 `muucmf_muushop_user_coupon`
-- -----------------------------
CREATE TABLE IF NOT EXISTS `muucmf_muushop_user_coupon` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户优惠券id',
  `user_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户id',
  `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `expire_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '到期时间,0表示永不过期',
  `order_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '使用的订单id, 0表示未使用',
  `read_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '领取时间 或 阅读时间',
  `coupon_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `info` text NOT NULL COMMENT '计费json {title: 10元, img: xxx, valuation: 0, rule{discount: 1000}}',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='优惠券';

-- -----------------------------
-- 表内记录 `muucmf_muushop_cart`
-- -----------------------------
INSERT INTO `muucmf_muushop_cart` VALUES ('6', '1', '1522285472', '12;尺码:M;颜色:黑色', '1');
INSERT INTO `muucmf_muushop_cart` VALUES ('7', '1', '1522285478', '11', '1');
-- -----------------------------
-- 表内记录 `muucmf_muushop_coupon`
-- -----------------------------
INSERT INTO `muucmf_muushop_coupon` VALUES ('1', '1482404289', '0', '0', '6', '测试优惠', '', '<p>测试优惠测试优惠测试优惠测试优惠</p>', '0', '{\"discount\":100}');
INSERT INTO `muucmf_muushop_coupon` VALUES ('2', '1482723402', '604800', '88', '3', '测试优惠券', '', '<p>测试优惠券</p>', '0', '{\"max_cnt\":1,\"max_cnt_day\":1,\"min_price\":1000,\"discount\":100}');
-- -----------------------------
-- 表内记录 `muucmf_muushop_delivery`
-- -----------------------------
INSERT INTO `muucmf_muushop_delivery` VALUES ('2', '1483580004', '1517042609', '固定运费模板', '固定运费模板', '0', '{\"express\":{\"name\":\"\\u666e\\u901a\\u5feb\\u9012\",\"cost\":1000}}');
INSERT INTO `muucmf_muushop_delivery` VALUES ('3', '1483588779', '1483876559', '指定地区运费', '按照地区不同设置不同价位的运费', '1', '{\"express\":{\"name\":\"\\u666e\\u901a\\u5feb\\u9012\",\"normal\":{\"start\":\"1\",\"start_fee\":1000,\"add\":\"1\",\"add_fee\":300},\"custom\":[{\"area\":[{\"id\":\"110000\",\"name\":\"\\u5317\\u4eac\\u5e02\"},{\"id\":\"120000\",\"name\":\"\\u5929\\u6d25\\u5e02\"},{\"id\":\"130000\",\"name\":\"\\u6cb3\\u5317\\u7701\"},{\"id\":\"140000\",\"name\":\"\\u5c71\\u897f\\u7701\"}],\"cost\":{\"start\":\"1\",\"start_fee\":600,\"add\":\"1\",\"add_fee\":300}},{\"area\":[{\"id\":\"150000\",\"name\":\"\\u5185\\u8499\\u53e4\"},{\"id\":\"210000\",\"name\":\"\\u8fbd\\u5b81\\u7701\"},{\"id\":\"220000\",\"name\":\"\\u5409\\u6797\\u7701\"},{\"id\":\"230000\",\"name\":\"\\u9ed1\\u9f99\\u6c5f\"}],\"cost\":{\"start\":\"1\",\"start_fee\":1000,\"add\":\"1\",\"add_fee\":200}},{\"area\":[{\"id\":\"540000\",\"name\":\"\\u897f\\u3000\\u85cf\"},{\"id\":\"650000\",\"name\":\"\\u65b0\\u3000\\u7586\"},{\"id\":\"710000\",\"name\":\"\\u53f0\\u6e7e\\u7701\"},{\"id\":\"810000\",\"name\":\"\\u9999\\u3000\\u6e2f\"},{\"id\":\"820000\",\"name\":\"\\u6fb3\\u3000\\u95e8\"}],\"cost\":{\"start\":\"1\",\"start_fee\":2000,\"add\":\"1\",\"add_fee\":600}},{\"area\":[{\"id\":\"310000\",\"name\":\"\\u4e0a\\u6d77\\u5e02\"},{\"id\":\"320000\",\"name\":\"\\u6c5f\\u82cf\\u7701\"},{\"id\":\"330000\",\"name\":\"\\u6d59\\u6c5f\\u7701\"}],\"cost\":{\"start\":\"1\",\"start_fee\":800,\"add\":\"1\",\"add_fee\":300}}]}}');
-- -----------------------------
-- 表内记录 `muucmf_muushop_nav`
-- -----------------------------
INSERT INTO `muucmf_muushop_nav` VALUES ('1', '0', '首页', '/muushop', '0', '1', '0', '#000000', '#000000', '', '0', '0');
INSERT INTO `muucmf_muushop_nav` VALUES ('2', '0', '全部商品', 'index.php?s=/muushop/index/cats', '1', '1', '0', '#000000', '#000000', '', '0', '0');
INSERT INTO `muucmf_muushop_nav` VALUES ('3', '0', '手机', '4', '2', '1', '0', '#000000', '#000000', '', '0', '0');
INSERT INTO `muucmf_muushop_nav` VALUES ('4', '0', '美容&彩妆', '4', '3', '1', '0', '#000000', '#000000', '', '0', '0');
INSERT INTO `muucmf_muushop_nav` VALUES ('5', '0', '用户', 'index.php?s=/muushop/user', '4', '1', '0', '#000000', '#000000', '', '0', '0');
-- -----------------------------
-- 表内记录 `muucmf_muushop_order`
-- -----------------------------
INSERT INTO `muucmf_muushop_order` VALUES ('195', 'ch_KO8CiHeD8GO45Wvrn9e90Wf5', '20180309101630744447', '223.20.215.170', '1', '1520561790', '1520561794', '1', '1520563615', '1520909870', '2600', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"7;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"1600\",\"title\":\"\\u5b89\\u5409\\u5c14\\u51c0\\u6c34\\u5668\\u5bb6\\u7528\\u76f4\\u996e\\u81ea\\u6765\\u6c34\\u8fc7\\u6ee4\\u5668\",\"main_img\":\"4\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('196', 'ch_P8qPeHu5Su508Siz5CvLynb1', '20180312081148387784', '223.20.215.170', '1', '1520813508', '1520813513', '1', '0', '0', '2500', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"7;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"1500\",\"title\":\"\\u5b89\\u5409\\u5c14\\u51c0\\u6c34\\u5668\\u5bb6\\u7528\\u76f4\\u996e\\u81ea\\u6765\\u6c34\\u8fc7\\u6ee4\\u5668\",\"main_img\":\"4\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('197', '', '20180312085955718585', '223.20.215.170', '1', '1520816395', '0', '0', '0', '0', '56900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"10;\\u5c3a\\u7801:\\u4e2d\\u53f7\",\"quantity\":\"1\",\"paid_price\":\"12800\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1222\",\"main_img\":\"10\"},{\"sku_id\":\"11\",\"quantity\":\"1\",\"paid_price\":\"26600\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1555\",\"main_img\":\"9\"},{\"sku_id\":\"7;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"1600\",\"title\":\"\\u5b89\\u5409\\u5c14\\u51c0\\u6c34\\u5668\\u5bb6\\u7528\\u76f4\\u996e\\u81ea\\u6765\\u6c34\\u8fc7\\u6ee4\\u5668\",\"main_img\":\"4\"},{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '10');
INSERT INTO `muucmf_muushop_order` VALUES ('198', '', '20180313112805270996', '223.20.215.170', '1', '1520911685', '0', '0', '0', '0', '15900', '0', '1000', '\"\"', '0', 'delivery', '', '', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('199', '', '20180313112959904716', '223.20.215.170', '1', '1520911799', '0', '0', '0', '0', '27600', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"11;\",\"quantity\":\"1\",\"paid_price\":\"26600\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1555\",\"main_img\":\"9\"}]', '10');
INSERT INTO `muucmf_muushop_order` VALUES ('200', 'ch_H8KCeDn5a5q14iDiP8S0yr10', '20180313133520740396', '223.20.215.170', '1', '1520919320', '1520919324', '1', '1520919345', '1520946265', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:L;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('201', 'ch_84GeTKW54OOK5G4i108mfb90', '20180313210722901724', '116.243.238.37', '1', '1520946442', '1520946446', '1', '1520946472', '1522286780', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '4');
INSERT INTO `muucmf_muushop_order` VALUES ('202', 'ch_nDuPm91CKyHOP0u948KSqTiL', '20180313213259853394', '116.243.238.37', '1', '1520947979', '1520950822', '1', '0', '0', '27600', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"11;\",\"quantity\":\"1\",\"paid_price\":\"26600\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1555\",\"main_img\":\"9\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('203', '', '20180313220723392524', '116.243.238.37', '1', '1520950043', '0', '0', '1521177185', '1521177193', '60800', '0', '1800', '\"\"', '25', 'delivery', '', '', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"5;\\u989c\\u8272:\\u7c89\\u8272;\\u5c3a\\u7801:L\",\"quantity\":\"5\",\"paid_price\":\"11800\",\"title\":\"\\u666e\\u83b1\\u5fb7\\u7535\\u52a8\\u81ea\\u884c\\u8f66 \\u6298\\u53e0\\u7535\\u52a8\\u6ed1\\u677f\\u8f6648V\\u9502\\u7535\\u6c60\\u7535\\u52a8\\u8f66 \\u4e00\\u4f53\\u8f6e\\u7537\\u5973\\u901a\\u7528\\u7535\\u74f6\\u8f66 \\u53d8\\u901f\\u7535\\u52a8\\u5355\\u8f66\\u4ee3\\u6b65 \\u81f3\\u5c0a\\u7248\",\"main_img\":\"7\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('204', 'ch_eP8CiP5inPCC98yzLOKKKyT4', '20180313221359185536', '116.243.238.37', '1', '1520950439', '1520950701', '1', '0', '0', '13800', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"10;\\u5c3a\\u7801:\\u8d85\\u5927\\u53f7\",\"quantity\":\"1\",\"paid_price\":\"12800\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1222\",\"main_img\":\"10\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('205', 'ch_ezP8W1rDifzHfrjLu9X1CmT8', '20180314143245801334', '116.243.238.37', '1', '1521009165', '1521009170', '1', '1521009189', '1521009196', '42000', '0', '1000', '\"\"', '5', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"5;\\u989c\\u8272:\\u7c89\\u8272;\\u5c3a\\u7801:L\",\"quantity\":\"1\",\"paid_price\":\"11800\",\"title\":\"\\u666e\\u83b1\\u5fb7\\u7535\\u52a8\\u81ea\\u884c\\u8f66 \\u6298\\u53e0\\u7535\\u52a8\\u6ed1\\u677f\\u8f6648V\\u9502\\u7535\\u6c60\\u7535\\u52a8\\u8f66 \\u4e00\\u4f53\\u8f6e\\u7537\\u5973\\u901a\\u7528\\u7535\\u74f6\\u8f66 \\u53d8\\u901f\\u7535\\u52a8\\u5355\\u8f66\\u4ee3\\u6b65 \\u81f3\\u5c0a\\u7248\",\"main_img\":\"7\"},{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"},{\"sku_id\":\"10;\\u5c3a\\u7801:\\u5c0f\\u53f7\",\"quantity\":\"1\",\"paid_price\":\"12800\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1222\",\"main_img\":\"10\"},{\"sku_id\":\"7;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"1500\",\"title\":\"\\u5b89\\u5409\\u5c14\\u51c0\\u6c34\\u5668\\u5bb6\\u7528\\u76f4\\u996e\\u81ea\\u6765\\u6c34\\u8fc7\\u6ee4\\u5668\",\"main_img\":\"4\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('206', '', '20180314182205700689', '114.242.249.62', '1', '1521022925', '0', '0', '0', '0', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_wap', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:XL;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '10');
INSERT INTO `muucmf_muushop_order` VALUES ('207', 'ch_erPaHGqXvrjHj5GWDGrnjLWP', '20180315102454248618', '116.243.238.37', '1', '1521080694', '1521080699', '1', '0', '0', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:S;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('208', 'ch_y5Smn5Xj98yLDSOevDyLe9C8', '20180316131635764813', '116.243.238.37', '1', '1521177395', '1521177400', '1', '0', '0', '101000', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"6;\",\"quantity\":\"1\",\"paid_price\":\"100000\",\"title\":\" Apple iPad Air 2 \\u5e73\\u677f\\u7535\\u8111 9.7\\u82f1\\u5bf8\",\"main_img\":\"3\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('209', 'ch_i1yzL0if9CqHWDyLm1eLer9K', '20180320074849276788', '116.243.238.37', '1', '1521503329', '1521503361', '1', '0', '0', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:XL;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('210', 'ch_1uPabT1qHOuTC4u14CvXLKW9', '20180321180045824106', '116.243.195.246', '1', '1521626445', '1521626449', '1', '1521626495', '1521626518', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:S;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('211', 'ch_i5eXzPr14yrD5S4u9OP8mjLC', '20180321182855396927', '116.243.195.246', '1', '1521628135', '1521628138', '1', '1521628151', '1521684878', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('212', 'ch_rHuPaH14Oev9ePSuzT9e9CGK', '20180321192211603341', '116.243.195.246', '1', '1521631331', '1521631335', '1', '1521631383', '1521683991', '2500', '0', '1000', '\"\"', '0', 'onlinepay', '', 'upacp_pc', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u7533\\u901a\\u5feb\\u9012\",\"ShipperCode\":\"STO\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"7;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"1500\",\"title\":\"\\u5b89\\u5409\\u5c14\\u51c0\\u6c34\\u5668\\u5bb6\\u7528\\u76f4\\u996e\\u81ea\\u6765\\u6c34\\u8fc7\\u6ee4\\u5668\",\"main_img\":\"4\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('213', 'ch_WnXz5KTebjf1jXrP04m184OC', '20180322095904224627', '116.243.195.246', '1', '1521683944', '1521683947', '1', '1521683978', '1521683988', '15900', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '{\"ShipperName\":\"\\u987a\\u4e30\\u901f\\u9012\",\"ShipperCode\":\"SF\",\"LogisticCode\":\"123456\"}', '{\"remark\":\"\"}', '[{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '12');
INSERT INTO `muucmf_muushop_order` VALUES ('214', '', '20180326221725561142', '116.243.237.1', '1', '1522073845', '0', '0', '0', '0', '42500', '0', '1000', '\"\"', '0', 'delivery', '', '', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"11\",\"quantity\":\"1\",\"paid_price\":\"26600\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1555\",\"main_img\":\"9\"},{\"sku_id\":\"12;\\u5c3a\\u7801:S;\\u989c\\u8272:\\u9ed1\\u8272\",\"quantity\":\"1\",\"paid_price\":\"14900\",\"title\":\"\\u5b98\\u65b9\\u6b63\\u7248 \\u795e\\u72ac\\u5c0f\\u4e03 \\u77ed\\u8896T\\u6064 \\u60c5\\u4fa3\\u6b3e\",\"main_img\":\"12\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('215', 'ch_PKazXHGe9mj5Pa98uPqH88a1', '20180327083700251643', '116.243.237.1', '1', '1522111020', '1522231947', '1', '0', '0', '40400', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"10;\\u5c3a\\u7801:\\u8d85\\u5927\\u53f7\",\"quantity\":\"1\",\"paid_price\":\"12800\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1222\",\"main_img\":\"10\"},{\"sku_id\":\"11\",\"quantity\":\"1\",\"paid_price\":\"26600\",\"title\":\"\\u6d4b\\u8bd5\\u5546\\u54c1555\",\"main_img\":\"9\"}]', '2');
INSERT INTO `muucmf_muushop_order` VALUES ('216', '', '20180329094651627591', '116.243.237.1', '1', '1522288011', '0', '0', '0', '0', '2500', '0', '1000', '\"\"', '0', 'onlinepay', '', 'alipay_pc_direct', '{\"id\":\"57\",\"user_id\":\"1\",\"modify_time\":\"1517296642\",\"name\":\"\\u6d4b\\u8bd5\\u65b0\",\"phone\":\"13426436565\",\"province\":\"110000\",\"city\":\"110100\",\"district\":\"110101\",\"address\":\"sdfsdfdsdfsf\",\"create_time\":\"1517296642\",\"delivery\":\"express\"}', '', '{\"remark\":\"\"}', '[{\"sku_id\":\"7;\\u989c\\u8272:\\u767d\\u8272\",\"quantity\":\"1\",\"paid_price\":\"1500\",\"title\":\"\\u5b89\\u5409\\u5c14\\u51c0\\u6c34\\u5668\\u5bb6\\u7528\\u76f4\\u996e\\u81ea\\u6765\\u6c34\\u8fc7\\u6ee4\\u5668\",\"main_img\":\"4\"}]', '1');
-- -----------------------------
-- 表内记录 `muucmf_muushop_product`
-- -----------------------------
INSERT INTO `muucmf_muushop_product` VALUES ('5', '6', '普莱德电动自行车 折叠电动滑板车48V锂电池电动车 一体轮男女通用电瓶车 变速电动单车代步 至尊版', '你没有看错！就是39元！两条70元还送皮带一条！没错！还包邮！！！抢2016秋冬款、男士条绒裤！！！好质量：不掉色、不起球、免烫免熨。质量保证！！！新品促销：前期赚人气、赔本跑量；每条低价售出；新品促销数量有限，赶快抢购！质量保证！请亲放心购买！！！限时促销价！不定时涨价！！', '<p>商品描述区域</p>', '7', '', '0', '0', '2', '0', '9', '2', '10', '11800', '12000', '10', '', '', '1,2,4', '5', '0', '0', '{\"table\":{\"\\u989c\\u8272\":[\"\\u767d\\u8272\",\"\\u84dd\\u8272\",\"\\u7c89\\u8272\"],\"\\u5c3a\\u7801\":[\"X\",\"XL\",\"L\"]},\"info\":{\"\\u989c\\u8272:\\u767d\\u8272;\\u5c3a\\u7801:X\":{\"price\":\"10000\",\"ori_price\":\"12000\",\"quantity\":\"5\"},\"\\u989c\\u8272:\\u767d\\u8272;\\u5c3a\\u7801:XL\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"2\"},\"\\u989c\\u8272:\\u767d\\u8272;\\u5c3a\\u7801:L\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"0\"},\"\\u989c\\u8272:\\u84dd\\u8272;\\u5c3a\\u7801:X\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"3\"},\"\\u989c\\u8272:\\u84dd\\u8272;\\u5c3a\\u7801:XL\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"4\"},\"\\u989c\\u8272:\\u84dd\\u8272;\\u5c3a\\u7801:L\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"0\"},\"\\u989c\\u8272:\\u7c89\\u8272;\\u5c3a\\u7801:X\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"4\"},\"\\u989c\\u8272:\\u7c89\\u8272;\\u5c3a\\u7801:XL\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"0\"},\"\\u989c\\u8272:\\u7c89\\u8272;\\u5c3a\\u7801:L\":{\"price\":\"11800\",\"ori_price\":\"12000\",\"quantity\":\"5\"}}}', '', '3', '1474959867', '1517744763', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('6', '11', ' Apple iPad Air 2 平板电脑 9.7英寸', '2017国际邀请赛新款 TI7周边 官方正版 大陆首发', '', '3', '3,4,6,5,8,9', '0', '0', '0', '0', '0', '0', '0', '100000', '100099', '11', '', '', '1,2,4', '0', '0', '0', '', '', '2', '1475377530', '1517744752', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('7', '6', '安吉尔净水器家用直饮自来水过滤器', '2017国际邀请赛新款 TI7周边 官方正版 大陆首发', '<p><img src=\"/Uploads/Editor/Picture/2016-10-02/57f0b59460ae6.jpg\" title=\"\" alt=\"TB2k6xXadfB11BjSspmXXctQVXa_!!2177654919.jpg\"/></p>', '4', '', '0', '0', '3', '0', '0', '3', '14', '5000', '5000', '10', '', '', '1', '0', '0', '0', '{\"table\":{\"\\u989c\\u8272\":[\"\\u9ed1\\u8272\",\"\\u767d\\u8272\"]},\"info\":{\"\\u989c\\u8272:\\u9ed1\\u8272\":{\"price\":\"1600\",\"ori_price\":\"10000\",\"quantity\":4},\"\\u989c\\u8272:\\u767d\\u8272\":{\"price\":\"1500\",\"ori_price\":\"10000\",\"quantity\":\"6\"}}}', '', '2', '1475392963', '1519783049', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('8', '6', 'Beats 节拍独奏者第二代无线豪华版红色头戴式耳机', '2017国际邀请赛新款 TI7周边 官方正版 大陆首发', '<p>体验全新的声音</p><p>Solo2更具活力，传递出音域更广、更加清晰的声音，让您更接近艺术家要表达的音色。无论您是喜欢嘻哈音乐、重金属、爵士乐还是电子乐，Solo2都能给您带来保真度更高的震撼音效。</p><p>流线型设计</p><p>Solo2拥有流线型美学造型，制造技术和材料选择一丝不苟，只为打造更加经久耐用的头戴式耳机。可轻松折叠，随时陪伴您游走他方。</p><p>定制舒适为舒适而打造</p><p>从灵活的头带中心开始，头戴式耳机的头架拥有前所未有的弯曲度，给予Solo2贴身定制的感觉。耳杯弯出人体工学角度，采用多个轴心达到这种自然配合，以实现最佳的舒适性和声音传递。最后，耳杯采用优质材料，可帮助散热和减少声音外泄。</p><p>不需要接触设备&nbsp;</p><p>掌控自如。只需通过色彩协调的 RemoteTalk耳机线，无需接触设备，即可切换歌曲和调节音量，甚至接听电话。（兼容iOS设备。功能可能随设备不同而有所差异。</p><p><br/></p><p><br/></p><p><br/></p>', '5', '', '0', '0', '0', '0', '1', '0', '0', '120000', '130000', '3', '', '', '1,2,4', '0', '0', '0', '', '', '3', '1481600657', '1517744740', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('9', '4', 'Apple/苹果 MacBook Air 13.3英寸笔记本电脑 i5 8G 128G', '【正规发票】 纤薄轻巧 8G内存 超长续航', '<p style=\"text-align: center;\"><img src=\"/Uploads/Editor/Picture/2017-01-10/58748b0b12735.jpg\" style=\"\"/></p><p style=\"text-align: center;\"><img src=\"/Uploads/Editor/Picture/2017-01-10/58748b0b11b15.jpg\" style=\"\"/></p><p style=\"text-align: center;\"><img src=\"/Uploads/Editor/Picture/2017-01-10/58748b0b126f6.jpg\" style=\"\"/></p><p style=\"text-align: center;\"><img src=\"/Uploads/Editor/Picture/2017-01-10/58748b0b8f5ba.jpg\" style=\"\"/></p><p style=\"text-align: center;\"><img src=\"/Uploads/Editor/Picture/2017-01-10/58748b0bea8bc.jpg\" style=\"\"/></p><p><br/></p>', '6', '', '0', '0', '0', '0', '0', '0', '0', '608000', '698800', '121', '1231232110101010', '', '1,2,4', '10', '0', '0', '', '', '2', '1484032907', '1517744728', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('10', '6', '测试商品222', '斯蒂芬斯蒂芬是的是的发送', '<p>对方答复的</p>', '10', '7,11,10,8,9', '0', '0', '1', '0', '0', '1', '5', '12800', '19900', '100', '', '6', '1,2,4', '0', '0', '0', '{\"table\":{\"\\u5c3a\\u7801\":[\"\\u5927\\u53f7\",\"\\u5c0f\\u53f7\",\"\\u4e2d\\u53f7\",\"\\u8d85\\u5927\\u53f7\"]},\"info\":{\"\\u5c3a\\u7801:\\u5927\\u53f7\":{\"price\":\"12800\",\"ori_price\":\"19900\",\"quantity\":\"10\"},\"\\u5c3a\\u7801:\\u5c0f\\u53f7\":{\"price\":\"12800\",\"ori_price\":\"19900\",\"quantity\":\"10\"},\"\\u5c3a\\u7801:\\u4e2d\\u53f7\":{\"price\":\"12800\",\"ori_price\":\"19900\",\"quantity\":11},\"\\u5c3a\\u7801:\\u8d85\\u5927\\u53f7\":{\"price\":\"12800\",\"ori_price\":\"19900\",\"quantity\":\"10\"}}}', '', '2', '1517205239', '1517743727', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('11', '4', '测试商品555', '', '<p>撒大声地斯蒂芬斯蒂芬</p>', '9', '', '0', '0', '0', '0', '0', '0', '0', '26600', '89900', '102', '', '', '1,2,4', '0', '0', '0', '', '', '2', '1517206781', '1517743716', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('12', '6', '官方正版 神犬小七 短袖T恤 情侣款', '鲍宇同款短袖T恤 麻辣变形计 关小迪 梁大巍 情侣装', '<p>dfgdfgdfgdgdgdgdfgdgdgdgddfgdfgdfgdfgdfgdgdfgdfgdgdgddggdgdfgd</p>', '12', '12,13,14', '0', '0', '5', '0', '0', '5', '25', '14900', '26600', '100', '', '', '1,2,4', '0', '0', '0', '{\"table\":{\"\\u5c3a\\u7801\":[\"S\",\"M\",\"L\",\"XL\"],\"\\u989c\\u8272\":[\"\\u767d\\u8272\",\"\\u9ed1\\u8272\"]},\"info\":{\"\\u5c3a\\u7801:S;\\u989c\\u8272:\\u767d\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":\"10\"},\"\\u5c3a\\u7801:S;\\u989c\\u8272:\\u9ed1\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":\"10\"},\"\\u5c3a\\u7801:M;\\u989c\\u8272:\\u767d\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":11},\"\\u5c3a\\u7801:M;\\u989c\\u8272:\\u9ed1\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":\"10\"},\"\\u5c3a\\u7801:L;\\u989c\\u8272:\\u767d\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":\"2\"},\"\\u5c3a\\u7801:L;\\u989c\\u8272:\\u9ed1\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":\"4\"},\"\\u5c3a\\u7801:XL;\\u989c\\u8272:\\u767d\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":7},\"\\u5c3a\\u7801:XL;\\u989c\\u8272:\\u9ed1\\u8272\":{\"price\":\"14900\",\"ori_price\":\"26600\",\"quantity\":\"0\"}}}', '', '2', '1517208326', '1518011685', '0', '1');
INSERT INTO `muucmf_muushop_product` VALUES ('13', '21', 'test', '', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '0', '', '0', '0', '0', '', '', '2', '1519781324', '1519781324', '0', '0');
-- -----------------------------
-- 表内记录 `muucmf_muushop_product_cats`
-- -----------------------------
INSERT INTO `muucmf_muushop_product_cats` VALUES ('4', '0', '美容&彩妆', 'Moblie', '0', '1474959660', '2', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('5', '0', '小皮具', 'test2', '0', '1475324579', '3', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('6', '4', 'test11', 'test11', '26', '1475325849', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('7', '4', 'test12', 'test12', '27', '1475326163', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('8', '0', '首饰&配饰', 'pc', '0', '1475401673', '6', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('9', '0', '手袋', 'Communication', '0', '1475401776', '4', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('10', '0', '鞋履系列', 'HooMuu', '0', '1475401899', '5', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('11', '5', '皮质配饰', 'xiezi', '30', '1475453902', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('12', '8', '首饰', 'pc', '0', '1475453960', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('13', '8', '太阳镜', 'pad', '0', '1480938605', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('14', '0', '成衣', 'Women', '0', '1517471661', '1', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('15', '14', '毛呢大衣', '', '22', '1517471710', '4', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('16', '14', '羽绒服', '', '23', '1517471741', '5', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('17', '14', '针织毛衣', '', '24', '1517471798', '2', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('18', '14', '裙装裤装', '', '25', '1517471825', '3', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('19', '4', '彩妆', '', '28', '1517475159', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('20', '4', '美发护发', '', '29', '1517477998', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('21', '14', '夹克&外套', '', '31', '1517716418', '1', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('22', '5', '拉链钱包', '', '0', '1517716569', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('23', '10', '平底鞋', '', '0', '1517716755', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('24', '10', '高跟鞋', '', '0', '1517716772', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('25', '10', '凉鞋', '', '0', '1517716787', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('26', '10', '球鞋', '', '0', '1517716823', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('27', '10', '长靴&短靴', '', '0', '1517716860', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('28', '9', '肩背包', '', '0', '1517718119', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('29', '9', '手提包', '', '0', '1517718135', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('30', '9', '购物袋', '', '0', '1517718148', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('31', '9', '斜挎包&双肩包', '', '0', '1517720583', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('32', '9', '手拿包', '', '0', '1517720631', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('33', '9', '行李箱', '', '0', '1517720670', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('34', '5', '长款钱包', '', '0', '1517730850', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('35', '5', '迷你钱包', '', '0', '1517731859', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('36', '5', '卡片夹&零钱包', '', '0', '1517732031', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('37', '8', '织物配饰', '', '0', '1517734701', '0', '1');
INSERT INTO `muucmf_muushop_product_cats` VALUES ('38', '8', '皮带', '', '0', '1517734710', '0', '1');
-- -----------------------------
-- 表内记录 `muucmf_muushop_product_comment`
-- -----------------------------
INSERT INTO `muucmf_muushop_product_comment` VALUES ('1', '5', '205', '1', '1', '1521168974', '', '4.50', '', '5;颜色:粉色;尺码:L');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('2', '12', '205', '1', '1', '1521168974', '', '5.00', '', '12;尺码:M;颜色:黑色');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('3', '10', '205', '1', '1', '1521168974', '', '5.00', '', '10;尺码:小号');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('4', '7', '205', '1', '1', '1521168974', '', '4.50', '', '7;颜色:白色');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('5', '12', '200', '1', '1', '1521176799', '', '5.00', '', '12;尺码:L;颜色:黑色');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('6', '5', '203', '1', '1', '1521177208', '2,39', '5.00', '', '5;颜色:粉色;尺码:L');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('7', '7', '195', '1', '1', '1521503466', '2,39', '5.00', '', '7;颜色:黑色');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('8', '12', '210', '1', '1', '1521626555', '2,38', '5.00', '非常牛~性价比非常高', '12;尺码:S;颜色:白色');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('9', '12', '213', '1', '1', '1521684011', '', '4.50', '非常好的产品', '12;尺码:M;颜色:白色');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('10', '7', '212', '1', '1', '1521684852', '46', '4.00', '一般般~~~', '7;颜色:白色');
INSERT INTO `muucmf_muushop_product_comment` VALUES ('11', '12', '211', '1', '1', '1521684894', '2', '5.00', '还可以~', '12;尺码:M;颜色:白色');
-- -----------------------------
-- 表内记录 `muucmf_muushop_product_sell`
-- -----------------------------
INSERT INTO `muucmf_muushop_product_sell` VALUES ('1', '11', '187', '1', '1520428696', '26600', '1', '{\"sku_id\":\"11;\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('2', '7', '195', '1', '1520909870', '1600', '1', '{\"sku_id\":\"7;\\u989c\\u8272:\\u9ed1\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('3', '12', '200', '1', '1520946265', '14900', '1', '{\"sku_id\":\"12;\\u5c3a\\u7801:L;\\u989c\\u8272:\\u9ed1\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('4', '5', '205', '1', '1521009196', '11800', '1', '{\"sku_id\":\"5;\\u989c\\u8272:\\u7c89\\u8272;\\u5c3a\\u7801:L\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('5', '12', '205', '1', '1521009196', '14900', '1', '{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u9ed1\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('6', '10', '205', '1', '1521009196', '12800', '1', '{\"sku_id\":\"10;\\u5c3a\\u7801:\\u5c0f\\u53f7\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('7', '7', '205', '1', '1521009196', '1500', '1', '{\"sku_id\":\"7;\\u989c\\u8272:\\u767d\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('8', '5', '203', '1', '1521177193', '11800', '5', '{\"sku_id\":\"5;\\u989c\\u8272:\\u7c89\\u8272;\\u5c3a\\u7801:L\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('9', '12', '210', '1', '1521626518', '14900', '1', '{\"sku_id\":\"12;\\u5c3a\\u7801:S;\\u989c\\u8272:\\u767d\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('10', '12', '213', '1', '1521683988', '14900', '1', '{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u767d\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('11', '7', '212', '1', '1521683991', '1500', '1', '{\"sku_id\":\"7;\\u989c\\u8272:\\u767d\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('12', '12', '211', '1', '1521684878', '14900', '1', '{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u767d\\u8272\"}');
INSERT INTO `muucmf_muushop_product_sell` VALUES ('13', '12', '201', '1', '1522286780', '14900', '1', '{\"sku_id\":\"12;\\u5c3a\\u7801:M;\\u989c\\u8272:\\u9ed1\\u8272\"}');
-- -----------------------------
-- 表内记录 `muucmf_muushop_user_address`
-- -----------------------------
INSERT INTO `muucmf_muushop_user_address` VALUES ('55', '1', '0', '新大蒙', '13426436565', '110000', '110100', '110101', 'sdfsdfdsfsfsdfs梵蒂冈的', '0');
INSERT INTO `muucmf_muushop_user_address` VALUES ('56', '1', '0', '新的', '18618380435', '110000', '110100', '110101', '新地址胜多负少11', '1517294292');
INSERT INTO `muucmf_muushop_user_address` VALUES ('57', '1', '1517296642', '测试新', '13426436565', '110000', '110100', '110101', 'sdfsdfdsdfsf', '1517296642');
-- -----------------------------
-- 表内记录 `muucmf_muushop_user_coupon`
-- -----------------------------
INSERT INTO `muucmf_muushop_user_coupon` VALUES ('6', '1', '1482982087', '1483586887', '0', '0', '2', '{\"title\":\"\\u6d4b\\u8bd5\\u4f18\\u60e0\\u5238\",\"img\":\"\",\"valuation\":\"0\",\"rule\":{\"max_cnt\":1,\"max_cnt_day\":1,\"min_price\":1000,\"discount\":100}}');
INSERT INTO `muucmf_muushop_user_coupon` VALUES ('7', '1', '1482984487', '0', '74', '0', '1', '{\"title\":\"\\u6d4b\\u8bd5\\u4f18\\u60e0\",\"img\":\"\",\"valuation\":\"0\",\"rule\":{\"discount\":100}}');
INSERT INTO `muucmf_muushop_user_coupon` VALUES ('8', '1', '1484462795', '0', '92', '0', '1', '{\"title\":\"\\u6d4b\\u8bd5\\u4f18\\u60e0\",\"img\":\"\",\"valuation\":\"0\",\"rule\":{\"discount\":100}}');
INSERT INTO `muucmf_muushop_user_coupon` VALUES ('9', '1', '1521503836', '0', '0', '0', '1', '{\"title\":\"\\u6d4b\\u8bd5\\u4f18\\u60e0\",\"img\":\"\",\"valuation\":\"0\",\"rule\":{\"discount\":100}}');
