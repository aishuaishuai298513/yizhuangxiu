//
//  Header.h
//  zhaiyi
//
//  Created by ass on 16/3/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef Header_h
#define Header_h

//通用域名
#define YZX_BASY_URL @"http://test7.feiteng010.com"
//注册
#define YZX_resign @"/api/index/reg"
//发送验证码
#define YZX_sendCode @"/api/index/sendcode"
//登陆
#define YZX_login @"/api/index/login"
//找回密码
#define YZX_repassword @"/api/index/repassword"
//关于易装修
#define YZX_aboutYZX @"/api/index/guanyuyizhuangxiu"
//保证金说明
#define YZX_baozhengjinshuoming @"/api/index/baozhengjinshuoming"
//版本更新
#define YZX_banbengengxin @"/api/index/banbengengxin"
//定时上传经纬度
#define YZX_shangchuanjingweidu @"/api/index/shangchuanjingweidu"
//个人资料（雇主端）
#define YZX_gerenziliao_gz @"/api/index/gerenziliao_gz"
//个人资料保存(雇主)
#define YZX_gerenzhiliao_gz_baocun @"/api/index/gerenzhiliao_gz_baocun"
//地图搜索雇主端
#define YZX_search_gz @"/api/index/search_gz"
//更换头像雇主
#define YZX_genghuantouxiang_gz @"/api/index/upload_headpic_gz"
//更换头像工人
#define YZX_genghuantouxiang_gr @"/api/index/upload_headpic_gr"
//我的（雇主端）
#define wode_gz @"/api/index/wode_gz"
//我的（工人端）
#define wode_gr @"/api/index/wode_gr"
//设置/修改支付密码
#define YZX_UpdatePassword @"/api/index/shezhizhifumima"
//钱包
#define YZX_qianbao @"/api/index/qianbao"
//意见反馈
#define YZX_yijianfankui @"/api/index/yijianfankui"
//联系我们
#define YZX_lianxiwomen @"/api/index/lianxiwomen"
//保证金纪录
#define YZX_baozhengjinjilu @"/api/index/baozhengjinjilu"
//红包
#define YZX_hongbao @"/api/index/hongbao"
//找工人页面（雇主端
#define YZX_zhaogongren @"/api/index/zhaogongren"
//通过发布人数获取应缴质保金（雇主端）
#define YZX_returnzhibaojin @"/api/index/returnzhibaojin"
//提交订单接口（雇主端）
#define YZX_tijiaodingdan @"/api/index/tijiaodingdan"
//订单列表（雇主端）
#define YZX_dingdanlist @"/api/index/dingdanlist"
//订单详情（雇主端）
#define YZX_dingdanxiangqing @"/api/index/dingdanxiangqing"
//辞退
#define YZX_citui @"/api/index/citui"
//地图搜索工人端
#define YZX_search_gr @"/api/index/search_gr"
//订单列表（工人端)
#define YZX_orderlist @"/api/index/orderlist"
//抢单详情（工人段）
#define YZX_qiangdanxiangqing @"/api/index/qiangdanxiangqing"
//抢单（工人端）
#define YZX_qiangdan @"/api/index/qiangdan"
//继续发布界面
#define YZX_jixufabu @"/api/index/jixufabupage"
//重新发布
#define YZX_chongxinfabu @"/api/index/chongxinfabu"
//辞退页面（雇主段）
#define YZX_cituipage @"/api/index/cituipage"
//确认开工
#define YZX_querenkaigong @"/api/index/querenkaigong"
//支付保证金－余额支付（雇主端）
#define YZX_zhifubaozhengjin_yue @"/api/index/zhifubaozhengjin_yue"
//提现－ 银行列表
#define YZX_yinhang @"/api/index/yinhang"
//提现
#define YZX_tixian @"/api/index/tixian"
//提现页面
#define YZX_tixianyemian @"/api/index/tixianyemian"
//交易记录
#define YZX_jiaoyijilu @"/api/index/jiaoyijilu"
//交易纪录详情
#define YZX_jiaoyijiluxiangqing @"/api/index/jiaoyijiluxiangqing"
//切换身份
#define YZX_qiehuan @"/api/index/qiehuanshenfen"
//个人资料（工人端
#define YZX_gerenziliaogr @"/api/index/gerenziliao_gr"
//个人资料保存（工人端）
#define YZX_gerenzhiliao_gr_baocun @"/api/index/gerenzhiliao_gr_baocun"
//订单（工人端）
#define YZX_dingdan_gr @"/api/index/dingdan"
//取消订单（工人端）
#define YZX_quxiaodingdan_gr @"/api/index/quxiaodingdan"
//实时结算页面（工人端）
#define YZX_shishijiesuan_gr @"/api/index/shishijiesuanpage"
//实时结算（工人端）
#define YZX_jiesuan_gr @"/api/index/shishijiesuan"
//删除订单（工人端）
#define YZX_shanchudingdan_gr @"/api/index/shanchudingdan"
//评价列表（雇主端）
#define YZX_pingjialiebiao_gr @"/api/index/pingjialiebiao_gr"
//支付工资页面（雇主端）
#define YZX_zhifugongzipage @"/api/index/zhifugongzipage"
//支付工资-余额支付（雇主端）
#define YZX_zhifugongzi_yue @"/api/index/zhifugongzi_yue"
//拒绝支付（雇主端）
#define YZX_jujuezhifu @"/api/index/jujuezhifu"
//确认收款（工人端）
#define YZX_querenshoukuan @"/api/index/querenshoukuan"
//评价工人
#define YZX_pingjiagongren @"/api/index/pingjiagongren"
//取消订单（雇主端）
#define YZX_quxiaodingdan_gz @"/api/index/quxiaodingdan_gz"
//删除订单（雇主端）
#define YZX_shanchudingdan_gz @"/api/index/shanchudingdan_gz"
//工种列表
#define YZX_gongzhongliebiao @"/api/index/gongzhonglist"
//删除个人资料资质证书（工人端）
#define YZX_shanchuzizhi @"/api/index/shanchuzizhi"
//支付工资  线下支付
#define YZX_xianxia  @"/api/index/zhifugongzi_xianxia"
//支付宝支付
#define YZX_zhifubaozhifu @"/api/index/zhifubaozhifu"
//微信支付
#define YZX_weixinzhifu @"/api/index/weixinzhifu"
//银联支付
#define YZX_yinlianzhifu @"/api/index/yinlianzhifu"
//我的消息
#define YZX_wodexiaoxi_gz @"/api/index/wodexiaoxi"
//删除消息
#define YZX_delmessage @"/api/index/del_message"


#endif /* Header_h */
