//
//  JHSubscribeViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/9.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHSubscribeViewController.h"
#import "UIImageView+WebCache.h"
#import "JHRestApi.h"
#import "MBProgressHUD+KR.h"
#import "UIImage+FDChangeStringToCRCode.h"
@interface JHSubscribeViewController ()<JHFollowAndCancelSubscribeDelegate>
/**
 *  标示 pushIcon
 */
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
/**
 *  订阅内容标题
 */
@property (weak, nonatomic) IBOutlet UILabel *publicNameLabel;
/**
 *  代码
 */
@property (weak, nonatomic) IBOutlet UILabel *publicCodeLabel;
/**
 *  功能介绍
 */
@property (weak, nonatomic) IBOutlet UILabel *publicDescLabel;
/**
 *  所属单位
 */
@property (weak, nonatomic) IBOutlet UILabel *publicOwnerLabel;
/**
 *  二维码
 */
@property (weak, nonatomic) IBOutlet UIImageView *eqCodeImageView;
@property (nonatomic ,strong) JHRestApi *apiManger;
@end

@implementation JHSubscribeViewController
- (JHRestApi *)apiManger {
    if (_apiManger == nil) {
        _apiManger = [JHRestApi new];
    }return _apiManger;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showInformation];
}
- (void)showInformation {
    [self.handImageView sd_setImageWithURL:[NSURL URLWithString:self.poiDic[@"PUSHICON"]] placeholderImage:[UIImage imageNamed:@"ic_dyh"]];
    self.publicNameLabel.text = self.poiDic[@"PUBLICNAME"];
    self.publicCodeLabel.text = self.poiDic[@"PUBLICCODE"];
    self.publicDescLabel.text = self.poiDic[@"PUBLICDESC"];
    self.publicOwnerLabel.text = self.poiDic[@"PUBLICOWNER"];
    self.title = @"设置订阅内容";
    
    NSString *sqStr = [NSString stringWithFormat:@"subscribe:%@:%@:juhcloudoffice",self.poiDic[@"PUBLICCODE"],self.poiDic[@"PUBLICNAME"]];
    self.eqCodeImageView.image = [UIImage getCRCodeImageWithString:sqStr];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(subscribeItem:)];
    if ([[NSString stringWithFormat:@"%@",self.poiDic[@"IsFollow"]]isEqualToString:@"1"]) {
        rightButton.title = @"取消订阅";
    }
    else if ([[NSString stringWithFormat:@"%@",self.poiDic[@"IsFollow"]]isEqualToString:@"0"])
    {
        rightButton.title = @"订阅";
    }
    //判断是需要显示订阅\取消按钮
    if ([[NSString stringWithFormat:@"%@",self.poiDic[@"FOLLOWTYPE"]] isEqualToString:@"1"]) {
        return;
    }
    [self.navigationItem setRightBarButtonItem:rightButton];
}
-(void)cancelSubscribeSuccess {
    [MBProgressHUD showSuccess:@"取消订阅成功"];
}
- (void)foolwSubcribeSuccess {
    [MBProgressHUD showSuccess:@"订阅成功"];
}
- (void)subscribeItem:(UIBarButtonItem *)sender {
    self.apiManger.subscribeDelegate = self;
    if ([sender.title isEqualToString:@"订阅"]) {
        //订阅内容
       [self.apiManger subscribeObjectFollowSubscribeWithSubscribe:self.poiDic[@"PUBLICGUID"]];
       sender.title = @"取消订阅";
    }else if ([sender.title isEqualToString:@"取消订阅"]){
        //取消订阅
        [self.apiManger resultPojoCancelSubscribeWithSubscribe:self.poiDic[@"PUBLICGUID"]];
        sender.title = @"订阅";
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
