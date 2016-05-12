//
//  SelectDeleteView.m
//  zhaiyi
//
//  Created by ass on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SelectDeleteView.h"

@interface SelectDeleteView()

@property (weak, nonatomic) IBOutlet UIButton *CancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *Makesure;


- (IBAction)makeSureClicked:(id)sender;

- (IBAction)quxiaoClicked:(id)sender;

@end

@implementation SelectDeleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype )loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SelectDeleteView" owner:self options:nil]lastObject];
}

- (IBAction)makeSureClicked:(id)sender {
    
    if (self.makeSure) {
        _makeSure();
    }
    
}

- (IBAction)quxiaoClicked:(id)sender {
    
    if (self.Cancle) {
        _Cancle();
    }
    
    
}
@end
