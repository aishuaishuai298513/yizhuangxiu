//
//  BaoZhengJinTableViewCell.m
//  zhaiyi
//
//  Created by ass on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaoZhengJinTableViewCell.h"

@interface BaoZhengJinTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
//开工日期
@property (weak, nonatomic) IBOutlet UILabel *kaigongriqi;
//订单号
@property (weak, nonatomic) IBOutlet UILabel *dingdanhao;
//人数
@property (weak, nonatomic) IBOutlet UILabel *renshu;
//保证金
@property (weak, nonatomic) IBOutlet UILabel *baozhengjin;
//缴纳日期
@property (weak, nonatomic) IBOutlet UILabel *creattime;
//地址
@property (weak, nonatomic) IBOutlet UILabel *adr;
@property (weak, nonatomic) IBOutlet UILabel *gongZhong;

@end
@implementation BaoZhengJinTableViewCell

- (void)awakeFromNib {
    self.gongZhong.layer.borderWidth = 0.5;
    self.gongZhong.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5]CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setList:(List *)list
{
    _list = list;
    self.kaigongriqi.text = list.kaigongriqi;
    self.gongZhong.text = list.gzname;
    self.dingdanhao.text = list.ordercode;
    self.adr.text = list.adr;
    self.renshu.text = [NSString stringWithFormat:@"工作人数:%@人",list.renshu];
    self.baozhengjin.text = [NSString stringWithFormat:@"保证金额:%@",list.baozhengjin];
    self.creattime.text = [NSString stringWithFormat:@"缴纳日期:%@",list.createtime];
}

@end
