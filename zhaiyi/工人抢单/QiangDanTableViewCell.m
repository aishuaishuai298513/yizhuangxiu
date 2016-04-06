//
//  QiangDanTableViewCell.m
//  zhaiyi
//
//  Created by ass on 16/1/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QiangDanTableViewCell.h"

@interface QiangDanTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *shengYuRenShu;

@property (weak, nonatomic) IBOutlet UILabel *renShu;

@property (weak, nonatomic) IBOutlet UILabel *jiaGe;

@property (weak, nonatomic) IBOutlet UIButton *gongZhong;

@property (weak, nonatomic) IBOutlet UILabel *Adrees;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhangDanId;


- (IBAction)qiangBtn:(id)sender;

@end

@implementation QiangDanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)qiangBtn:(id)sender {
    
    if (_qiangBlock) {
        _qiangBlock(self.indexPath);
    }
    
}

-(void)setCellModel:(DWOrderModel *)cellModel
{
    _cellModel = cellModel;
    
    self.dateLabel.text = _cellModel.createtime;

    self.Adrees.text = _cellModel.adr;
 
    self.renShu.text = [NSString stringWithFormat:@"%@人",_cellModel.n];
    self.shengYuRenShu.text = [NSString stringWithFormat:@"余%@人",_cellModel.shengyu];
    self.jiaGe.text = [NSString stringWithFormat:@"%d元/天",[_cellModel.price intValue]];
    
    //富文本
    NSString *yuren = [NSString stringWithFormat:@"余%@人",_cellModel.shengyu];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:yuren];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(1, yuren.length-2)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1, yuren.length-2)];

    self.shengYuRenShu.attributedText = attributeStr;
    
//    self.shengYuRenShu.text = [NSString stringWithFormat:@"余%d人",[_cellModel.num intValue]-[_cellModel.in_num intValue]];
    self.zhangDanId.text = _cellModel.ordercode;
    
    [_gongZhong setTitle:_cellModel.gzname forState:UIControlStateNormal];

}

@end
