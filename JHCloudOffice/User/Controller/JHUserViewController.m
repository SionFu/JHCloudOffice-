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
#import "JHWeaverNetManger.h"
#import "JHTaskTableViewController.h"
#import "JHInstancesTableViewController.h"
#import "JHGlobalModel.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface JHUserViewController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong)NSArray *portalArray;
@property (nonatomic, strong)NSMutableArray  *muPVC;
@property (nonatomic, assign)NSInteger nowIndex;
@property (nonatomic, strong)UINavigationItem *rootNavigatioItem;
@end

@implementation JHUserViewController
-(UINavigationItem *)rootNavigatioItem {
    return [JHGlobalModel sharedJHGlobalModel].rootNavigationItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [self addNavigationBtnWithIndex:self.nowIndex];
}
- (NSArray *)portalArray{
    if (_portalArray == nil) {
        //测试代码
        _portalArray = [NSArray arrayWithObjects:@"我的阅办",@"我的邮件",@"我的流程",@"通知公告",@"已下载文件", nil];
    }return _portalArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
        }else if ([poral isEqualToString:@"我的阅办"]) {
            JHTaskTableViewController *taskView = [JHTaskTableViewController new];
            taskView.taskStates = @"0;1;2;3;4;5";
            taskView.title = @"我的阅办";
            [muPVC addObject:taskView];
        }else if ([poral isEqualToString:@"我的流程"]) {
            JHInstancesTableViewController *instancesView = [JHInstancesTableViewController new];
            instancesView.title = @"我的流程";
            [muPVC addObject:instancesView];
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
    self.nowIndex = index;
    [self addNavigationBtnWithIndex:index];
    

}
- (void)addNavigationBtnWithIndex:(NSInteger)index {
    if (index == 0) {
        [self addNavigationButton];
    }
    if (index == 1) {
        //修改为发送邮件 按钮
        self.rootNavigatioItem.rightBarButtonItems = nil;
        self.rootNavigatioItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendEmailButtonItemClick)];
    }
    if (index == 2) {
        [self addNavigationButton];
        
    }
    if (index == 3) {
        [self addNavigationButton];
        
    }
}
- (void)addNavigationButton {
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(addObject:)];
    //打开扫描二维码
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(scanCRCodeViewController)];
    //打开查找视图
    NSArray *buttonArray = [NSArray arrayWithObjects:scanButton,searchButton, nil];
    self.rootNavigatioItem.rightBarButtonItems = buttonArray;
}
- (void)rightBarButtonClick {
    NSLog(@"编写邮件");
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
