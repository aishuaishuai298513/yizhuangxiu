//
//  jieSuanView.m
//  zhaiyi
//
//  Created by ass on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "jieSuanView.h"

@interface jieSuanView()<UITextFieldDelegate>
/////仅赋值
@property (weak, nonatomic) IBOutlet UILabel *adrL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *yujiL;
@property (weak, nonatomic) IBOutlet UILabel *danrigongziL;
@property (weak, nonatomic) IBOutlet UILabel *gongjiL;

///////////////////////////////////////

@property (weak, nonatomic) IBOutlet UIView *xianshangView;

@property (weak, nonatomic) IBOutlet UIView *xianXiaView;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

@property (weak, nonatomic) IBOutlet UIImageView *xianshangImage;

@property (weak, nonatomic) IBOutlet UIImageView *xianxiaImageV;


//遮盖View
@property (nonatomic, strong) UIView *backView;
//结算View
@property (nonatomic, strong) jieSuanView *jiesuanView;

@property (nonatomic, strong) NSString *jiesuanOrderID;

@end




@implementation jieSuanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(instancetype)LoadView
{
    jieSuanView *jieSuanView = [[[NSBundle mainBundle]loadNibNamed:@"jieSuanView" owner:nil options:nil]lastObject];
    
    [jieSuanView addTaptoView];
    //[jieSuanView addNotification];
    

//    return [[[NSBundle mainBundle]loadNibNamed:@"jieSuanView" owner:nil options:nil]lastObject];
    return jieSuanView;
}

//- (void)makeSureBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
//{
//    [self.makeSureBtn addTarget:target action:action forControlEvents:controlEvents];
//}
//
//- (void)cancleBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
//{
//    [self.cancleBtn addTarget:target action:action forControlEvents:controlEvents];
//}

-(void)addTaptoView
{
    UITapGestureRecognizer  *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xianxiaClicked)];
    UITapGestureRecognizer  *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xianshangClicked)];
    
    [self.xianshangView addGestureRecognizer:tap2];
    [self.xianXiaView addGestureRecognizer:tap1];
}


//设置数据
-(void)setDataSource:(NSMutableDictionary *)dataSource
{
    _dataSource = dataSource;
    self.adrL.text = [dataSource objectForKey:@"gongzuodidian"];
     self.timeL.text = [dataSource objectForKey:@"kaigongriqi"];
     self.yujiL.text = [dataSource objectForKey:@"yujitianshu"];
     self.tianShuTextF.text = [dataSource objectForKey:@"tianshu"];
     self.danrigongziL.text = [NSString stringWithFormat:@"%ld元",[[dataSource objectForKey:@"price"] integerValue]];
     self.gongjiL.text = [NSString stringWithFormat:@"%ld元",[[dataSource objectForKey:@"gongji"] integerValue]];
    
    if ([[dataSource objectForKey:@"zhifufangshi"] isEqualToString:@"线上"]) {
        [self xianshangClicked];
    }else
    {
        [self xianxiaClicked];
    }
    
    
}


-(void)xianxiaClicked
{
    self.xianxiaImageV.image = [UIImage imageNamed:@"圆圈红"];
    self.xianshangImage.image = [UIImage imageNamed:@"圆圈灰"];
    self.zhifufangshi = @"线下";
}

-(void)xianshangClicked
{
    self.xianxiaImageV.image = [UIImage imageNamed:@"圆圈灰"];
    self.xianshangImage.image = [UIImage imageNamed:@"圆圈红"];
    self.zhifufangshi = @"线上";
}



-(void)setTianshu:(int)tianshu
{
    _tianshu = tianshu;
    int money = tianshu * [self.danrigongziL.text intValue];
    self.gongjiL.text = [NSString stringWithFormat:@"%d元",money];
}


-(void)jieSuan:(DWOrderModel*)dworderMoodel jiesuansucess:(JieSuanSuccessBlock)jieSuanSuccess JieSuanFaluse:(JieSuanFaluseBlock)JieSuanFaluse
{
    self.jieSuanSuccess = jieSuanSuccess;
    self.JieSuanFaluse = JieSuanFaluse;
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:dworderMoodel.ID forKey:@"id"];
    
    self.jiesuanOrderID = dworderMoodel.ID;
    
    
    //__weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_shishijiesuan_gr params:parm success:^(id responseObj) {
        //NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            //添加遮盖
            _backView = [Function createBackView:self action:@selector(backViewClicked)];
           // _jiesuanView = [jieSuanView LoadView];
            self.dataSource = [responseObj objectForKey:@"data"];
            
            //确定 取消 按钮添加事件
            [self.makeSureBtn addTarget:self action:@selector(jiesuanMakeSuerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.cancleBtn addTarget:self action:@selector(jiesuanCancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [[UIApplication sharedApplication].keyWindow addSubview:_backView];
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            
            self.frame = CGRectMake((SCREEN_WIDTH - 300)/2, (SCREEN_HEIGHT - 263)/2, 300, 263);
            
            //            [_jiesuanView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            //            [_jiesuanView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            //            [_jiesuanView autoSetDimension:ALDimensionWidth toSize:300];
            //            [_jiesuanView autoSetDimension:ALDimensionHeight toSize:263];
            
            [self notofictionKeyBoard];
            
            self.tianShuTextF.keyboardType = UIKeyboardTypeDecimalPad;
            [self.tianShuTextF becomeFirstResponder];
            self.tianShuTextF.delegate = self;
            
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        
    }];

}

//监听键盘
-(void)notofictionKeyBoard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘弹出
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSNumber *duration = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    if(SCREEN_HEIGHT - (self.height+self.y)<=keyBoardFrame.size.height)
    {
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            CGFloat h = SCREEN_HEIGHT-keyBoardFrame.size.height-self.height;
            self.y = h-5;
        }];
    }
}

//键盘隐藏
-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    NSNumber *duration = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        self.y = (SCREEN_HEIGHT - 263)/2;
    }];
    
}

#pragma mark  textfildeDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strs;
    
    if ([string isEqualToString:@""]) {
        strs = [textField.text substringToIndex:textField.text.length-1];
    }else
    {
        strs  = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    self.tianshu = [strs intValue];
    
    return YES;
}


#pragma makr  确定结算
-(void)jiesuanMakeSuerBtnClicked
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:self.jiesuanOrderID forKey:@"id"];
    [parm setObject:self.tianShuTextF.text forKey:@"tianshu"];
    [parm setObject:self.zhifufangshi forKey:@"zhifufangshi"];
   // NSLog(@"%@",parm);
    
    [NetWork postNoParm:YZX_jiesuan_gr params:parm success:^(id responseObj) {
        //NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
            [self jiesuanCancleBtnClicked];
            
            if (_jieSuanSuccess) {
                _jieSuanSuccess(responseObj);
            }
            
        }else
        {
            if (_JieSuanFaluse) {
             _JieSuanFaluse(responseObj);
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
#pragma makr  取消
-(void)jiesuanCancleBtnClicked
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self removeFromSuperview];
    [_backView removeFromSuperview];
}

-(void)backViewClicked
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
@end
