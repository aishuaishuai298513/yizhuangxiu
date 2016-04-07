//
//  TiShiYuE.m
//  zhaiyi
//
//  Created by ass on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TiShiYuE.h"

@interface TiShiYuE()

@property (weak, nonatomic) IBOutlet UIButton *makeSurebtn;

@end

@implementation TiShiYuE


+(instancetype)loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"TiShiYuE" owner:nil options:nil]lastObject];
}

- (void)MakeSureBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.makeSurebtn addTarget:target action:action forControlEvents:controlEvents];
}

@end
