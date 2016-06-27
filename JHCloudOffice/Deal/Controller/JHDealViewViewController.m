//
//  JHDealViewViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHDealViewViewController.h"
#import "JHHoneHeadView.h"
#import "JHUserInfo.h"
#import "JHNetworkManager.h"
#import "JHProcessViewController.h"
@interface JHDealViewViewController ()<JHHomeMenuButtonDelegate>
/**
 *  用户姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation JHDealViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滚动选择视图
    [self setUpHomeHeadView];
    //显示用户登陆信息
    [self showUserInfo];
    //登陆成功就开始获取流程数据
    [JHNetworkManager getModules];
}
- (void)showUserInfo {
    self.nameLabel.text = [JHUserInfo sharedJHUserInfo].name;
    self.companyLabel.text = [JHUserInfo sharedJHUserInfo].company;
}
- (void)setUpHomeHeadView {
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    JHHoneHeadView *headView = [[JHHoneHeadView alloc]initWithFrame:CGRectMake(0, 0, screenWith, screenWith / 1.5)];
    
    headView.delegate = self;

    [self.headView addSubview: headView];
}
-(void)clickHomeMenuButton:(long)sender{
    NSLog(@"%ld",sender - 100);
    switch (sender - 100) {
        case 0:{
            JHProcessViewController *evc = [JHProcessViewController new];
            [self.navigationController pushViewController:evc animated:YES];
                }
            break;
            
        default:
            break;
    }
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
