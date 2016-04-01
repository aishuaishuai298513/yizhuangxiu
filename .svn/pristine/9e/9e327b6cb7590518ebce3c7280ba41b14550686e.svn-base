//
//  UIImage+Extension.m
//  adan微博
//
//  Created by exe on 15/11/24.
//  Copyright (c) 2015年 adan. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
//根据图片名返回一张能够自由拉伸的图片
+(UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width *0.5 topCapHeight:image.size.height *0.5];
}
@end
