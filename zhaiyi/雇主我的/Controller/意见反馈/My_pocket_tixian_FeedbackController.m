//
//  My_pocket_tixian_FeedbackController.m
//  zhaiyi
//
//  Created by sks on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "My_pocket_tixian_FeedbackController.h"

@interface My_pocket_tixian_FeedbackController ()
<
UITextViewDelegate,
UIAlertViewDelegate,
UITextFieldDelegate
>
{
    ADAccount *_account;
    BOOL _isFirst;
    CGRect _orignalFrame;
    
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;

//意见选项勾选
@property (strong, nonatomic) NSString *jianjie;
@property (strong, nonatomic) NSString *shiyong;
@property (strong, nonatomic) NSString *jiemianmeiguan;
@property (strong, nonatomic) NSString *kuaijiezhaogong;


- (IBAction)makeSureClicked:(id)sender;


@end



@implementation My_pocket_tixian_FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initalData];
    [self creatChildView];

}

-(void)creatChildView
{
    self.makeSureBtn.layer.cornerRadius = 20;
    self.makeSureBtn.clipsToBounds = YES;
    
    for (int i = 1; i<=8; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageSelect:)];
        UIImageView *imageV = [self.view viewWithTag:100+i];
        [imageV addGestureRecognizer:tap];
        imageV.userInteractionEnabled = YES;
    }

}

//意见选项
-(void)ImageSelect:(UITapGestureRecognizer *)tap
{
    UIImageView *selectImag = (UIImageView *)tap.view;
    int tag = (int)selectImag.tag;
    
    //奇数
    if (tag%2) {
        UIImageView *imageV = [self.view viewWithTag:tag+1];
        [imageV setImage:[UIImage imageNamed:@"找工人4"]];
    }else
    {
        UIImageView *imageV = [self.view viewWithTag:tag-1];
        [imageV setImage:[UIImage imageNamed:@"找工人4"]];
    }
    UIImageView *imageV = [self.view viewWithTag:tag];
    [imageV setImage:[UIImage imageNamed:@"找工人5"]];
    
    
    int num = tag%100;
    switch (num) {
        case 2:
            _jianjie = @"否";
            break;
        case 4:
            _shiyong = @"否";
            break;
        case 6:
            _jiemianmeiguan = @"否";
            break;
        case 8:
            _kuaijiezhaogong = @"否";
            break;
        default:
            break;
    }
    
}



-(void)initalData{
    
    self.title = @"意见反馈";
    _textView.delegate = self;
//     _contactText.delegate =self;
    //_orignalFrame = _contactText.frame;
    
    _account = [ADAccountTool account];
    [self resignTheFirstResponse];
    _isFirst = YES;
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:_contactView selector:@selector(textViewChanged) name:UITextViewTextDidChangeNotification object:nil];
 
}
-(void)textViewChanged{
    _isFirst = NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
 
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];

}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [Function isMobileNumber:textField.text];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


#pragma mark ---- UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (_isFirst) {
        textView.text = @"";
        _isFirst = NO;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"尊贵的用户,您好,请简要的描述你遇到的问题及建议,我们将提供更好的服务给您.";
        textView.textColor = [UIColor lightGrayColor];
        _isFirst = YES;
    }
 
}
-(void)textViewDidChange:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//注销第一响应者
-(void)resignTheFirstResponse{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEndediting:)];
    [self.view addGestureRecognizer:tap];
}
-(void)tapEndediting:(UITapGestureRecognizer *)tap{
    
    [self.view endEditing:YES];
}
#pragma mark 键盘监控
-(void)keyBoardShow:(NSNotification *)notity{
    
   NSTimeInterval time=[[notity.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    float height=[[notity.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
    [UIView animateWithDuration:time animations:^{
        if (self.textView.frame.origin.y + 30 > Ga - height) {
            self.textView.frame = CGRectMake(0, Ga-height-30, kU, 30);
        }
 
        [self.view layoutIfNeeded];
    }];
}
-(void)keyBoardHidden:(NSNotification *)notity{
    
    NSTimeInterval time=[[notity.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];

    [UIView animateWithDuration:time animations:^{
        self.textView.frame = _orignalFrame;
        [self.view layoutIfNeeded];
    }];
}


#pragma mark 上传信息
-(void)postFeedBack{
    
//    if ([_textView.text isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"反馈信息不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    NSLog(@"反馈: %@",_textView.text);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_account.userid forKey:@"userid"];
    [params setObject:_account.token forKey:@"token"];
    if ([_textView.text isEqualToString:@"尊贵的用户,您好,请简要的描述你遇到的问题及建议,我们将提供更好的服务给您."]) {
        [params setObject:@"" forKey:@"content"];
    }else
    {
        [params setObject:_textView.text forKey:@"content"];
    }
    
    //简洁
    if (_jianjie) {
     [params setObject:_jianjie forKey:@"jianjie"];
    }else
    {
    [params setObject:@"是" forKey:@"jianjie"];
    }
    //实用
    if (_shiyong) {
        [params setObject:_shiyong forKey:@"shiyong"];
    }else
    {
        [params setObject:@"是" forKey:@"shiyong"];
    }
    //界面美观
    if (_jiemianmeiguan) {
        [params setObject:_jiemianmeiguan forKey:@"jiemianmeiguan"];
    }else
    {
        [params setObject:@"是" forKey:@"jiemianmeiguan"];
    }
    //快捷找活
    if (_kuaijiezhaogong) {
        [params setObject:_kuaijiezhaogong forKey:@"kuaijiezhaohuo"];
    }else
    {
        [params setObject:@"是" forKey:@"kuaijiezhaohuo"];
    }
    
    
    NSLog(@"反馈信息: %@",params);
    [NetWork postNoParm:YZX_yijianfankui params:params success:^(id responseObj) {
        NSLog(@"反馈信息: %@",responseObj);

        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]){
            [ITTPromptView showMessage:@"提交成功"];
            pop
        } else {
            [ITTPromptView showMessage:@"提交失败,请重试"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"反馈信息失败: %@",error.localizedDescription);
        
    }];
}

#pragma mark 提交反馈
- (IBAction)makeSureClicked:(id)sender {
    [self postFeedBack];
}
@end
