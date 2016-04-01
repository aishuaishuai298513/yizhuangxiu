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

@interface AppDelegate ()
<
WXApiDelegate
>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    
//        My_Login_In_ViewController *login = [[My_Login_In_ViewController alloc]init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
//        self.window.rootViewController = nav;
    
    [CZRootTool chooseRootViewController:self.window];
    [self.window makeKeyAndVisible];
    
    [self weiXinPay];
    //高德地图
    [self configureAPIKey];
    
    
    return YES;
}
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
    [WXApi registerApp:WX_APP_ID withDescription:@"小木匠支付"];
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
    [UMSocialQQHandler setQQWithAppId:@"1104951123" appKey:@"FwOJSUJTYSOzE8Uc" url:SHARE_URL];
//     [UMSocialData defaultData].extConfig.qqData.url = SHARE_URL;

    [UMSocialQQHandler setSupportWebView:YES];

    //微信
    [UMSocialWechatHandler setWXAppId:@"wx2863d9247c321b5c" appSecret:@"e5cf3a3ed66f1090275eb2bb997b2076" url:SHARE_URL];
    
}
//推送相关
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    //[rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
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

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    //设置回调
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
    
    
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
    }
    if ([url.host isEqualToString:@"pay"]) {//微信支付
        return  [WXApi handleOpenURL:url delegate:self];
    }
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
