//
//  My_pocket_qiehuan_View.m
//  zhaiyi
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_qiehuan_View.h"

@implementation My_pocket_qiehuan_View

-(void)setLX:(NSString *)LX
{
    
    if ([LX isEqualToString:@"78"]) {
        _gongrenTopConstraint.constant =  0;
        _guzhuBottomConstraint.constant =  0;
        NSLog(@"切换工人");
    } else{
        _gongrenTopConstraint.constant = 65;
        _guzhuBottomConstraint.constant = 65;
        NSLog(@"切换雇主");
    }
    
    if ([LX isEqualToString:@"0"]) {
        _OK2.hidden=NO;
    }else
    {
        _OK1.hidden=NO;
    }
}

- (IBAction)gongren:(id)sender {
}

- (IBAction)guzhu:(id)sender {
}

+(My_pocket_qiehuan_View *)initViewWithXib
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"My_pocket_qiehuan_View" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
