//
//  ADCellItem.h
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADCellItem : NSObject
//标题
@property(nonatomic,copy)NSString *title;
//描述
@property(nonatomic,copy)NSString *des;
//其他的信息
@property(nonatomic,copy)NSString *other;

+(instancetype)itemWithTitle:(NSString *)title des:(NSString *)des other:(NSString *)other;


@end
