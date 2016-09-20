//
//  JHEmailContentViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHEmailContentViewController.h"
#import "JHWeaverNetManger.h"
#import "MBProgressHUD+KR.h"
@interface JHEmailContentViewController ()<JHGetMailDelegate,UIWebViewDelegate>
@property (nonatomic ,strong)JHWeaverNetManger *manger;
/**
 *  发件人
 */
@property (weak, nonatomic) IBOutlet UILabel *sendFromLabel;
/**
 *  收到邮件时间
 */
@property (weak, nonatomic) IBOutlet UILabel *sendDateLbel;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
/**
 *  邮件内容显示控件
 */
@property (weak, nonatomic) IBOutlet UIWebView *mailContentWebView;
/**
 *  下载附件进度条
 */
@property (weak, nonatomic) IBOutlet UIProgressView *downFileProgressView;
/**
 *  显示附件视图
 */
@property (weak, nonatomic) IBOutlet UIView *fileView;
/**
 *  需要显示的邮件 id
 */
@property (nonatomic, strong) NSString *mailIdStr;
@end

@implementation JHEmailContentViewController
-(NSString *)mailIdStr {
    return self.mailContentDic[@"mailid"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"正在加载..." toView:self.view];
    self.manger = [JHWeaverNetManger new];
    self.manger.getMailDelegate = self;
    [self.manger mailContentObjectsGetMailContentWithMailId:self.mailIdStr];
}
-(void)getMailSuccess {
    //显示先关控件内容
    self.mailContentWebView.delegate = self;
    [self.mailContentWebView loadHTMLString:@"" baseURL:nil];
    //成功下载邮件 刷新视图
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self loadViewIfNeeded];
}
-(void)getMailFaild {
    //下载邮件失败
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

@end
