//
//  JHUserViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/7.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHUserViewController.h"
#import "YSLContainerViewController.h"
#import "JHUserTableViewController.h"
#import "JHFileListTableViewController.h"
#import "JHReadEmailTableViewController.h"
@interface JHUserViewController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong)NSArray *portalArray;
@property (nonatomic, strong)NSMutableArray  *muPVC;
@end

@implementation JHUserViewController
- (void)viewWillAppear:(BOOL)animated {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = NO;
}
- (NSArray *)portalArray{
    if (_portalArray == nil) {
        //测试代码
        _portalArray = [NSArray arrayWithObjects:@"我的阅办",@"我的邮件",@"我的流程",@"通知公告",@"已下载文件", nil];
    }return _portalArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupPortalTableViewController];
}
- (void)setupPortalTableViewController{
    NSMutableArray *muPVC = [NSMutableArray array];
    self.muPVC = muPVC;
    for (NSString *poral in self.portalArray) {
        JHUserTableViewController *pvc = [[JHUserTableViewController alloc]init];
        pvc.title = poral;
        if ([poral isEqualToString:@"通知公告"]) {
            JHFileListTableViewController *fileView = [JHFileListTableViewController new];
            fileView.seccategory = @"541";
            fileView.title = @"通知公告";
            [muPVC addObject:fileView];
        }
        else if ([poral isEqualToString:@"我的邮件"]) {
            JHReadEmailTableViewController *readView = [JHReadEmailTableViewController new];
            readView.unReadMail = false;
            readView.title = @"我的邮件";
            [muPVC addObject:readView];
        }
        else {
        [muPVC addObject:pvc];
        }
    }
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:muPVC topBarHeight:statusHeight + navigationHeight parentViewController:self];
    containerVC.delegate = self;
    [self.view addSubview:containerVC.view];
    self.view.backgroundColor = [UIColor colorWithRed:0.7332 green:0.7332 blue:0.7332 alpha:1.0];
}

-(void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller{
    //    [JHModulesData sharedJHModulesData].curreatVCIndex = index;
    if (index == 1) {
        JHReadEmailTableViewController *readView = (JHReadEmailTableViewController*)controller;
        [readView.tableView reloadData];
    }
    
    NSLog(@"%ld%@",(long)index,controller);
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
