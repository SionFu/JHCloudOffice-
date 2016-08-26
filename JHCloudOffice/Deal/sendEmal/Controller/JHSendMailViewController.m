//
//  JHSendMailViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHSendMailViewController.h"
#import "JHChosePeopleViewController.h"
#import "JHPageDataManager.h"
#import "JHNetworkManager.h"
#import "MBProgressHUD+KR.h"
#import "JHUserInfo.h"
#import "JHPageDataItem.h"
#import "JHOrguserManger.h"
@interface JHSendMailViewController ()<JHOrguser>
- (IBAction)receivePeopleBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *receivePeopleBtn;
@property (nonatomic ,assign) NSInteger senderControlTag;
@end

@implementation JHSendMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationButton];
}
- (void)addNavigationButton {
    UIBarButtonItem *liftButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closeScanVC)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendEmail:)];
    [self.navigationItem setLeftBarButtonItem:liftButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}
- (void)sendEmail:(UIButton *)send {
    NSLog(@"点击发送按钮");
}
- (void)closeScanVC {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)receivePeopleBtn:(id)sender {
    UIButton *button = sender;
    self.senderControlTag = button.tag;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *value = [JHUserInfo sharedJHUserInfo].companyObjectId;
    NSString *displayValue = value;
    NSString *type = @"ShortString";
    NSString *Key = @"owercompany";
    dic = @{
            @"value":value,
            @"displayValue":displayValue,
            @"type":type,
            @"Key":Key,
            };
    JHPageDataItem *item = [JHPageDataItem new];
    item.Parents = [NSArray arrayWithObject:dic];
    [JHPageDataManager sharedJHPageDataManager].pageDataItemsArray = [NSMutableArray arrayWithObject:item];
    [[JHNetworkManager sharedJHNetworkManager] getPageSettingWithCurrentVC:0 andRow:0];
    
    [[JHNetworkManager sharedJHNetworkManager]getUsersWithDic:[[JHPageDataManager sharedJHPageDataManager]findOwercompanyWithKey:button.tag]];
    JHNetworkManager *net = [JHNetworkManager new];
    net.getOrguserDelegate = self;
    [MBProgressHUD showMessage:@"正在加载..."];
}
-(void)getOrguserSuccess {
    [MBProgressHUD hideHUD];
    JHChosePeopleViewController *cVC = [JHChosePeopleViewController new];
    cVC.navigationTitle = @"选择收件人";
    UINavigationController *nvpageVC = [[UINavigationController alloc]initWithRootViewController:cVC];
    cVC.indexPathTag = self.senderControlTag;
    [self.navigationController presentViewController:nvpageVC animated:YES completion:nil];
    cVC.sendBtn = self.receivePeopleBtn;
    cVC.indexNView = self.view;
}
- (void)dealloc {
//视图消失时  自动删除 最后一个数组
[[JHOrguserManger sharedJHOrguserManger]removerLastParentidsArray];
}
@end
