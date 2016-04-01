//
//  ADDetailViewCell.m
//  zhaiyi
//
//  Created by exe on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADDetailViewCell.h"

@implementation ADDetailViewCell

+(instancetype)cell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ADDetailViewCell" owner:nil options:nil]lastObject];
}

@end
