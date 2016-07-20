//
//  JHChosePeopleViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/20.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHChosePeopleViewController.h"
#import "JHOrguserTableViewController.h"
#import "YSLContainerViewController.h"
@interface JHChosePeopleViewController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong)NSArray *portalArray;
@property (nonatomic, strong)NSMutableArray  *muPVC;
@end
#define CONTROLFRME CGRectMake(5, 5, self.view.frame.size.width * 2.8 / 4 - 10, 30)
#define BUTTONCONTROLFRME CGRectMake(5, 5, 30, 30)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
@implementation JHChosePeopleViewController
- (NSArray *)portalArray{
    if (_portalArray == nil) {
        _portalArray = [NSArray arrayWithObjects:@"选择列表",@"已选择",@"搜索", nil];
        
    }return _portalArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加选择导航器
    [self setupPortalTableViewController];
    //在导航栏上添加状态保存提交和取消按钮
    [self addNavigationBtn];
    self.title = @"测试很长的标题";

}

- (void)addNavigationBtn{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH / 2 + 75, 25, SCREENWIDTH / 2 - 80, 30)];
    NSArray *titleArray = [NSArray arrayWithObjects:@"清空",@"确定", nil];
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *statusbutton = [[UIButton alloc]initWithFrame:CGRectMake(i * ((SCREENWIDTH / 2 ) / 3), 0, (SCREENWIDTH / 2 - 40 ) / 3, 30)];
        [statusbutton setTitle:titleArray[i] forState:UIControlStateNormal];
        [statusbutton setBackgroundImage:[UIImage imageNamed:@"tab_unselected_pressed.9"] forState:UIControlStateHighlighted];
        [statusbutton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [statusbutton setTag:100 + i];
        [buttonView addSubview:statusbutton];
    }
    [self.navigationController.view addSubview:buttonView];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                          initWithTitle:@"取消"
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(doClickBackAction:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
//返回 (取消) 按钮
- (void)doClickBackAction:(UIBarButtonItem *)send {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBarButtonClick:(UIBarButtonItem *)send {
    switch (send.tag) {
        case 100:
            NSLog(@"点击了清空");
            [self clearButtonClick];
            break;
        case 101:
            NSLog(@"确定");
            [self saveButtonClick];
            break;
        default:
            NSLog(@"无效按钮");
            break;
    }
}
- (void)clearButtonClick {
    
}
- (void)saveButtonClick {
    
}
- (void)setupPortalTableViewController{
    NSMutableArray *muPVC = [NSMutableArray array];
    self.muPVC = muPVC;
    for (NSString *poral in self.portalArray) {
        JHOrguserTableViewController *pvc = [[JHOrguserTableViewController alloc]init];
        pvc.title = poral;
        [muPVC addObject:pvc];
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
