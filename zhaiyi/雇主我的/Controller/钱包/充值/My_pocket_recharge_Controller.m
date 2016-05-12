//
//  My_pocket_recharge_ControllerViewController.m
//  zhaiyi
//
//  Created by cajan on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "My_pocket_recharge_Controller.h"
#import "Order.h"
#import <CJContent.h>
#import <DataSigner.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"

#import "UPPaymentControl.h"

#define NUMBERS @"0123456789.\n"
#define PAY_POST_URL @"http://zhaiyi.bjqttd.com/api/recharge/user_recharge"

@interface My_pocket_recharge_Controller ()
<
UITextFieldDelegate,
UIAlertViewDelegate
>
{
    UITapGestureRecognizer *tap1;
    UITapGestureRecognizer *tap2;
    UITapGestureRecognizer *tap3;
    
    NSMutableDictionary *_parames;
    UIView *_maskView;
    CGRect _frame;
    
    NSDictionary *_payResultDict;
    
    ADAccount *_account;
}

@property (weak, nonatomic) IBOutlet UIView *YinLianView;

@property (weak, nonatomic) IBOutlet UIView *WeiXinView;

@property (weak, nonatomic) IBOutlet UIView *ZhiFuBaoView;

@property (weak, nonatomic) IBOutlet UIView *JinEView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *chongZhiZhangHu;

//银联
@property(nonatomic, strong) NSString *tnMode;

@end

@implementation My_pocket_recharge_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initalData];
    [self createbtn];
    
    
}

-(void)createbtn
{
    self.nextBtn.layer.cornerRadius = 20;
    self.nextBtn.clipsToBounds = YES;
    self.nextBtn.backgroundColor = THEME_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化数据
-(void)initalData{
    _account = [ADAccountTool account];
    self.title = @"充值";
    self.chongZhiZhangHu.text =_account.mobile;
    
    _moneyTF.delegate = self;
   // _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    _parames = [[NSMutableDictionary alloc]init];
    //NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
   // NSDictionary *dict = [userDefualts objectForKey:@"enter_user_info"];

    _payResultDict = [[NSDictionary alloc]init];
    _frame = _moneyView.frame;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector( keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    //默认选中银联支付
    _ylBtn.selected = YES;
    
    //注册监听-微信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatPaidNotification:) name:@"WXpayresult" object:nil];
    
    [_ylBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateSelected];
    [_wxBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateSelected];
    [_alipayBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateSelected];
    
    [self addTapForView];
    
}

-(void)addTapForView
{
    
    tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    
    [self.YinLianView addGestureRecognizer:tap1];
    [self.WeiXinView addGestureRecognizer:tap2];
    [self.ZhiFuBaoView addGestureRecognizer:tap3];
    
}
//删除手势
-(void)removeTapForView
{
    [self.YinLianView removeGestureRecognizer:tap1];
    [self.WeiXinView removeGestureRecognizer:tap2];
    [self.ZhiFuBaoView removeGestureRecognizer:tap3];
}

-(void)CellViewClicked:(UIGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 101:
            [self ylBtnC];
            break;
        case 102:
            [self wxBtnC];
            break;
        case 103:
            [self alipayBtnC];
            break;
        default:
            break;
    }
}


//银联
- (void)ylBtnC {
    _ylBtn.selected = YES;
    if (_ylBtn.selected) {
        _wxBtn.selected = NO;
        _alipayBtn.selected = NO;
    }
}
//微信
-(void)wxBtnC{
    _wxBtn.selected = YES;
    if (_wxBtn.selected) {
        _alipayBtn.selected = NO;
        _ylBtn.selected = NO;
    }
}
//阿里
- (void)alipayBtnC{
    _alipayBtn.selected = YES;
    if (_alipayBtn.selected) {
        _wxBtn.selected = NO;
        _ylBtn.selected = NO;
        
    }
}

//下一步
- (IBAction)nextBtn:(UIButton *)sender {
    if ([_moneyTF.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"充值金额不能为空" ];

    } else {
        //
        if (_ylBtn.selected) {
            NSLog(@"银联 充值金额为:%@",_moneyTF.text);
            //[ITTPromptView showMessage:@"银联支付暂未开通"];
                   [self yilianOrder];
        }else if (_wxBtn.selected){
            //NSLog(@"微信 充值金额为:%@",_moneyTF.text);
            [self weixinPayDemo];
            //        [self orderDetail];
        } else if (_alipayBtn.selected){
            //NSLog(@"支付宝充值金额为:%@",_moneyTF.text);
            [self zhifubaoGetOrder];
        }else {
            [ITTPromptView showMessage:@"请选择支付方式" ];
        }
        //
    }
    
}


//获取订单
-(void)yilianOrder
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.moneyTF.text forKey:@"money"];
    [parm setObject:@"" forKey:@"ordercode"];
    
    __weak typeof (self)weakSelf = self;
    NSLog(@"银联 待上传信息 %@",parm);
    
    [NetWork postNoParm:YZX_yinlianzhifu params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            NSLog(@"%@",responseObj);
            _payResultDict = [responseObj objectForKey:@"data"];
            [weakSelf yinlianPay];
        }
        NSLog(@"%@",responseObj);
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)zhifubaoGetOrder
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.moneyTF.text forKey:@"money"];
    [parm setObject:@"" forKey:@"ordercode"];
    __weak typeof (self)weakSelf = self;
    NSLog(@"支付宝支付 待上传信息 %@",parm);
    
    [NetWork postNoParm:YZX_zhifubaozhifu params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            _payResultDict = [responseObj objectForKey:@"data"];
            [weakSelf alipay];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)yinlianPay
{
    //当获得的tn不为空时，调用支付接口
    NSString *tn =[_payResultDict objectForKey:@"tn"];
    //self.tnMode = [_payResultDict objectForKey:@"merId"];
    
    self.tnMode = @"00";
    //上线
    //self.tnMode = @"01";
    
    if (tn != nil && tn.length > 0)
    {
        [[UPPaymentControl defaultControl]
         startPay:tn
         fromScheme:@"UPPayDemo"
         mode:self.tnMode
         viewController:self];
    }
}


//支付宝
-(void)alipay{
    Order *order = [[Order alloc]init];
    // order.partner = PARTNER_ID;
    order.partner = [_payResultDict objectForKey:@"pid"];
    order.seller = SELLER;
    //order.seller = [_payResultDict objectForKey:@"pid"];
    //订单号
    NSString *orderNum = [_payResultDict objectForKey:@"ordercode"];
    NSLog(@"-------%@",orderNum);
    order.tradeNO = orderNum;
    order.productName = @"支付";
    order.productDescription = @"支付工人工资";
    //交易金额
    order.amount = [_payResultDict objectForKey:@"money"];
    //回调
    //order.notifyURL = REBACK_URL;
    order.notifyURL = [_payResultDict objectForKey:@"notifyurl"];
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //App URL Scheme
    //alisdkdemo
    NSString *appScheme = @"alisdkdemo";//返回App的标识
    NSString *orderDes = [order description];
    //签名
    //id <DataSigner> dataSinger = CreateRSADataSigner(PRIVATE_ALIPAY_KEY);
    id <DataSigner> dataSinger = CreateRSADataSigner([_payResultDict objectForKey:@"pkcs8"]);
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
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    
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

    
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.moneyTF.text forKey:@"money"];
    [parm setObject:@"" forKey:@"ordercode"];
    
    NSLog(@"微信支付 待上传信息 %@",parm);
    [NetWork postNoParm:YZX_weixinzhifu params:parm success:^(id responseObj) {
        
        //NSLog(@"微信生成信息: %@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            PayReq *request = [[PayReq alloc]init];
            
            NSDictionary *dict = [responseObj objectForKey:@"data"];
            
            //request.partnerId = @"1303015401";
            request.partnerId = [dict objectForKey:@"partnerid"];
            request.prepayId = [dict objectForKey:@"prepayid"];
            //request.package = @"Sign=WXPay";
            request.package = [dict objectForKey:@"package"];
            request.nonceStr = [dict objectForKey:@"noncestr"];
            request.timeStamp = (UInt32)[[dict objectForKey:@"timestamp"]longLongValue];
            request.sign = [dict objectForKey:@"sign"];
            
            if([WXApi isWXAppInstalled])
            {
                if ([WXApi isWXAppSupportApi ]) {
                    
                    [WXApi sendReq:request];
                }else
                {
                    [ITTPromptView showMessage:@"微信客户端版本不支持"];
                }
                
            }else
            {
                [ITTPromptView showMessage:@"微信客户端未安装"];
            }
            
            
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
           // _moneyView.frame = CGRectMake(0, y, kU, _moneyView.bounds.size.height);
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
       
        //_moneyView.frame = _frame;
        self.view.y = 0;
        [self.view layoutIfNeeded];
    }];
    
}


-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    
}

@end
