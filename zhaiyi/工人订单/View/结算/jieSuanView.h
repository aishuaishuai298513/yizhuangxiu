//
//  jieSuanView.h
//  zhaiyi
//
//  Created by ass on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWOrderModel.h"

typedef void(^JieSuanSuccessBlock)(NSDictionary *response);
typedef void(^JieSuanFaluseBlock)(NSDictionary *response);

@interface jieSuanView : UIView

@property (nonatomic, strong)NSMutableDictionary *dataSource;

@property (weak, nonatomic) IBOutlet UITextField *tianShuTextF;
@property (nonatomic, strong) NSString *zhifufangshi;

@property (nonatomic, assign) float tianshu;

@property (nonatomic, copy)JieSuanSuccessBlock jieSuanSuccess;
@property (nonatomic, copy)JieSuanFaluseBlock JieSuanFaluse;
+(instancetype)LoadView;


//结算业务
-(void)jieSuan:(DWOrderModel*)dworderMoodel jiesuansucess:(JieSuanSuccessBlock)jieSuanSuccess JieSuanFaluse:(JieSuanFaluseBlock)JieSuanFaluse;
@end
