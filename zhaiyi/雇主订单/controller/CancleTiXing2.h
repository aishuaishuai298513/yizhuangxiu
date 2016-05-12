//
//  grabOrderResult.h
//  zhaiyi
//
//  Created by ass on 16/3/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancleTiXing2 : UIView

+(instancetype)LoadView;

- (void)YesBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property (weak, nonatomic) IBOutlet UILabel *Content;

@end
