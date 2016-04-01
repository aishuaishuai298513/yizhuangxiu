//
//  AFNetFirst.h
//  4S GOLF
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetFirst : NSObject
+ (void)GET:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data))block; // get 请求方式

+ (void)GET2:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data , NSError * error))block; // get 请求方式

+ (void)POST:(NSString *)url parmater:(NSDictionary *)dic Block:(void (^)(NSData *data))block; // post 请求方式

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

@end
