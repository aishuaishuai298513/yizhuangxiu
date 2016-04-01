//
//  NetWork.h
//  DouBanMovie
//
//  Created by ass on 14-10-8.
//  Copyright (c) 2016年 ass. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define BaseUrl @"http://zhaiyi.bjqttd.com"

#define BaseUrl @"http://123.56.235.148"
//高德appkey

//BASEURL
#define Unicom_URL1 @"http://drf.unioncloud.com:10094/"

//找工人通用
#define ZhaoGongRen @"http://drf.unioncloud.com:10094/drf/datagateway/drfrestservice/ExecuteFunction"

//发布的订单
#define FaBuDeDingDan @"/api/personal/my_order"

//注册
#define ZhuCe @"/api/user/register"

//登录
#define DengLu @"/api/user/login"

//抢单
#define qiangDan @"/api/grab/grab_order"

//工人端抢单列表 | 施工中
#define GrQdlbWorking @"/api/grab/grab_list_work"

//工人端抢单列表 | 已完成
#define GrQdlbWorked @"/api/grab/grab_list_finish"

//雇主端 确认招用抢单列表
#define QrzyQdlb @"/api/grab/grab_list"

//雇主发布订单
#define FaBuXuQiu @"/api/grab/send_demand"

//工人端|工人端查看雇主下单列表
#define qiangDanLieBiao @"/api/grab/work_list"

//雇主招用
#define guzhuzhaoyong @"/api/grab/confirm_recruit"

//雇主验收
#define guzhuyanShou @"/api/grab/confirm_check"

//获取短信验证码
//#define getYanZhengMa @"/api/user/SendTemplateSMS"
  #define getYanZhengMa @"/api/user/registeredSMS"
//更新工人位置
#define gengXinGongRenWeizhi @"/api/user/save_user_place"

//附近工人
#define fujinGongRen @"/api/user/near_worker"

//雇主订单数量
#define guzhuDingDanshuliang @"/api/personal/my_order_count"

//工人端的抢单列表状态的数量
#define gongRenDingDanShuLiang @"/api/grab/work_count"

//工人竣工
#define gongRenJungong @"/api/grab/worker_finish"

//工人取消订单
#define gongRenQuxiaoDingDan @"/api/grab/cancel_order"

//订单评价 | 工人端和雇主端
#define dingdanPingJia @"/api/grab/order_appraise"

//雇主端 | 辞退工人
#define ciTuiGongRen @"/api/grab/cancel_work"

//工人端 | 我的消息
#define wodexiaoxi @"/api/personal/my_work_news"

//工人端 | 消息详情
#define xiangxixiangqing @"/api/personal/my_work_news"

//雇主删除订单
#define guzhushanchuDingdan @"/api/grab/delete_employee_order"

//工人删除订单
#define gongrenshanchuDingdan @"/api/grab/delete_work_order"

//礼包
#define libao @"/api/personal/my_gift"

//雇主端 | 已竣工的工人列表
#define yijungongGongRenLb @"/api/grab/work_finsh_list"

//雇主单独评价
#define danduPingjia @"/api/grab/comment_worker"

//雇主端 | 一键评价
#define yiJianPingjia @"/api/grab/user_first_commont"

#define GongZhongFenLei @"/api/personal/work_sort"

#define pingjiaLieBiao @"/api/grab/check_worker_comment"

#define xiaoxixiangqing @"/api/grab/indent_details"

//删除评价
#define shanchuPingjia @"/api/grab/delete_assess"

#define fujinDingdan @"/api/user/near_order"

//判断是否可以确认招用
#define IfQueRenZhaoYong @"/api/grab/check"



//#define BASEURL [NSURL URLWithString:Unicom_URL1]

//通用
//#define zhaoGongRen @"drf/datagateway/drfrestservice/ExecuteFunction"


@interface NetWork : NSObject<UIAlertViewDelegate>

+ (void)GET:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data))block; // get 请求方式

+ (void)GET2:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data , NSError * error))block; // get 请求方式

+ (void)POST:(NSString *)url andBaseURL:(NSString *)baseUrl parmater:(NSMutableDictionary *)dic Block:(void (^)(NSDictionary *data))block; // post 请求方式

/**
 *  发送一个get请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */

+(void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

+(void)typePicturePOST:(NSString *)strPath parameters:(NSDictionary *)dic withPicureData:(NSData *)pictureData  withKey:(NSString *)key finish:(
                                                                                                                       void (^)(NSData *data,NSError *error) )cb;

+(void)typearrPicturePOST:(NSString *)strPath parameters:(NSDictionary *)dic withPicureData:(NSArray *)pictureData  withKeyArray:(NSArray *)keyArray finish:(void (^)(NSData *data,NSError *error) )cb;


///////---ass

//封装AFN
+(void)get:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure;

//发送POST请求
+(void)post:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure;

/**
 *  无预留参数的Post请求
 */
+(void)postNoParm:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (void)postWithParmStr:(NSString *)url functionName:(NSString *)functionName jsonParams:(NSString *)jsonParams UserID:(NSString *)UserID success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

+(void)postNoParmForMap:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure;

@end
