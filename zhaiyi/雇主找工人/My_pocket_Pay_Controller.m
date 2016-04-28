//
//  My_pocket_recharge_ControllerViewController.m
//  zhaiyi
//
//  Created by cajan on 16/1/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "My_pocket_Pay_Controller.h"
#import "Order.h"
#import <CJContent.h>
#import <DataSigner.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "MainViewController.h"
#import "TiShiYuE.h"

#import "ZSDPaymentView.h"

#import "UPPaymentControl.h"

#define NUMBERS @"0123456789.\n"
#define PAY_POST_URL @"http://zhaiyi.bjqttd.com/api/recharge/user_recharge"

@interface My_pocket_Pay_Controller ()
<
UITextFieldDelegate,
UIAlertViewDelegate
>
{
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

@property (weak, nonatomic) IBOutlet UIView *YinLianView;

@property (weak, nonatomic) IBOutlet UIView *WeiXinView;

@property (weak, nonatomic) IBOutlet UIView *ZhiFuBaoView;

@property (weak, nonatomic) IBOutlet UIView *JinEView;

@property (weak, nonatomic) IBOutlet UIView *yuEView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
//帐户余额
@property (weak, nonatomic) IBOutlet UILabel *zhangHuYe;

//提示View
@property (nonatomic, strong) TiShiYuE *tiShiYuEView;
//遮盖
@property (nonatomic, strong) UIView *bg;

@property (nonatomic, strong) NSString *miMa;

//银联支付参数
@property(nonatomic, copy)NSString *tnMode;

@end

@implementation My_pocket_Pay_Controller

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
    self.title = @"保证金";
    //帐户余额
    if (self.Yue.length) {
     self.zhangHuYe.text = [NSString stringWithFormat:@"当前帐户余额%@元",self.Yue];   
    }
    _moneyTF.text = self.ZhiFuJinE;
    _moneyTF.userInteractionEnabled = NO;
    
    _moneyTF.delegate = self;
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    _parames = [[NSMutableDictionary alloc]init];
//    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dict = [userDefualts objectForKey:@"enter_user_info"];
//    NSLog(@"信息: %@",dict);
//    [_parames setObject:[dict objectForKey:@"nickname"]forKey:@"nickname"];
//    [_parames setObject:[dict objectForKey:@"userid"]forKey:@"user_id"];

    NSLog(@"信息222: %@ ",_parames);
    _payResultDict = [[NSDictionary alloc]init];
    _frame = _moneyView.frame;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector( keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    //默认选中余额支付
    _yeBtn.selected = YES;
    
    //注册监听-微信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatPaidNotification:) name:@"WXpayresult" object:nil];
    
    [_ylBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateSelected];
    [_wxBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateSelected];
    [_alipayBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateSelected];
    [_yeBtn setImage:[UIImage imageNamed:@"找工人5"] forState:UIControlStateSelected];
    //添加点击手势
    [self addTapForView];
    
}

-(void)addTapForView
{
    
    tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CellViewClicked:)];
    
    [self.YinLianView addGestureRecognizer:tap1];
    [self.WeiXinView addGestureRecognizer:tap2];
    [self.ZhiFuBaoView addGestureRecognizer:tap3];
    [self.yuEView addGestureRecognizer:tap4];
    
}
//删除手势
-(void)removeTapForView
{
    [self.YinLianView removeGestureRecognizer:tap1];
    [self.WeiXinView removeGestureRecognizer:tap2];
    [self.ZhiFuBaoView removeGestureRecognizer:tap3];
    [self.yuEView removeGestureRecognizer:tap4];
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
        case 104:
            [self yeBtnC];
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
        _yeBtn.selected = NO;
    }
}
//微信
-(void)wxBtnC{
    _wxBtn.selected = YES;
    if (_wxBtn.selected) {
        _alipayBtn.selected = NO;
        _ylBtn.selected = NO;
        _yeBtn.selected = NO;
    }
}
//阿里
- (void)alipayBtnC{
    _alipayBtn.selected = YES;
    if (_alipayBtn.selected) {
        _wxBtn.selected = NO;
        _ylBtn.selected = NO;
        _yeBtn.selected = NO;
        
    }
}

//余额
- (void)yeBtnC{
    _yeBtn.selected = YES;
    if (_yeBtn.selected) {
        _wxBtn.selected = NO;
        _ylBtn.selected = NO;
        _alipayBtn.selected = NO;
        
    }
}

#pragma mark 下一步
- (IBAction)nextBtn:(UIButton *)sender {
    
        if (_yeBtn.selected) {
            //余额支付  提交订单
            [self YuEPay];
            
           }
        else if (_ylBtn.selected) {
           [self yilianOrder];
        }else if (_wxBtn.selected){
            NSLog(@"微信 充值金额为:%@",_moneyTF.text);
            [self weixinPayDemo];
            //        [self orderDetail];
        } else if (_alipayBtn.selected){
            NSLog(@"支付宝充值金额为:%@",_moneyTF.text);
            //[self orderDetail];
            [self zhifubaoGetOrder];
        }else {
            [ITTPromptView showMessage:@"请选择支付方式" ];
        }
        //
    
}
//余额支付  提交订单
-(void)YuEPay
{
    //支付框
    ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
    
    __weak typeof (self)weakSelf = self;
    
    payment.getText =  ^int(NSString *textInput){
        
       // NSLog(@"密码%@",textInput);
        weakSelf.miMa = textInput;
        //提现
        [weakSelf netWorkYuEPay];
        
        //消除支付框
        return 1;
    };
    payment.title = @"请输入支付密码";
    payment.goodsName = @"支付金额";
    payment.amount = [self.ZhiFuJinE floatValue];
    [payment show];

}

#pragma mark 余额支付接口
-(void)netWorkYuEPay
{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:_account.userid forKey:@"userid"];
    [parm setObject:_account.token forKey:@"token"];
    [parm setObject:self.ZhiFuJinE forKey:@"baozhengjin"];
    [parm setObject:self.orderCode forKey:@"ordercode"];
    [parm setObject:self.miMa forKey:@"zhifumima"];
    
    [NetWork postNoParm:YZX_zhifubaozhengjin_yue params:parm success:^(id responseObj) {
        SLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            
            [self makePopView];
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 弹出提示框
-(void)makePopView
{
    self.tiShiYuEView =[TiShiYuE loadView];
    self.tiShiYuEView.frame = CGRectMake((SCREEN_WIDTH-240)/2, SCREEN_WIDTH/2, 240, 200);
    
    //显示余额等
    self.tiShiYuEView.label1.text = [NSString stringWithFormat:@"当前帐户余额:%.2f",[self.Yue floatValue]];
    self.tiShiYuEView.label2.text = [NSString stringWithFormat:@"可用余额:%.2f    保证金:%.2f",[self.Yue floatValue]-[self.ZhiFuJinE floatValue],[self.ZhiFuJinE floatValue]];
    
    //底部大的透明View
    self.bg = [Function createBackView:self action:@selector(bgViewClicked)];
    //no按钮添加事件
    
    [self.tiShiYuEView MakeSureBtnAddTarget:self action:@selector(tiShiMakeSureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bg];
    [[UIApplication sharedApplication].keyWindow addSubview:self.tiShiYuEView];

}
#pragma mark 提示余额
-(void)tiShiMakeSureBtnClicked
{
    [self.bg removeFromSuperview];
    self.bg = nil;
    [self.tiShiYuEView removeFromSuperview];
    
    
    MainViewController *controller = self.navigationController.childViewControllers[0];
    //[controller ]
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:controller animated:NO];
     controller.pushOrder = YES;
    
    
    
}
//遮盖点击事件
-(void)bgViewClicked
{

}

-(void)zhifubaoGetOrder
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.ZhiFuJinE forKey:@"money"];
    [parm setObject:self.orderCode forKey:@"ordercode"];
    
    __weak typeof (self)weakSelf = self;

    [NetWork postNoParm:YZX_zhifubaozhifu params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"] isEqualToString:@"1"]) {
            
            _payResultDict = [responseObj objectForKey:@"data"];
            [weakSelf alipay];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)yilianOrder
{
    ADAccount *acount = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.ZhiFuJinE forKey:@"money"];
    [parm setObject:self.orderCode forKey:@"ordercode"];
    
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

-(void)yinlianPay
{
    //当获得的tn不为空时，调用支付接口
    NSString *tn =[_payResultDict objectForKey:@"tn"];
    //self.tnMode = [_payResultDict objectForKey:@"merId"];
    //测试环境
    self.tnMode = @"00";
    //开发环境
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
    order.productDescription = @"支付保证金";
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
    NSString *appScheme = @"AliPayTest";//返回App的标识
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
                    //[ITTPromptView showMessageWhitleColor:@"支付成功"];

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
    [parm setObject:self.ZhiFuJinE forKey:@"money"];
    [parm setObject:self.orderCode forKey:@"ordercode"];
    
    NSLog(@"微信支付 待上传信息 %@",parm);
    [NetWork postNoParm:YZX_weixinzhifu params:parm success:^(id responseObj) {
       
        NSLog(@"微信生成信息: %@",responseObj);
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
