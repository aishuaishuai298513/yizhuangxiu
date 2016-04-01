//
//  My_pocket_recharge_ControllerViewController.m
//  zhaiyi
//
//  Created by cajan on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "My_pocket_Controller.h"
#import "Order.h"
#import <CJContent.h>
#import <DataSigner.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
//支付View
#import "ZSDPaymentView.h"

#define NUMBERS @"0123456789.\n"
#define PAY_POST_URL @"http://zhaiyi.bjqttd.com/api/recharge/user_recharge"

typedef NS_ENUM(NSInteger,Paytype)
{
    YUEPAY,
    YINLIANPAY,
    WEIXINPAY,
    ZHIFUBAOPAY

};

@interface My_pocket_Controller ()
<
UITextFieldDelegate,
UIAlertViewDelegate
>
{
    //手势
    UITapGestureRecognizer *tap1;
    UITapGestureRecognizer *tap2;
    UITapGestureRecognizer *tap3;
    UITapGestureRecognizer *tap4;
    
    NSMutableDictionary *_parames;
    UIView *_maskView;
    CGRect _frame;
    
    NSDictionary *_payResultDict;
    
    ADAccount *_account;
}
//支付方式
@property (nonatomic,assign)Paytype paytype;

@end

@implementation My_pocket_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initalData];
//    [self initNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化数据
-(void)initalData{
    _account = [ADAccountTool account];
    self.title = @"支付";
    _moneyTF.delegate = self;
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    _parames = [[NSMutableDictionary alloc]init];
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefualts objectForKey:@"enter_user_info"];
    NSLog(@"信息: %@",dict);
    [_parames setObject:[dict objectForKey:@"nickname"]forKey:@"nickname"];
    [_parames setObject:[dict objectForKey:@"userid"]forKey:@"user_id"];

   // NSLog(@"信息222: %@ ",_parames);
    _payResultDict = [[NSDictionary alloc]init];
    _frame = _moneyView.frame;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector( keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //注册监听-微信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatPaidNotification:) name:@"WXpayresult" object:nil];
    
    [self addTapForView];
    [self yuEC];
    
}
//cell添加手势
-(void)addTapForView
{
    
    tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    
    [self.YuEView addGestureRecognizer:tap1];
    [self.YinLianView addGestureRecognizer:tap2];
    [self.WeiXinView addGestureRecognizer:tap3];
    [self.ZhiFuBaoView addGestureRecognizer:tap4];

}
//cell移除手势
-(void)removeTapForView
{
    [self.YuEView removeGestureRecognizer:tap1];
    [self.YinLianView removeGestureRecognizer:tap2];
    [self.WeiXinView removeGestureRecognizer:tap3];
    [self.ZhiFuBaoView removeGestureRecognizer:tap4];
}

-(void)CellViewClicked:(UIGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 201:
            [self yuEC];
            break;
        case 202:
            [self ylBtnC];
            break;
        case 203:
            [self wxBtnC];
            break;
        case 204:
            [self alipayBtnC];
            break;
        default:
            break;
    }
}

//余额
- (void)yuEC {
    self.paytype = YUEPAY;
    [self setImages:_YuEImageV];
}
//银联
- (void)ylBtnC {
    self.paytype = YINLIANPAY;
    [self setImages:_YinLianImageV];
}
//微信
-(void)wxBtnC{
   self.paytype = WEIXINPAY;
    [self setImages:_WeiXinImageV];
}
//阿里
- (void)alipayBtnC{
   self.paytype = ZHIFUBAOPAY;
    [self setImages:_ZhiFuBaoImageV];
}

-(void)setImages:(UIImageView *)showView
{
    
    self.YuEImageV.hidden = YES;
    self.YinLianImageV.hidden = YES;
    self.WeiXinImageV.hidden = YES;
    self.ZhiFuBaoImageV.hidden = YES;
    
    showView.hidden = NO;

}

//下一步
- (IBAction)nextBtn:(UIButton *)sender {
    if ([_moneyTF.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"输入支付金额"];

    } else {
        //
        if(self.paytype == YUEPAY)
        {
            
            ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
            payment.getText =  ^int(NSString *textInput){
                
                NSLog(@"密码%@",textInput);
    
                return 1;
            };
            
            payment.title = @"输入密码";
            //payment.goodsName = @"商品名称";
            payment.amount = 20.00f;
            [payment show];
            
            return;
        }
        if (self.paytype == YINLIANPAY) {
            NSLog(@"银联 充值金额为:%@",_moneyTF.text);
            [ITTPromptView showMessage:@"银联支付暂未开通"];
            //        [self orderDetail];
        }else if (self.paytype == WEIXINPAY){
            NSLog(@"微信 充值金额为:%@",_moneyTF.text);
            [self weixinPayDemo];
            //        [self orderDetail];
        } else if (self.paytype == ZHIFUBAOPAY){
            NSLog(@"支付宝充值金额为:%@",_moneyTF.text);
            [self orderDetail];
        }else {
            [ITTPromptView showMessage:@"请选择支付方式" ];
        }
        //
    }
    
}
//获取订单
-(void)orderDetail{
    
    if (self.paytype == ZHIFUBAOPAY) {
        [_parames setObject:@"100" forKey:@"type"];
    }
    if (self.paytype == YINLIANPAY) {
        [_parames setObject:@"101" forKey:@"type"];
    }
    if (self.paytype == WEIXINPAY) {
        [_parames setObject:@"102" forKey:@"type"];
    }
    [_parames setObject:_moneyTF.text forKey:@"money"];
    [NetWork postNoParm:PAY_POST_URL params:_parames success:^(id responseObj) {
        NSLog(@"res : %@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            _payResultDict = [responseObj objectForKey:@"data"];
            
            if (self.paytype == ZHIFUBAOPAY) {
                [self alipay];
            }
//             else if (_wxBtn.selected){
//                [self weiXinPay];
//            }
        }
        NSLog(@"订单生成: %@",_payResultDict);
        
        } failure:^(NSError *error) {
            NSLog(@"订单生成失败: %@",error.localizedDescription);
        }];
}
//支付宝
-(void)alipay{
    Order *order = [[Order alloc]init];
    order.partner = PARTNER_ID;
    order.seller = SELLER;
    //订单号
    NSString *orderNum = [_payResultDict objectForKey:@"out_trade_no"];
    NSLog(@"-------%@",orderNum);
    order.tradeNO = orderNum;
    order.productName = @"充值";
    order.productDescription = @"为小木匠充值";
    //交易金额
    order.amount = _moneyTF.text;
    //回调
    order.notifyURL = REBACK_URL;
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //App URL Scheme
    NSString *appScheme = @"AliPayTest";//返回App的标识
    NSString *orderDes = [order description];
    //签名
    id <DataSigner> dataSinger = CreateRSADataSigner(PRIVATE_ALIPAY_KEY);
    
    NSString *singerStr = [dataSinger signString:orderDes];
    NSString *orderString = nil;
    if (singerStr != nil) {
        
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderDes, singerStr, @"RSA"];
        //向支付宝平台发送支付信息
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"%@", resultDic);
            NSString *message = [_payResultDict objectForKey:@"message"];

            NSInteger orderStatus = [[resultDic objectForKey:@"resultStatus"]integerValue];
            switch (orderStatus) {
                case 9000:{
                    //支付成功
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"再次充值", nil];
                [alert show];

                }
                    break;
                case 4000:{
                    [ITTPromptView showMessage:@"订单支付失败!"];
                }
                    break;
                case 6001:{
                    [ITTPromptView showMessage:@"您取消了支付!"];
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
    }
}

//微信支付
-(void)weixinPayDemo{
    
    NSMutableDictionary *paramater = [NSMutableDictionary dictionary];
    [paramater setObject:_account.userid forKey:@"user_id"];
    [paramater setObject:_moneyTF.text forKey:@"money"];
    //[paramater setObject:_account.nickname forKey:@"nickname"];
    [paramater setObject:@"102" forKey:@"type"];
    NSLog(@"微信支付 待上传信息 %@",paramater);
    [NetWork postNoParm:PAY_POST_URL params:paramater success:^(id responseObj) {
       
        NSLog(@"微信生成信息: %@",responseObj);
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            PayReq *request = [[PayReq alloc]init];
            
            NSDictionary *dict = [responseObj objectForKey:@"data"];
            
            request.partnerId = @"1303015401";
            request.prepayId = [dict objectForKey:@"prepayid"];
            request.package = @"Sign=WXPay";
            request.nonceStr = [dict objectForKey:@"noncestr"];
            request.timeStamp = (UInt32)[[dict objectForKey:@"timestamp"]longLongValue];
            request.sign = [dict objectForKey:@"sign"];
            [WXApi sendReq:request];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)wechatPaidNotification:(NSNotification *)notification{
    NSLog(@"notification  %@",notification.userInfo);
    PayResp *resp = notification.userInfo[@"resp"];
    [self wechatPaid:resp];
}
- (void)wechatPaid:(PayResp *)resp {
     NSLog(@"resp  %@",resp);
    switch (resp.errCode) {
        case WXSuccess:
         {
            NSLog(@"微信支付成功");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"再次充值", nil];
            [alert show];
        }
            return;
        case WXErrCodeUserCancel:
            [ITTPromptView showMessage:@"您取消了支付!"];
             break;
        default:
            [ITTPromptView showMessage:@"很遗憾，支付失败!"];
             break;
    }
}

#pragma mark Alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"停留页面");
    }
}

#pragma mark UITextFeild
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_moneyTF resignFirstResponder];
}

//显示
-(void)keyBoardWillShow:(NSNotification *)sender{
    
    [self removeTapForView];
    
    NSTimeInterval time = [[sender.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    float height=[[sender.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
    
    CGFloat y = Ga -(_moneyView.frame.origin.y + _moneyView.bounds.size.height);
    if (y < height) {
        
        [UIView animateWithDuration:time animations:^{
            //_moneyView.frame = CGRectMake(0, y, kU, _moneyView.bounds.size.height);
            self.view.y = y-height;
            [self.view layoutIfNeeded];
         }];
        
    }
    
    
}
//收起
-(void)keyBoardWillHidden:(NSNotification *)sender{
    [self addTapForView];
    NSTimeInterval time = [[sender.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    [UIView animateWithDuration:time animations:^{
       
        self.view.y = 0;
        [self.view layoutIfNeeded];
    }];
    
}


-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    
}

@end
