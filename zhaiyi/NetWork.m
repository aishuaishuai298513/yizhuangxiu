//
//  NetWork.m
//  DouBanMovie
//
//  Created by 周琦 on 14-10-8.
//  Copyright (c) 2014年 周琦. All rights reserved.
//

#import "NetWork.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "My_Login_In_ViewController.h"

@implementation NetWork

static BOOL isFirst = NO;
static BOOL canUseNetWork =NO;

+ (void)GET:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data))block
{
    
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
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
           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded",nil]];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:Url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded",nil]];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:Url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
                    block(responseObject);
      
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接不稳定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [errorAlert show];
                NSLog(@"error = %@", error);
            }];
        }
    }];
}


+ (void)GET2:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data , NSError * error))block
{
    
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    
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
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded",nil]];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:Url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // 获取的数据传回去
                block(responseObject,nil);
                
                [SVProgressHUD dismiss];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接不稳定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [errorAlert show];
                block(nil,error);
            }];
        }
        // 当前为WiFi
        if (status == 2) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded",nil]];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [manager GET:Url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 block(responseObject,nil);
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


+ (void)POST:(NSString *)url andBaseURL:(NSString *)baseUrl parmater:(NSMutableDictionary *)dic Block:(void (^)(NSDictionary *))block
{
    NSString *Url = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,url];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSLog(@"%@",dic);

    NSError *parseError = nil;
    
    NSString *string =[self dictionaryToJson:dic];
    
    [param setObject:string forKey:@"params"];
    
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
           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded",nil]];
            
            NSLog(@"%@",Url);
            [manager POST:Url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // 获取的数据传回去
                block([operation.responseString objectFromJSONString]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                block([operation.responseString objectFromJSONString]);
            }];
        }
        // 当前为WiFi
        if (status == 2) {
           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            // 对https加密解析
            manager.securityPolicy.allowInvalidCertificates = YES;
           [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded",nil]];
            NSLog(@"%@",url);
            [manager POST:Url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"%@",responseObject);
                block([operation.responseString objectFromJSONString]);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
                block([operation.responseString objectFromJSONString]);
            }];
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{
    
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    
    // AFNetWorking
    
    // 创建请求管理对象
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded",nil]];
    
    // 发生请求
    [manager GET:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    //拼接请求地址
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,strPath];
    
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
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager alloc];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:Url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ([key isEqualToString:@"sound"]) {
            
            [formData appendPartWithFileData:pictureData name:key fileName:@"headPicture.mp3" mimeType:@"image/png"];
            
        } else {
            
            [formData appendPartWithFileData:pictureData name:key fileName:@"headPicture.png" mimeType:@"image/png"];
            
        }
    //[formData appendPartWithFileData:pictureData name:key fileName:@"headPicture.png" mimeType:@"image/png"];
        
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
    //拼接请求地址
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,strPath];
    
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
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager alloc];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:Url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i=0;i<pictureData.count;i++){
            if ([keyArray[i] isEqualToString:@"sound"]) {
                [formData appendPartWithFileData:pictureData[i] name:keyArray[i] fileName:@"headPicture.mp3" mimeType:@"image/png"];
            } else {
                [formData appendPartWithFileData:pictureData[i] name:keyArray[i] fileName:@"headPicture.png" mimeType:@"image/png"];
            }
            
//            [formData appendPartWithFileData:pictureData[i] name:keyArray[i] fileName:@"headPicture.png" mimeType:@"image/png"];
        }
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



+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    
    if (!dic) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return [string stringByReplacingOccurrencesOfString:@"\\u0000" withString:@""];
    
}

//ass
//封装AFN
+(void)get:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure
{
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //2.发送网络请求
    [mgr GET:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//发送POST请求
+(void)post:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id))success failure:(void(^)(NSError *))failure
{
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded", nil]];

    
    //2.发送网络请求
    [mgr POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


+(void)postWithParmStr:(NSString *)url functionName:(NSString *)functionName jsonParams:(NSString *)jsonParams UserID:(NSString *)UserID success:(void(^)(id))success failure:(void(^)(NSError *))failure
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    NSString *Url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded", nil]];
    

    
    //2.发送网络请求
    [mgr POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        [SVProgressHUD dismiss];
        if (success) {
            success(responseObj);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        if (failure) {
            failure(error);
        }
    }];
    
}



+(void)postNoParm:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure
{

    NSString *Url = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,url];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];

    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
   // mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded", nil]];

   //添加固定参数
        [params setObject:@"ios"forKey:@"apptype"];
    //2.发送网络请求
    [mgr POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
        NSLog ( @"operation: %@" , operation. responseString );
        
       [SVProgressHUD dismiss];
        if (success) {
            
            if([[responseObj objectForKey:@"result"]isEqualToString:@"-1"])
            {
                [Function tuichuLogin];
                return ;
            }
            success(responseObj);
        }
        NSLog(@"%@",responseObj);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        if (failure) {
            failure(error);
        }
    }];
}



//－－－－－－－－－－－－－－－－－－－－－－－－－－－－地图专用－－－－－－－－－－－－－－－－－－－－－－－－－－－－
+(void)postNoParmForMap:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure
{
     NSString *Url = [NSString stringWithFormat:@"%@%@",YZX_BASY_URL,url];
    
    //1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"application/x-www-form-urlencoded", nil]];
    
    //    NSLog(@"%@",params);
    
    //添加固定参数
    [params setObject:@"ios"forKey:@"apptype"];
    
    //2.发送网络请求
    [mgr POST:Url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj) {
    

        if([[responseObj objectForKey:@"result"]isEqualToString:@"-1"])
        {
            [Function tuichuLogin];
            return ;
        }
        
        if (success) {
            success(responseObj);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
@end


