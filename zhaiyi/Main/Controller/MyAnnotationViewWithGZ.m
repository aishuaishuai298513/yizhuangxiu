//
//  MyAnnotationView.m
//  zhaiyi
//
//  Created by ass on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyAnnotationViewWithGZ.h"

@implementation MyAnnotationViewWithGZ

+(instancetype) appView{
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"MyAnnotationViewWithGZ" owner:nil options:nil];
    return [objs lastObject];
    
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImage.layer.cornerRadius = self.iconImage.width/2;
    self.iconImage.layer.masksToBounds = YES;
    
}
- (void)addTarget:(nullable id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    //UIView *selfview = self;
//    self.datouzhenTopImageView.userInteractionEnabled = YES;
//    [self.datouzhenTopImageView addGestureRecognizer:tap];
}

-(void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
    
    self.name.text = [userInfo objectForKey:@"name"];
    self.type.text = [userInfo objectForKey:@"gzname"];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,[userInfo objectForKey:@"headpic"]]]];
    
    [Function xingji:self xingji:[[userInfo objectForKey:@"xing"] intValue] startTag:1];
    
}

@end
