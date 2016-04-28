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
#import "UserInfoGr.h"
#import "MJExtension.h"
#import "PureLayout.h"

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
    NSArray *_webPicArr;
    
    BOOL _isSex;
    BOOL _isWebImage;
    UIPickerView *_pickerView;
    UIView *_pView;
    
    NSMutableArray *_gzTypeArr;
    NSArray *_sexTypeArr;

    NSArray *_titleArr;
    NSMutableArray *_contentArr;
    ADAccount *_account;
    
    CGFloat imageRowHeigh;
    //黑色遮盖
    UIView *backView;
    
    //所需传参数
//    NSString *name;
//    NSString *sex;
//    NSString *age;
//    NSString *gzname;
//    NSString *xianjuzhudi;
//    NSString *huji;
//    NSString *gongling;
//    NSString *xueli;
//    NSString *shenfenzheng;
//    NSString *ziwojieshao;
}

@property (nonatomic, strong)UserInfoGr *userInfoGr;

@property (nonatomic, strong)NSMutableArray *gongZongDataSource;

//弹出框
@end

@implementation PersonalGongRenController

//工种
-(NSMutableArray *)gongZongDataSource
{
    if (!_gongZongDataSource) {
        _gongZongDataSource = [NSMutableArray array];
    }
    return _gongZongDataSource;
}

-(UserInfoGr*)userInfoGr
{
    if (!_userInfoGr) {
        _userInfoGr = [[UserInfoGr alloc]init];
    }
    return _userInfoGr;
}
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
    
    _tv.delegate = self;
    _tv.dataSource = self;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self netWorkUserinfo];
}

#pragma mark 个人资料（工人）
-(void)netWorkUserinfo
{
    ADAccount *account = [ADAccountTool account];
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:account.userid forKey:@"userid"];
    [parm setObject:account.token forKey:@"token"];
    
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_gerenziliaogr params:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            self.userInfoGr = [UserInfoGr mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
            
            [weakSelf setData];
            
            [_tv reloadData];
            
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    //默默的请求工种
    [NetWork postNoParm:YZX_gongzhongliebiao params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            self.gongZongDataSource = [responseObj objectForKey:@"data"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)createUI{
    _gzTypeArr = [NSMutableArray array];
    _params = [NSMutableDictionary dictionary];
    _picArr = [NSMutableArray array];
    _modifyDict  = [NSMutableDictionary dictionary];
    _account = [ADAccountTool account];
    _isWebImage = YES;
    _webPicArr = [NSArray array];
    
    self.title = @"个人资料";
    
    UIView *footView = [UIView new];
    self.tv.tableFooterView = footView;

    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, kU, 200)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self customPickerView];
    //[self setData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark 设置数据
-(void)setData{
    
    NSArray *array = @[self.userInfoGr.name,self.userInfoGr.sex,self.userInfoGr.age,self.userInfoGr.gzname,self.userInfoGr.huji,self.userInfoGr.xianjuzhudi,self.userInfoGr.gongling,self.userInfoGr.xueli,self.userInfoGr.shenfenzheng,@"",self.userInfoGr.ziwojieshao];
    
//    name = self.userInfoGr.name;
//    sex = self.userInfoGr.sex;
//    age = self.userInfoGr.age;
//    gzname = self.userInfoGr.gzname;
//    xianjuzhudi = self.userInfoGr.xianjuzhudi;
//    gongling = self.userInfoGr.gongling;
//    xueli = self.userInfoGr.xueli;
//    shenfenzheng = self.userInfoGr.shenfenzheng;
//    ziwojieshao = self.userInfoGr.ziwojieshao;
    
    _contentArr = [NSMutableArray array];
   [_contentArr addObjectsFromArray:array];
    
    //图片数组
    if(self.userInfoGr.zizhizhengshu)
    {
        _webPicArr = self.userInfoGr.zizhizhengshu;
    }
    
    NSLog(@"%@",self.userInfoGr.name);
    
}

#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count+1;
}

//tag 值用到  370 - 379 (378除外)
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString *reusID = @"personCell";
//    static NSString *reusID2 = @"personCell8";
//    static NSString *makeSureID = @"makeSureID";
         PersonaldetailsCell *cell = [PersonaldetailsCell loadPersonaldetailsCell];
    
    if (indexPath.row != 9&&indexPath.row !=_titleArr.count) {
//        PersonaldetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:reusID];
//        if (!cell) {
//           
//        }
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
            if (indexPath.row == 3) {
                //[ _params setObject:@"" forKey:@""];
                UIImageView *imageV = [[UIImageView alloc]init];
                imageV.image = [UIImage imageNamed:@"下拉"];
                [cell.contentView addSubview:imageV];
                
                [imageV autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cell.contentView];
                [imageV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.contentView withOffset:-20];
                [imageV autoSetDimension:ALDimensionWidth toSize:20];
                [imageV autoSetDimension:ALDimensionHeight toSize:15];
                
            }
            
        }
        if (indexPath.row == 0 ||indexPath.row == 4||indexPath.row == 5||indexPath.row == 7||indexPath.row == 10) {
            cell.textfield.enabled = YES;
            cell.textfield.keyboardType = UIKeyboardTypeDefault;
        }
        
        if (indexPath.row == 6||indexPath.row == 8||indexPath.row == 2) {
            cell.textfield.enabled = YES;
            cell.textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        cell.textfield.delegate = self;
        cell.textfield.tag = 371 + indexPath.row;
        return cell;
    }else if (indexPath.row ==_titleArr.count)
    {
        PersonalMakeSureCell *cell = [PersonalMakeSureCell cellLoad];
//        if (!cell) {
//            cell = [PersonalMakeSureCell cellLoad];
//        }
        [cell addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        PersonalDetails2Cell *cell2 = [PersonalDetails2Cell loadPersonaldetailsCell];
//        if (!cell2) {
//            cell2 = [PersonalDetails2Cell loadPersonaldetailsCell];
//        }
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.nameLb.text = _titleArr[indexPath.row];
        [cell2.addPicBtn addTarget:self  action:@selector(addPicture:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加图片按钮
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.image = [UIImage imageNamed:@"加号"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture:)];
        imgV.userInteractionEnabled = YES;
        [imgV addGestureRecognizer:tap];
        
        //布局九宫格
        int lieshu = 3;//列数
        //int hangshu = 3;//行数
        CGFloat colpan = 20;//间隔
        int hangNum;//行号
        int lieNum;//列号
        CGFloat ImageWith = (SCREEN_WIDTH-cell2.nameLb.width-colpan*(lieshu+1))/lieshu;
        CGFloat ImageHeigh = ImageWith;
        
        //图片
         if (_isWebImage) {
             NSLog(@"%d",_isWebImage);
            for (int i = 0; i < _webPicArr.count+_picArr.count+1; i++) {
                //行号
                hangNum = i/lieshu;
                //列号
                lieNum = i%lieshu;
                
                //添加加号
                if (i==_webPicArr.count+_picArr.count) {
                    
                    if(i==8)
                    {
                        imgV.frame = CGRectMake((cell2.nameLb.width+5)+lieNum*(ImageWith+colpan), 10+(hangNum+1)*(ImageHeigh+colpan), ImageWith, 0);
                    }else
                    {
                    
                    imgV.frame = CGRectMake((cell2.nameLb.width+5)+lieNum*(ImageWith+colpan), 10+hangNum*(ImageHeigh+colpan), ImageWith, ImageHeigh);
                        
                        
                    [cell2.contentView addSubview:imgV];
                        
                    }
                    
                    imageRowHeigh =imgV.frame.origin.y+imgV.frame.size.height+10;
                }
                //添加网络图片与自选图片
                else
                {
                    UIImageView *svImgV = [[UIImageView alloc]init];
                    svImgV.frame = CGRectMake((cell2.nameLb.width+5)+lieNum*(ImageWith+colpan), 10+hangNum*(ImageHeigh+colpan), ImageWith, ImageHeigh);
                    
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(svImgV.x-10, svImgV.y-10, svImgV.width+20, svImgV.height+20)];
                    view.backgroundColor = [UIColor clearColor];
                    
    

                    if (i<_webPicArr.count) {
                        
                        NSLog(@"草泥马%ld",_webPicArr.count);
                      [svImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,_webPicArr[i]]] placeholderImage:nil];
                        
                      [cell2.contentView addSubview:svImgV];
        
                        
                    }else if(i-_webPicArr.count<_picArr.count&&i>=_webPicArr.count)
                    {
                        
                       svImgV.image = [UIImage imageWithData:[_picArr objectAtIndex:i-_webPicArr.count]];
                        
                      [cell2.contentView addSubview:svImgV];
                        
                    }
                
                    
                    
                    //添加删除符号
                    UIButton *removeButton = [[UIButton alloc]initWithFrame:CGRectMake(view.width-20, 0, 20, 20)];
                    removeButton.tag = 100+i;
                    [removeButton addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [removeButton setBackgroundImage:[UIImage imageNamed:@"叉叉-1"] forState:UIControlStateNormal];
                    [view addSubview:removeButton];
                    svImgV.userInteractionEnabled = YES;
                    
                    [cell2.contentView addSubview:view];
                    
                }
                
            }
        } else {

            
        }
        
        return cell2;
    }

 }

#pragma mark 删除图片
-(void)removeImage:(id)sender
{
    UIButton *btn =(UIButton *)sender;
    int num = (int)btn.tag -100;
    if(num<_webPicArr.count)
    {
        [self removeImageNetWork:num];
    }else
    {
        int num2 = num-(int)_webPicArr.count;
        [_picArr removeObjectAtIndex:num2];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
        NSArray *indexPathArr = @[indexPath];
        [self.tv reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
    
    }
    
}

#pragma mark 删除图片接口
-(void)removeImageNetWork:(int)num
{
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    [parm setObject:_webPicArr[num] forKey:@"url"];
    
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_shanchuzizhi params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            
            //删除图片
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:_webPicArr];
            [array removeObjectAtIndex:num];
            _webPicArr = array;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
            NSArray *indexPathArr = @[indexPath];
            [weakSelf.tv reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
        }else
        {
            [ITTPromptView showMessage:[responseObj objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
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
    
    PersonaldetailsCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 1:{
            NSLog(@"选择性别");
            
            _isSex = YES;
            
            backView = [Function createBackView:self action:@selector(backClicked)];
            backView.alpha = 0.8;
            
            _pView.height = 150;
            _pickerView.height = _pView.height;
           //_pView.frame = CGRectMake(40, 100, SCREEN_WIDTH - 80, 60);
            [[UIApplication sharedApplication].keyWindow addSubview:_pView];
            [self.view addSubview:backView];
            
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            [self.view endEditing:YES];
            [UIView animateWithDuration:1 animations:^{
                _pView.hidden = NO;
            }];
            
            cell.textfield.text =_sexTypeArr[0];
        }
            break;
        case 3:{
            _isSex = NO;
            
            //获得工种
            [self networkGongZhong:cell.textfield ];
            
            //[self.gongZongDataSource[row] objectForKey:@"gzname"]

                }
            break;
        default:
            break;
    }
}

#pragma mark 请求工种
-(void)networkGongZhong :(UITextField *)textFiled
{
    //获得工种
    ADAccount *acount = [ADAccountTool account];
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:acount.userid forKey:@"userid"];
    [parm setObject:acount.token forKey:@"token"];
    __weak typeof (self)weakSelf = self;
    [NetWork postNoParm:YZX_gongzhongliebiao params:parm success:^(id responseObj) {
        if ([[responseObj objectForKey:@"result"]isEqualToString:@"1"]) {
            NSLog(@"%@",responseObj);
            self.gongZongDataSource = [responseObj objectForKey:@"data"];
            [weakSelf pickViewGongZhong];
            //获取第一条数据
            textFiled.text =[self.gongZongDataSource[0] objectForKey:@"gzname"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma 工种弹窗
-(void)pickViewGongZhong
{
    backView = [Function createBackView:self action:@selector(backClicked)];
    backView.alpha = 0.8;
    //_pView.frame = CGRectMake(40, 100, SCREEN_WIDTH - 80, 60);
    _pView.height = 200;
    _pickerView.height = _pView.height;
    [[UIApplication sharedApplication].keyWindow addSubview:_pView];
    [self.view addSubview:backView];
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:1 animations:^{
        _pView.hidden = NO;
    }];
    NSLog(@"选择工作");

}

-(void)backClicked
{

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {
        return imageRowHeigh;
    }else if (indexPath.row == _titleArr.count)
    {
        return 125;
    }
    else {
        return 60;
    }
}

#pragma mark UItextFeild

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _pView.hidden = YES;
 
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 
    NSInteger index = textField.tag-371;
    //NSLog(@"%d",index);
    [_contentArr replaceObjectAtIndex:index withObject:textField.text];

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

    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _imageData = UIImageJPEGRepresentation(image, 0.3);
        
        [self dismissViewControllerAnimated:YES completion:^{
            [_picArr addObject:_imageData];
            //NSLog(@"_picArr%@,",_picArr.count);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
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
    
    return nil;
}


//
#pragma mark 自定义 pickerView
-(void)customPickerView{
    NSLog(@"customPickerView");
    _pView = [[UIView alloc]init];
    _pView.frame = CGRectMake(60, 150, SCREEN_WIDTH-120, 100);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 60, 30);
    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelChoosePicker) forControlEvents:UIControlEventTouchUpInside];
    [_pView addSubview:leftBtn];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(_pView.width - 70, 0, 60, 30);
//    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(ensureChoosePicker) forControlEvents:UIControlEventTouchUpInside];
//    [_pView addSubview:rightBtn];
    
    _pView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    _pickerView.frame = CGRectMake(0, 30, _pView.width, _pView.height);
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
    
    [backView removeFromSuperview];
}
-(void)ensureChoosePicker{
    NSString  *index = [NSString stringWithFormat:@"%ld",[_pickerView selectedRowInComponent:0]+1];
    [UIView animateWithDuration:1 animations:^{
        _pView.hidden = YES;
    }];
    [backView removeFromSuperview];
}
#pragma mark PickerView
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_isSex) {
        return _sexTypeArr.count;
    }else{
        //return _gzTypeArr.count;
        return self.gongZongDataSource.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (_isSex) {
        return _sexTypeArr[row];
    } else {
        //return _gzTypeArr[row];
       // NSLog(@" %@",[self.gongZongDataSource[row] objectForKey:@"gzname"]);
        return [self.gongZongDataSource[row] objectForKey:@"gzname"];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *str;
    NSString *ID;
    UITextField *textFeild;
    if (_isSex) {
        str = [_sexTypeArr objectAtIndex:[pickerView selectedRowInComponent:component]];
        textFeild = [self.tv viewWithTag:372];
    } else {
        textFeild = [self.tv viewWithTag:374];
        //str = [_gzTypeArr objectAtIndex:[pickerView selectedRowInComponent:component]];
        str = [[self.gongZongDataSource objectAtIndex:[pickerView selectedRowInComponent:component]] objectForKey:@"gzname"];
        
        ID = [[self.gongZongDataSource objectAtIndex:[pickerView selectedRowInComponent:component]] objectForKey:@"id"];
        //NSLog(@" %@",ID);
        [_params setObject:ID forKey:@"gongzhongid"];
        
    }
    textFeild.text = str;
    
    //更换数据源
    [_contentArr replaceObjectAtIndex:textFeild.tag-371 withObject:textFeild.text];
    
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
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
};

#pragma mark  完成提交
- (void)clickFinish{
    
    [self getTextFieldText];
    
}
//获取输入框文字
-(void)getTextFieldText{
    //姓名
    UITextField *nameField = [self.view viewWithTag:371];
    NSLog(@"%@",nameField.text);
    if ([nameField.text isEqualToString:@""]) {
        
        [ITTPromptView showMessage:@"姓名不能为空"];
        return;
    }
    
    if (nameField !=nil) {
        [_params setObject:nameField.text forKey:@"name"];
    }
    
    //性别
    UITextField *sexField = [self.view viewWithTag:372];
    NSLog(@"%@",sexField.text);
    if ([sexField.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"性别不能为空"];
        return;
    }
    //NSString *sexStr = [self  getSexTypeCode:sexField.text];
    if (sexField != nil) {
        [_params setObject:sexField.text forKey:@"sex"];

    }
    
    //年龄
    UITextField *ageField = [self.view viewWithTag:373];
    if ([ageField.text isEqualToString:@""]) {
        [ITTPromptView showMessage:@"年龄不能为空"];
        return;
    }
    if (ageField != nil) {
        [_params setObject:ageField.text forKey:@"age"];
    }
    
    //工种
    UITextField *gzTypeField = [self.view viewWithTag:374];
//    NSString *gzTypeStr = [self returnGZtype:gzTypeField.text];
//    if (gzTypeStr !=  nil) {
//        [_params setObject:gzTypeStr forKey:@"gongzhongid"];
//    }
    
    if (![_params objectForKey:@"gongzhongid"]) {
        
        for (int i = 0; i<self.gongZongDataSource.count; i++) {
            if ([gzTypeField.text isEqualToString:[self.gongZongDataSource[i] objectForKey:@"gzname"]]) {
                [_params setObject:[self.gongZongDataSource[i] objectForKey:@"id"] forKey:@"gongzhongid"];
            }
        }
    }
    
    //户籍
    UITextField *cityField = [self.view viewWithTag:375];
    if (cityField != nil) {
        [_params setObject:cityField.text forKey:@"huji"];
    }
    
    //地址
    UITextField *addressField = [self.view viewWithTag:376];
    if (addressField != nil) {
        [_params setObject:addressField.text forKey:@"xianjuzhudi"];

    }
    //工龄
    UITextField *gongLingFile = [self.view viewWithTag:377];
    if (gongLingFile != nil) {
        [_params setObject:gongLingFile.text forKey:@"gongling"];
    }
    
    //学历
    UITextField *educationField = [self.view viewWithTag:378];
    if (educationField != nil) {
        [_params setObject:educationField.text forKey:@"xueli"];    }
    
    //身份证
    UITextField *idCardField = [self.view viewWithTag:379];
    if (idCardField != nil) {
        [_params setObject:idCardField.text forKey:@"shenfenzheng"];
    }
    
    //自我介绍
    UITextField *descField = [self.view viewWithTag:381];
    if (descField.text != nil) {
        [_params setObject:descField.text forKey:@"ziwojieshao"];
    }
    
    [self postData];
    
}

#pragma mark 获得工种
-(void)getGZTypeData{
    
    [_gzTypeArr addObjectsFromArray:@[@"木工",@"油工",@"电工",@"瓦工",@"小工"]];
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
    
    if (([[_params objectForKey:@"age"]intValue]-13)<[[_params objectForKey:@"gongling"]intValue]) {
        
        [ITTPromptView showMessage:@"工龄不合法"];
        return;
    }
    
   //[_params setObject:ID forKey:@"gongzhongid"];
    
    if (![_params objectForKey:@"gongzhongid"]) {
        
        [_params setObject:@"" forKey:@"gongzhongid"];
    }
    
    NSMutableArray *keyArr = [[NSMutableArray alloc]init];
    for (int i = 0; i <_picArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"pic%d",i+1];
        [keyArr addObject:str];
        
    }
//    for (int i = 0; i<_webPicArr.count; i++) {
//        
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YZX_BASY_URL,_webPicArr[i]]]]];
//        
//         NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
//         [_picArr addObject:imageData];
//    }
    
//    NSLog(@"%ld",_picArr.count);
//    
//    NSLog(@"上传图片数量: %ld",_picArr.count);
    ADAccount *acount = [ADAccountTool account];
    [_params setObject:acount.userid forKey:@"userid"];
    [_params setObject:acount.token forKey:@"token"];
    [_params setObject:@"ios" forKey:@"apptype"];
   // NSLog(@"%@",_params);
     [AFNetFirst typearrPicturePOST:YZX_gerenzhiliao_gr_baocun parameters:_params withPicureData:_picArr withKeyArray:keyArr finish:^(NSData *data, NSError *error) {
     
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
         [ITTPromptView showMessage:dict[@"message"]];
         if ([[dict objectForKey:@"result"]isEqualToString:@"1"]) {
             //NSLog(@"上传成功");
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

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (_pView) {
        [_pView removeFromSuperview];
    }
    
}


@end
