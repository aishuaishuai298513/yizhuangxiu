//
//  PersonalMakeSureCell.h
//  zhaiyi
//
//  Created by ass on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalMakeSureCell : UITableViewCell

+(instancetype)cellLoad;

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
