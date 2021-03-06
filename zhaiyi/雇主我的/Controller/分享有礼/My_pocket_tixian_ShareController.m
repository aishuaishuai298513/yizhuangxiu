//
//  My_pocket_tixian_ShareController.m
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_tixian_ShareController.h"


#define GET_RECORD @"http://zhaiyi.bjqttd.com/api/personal/share_with"

#define shareTitle @"和我一起加入“亿装修”平台吧"
@interface My_pocket_tixian_ShareController ()
{
    NSString *isFirstShare;
}
@end

@implementation My_pocket_tixian_ShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//创建分享视图
// button tag 值为 390 - 393
-(void)creatView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(30,120, kU-60, 320)];
    bgView.layer.cornerRadius = 3;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:bgView];
    CGFloat bgWidth = bgView.size.width;
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake((bgWidth-200)/2, 40,200, 20)];
    titleLb.text = @"分享亿装给朋友";
    titleLb.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLb];

    NSArray *arr = @[@"qq好友",@"qq空间",@"微信好友",@"朋友圈"];
    NSArray *arrTitle = @[@"QQ好友",@"QQ空间",@"微信好友",@"朋友圈"];

    for (int i = 0; i<4; i++) {
        int row = i%2;
        int loc = i/2;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((bgWidth-100)/3)*(row+1)+row *50, 90 +98*(loc), 50, 50);
        UILabel *label = [[UILabel alloc]init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = arrTitle[i];
        label.font = [UIFont systemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        btn.tag = 390 + i;
        [btn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        [bgView addSubview:label];
//代码约束
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeBottom multiplier:1.0 constant:6];
        [bgView addConstraint:constraint1];
        [bgView addConstraint:constraint2];

        
        
    }
 
}

-(void)shareBtnClicked:(UIButton *)sender{
    
    switch (sender.tag) {
        case 390:{
           //qq 分享
            [self qqShare];
        
        }
            break;
        case 391:{
            //qq 空间
            [self QZoneShare];
        }
            break;
        case 392:{
            //微信
            [self wxShare];
        }
            break;
        case 393:{
            //朋友圈
            [self WechatTimeline];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)qqShare{
    
//    UMSocialUrlResource *share_url = [[UMSocialUrlResource alloc]init];
//    share_url.url = SHARE_URL;
    
    NSLog(@"QQ 分享");
    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToQQ] content:@"加入亿装修,天南地北工作不发愁" image:[UIImage imageNamed:@"share"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
            
            [self judgeIsShared];
        }
    }];
    
    [UMSocialData defaultData].extConfig.qqData.url = YZX_shareUrl;
    [UMSocialData defaultData].extConfig.qqData = UMSocialQQMessageTypeDefault;
}
// qq空间
-(void)QZoneShare{
    
    NSLog(@"QQ 空间分享");
    
    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToQzone] content:@"加入亿装修,天南地北工作不发愁" image:[UIImage imageNamed:@"share"]  location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
            
           //[self judgeIsShared];
        }
    }];
  

}
//微信
-(void)wxShare{
//    UMSocialUrlResource *share_url = [[UMSocialUrlResource alloc]init];
//    share_url.url = SHARE_URL;
    NSLog(@"微信分享");
    [UMSocialData defaultData].extConfig.wechatSessionData.url = YZX_shareUrl;

    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatSession] content:@"加入亿装修,天南地北工作不发愁" image:[UIImage imageNamed:@"share"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
            
            //[self judgeIsShared];
        }
    }];
    
}
//朋友圈
-(void)WechatTimeline{
    NSLog(@"朋友圈分享");
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"亿装修";
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatTimeline] content:@"加入亿装修,天南地北工作不发愁" image:[UIImage imageNamed:@"share"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
            
            //[self judgeIsShared];
        }
    }];
    
}



-(void)judgeIsShared{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[self getDate] isEqualToString:[user objectForKey:@"Is_Fist_Share"]]) {
        NSLog(@"分享过了,不再增加积分");
    } else {
        [self postRecord];
    }
    
}


-(void)postRecord{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:acount.userid forKey:@"user_id"];
    NSInteger  recordNum = 50;
    NSString *record = [NSString stringWithFormat:@"%ld",recordNum];
    [params setObject:record forKey:@"record"];
    
    [NetWork postNoParm:GET_RECORD params:params success:^(id responseObj) {
        NSLog(@"分享上传: %@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:[self getDate] forKey:@"Is_Fist_Share"];
            [user synchronize];
        }
    } failure:^(NSError *error) {
        NSLog(@"分享上传失败 :%@",error.localizedDescription);
    }];
    
    
    
    
}

-(NSString *)getDate{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld%ld%ld",year,month,day];
    NSLog(@"日期%@",dateString);
    
    return dateString;
    
}


@end
