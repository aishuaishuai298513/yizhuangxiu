//
//  ZSDPaymentView.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef int(^getTextInPut)(NSString *text);

@interface ZSDPaymentView : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,assign) CGFloat amount;

@property (nonatomic, copy) getTextInPut getText ;

-(void)show;

@end
