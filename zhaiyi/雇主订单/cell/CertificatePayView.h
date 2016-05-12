//
//  CertificatePayView.h
//  zhaiyi
//
//  Created by ass on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayInfoModel.h"
@interface CertificatePayView : UIView

@property (nonatomic, strong)PayInfoModel *payinfoModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLa;
//初始化
+(instancetype)loadView;

-(id)init;

//target-action模式
-(void)addTargetWithCancleBtnClicked:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;

-(void)addTargetWithMakeSureBtnClicked:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents;
//

@end
