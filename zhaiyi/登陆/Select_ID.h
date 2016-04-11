//
//  Select_ID.h
//  zhaiyi
//
//  Created by ass on 16/3/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Select_ID : UIView
+(instancetype)loadView;

@property (nonatomic, assign)BOOL ifFirstLogin;

@property (nonatomic, copy)void(^selectShenFen)();
@end
