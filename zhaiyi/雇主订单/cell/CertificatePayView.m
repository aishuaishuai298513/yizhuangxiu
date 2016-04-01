//
//  CertificatePayView.m
//  zhaiyi
//
//  Created by ass on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CertificatePayView.h"

@interface CertificatePayView()

@property (weak, nonatomic) IBOutlet UILabel *workAdressL;
@property (weak, nonatomic) IBOutlet UILabel *workStartDateL;
@property (weak, nonatomic) IBOutlet UILabel *workDayCountL;

@property (weak, nonatomic) IBOutlet UILabel *actualWorkDayL;

@property (weak, nonatomic) IBOutlet UILabel *dayPayL;

@property (weak, nonatomic) IBOutlet UILabel *workTypeL;

@property (weak, nonatomic) IBOutlet UILabel *payMoneyCountL;

@property (weak, nonatomic) IBOutlet UIButton *canclebtnClicked;

@property (weak, nonatomic) IBOutlet UIButton *makeSurebtnClicked;

@end
@implementation CertificatePayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CertificatePayView" owner:nil options:nil]lastObject];
}

-(id)init
{
    if ([super init]) {
        [CertificatePayView loadView];
    }
    return self;
}

/*
 添加按钮点击事件
 */
-(void)addTargetWithCancleBtnClicked:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.canclebtnClicked addTarget:target action:action forControlEvents:controlEvents];

}
-(void)addTargetWithMakeSureBtnClicked:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.makeSurebtnClicked addTarget:target action:action forControlEvents:controlEvents];

}



@end
