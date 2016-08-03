//
//  LoginViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/21.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "LoginViewController.h"
#import "JHNetworkManager.h"
#import "MBProgressHUD+KR.h"
#import "JHUserInfo.h"
#import "JHUserDefault.h"
@interface LoginViewController ()<JHLoginDelegate>
/**
 *  用户名文本输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/**
 *  密码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *userPwdTextFileField;
/**
 *  是否记住密码复选框
 */
@property (weak, nonatomic) IBOutlet UIButton *remberPwd;
- (IBAction)rembePwdCheckBox:(UIButton *)sender;
/**
 *  点击登录按钮
 */
- (IBAction)loginBtnClick:(id)sender;
/**
 *  密码输入框离底部的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userViewBottomConstraint;
/**
 *  用户名密码视图
 */
@property (weak, nonatomic) IBOutlet UIView *userImputView;
@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //关闭用户名的文本框的自动修正
    self.userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //添加输入框的左视图
    [self addImageViewToTextField];
    
    //判断是否自动登录
    if ([JHUserDefault autoLogin]) {
        self.userNameTextField.text = [JHUserDefault getUserName];
        self.userPwdTextFileField.text = [JHUserDefault getPwd];
        [self enterBtnClick:nil];
    }
}
- (void)addImageViewToTextField {
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 46, 30)];
    userImageView.image = [UIImage imageNamed:@"user"];
    
    UIImageView *lockImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 46, 30)];
    lockImageView.image = [UIImage imageNamed:@"lock"];
    self.userNameTextField.leftView = userImageView;
    self.userPwdTextFileField.leftView = lockImageView;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userPwdTextFileField.leftViewMode = UITextFieldViewModeAlways;
}
//当用户名输入框开始编辑
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
//    self.userViewBottomConstraint.constant = 130;
}
- (void)showKeyboard:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardDidHideNotification]doubleValue];
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue];
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat height = rect.size.height;
    self.userViewBottomConstraint.constant = height - 30;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        //显示输入框向上移动动画
        [self.view layoutIfNeeded];
    } completion:nil];
    
   
}
- (void)closeKeyboard:(NSNotification *)notification{
    //键盘弹起的持续时间
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //键盘弹起动画的类型
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue];
    //将输入框view移动到初始位置
    self.userViewBottomConstraint.constant = 0;
    [UIView animateKeyframesWithDuration:duration delay:0 options:option animations:^{
        //显示 输入框向下移动动画
        [self.view layoutIfNeeded];
        
    } completion:nil];

}
- (IBAction)enterBtnClick:(id)sender {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];

    [JHNetworkManager vaidataUserWithUserName:self.userNameTextField.text andPassword:self.userPwdTextFileField.text];
    [JHNetworkManager sharedJHNetworkManager].loginDelegate = self;
    [MBProgressHUD showMessage:@"正在登陆..." toView:self.view];
    
    
}

//点击 next 光标 进入到密码输入框
- (IBAction)endEdit:(id)sender {
       [self.userPwdTextFileField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//代理返回登陆成功
-(void)loginSuccess{
    if (self.remberPwd.selected == YES) {
        [JHUserDefault remberUserName:(self.userNameTextField.text) andUserPwd:(self.userPwdTextFileField.text)];
    } else{
        //清除账号密码
        [JHUserDefault clearUser];
    }
    
    //登陆成功就开始获取流程数据
    [MBProgressHUD showSuccess:@"登陆成功"];
    [MBProgressHUD showMessage:@"正在加载配置.." toView:self.view];
    [[[JHNetworkManager alloc]init] getModules];
    

}
-(void)beginGetModules{
    [self performSegueWithIdentifier:@"Login" sender:nil];
}
-(void)loginfaild{
    [MBProgressHUD showError:[JHUserInfo sharedJHUserInfo].errorCode];
}
-(void)loginNetError{
    [MBProgressHUD  hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"无法连接网络"];
}
//点击登陆按钮
- (IBAction)loginBtnClick:(id)sender {
    [self enterBtnClick:nil];
    [self.view endEditing:YES];
    
    
}
- (IBAction)rembePwdCheckBox:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
