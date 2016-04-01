//
//  dataModel.h
//  zhaiyi
//
//  Created by ass on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class List;
@interface dataModel : NSObject

@property (nonatomic, copy) NSString *month;
@property (nonatomic, strong)NSMutableArray *list;
@end
