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

- (void)addTarget:(nullable id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    //UIView *selfview = self;
//    self.datouzhenTopImageView.userInteractionEnabled = YES;
//    [self.datouzhenTopImageView addGestureRecognizer:tap];
}

@end
