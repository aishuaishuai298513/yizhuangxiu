//
//  DWOrderDetailCell.h
//  zhaiyi
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWOrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *namelb;

@property (weak, nonatomic) IBOutlet UILabel *typelb;

@property (weak, nonatomic) IBOutlet UILabel *jieshao;

@property (weak, nonatomic) IBOutlet UIButton *xing1;
@property (weak, nonatomic) IBOutlet UIButton *xing2;
@property (weak, nonatomic) IBOutlet UIButton *xing3;
@property (weak, nonatomic) IBOutlet UIButton *xing4;
@property (weak, nonatomic) IBOutlet UIButton *xing5;

@property (weak, nonatomic) IBOutlet UIButton *cellBtn;

@property (nonatomic, assign) int xingji;


@end
