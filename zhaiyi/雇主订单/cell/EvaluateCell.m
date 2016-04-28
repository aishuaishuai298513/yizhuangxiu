//
//  EvaluateCell.m
//  zhaiyi
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "EvaluateCell.h"

@interface EvaluateCell()


@property (nonatomic, assign) int xingji;

@property (nonatomic, assign) BOOL isFabiaopinglun;


- (IBAction)xingClicked:(id)sender;

@end

@implementation EvaluateCell

- (void)awakeFromNib {
    
    _isFabiaopinglun = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (IBAction)xingClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    //NSLog(@"%d",btn.tag);
    _xingji = (int)btn.tag;
    
    
    for (int i = 1; i<=5; i++) {
        
        for (UIView *view in self.contentView.subviews) {
            if (view.tag == i) {
                UIButton *btn = (UIButton *)view;
                
                [btn setBackgroundImage:[UIImage imageNamed:@"xing3"] forState:UIControlStateNormal];
            }
        }
    }
    
    for (int i = 1; i<=btn.tag; i++) {
        
            for (UIView *view in self.contentView.subviews) {
                if (view.tag == i) {
                    UIButton *btn = (UIButton *)view;
                    
                    [btn setBackgroundImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
                    
                }
            }
      }
    
    if (self.delegate) {
        NSLog(@"%d",_xingji);
        [self.delegate cellXingClicked:_xingji row:self.row];
    }
}

@end
