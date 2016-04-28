//
//  grabOrderResult.m
//  zhaiyi
//
//  Created by ass on 16/3/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "tuiChuTixing.h"

@interface tuiChuTixing()

@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@end

@implementation tuiChuTixing

+(instancetype)LoadView
{
return  [[[NSBundle mainBundle]loadNibNamed:@"tuiChuTixing" owner:nil options:nil]lastObject];
    
}


- (void)YesBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.makeSureBtn addTarget:target action:action forControlEvents:controlEvents];
    
}


@end
