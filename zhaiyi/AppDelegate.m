//
//  AppDelegate.m
//  zhaiyi
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "CZRootTool.h"
#import "APService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "My_Login_In_ViewController.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "tuiChuTixing.h"
#import "UPPaymentControl.h"

@interface AppDelegate ()
<
WXApiDelegate
>
{
    tuiChuTixing *tixing ;
    UIView *backView;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self jiGuangTuiSong];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"%@",remoteNotification);
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [self uMengShare];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    
    [APService setupWithOption:launchOptions];
    
    [CZRootTool chooseRootViewController:self.window];
    [self.window makeKeyAndVisible];
    
    [self weiXinPay];
    //高德地图
    [self configureAPIKey];
    
    //监听退出
    [self tuichu];
    
    return YES;
}

//////////////////////////////////////////其他账号登陆相关操作／／／／／／／／／／／／／／／／／／／／／／／／
-(void)tuichu
{
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"tuichu" object:nil];

}
-(void)notice:(id)sender
{
    tixing = [tuiChuTixing LoadView];
    
    [tixing YesBtnAddTarget:self action:@selector(tuichuMakeSure) forControlEvents:UIControlEventTouchUpInside];
    tixing.x = (ScreenW-tixing.width)/2;
    tixing.y = (ScreenH-tixing.height)/2;
    
    
    
    backView = [Function createBackView:self action:@selector(backClicked)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    [[UIApplication sharedApplication].keyWindow addSubview:tixing];

}
-(void)tuichuMakeSure
{
    [tixing removeFromSuperview];
    [backView removeFromSuperview];
    
    UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* MainCotroller = [MainStoryboard instantiateViewControllerWithIdentifier:@"MainNav"];
    // 设置窗口的根控制器
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    keyWindow.rootViewController = MainCotroller;

    [ADAccountTool deleteAccount];
}
-(void)backClicked
{
    
}
//////////////////////////////////////--end--其他账号登陆////////////////////////////////////////
#pragma mark 高德地图
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
#define kMALogTitle @"提示"
#define kMALogContent @"apiKey为空，请检查key是否正确设置"
        
        NSString *log = [NSString stringWithFormat:@"[MAMapKit] %@", kMALogContent];
        NSLog(@"%@", log);
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMALogTitle message:kMALogContent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
//        });
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapSearchServices sharedServices].apiKey = (NSString *)APIKey;
}

#pragma mark 微信支付
-(void)weiXinPay{
    [WXApi registerApp:WX_APP_ID withDescription:@"亿装支付"];
}
//微信支付回调
-(void)onResp:(BaseResp *)resp{
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode: %d",resp.errCode];

    NSString *strTitle;
    if ([resp isKindOfClass:[PayResp class]]) {
        
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    NSLog(@"resp    %@",resp);
    NSDictionary *respDict = [NSDictionary dictionaryWithObject:resp forKey:@"resp"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"WXpayresult" object:nil userInfo:respDict];
 }

#pragma mark 分享
-(void)uMengShare{
    
    [UMSocialData setAppKey:@"569703cde0f55ab2bc0006b3"];
     //QQ
    //[UMSocialQQHandler setQQWithAppId:@"1104951123" appKey:@"FwOJSUJTYSOzE8Uc" url:SHARE_URL];
    [UMSocialQQHandler setQQWithAppId:@"1105244107" appKey:@"EJx8lws2kWGWJee2" url:SHARE_URL];
    
//     [UMSocialData defaultData].extConfig.qqData.url = SHARE_URL;

    [UMSocialQQHandler setSupportWebView:YES];
    //微信
    //[UMSocialWechatHandler setWXAppId:@"wx2863d9247c321b5c" appSecret:@"e5cf3a3ed66f1090275eb2bb997b2076" url:SHARE_URL];
    [UMSocialWechatHandler setWXAppId:@"wx05c7d1017ae4ebdb" appSecret:@"f1bfd3a7eb4465fcb3dc151e8656b359" url:SHARE_URL];
}


//推送相关

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"%@",userInfo);
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];
     NSLog(@"收到通知:%@", [self logDic:userInfo]);
    //设置角标
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    //[rootViewController addNotificationCount];
}

//点击通知进入app
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    //程序在前台
    if(application.applicationState == UIApplicationStateActive)
    {
       
        NSString *content = [userInfo objectForKey:@"content"];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知消息" message: content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
        [alert show];
    }
    //点击通知程序从后台进入前台
    else if (application.applicationState == UIApplicationStateInactive)
    {
        NSLog(@"applicationState  %ld",application.applicationState );
        
    }else if (application.applicationState == UIApplicationStateBackground)
    {
        NSLog(@"applicationState  %ld",application.applicationState );
    }
    
    NSLog(@"%ld",application.applicationState );
    NSLog(@"%@",userInfo);
   
    NSString *Type = [userInfo objectForKey:@"type"];
    int numType = [Type intValue];
   // NSLog(@"%@",Type);
    
    //保存发布工人通知
    if (numType == 12) {
       // NSLog(@"啊啊啊啊啊啊啊啊啊%@",[userInfo objectForKey:@"type"]) ;
        //保存发布找工人通知数
        [Function SaveFaBuZhaoGongRen:nil];
    }else if(
             numType == 2 ||
             numType == 3 ||
             numType == 4 ||
             numType == 5 ||
             numType == 6
             )
    {
        //保存工人收到订单状态改变通知数
       [Function SaveDingDanChangge_gongren:nil];
        
    }else
    {
        //保存雇主收到订单状态改变通知数
        [Function SaveDingDanChangge_guzhu:nil];
    }
    
    //发送通知 改变图标状态
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhiTuBiao" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    //type = 7,有人抢单
    //type = 9,有人发起结算
    //type = 10,有人确认收款
    //type = 12 有雇主发布了新的订单
    [APService handleRemoteNotification:userInfo];
    [APService resetBadge];
    
   // NSLog(@"收到通知:%@", [self logDic:userInfo]);
    //设置角标
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        
        return nil;
    }
    
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

//******************************************推送相关******************************************
//极光推送
-(void)jiGuangTuiSong
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}


- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接");
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    
    if ([APService registrationID]) {
        NSLog(@"get RegistrationID");
    }
}

//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    
//    NSDictionary *userInfo = [notification userInfo];
//    NSString *title = [userInfo valueForKey:@"title"];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extra = [userInfo valueForKey:@"extras"];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    
//    NSString *currentContent = [NSString
//                                stringWithFormat:
//                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
//                                [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                               dateStyle:NSDateFormatterNoStyle
//                                                               timeStyle:NSDateFormatterMediumStyle],
//                                title, content, [self logDic:extra]];
//    NSLog(@"%@", currentContent);
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知消息" message: content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    
//    [alert show];
//    
//}




-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    NSLog(@"%@",url);
    //设置回调
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
    
    
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSLog(@"%@",url);
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
    }
    
    if ([url.host isEqualToString:@"pay"]) {//微信支付
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        return YES;
    }
    //银联支付
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            
            //判断签名数据是否存在
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return;
            }
            
            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:0
                                                                 error:nil];
            NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
            
            
            
            //验签证书同后台验签证书
            //此处的verify，商户需送去商户后台做验签
//            if([self verify:sign]) {
//                //支付成功且验签成功，展示支付成功提示
//            }
//            else {
//                //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//            }
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            [ITTPromptView showMessage:@"交易失败"];
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            [ITTPromptView showMessage:@"交易取消"];

        }
    }];


    
    return result;
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //设置角标
    //[UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //设置角标
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
