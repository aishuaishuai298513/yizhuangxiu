//
//  grabOrderResult.m
//  zhaiyi
//
//  Created by ass on 16/3/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CancleTiXing.h"

@interface CancleTiXing()

@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *Cancle;

@end

@implementation CancleTiXing

+(instancetype)LoadView
{
    
    return  [[[NSBundle mainBundle]loadNibNamed:@"CancleTiXing" owner:nil options:nil]lastObject];
    
    
}


- (void)YesBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.makeSureBtn addTarget:target action:action forControlEvents:controlEvents];
    
}

- (void)NoBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.Cancle addTarget:target action:action forControlEvents:controlEvents];

}

@end
