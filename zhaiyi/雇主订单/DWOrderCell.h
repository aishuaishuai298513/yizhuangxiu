//
//  DWOrderCell.h
//  zhaiyi
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"

@interface DWOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtnActin:(UIButton *)sender;
- (IBAction)evaluateBtnAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, copy) void(^deleteBlock)(UIButton *);
@property (nonatomic, copy) void(^evaluateBlock)(UIButton *);
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *zhuangTai;
@property (weak, nonatomic) IBOutlet UILabel *dingDanhao;
@property (weak, nonatomic) IBOutlet UILabel *Adress;
@property (weak, nonatomic) IBOutlet UILabel *gongzhong;
@property (weak, nonatomic) IBOutlet UILabel *yujitianshu;

@property (weak, nonatomic) IBOutlet UIButton *biaoZhiImageV;

@property (weak, nonatomic) IBOutlet UIButton *jiesuanshuBtn;

@property (nonatomic, strong) DWOrderModel *MOdel ;

@end
