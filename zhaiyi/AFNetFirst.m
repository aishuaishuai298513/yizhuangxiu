//
//  AFNetFirst.m
//  4S GOLF
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AFNetFirst.h"

#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define BASE_URL  [NSURL URLWithString:YZX_BASY_URL]
@implementation AFNetFirst

static BOOL isFirst = NO;
static BOOL canUseNetWork =NO;

+ (void)GET:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data))block
{
    
    
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当前网络未知
        if (status == -1) {
            //            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
            [SVProgressHUD showErrorWithStatus:@"网络连接失败,请查看网络是否连接正常！"];
            
        }
        // 当前无连接
        if (status == 0) {
            [SVProgressHUD showErrorWithStatus:@"网络连接失败,请查看网络是否连接正常！"];
        }
        // 当前为3G网络
        if (status == 1) {
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:BASE_URL];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // 获取的数据传回去
                NSDictionary * ary = (NSDictionary *)responseObject;
                if ([[ary objectForKey:@"message"] isEqualToString:@"非法访问"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"denglu" object:nil];
                }else{
                    block(responseObject);
                }
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@", error);
            }];
        }
        // 当前为WiFi
        if (status == 2) {
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:BASE_URL];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * ary = (NSDictionary *)responseObject;
                if ([[ary objectForKey:@"message"] isEqualToString:@"非法访问"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"denglu" object:nil];
                }else{
                    block(responseObject);
                }
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                //                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接不稳定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //                [errorAlert show];
                //                NSLog(@"error = %@", error);
            }];
        }
    }];
}


+ (void)GET2:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data , NSError * error))block
{
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当前网络未知
        if (status == -1) {
            //            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
            [SVProgressHUD showErrorWithStatus:@"网络连接失败,请查看网络是否连接正常！"];
            
        }
        // 当前无连接
        if (status == 0) {
            [SVProgressHUD showErrorWithStatus:@"网络连接失败,请查看网络是否连接正常！"];
        }
        // 当前为3G网络
        if (status == 1) {
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:BASE_URL];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // 获取的数据传回去
                NSDictionary * ary = (NSDictionary *)responseObject;
                if ([[ary objectForKey:@"message"] isEqualToString:@"非法访问"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"denglu" object:nil];
                }else{
                    block(responseObject,nil);
                }
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接不稳定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [errorAlert show];
                block(nil,error);
            }];
        }
        // 当前为WiFi
        if (status == 2) {
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:BASE_URL];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary * ary = (NSDictionary *)responseObject;
                if ([[ary objectForKey:@"message"] isEqualToString:@"非法访问"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"denglu" object:nil];
                }else{
                    block(responseObject,nil);
                }
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接不稳定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [errorAlert show];
                NSLog(@"error = %@", error);
                block(nil,error);
            }];
        }
    }];
}


+ (void)POST:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data))block
{
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当前网络未知
        if (status == -1) {
            static int flag = 1;
            if (flag == 1) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            flag++;
        }
        // 当前无连接
        if (status == 0) {
            static int flag = 1;
            if (flag == 1) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            };
        }
        // 当前为3G网络
        if (status == 1) {
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:BASE_URL];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
            [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // 获取的数据传回去
                block(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@", error);
            }];
        }
        // 当前为WiFi
        if (status == 2) {
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]initWithBaseURL:BASE_URL];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
            [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                block(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@", error);
            }];
        }
    }];
}
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    // AFNetWorking
    // 创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
    // 发生请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
//data数据流形式上传图片，key为字段
+(void)typePicturePOST:(NSString *)strPath parameters:(NSDictionary *)dic withPicureData:(NSData *)pictureData  withKey:(NSString *)key finish:(void (^)(NSData *data,NSError *error) )cb
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    //调用这个函数的时候只检查一次网络。
    if (isFirst==NO) {
        //网络只有在startMonitoring 完成后才可以检查网络状态
        [[AFNetworkReachabilityManager sharedManager]startMonitoring]; //监听网络状态
        
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"status is %d",(int)status);
            canUseNetWork=YES;
        }];
        isFirst=YES;
    }
    BOOL isOK=[[AFNetworkReachabilityManager sharedManager]isReachable];
    //网络不可用时
    if (isOK==FALSE  && canUseNetWork ==YES ) {
        NSError *error=[NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        cb (nil, error);
        return;
    }
    
    
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc]initWithBaseURL:BASE_URL];

    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:strPath parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ([key isEqualToString:@"sound"]) {
            [formData appendPartWithFileData:pictureData name:key fileName:@"headPicture.mp3" mimeType:@"image/png"];
        } else {
            [formData appendPartWithFileData:pictureData name:key fileName:@"headPicture.png" mimeType:@"image/png"];
        }
        //        [formData appendPartWithFileData:pictureData name:key fileName:@"headPicture.png" mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        cb (responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        cb (nil,error);
    }];
    
    //用来计算上传的进度。
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
        //nytesSent 本次上传了多少字节
        //totalBytesSent 累计上传了多少字节
        //totalBytesExpectedToSend 文件有多大，应该上传多少
        NSLog(@"task %@ progree is %f",task,totalBytesSent*1.0/totalBytesExpectedToSend);
    }];
}

//data数据流形式上传多张图片，key为字段
+(void)typearrPicturePOST:(NSString *)strPath parameters:(NSDictionary *)dic withPicureData:(NSArray *)pictureData  withKeyArray:(NSArray *)keyArray finish:(void (^)(NSData *data,NSError *error) )cb
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    //调用这个函数的时候只检查一次网络。
    if (isFirst==NO) {
        //网络只有在startMonitoring 完成后才可以检查网络状态
        [[AFNetworkReachabilityManager sharedManager]startMonitoring]; //监听网络状态
        
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"status is %d",(int)status);
            canUseNetWork=YES;
        }];
        isFirst=YES;
    }
    BOOL isOK=[[AFNetworkReachabilityManager sharedManager]isReachable];
    //网络不可用时
    if (isOK==FALSE  && canUseNetWork ==YES ) {
        NSError *error=[NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        cb (nil, error);
        return;
    }
    
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc]initWithBaseURL:BASE_URL];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:strPath parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i=0;i<pictureData.count;i++){
            if ([keyArray[i] isEqualToString:@"sound"]) {
                [formData appendPartWithFileData:pictureData[i] name:keyArray[i] fileName:@"headPicture.mp3" mimeType:@"image/png"];
            } else {
                [formData appendPartWithFileData:pictureData[i] name:keyArray[i] fileName:@"headPicture.png" mimeType:@"image/png"];
            }
            
            //            [formData appendPartWithFileData:pictureData[i] name:keyArray[i] fileName:@"headPicture.png" mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [SVProgressHUD dismiss];
        cb (responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [SVProgressHUD dismiss];
        cb (nil,error);
    }];
    
    //用来计算上传的进度。
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
        //nytesSent 本次上传了多少字节
        //totalBytesSent 累计上传了多少字节
        //totalBytesExpectedToSend 文件有多大，应该上传多少
        NSLog(@"task %@ progree is %f",task,totalBytesSent*1.0/totalBytesExpectedToSend);
        
        
        
    }];
}





@end
