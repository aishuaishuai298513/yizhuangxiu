//
//  PersonalGongRenController.m
//  zhaiyi
//
//  Created by cajan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalGongRenController.h"
#import "PersonaldetailsCell.h"
#import "PersonalDetails2Cell.h"
#import "PersonalMakeSureCell.h"

@interface PersonalGongRenController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIAlertViewDelegate
>
{
     //账户信息
//    NSUserDefaults *_userDefaults;
    //待保存数据
    NSMutableDictionary *_modifyDict;
    //待上传数据
    NSMutableDictionary *_params;
    //
    NSDictionary *_userInfoDict;
    UIScrollView *_sv;
    UIImageView *_svImgV;
    //图片
    NSData *_imageData;
    UIImagePickerController *_picker;
    NSMutableArray *_picArr;
    NSMutableArray *_webPicArr;
    
    BOOL _isSex;
    BOOL _isWebImage;
    UIPickerView *_pickerView;
    UIView *_pView;
    
    NSMutableArray *_gzTypeArr;
    NSArray *_sexTypeArr;

    NSArray *_titleArr;
    NSArray *_contentArr;
    ADAccount *_account;
}

@end

@implementation PersonalGongRenController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initalData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initalData{

    _sv = [[UIScrollView alloc]init];
    _svImgV = [[UIImageView alloc]init];
    [self getGZTypeData];
    _titleArr = @[@"*姓名",@"*性别",@"*年龄",@"*工种",@"*户籍",@"现居住地址",@"*工龄",@"学历",@"身份证号码",@"资质证书",@"自我介绍"];
    _sexTypeArr = @[@"男",@"女"];
    _contentArr = @[_account.username,@"18",[self returnSexType:_account.sex],[self jugeGongZhongType:_account.gztypeid],_account.live_city,_account.address,_account.job_year,_account.education,_account.id_card,@"",_account.user_desc];
    _tv.delegate = self;
    _tv.dataSource = self;
//    [self resignTheFirstResponser];
}
-(void)createUI{
    _gzTypeArr = [NSMutableArray array];
    _params = [NSMutableDictionary dictionary];
    _picArr = [NSMutableArray array];
    _modifyDict  = [NSMutableDictionary dictionary];
    _account = [ADAccountTool account];
    _isWebImage = YES;
    _webPicArr = [self loadEducationImage];
    
    self.title = @"个人资料";
 
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"右上角按钮"] forState:UIControlStateNormal];
//    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightButton addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.frame = CGRectMake(0, 0, 84, 30);
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *footView = [UIView new];
    self.tv.tableFooterView = footView;
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, kU, 200)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self customPickerView];
    [self setData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark 设置数据
-(void)setData{
    
    //初始化上传数据
    
    [_params setObject:_account.userid forKey:@"user_id"];
    [_params setObject:_account.username forKey:@"username"];
    [_params setObject:_account.sex forKey:@"sex"];
    [_params setObject:_account.tel forKey:@"tel"];
    [_params setObject:_account.address forKey:@"address"];
    [_params setObject:_account.gztypeid forKey:@"type"];
    [_params setObject:_account.live_city forKey:@"live_city"];
    [_params setObject:_account.job_year forKey:@"job_year"];
    [_params setObject:_account.education forKey:@"education"];
    [_params setObject:_account.id_card forKey:@"id_card"];
    [_params setObject:_account.user_desc forKey:@"user_desc"];
    [_params setObject:_account.education_image forKey:@"education_image"];
    
    //保存本地
    _modifyDict =  [ADAccountTool backWitDictionary];
    
}


#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count+1;
}

//tag 值用到  370 - 379 (378除外)
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reusID = @"personCell";
    static NSString *reusID2 = @"personCell8";
    static NSString *makeSureID = @"makeSureID";

    if (indexPath.row != 9&&indexPath.row !=_titleArr.count) {
        PersonaldetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:reusID];
        if (!cell) {
            cell = [PersonaldetailsCell loadPersonaldetailsCell];
        }
        cell.textfield.text = _contentArr [indexPath.row];
        cell.nameLabel.text = _titleArr [indexPath.row];
        
        //设置文字颜色
        if ([[cell.nameLabel.text substringToIndex:1] isEqualToString:@"*"]) {
            
            //设置字颜色
          [self setTextColor:cell.nameLabel];
        }
    
        if (indexPath.row == 1||indexPath.row == 3) {
            cell.textfield.enabled = NO;
            cell.textfield.clearButtonMode = UITextFieldViewModeNever;
        }
        
        if (indexPath.row == 6||indexPath.row == 8) {
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        cell.textfield.delegate = self;
        cell.textfield.tag = 370 + indexPath.row;
        return cell;
    }else if (indexPath.row ==_titleArr.count)
    {
        PersonalMakeSureCell *cell = [tableView dequeueReusableCellWithIdentifier:makeSureID];
        if (!cell) {
            cell = [PersonalMakeSureCell cellLoad];
        }
        [cell addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        PersonalDetails2Cell *cell2 = [tableView dequeueReusableCellWithIdentifier:reusID2];
        if (!cell2) {
            cell2 = [PersonalDetails2Cell loadPersonaldetailsCell];
        }
        cell2.nameLb.text = _titleArr[indexPath.row];
        [cell2.addPicBtn addTarget:self  action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kU - 88, 10, 80, 80)];
        imgV.image = [UIImage imageNamed:@"tianjia"];
        [cell2.contentView addSubview:imgV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture:)];
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:tap];
        _sv.frame = CGRectMake(90, 0, kU - 188, 100);
        [cell2.contentView addSubview:_sv];
        //图片
         if (_isWebImage) {
            for (int i = 0; i < _webPicArr.count; i++) {
                UIImageView *svImgV = [[UIImageView alloc]initWithFrame:CGRectMake((90)*i, 10, 80, 80)];
                [svImgV sd_setImageWithURL:[NSURL URLWithString:_webPicArr[i]] placeholderImage:nil];
                [_sv addSubview:svImgV];
                _sv.contentSize = CGSizeMake(90*_webPicArr.count, 80);
            }
        } else {
                  NSLog(@"图片数量 %ld",_picArr.count);
            for (int i = 0; i<_picArr.count; i++) {
                UIImageView *svImgV = [[UIImageView alloc]initWithFrame:CGRectMake((90)*i, 10, 80, 80)];
                svImgV.image = [UIImage imageWithData:[_picArr objectAtIndex:i]];
                [_sv addSubview:svImgV];
                _sv.contentSize = CGSizeMake(90*_picArr.count, 80);
            }
        }
        [_sv setShowsVerticalScrollIndicator:NO];
        [_sv setShowsHorizontalScrollIndicator:NO];
        
        return cell2;
    }

 }
#pragma mark 点解完成 修改信息
-(void)finshInfo
{
    NSLog(@"123");
}
#pragma mark 设置label字体颜色
-(void)setTextColor:(UILabel *)label
{
    [Function fuwenbenLabel:label FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 1) AndColor:[UIColor redColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
    switch (indexPath.row) {
        case 1:{
            NSLog(@"选择性别");
            _isSex = YES;
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            [self.view endEditing:YES];
            [UIView animateWithDuration:1 animations:^{
                _pView.hidden = NO;
            }];
        }
            break;
        case 3:{
            _isSex = NO;
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            [self.view endEditing:YES];

            [UIView animateWithDuration:1 animations:^{
                _pView.hidden = NO;
            }];
            NSLog(@"选择工作");
        }
            break;
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {
        return 100;
    } else {
        return 60;
    }
}

#pragma mark UItextFeild

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _pView.hidden = YES;
 
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 
      return YES;
}

//添加证书
-(void)addPicture:(UIButton *)sender{
    UIActionSheet *myAction = [[UIActionSheet alloc]initWithTitle:@"上传证书" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [myAction showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                _picker = [[UIImagePickerController alloc]init];
                _picker.delegate = self;
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _picker.allowsEditing = YES;
                [self presentViewController:_picker animated:YES completion:^{
                    
                }];
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
        case 1:{
            //相册
            _picker = [[UIImagePickerController alloc]init];
            _picker.delegate = self;
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_picker animated:YES completion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma Delegate method UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [_webPicArr removeAllObjects];
    _isWebImage = NO;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _imageData = UIImageJPEGRepresentation(image, 0.3);
        //        _userImage = image;
        //保存图片
        //      [self saveImage:image];
        //        [self changeImage];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [_picArr addObject:_imageData];
      
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
            NSArray *indexPathArr = @[indexPath];
            [self.tv reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"来自相册");
        }];
    } else if (_picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        _imageData = UIImageJPEGRepresentation(image, 0.3);
        //        _userImage = image;
        //保存图片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //        [self saveImage:image];
        //        [self changeImage];
        [self dismissViewControllerAnimated:YES completion:^{
            [_picArr addObject:_imageData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
            NSArray *indexPathArr = @[indexPath];
            [self.tv reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"来自相机");
        }];
    }
}
//保存图片
-(void)saveImage:(UIImage *)image{
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docunmentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [docunmentsDirectory stringByAppendingPathComponent:@"zhengshu.jpg"];
    success = [fileManager fileExistsAtPath:imageFilePath];
    if (success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
        //写入
        [UIImageJPEGRepresentation(image, 0.3f) writeToFile:imageFilePath atomically:YES];
    }
}
-(NSMutableArray *)loadEducationImage{
    
    NSMutableArray *picArr = [NSMutableArray array];
    NSString *str =  _account.education_image;
    NSArray *arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    for (NSString *str1 in arr) {
        NSString *str2 = [NSString stringWithFormat:@"%@%@",XMJ_BASE_URL,str1];
        [picArr addObject:str2];
    }
    NSLog(@"%@",arr);
    return picArr;
    
}


//
#pragma mark 自定义 pickerView
-(void)customPickerView{
    NSLog(@"customPickerView");
    _pView = [[UIView alloc]initWithFrame:CGRectMake(0, Ga-230+64, kU, 230)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 60, 30);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelChoosePicker) forControlEvents:UIControlEventTouchUpInside];
    [_pView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(kU - 70, 0, 60, 30);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(ensureChoosePicker) forControlEvents:UIControlEventTouchUpInside];
    [_pView addSubview:rightBtn];
    
    _pView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    _pickerView.frame = CGRectMake(0, 30, kU, 160);
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_pView addSubview:_pickerView];
    
    [self.view addSubview:_pView];
    _pView.hidden = YES;
}
//
-(void)cancelChoosePicker{
    [UIView animateWithDuration:2 animations:^{
        _pView.hidden = YES;
        [self.view layoutIfNeeded];
        
    }];
    
    NSLog(@"取消");
}
-(void)ensureChoosePicker{
    NSString  *index = [NSString stringWithFormat:@"%ld",[_pickerView selectedRowInComponent:0]+1];
    NSLog(@"确定 %@",index);
    [UIView animateWithDuration:1 animations:^{
        _pView.hidden = YES;
    }];
}
#pragma mark PickerView
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_isSex) {
        return _sexTypeArr.count;
    }else{
        return _gzTypeArr.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_isSex) {
        return _sexTypeArr[row];
    } else {
        return _gzTypeArr[row];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *str;
    UITextField *textFeild;
    if (_isSex) {
        str = [_sexTypeArr objectAtIndex:[pickerView selectedRowInComponent:component]];
        textFeild = [self.tv viewWithTag:371];
    } else {
        textFeild = [self.tv viewWithTag:373];
        str = [_gzTypeArr objectAtIndex:[pickerView selectedRowInComponent:component]];
    }
    textFeild.text = str;
    NSLog(@"%@",str);
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        //        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//完成
- (void)clickFinish{
    
    [self getTextFieldText];
    NSLog(@"待上传 %@  待保存 %@",_params, _modifyDict);
    NSLog(@"修改后信息:" );
    
}
//获取输入框文字
-(void)getTextFieldText{
    //姓名
    UITextField *nameField = [self.view viewWithTag:370];
    if ([nameField.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"姓名不能为空"];
    } else {
        [_params setObject:nameField.text forKey:@"username"];
        [_modifyDict setObject:nameField.text forKey:@"username"];
        [self postData];
    }
    
    //性别
    UITextField *sexField = [self.view viewWithTag:372];
    NSString *sexStr = [self  getSexTypeCode:sexField.text];
    if (sexStr != nil) {
        [_params setObject:sexStr forKey:@"sex"];
        [_modifyDict setObject:sexStr forKey:@"sex"];
    }
    
    //工种
    UITextField *gzTypeField = [self.view viewWithTag:373];
    NSString *gzTypeStr = [self returnGZtype:gzTypeField.text];
    if (gzTypeStr != nil) {
        [_modifyDict setObject:gzTypeStr forKey:@"gztypeid"];
        [_params setObject:gzTypeStr forKey:@"type"];
    }
    
    //户籍
    UITextField *cityField = [self.view viewWithTag:374];
    if (cityField != nil) {
        [_params setObject:cityField.text forKey:@"live_city"];
        [_modifyDict setObject:cityField.text forKey:@"live_city"];
    }
    
    //地址
    UITextField *addressField = [self.view viewWithTag:375];
    if (addressField != nil) {
        [_params setObject:addressField.text forKey:@"address"];
        [_modifyDict setObject:addressField.text forKey:@"address"];
    }
    //工龄
    UITextField *ageField = [self.view viewWithTag:376];
    if (ageField != nil) {
        [_params setObject:ageField.text forKey:@"job_year"];
        [_modifyDict setObject:ageField.text forKey:@"job_year"];
    }
    
    //学历
    UITextField *educationField = [self.view viewWithTag:377];
    if (educationField != nil) {
        [_params setObject:educationField.text forKey:@"education"];
        [_modifyDict setObject:educationField.text forKey:@"education"];
    }
    
    //身份证
    UITextField *idCardField = [self.view viewWithTag:378];
    if (idCardField != nil) {
        [_params setObject:idCardField.text forKey:@"id_card"];
        [_modifyDict setObject:idCardField.text forKey:@"id_card"];
    }
    
    //用户描述
    UITextField *descField = [self.view viewWithTag:380];
    if (descField.text != nil) {
        [_params setObject:descField.text forKey:@"user_desc"];
        [_modifyDict setObject:descField.text forKey:@"user_desc"];
    }
    
    
    
}

#pragma mark 获得工种
-(void)getGZTypeData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_account.userid forKey:@"user_id"];
    
    [NetWork postNoParm:POST_GONGZHONG_LIST params:params success:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"]isEqualToString:@"1000"]) {
            NSArray *arr = [responseObj objectForKey:@"data"];
//            NSMutableArray *typeArr;
            for (NSDictionary *dict in arr) {
                [_gzTypeArr addObject:[dict objectForKey:@"typeName"]];
            }
            if (_gzTypeArr.count == 0) {
                [_gzTypeArr addObject:[self jugeGongZhongType:_account.gztypeid]];
            }
         }
    } failure:^(NSError *error) {
        NSLog(@"工种获取: %@",error.localizedDescription);
    }];
}
#pragma mark 工种判断
-(NSString *)jugeGongZhongType:(NSString *)str{
    
    if ([str isEqualToString:@"1"]) {
        return @"泥工";
    }else if ([str isEqualToString:@"2"]){
        return @"油工";
    }else if ([str isEqualToString:@"3"]){
        return @"水工";
    }else if ([str isEqualToString:@"4"]){
        return @"电工";
    }else if ([str isEqualToString:@"5"]){
        return @"木工";
    }else{
        return @"小工";
    }
}

-(NSString *)returnGZtype:(NSString *)str{
    
    if ([str isEqualToString:@"泥工"]) {
        return @"1";
    }else if ([str isEqualToString:@"油工"]){
        return @"2";
    }else if ([str isEqualToString:@"水工"]){
        return @"3";
    }else if ([str isEqualToString:@"电工"]){
        return @"4";
    }else if ([str isEqualToString:@"木工"]){
        return @"5";
    }else{
        return @"6";
    }
}
-(NSString *)returnSexType:(NSString *)str{
    if ([str isEqualToString:@"82"]) {
        return @"男";
    }else{
        return @"女";
    }
}
-(NSString *)getSexTypeCode:(NSString *)str{
    if ([str isEqualToString:@"男"]) {
        return @"82";
    }else{
        return @"81";
    }
}

#pragma mark 上传信息
-(void)postData{

    NSMutableArray *keyArr = [[NSMutableArray alloc]initWithCapacity:_picArr.count];
    NSMutableArray *array;
    for (int i = 0; i <_picArr.count; i++) {
        [array addObject:[_picArr objectAtIndex:i]];
        NSString *str = [NSString stringWithFormat:@"education_image%d",i];
        [keyArr addObject:str];
        
    }
    NSLog(@"上传图片数量: %ld",_picArr.count);
     [AFNetFirst typearrPicturePOST:POST_GONGREN_DETAIL_URL parameters:_params withPicureData:_picArr withKeyArray:keyArr finish:^(NSData *data, NSError *error) {
     
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
         [ITTPromptView showMessage:dict[@"message"]];
         if ([[dict objectForKey:@"code"]isEqualToString:@"1000"]) {
             NSLog(@"上传成功");
             
             _account = [ADAccount accountWithDict:_modifyDict];
             [ADAccountTool save:_account];             

             [self.navigationController popViewControllerAnimated:YES];
         }
         NSLog(@"工人修改信息%@",dict);
         NSLog(@"工人错误信息%@",error.localizedDescription);
          }];
}

//
-(void)resignTheFirstResponser{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTheResponser:)];
    [self.view addGestureRecognizer:tap1];
}
-(void)cancelTheResponser:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    _pickerView.hidden = YES;
}

#pragma mark 键盘监控
-(void)keyBoardWillShow:(NSNotification *)notify{

    NSTimeInterval time=[[notify.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];

    float height=[[notify.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
    [UIView animateWithDuration:time animations:^{
        _tvBottomConstraint.constant = height;
        [self.view layoutIfNeeded];
    }];

    
    NSLog(@"键盘 show");
    
}

-(void)keyBoardWillHidden:(NSNotification *)notify{
    
    NSTimeInterval time=[[notify.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    [UIView animateWithDuration:time animations:^{
        _tvBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];

    NSLog(@"键盘 hidden");
}




@end
