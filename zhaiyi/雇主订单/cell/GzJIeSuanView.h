//
//  CertificatePayView.h
//  zhaiyi
//
//  Created by ass on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayInfoModel.h"
@interface GzJIeSuanView : UIView

@property (nonatomic, strong)PayInfoModel *payinfoModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLa;
//初始化
+(instancetype)loadView;

-(id)init;

@end
