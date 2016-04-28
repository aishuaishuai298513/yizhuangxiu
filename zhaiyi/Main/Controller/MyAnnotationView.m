//
//  MyAnnotationView.m
//  zhaiyi
//
//  Created by ass on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyAnnotationView.h"

@implementation MyAnnotationView

+(instancetype) appView{
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"MyAnnotationView" owner:nil options:nil];
    return [objs lastObject];
    
    
}

- (void)addTarget:(nullable id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    //UIView *selfview = self;
    self.datouzhenTopImageView.userInteractionEnabled = YES;
    [self.datouzhenTopImageView addGestureRecognizer:tap];
}

-(void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
    NSLog(@"%@",_userInfo);
    self.gongzhong.text = [userInfo objectForKey:@"gzname"];
    self.renShu.text = [userInfo objectForKey:@"n"];

}

@end
