//
//  ADCellItem.m
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADCellItem.h"

@implementation ADCellItem
//封装一个类方法创建Item.

+(instancetype)itemWithTitle:(NSString *)title des:(NSString *)des other:(NSString *)other
{
    ADCellItem *item = [[self alloc]init];
    item.title = title;
    item.des = des;
    return item;
}
@end
