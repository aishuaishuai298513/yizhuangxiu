//
//  MyAnnotationView.m
//  zhaiyi
//
//  Created by ass on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyAnnotationView.h"

@interface MyAnnotationView()
@property (nonatomic, assign)int countNum;
@end

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
    self.renShu.text = [NSString stringWithFormat:@"%@人",[userInfo objectForKey:@"n"]];
    
    
    self.countNum = 1;
    NSTimer *myTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop]addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

-(void)changeText
{
    if (_countNum == 3) {
        self.zhaoGongZhungTai.text = @"正在招工···";
        _countNum = 1;
    }else if (_countNum == 1)
    {
     self.zhaoGongZhungTai.text = @"正在招工·";
        _countNum++;
    }else if (_countNum == 2)
    {
    self.zhaoGongZhungTai.text = @"正在招工··";
        _countNum++;
    }

}


@end
