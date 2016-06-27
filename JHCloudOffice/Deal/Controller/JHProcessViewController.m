//
//  JHProcessViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/26.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHProcessViewController.h"
#import "YSLContainerViewController.h"
#import "JHPortalTableViewController.h"
@interface JHProcessViewController ()<YSLContainerViewControllerDelegate>
@property (nonatomic, strong)NSArray *portalArray;
@end

@implementation JHProcessViewController
- (NSArray *)portalArray{
    if (_portalArray == nil) {
        _portalArray = [NSArray arrayWithObjects:@"行政流程",@"商贸流程",@"测试",@"个测试",@"再测试", nil];
    }return _portalArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupPortalTableViewController];
}
- (void)setupPortalTableViewController{
    NSMutableArray *muPVC = [NSMutableArray array];
    for (NSString *poral in self.portalArray) {
        JHPortalTableViewController *pvc = [[JHPortalTableViewController alloc]initWithNibName:@"JHPortalTableViewController" bundle:nil];;
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
    NSLog(@"%ld",(long)index);
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
