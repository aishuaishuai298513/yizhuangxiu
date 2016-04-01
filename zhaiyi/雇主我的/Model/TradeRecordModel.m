//
//  TradeRecordModel.m
//  zhaiyi
//
//  Created by cajan on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TradeRecordModel.h"

@implementation TradeRecordModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
 
}



@end
