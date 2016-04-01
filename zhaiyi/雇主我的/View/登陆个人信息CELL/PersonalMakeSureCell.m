//
//  PersonalMakeSureCell.m
//  zhaiyi
//
//  Created by ass on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalMakeSureCell.h"

@interface PersonalMakeSureCell()

@property (weak, nonatomic) IBOutlet UIButton *makeSurebtn;

@end

@implementation PersonalMakeSureCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    
    [self.makeSurebtn addTarget:target action:action forControlEvents:controlEvents];
}

+(instancetype)cellLoad
{
    return [[[NSBundle mainBundle]loadNibNamed:@"PersonalMakeSureCell" owner:nil options:nil]lastObject];
}

@end
