//
//  SelectDeleteView.h
//  zhaiyi
//
//  Created by ass on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDeleteView : UIView

+(instancetype )loadView;
@property (nonatomic, copy)void(^makeSure)();
@property (nonatomic, copy)void(^Cancle)();

@end
