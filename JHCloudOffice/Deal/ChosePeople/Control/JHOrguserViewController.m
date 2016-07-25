//
//  JHOrguserViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/22.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHOrguserViewController.h"
#import "JHOrguserTableView.h"
#import "JHOrguserTableViewCell.h"
#import "JHOrguserManger.h"
#import "JHNetworkManager.h"
@interface JHOrguserViewController ()<UITableViewDataSource,UITableViewDelegate,JHOrguser>
@property (nonatomic ,strong ) UINib *nib;
/**
 *  放置选择组织人员的左右滑动选择视图
 */
@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) NSArray *parentidsArray;
@property (nonatomic, strong) JHOrguserTableView *tVC;
@end
#define TABLEVIEWFRAMEL CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height - 104)
#define TABLEVIEWFRAMER CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height - 104)
/*
 float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
 float navigationHeight = self.navigationController.navigationBar.frame.size.height;
 */
@implementation JHOrguserViewController
-(void)getOrguserSuccess {
    [self.tVC reloadData];
    
    NSLog(@"新表格刷新");
}
-(UIScrollView *)scroller {
    if (_scroller == nil) {
        _scroller = [[UIScrollView alloc]initWithFrame:TABLEVIEWFRAMEL];
    }return _scroller;
}
-(NSArray *)parentidsArray {
    if (_parentidsArray == nil) {
        _parentidsArray = [NSArray arrayWithArray:[JHOrguserManger sharedJHOrguserManger].parentidsArray];
    }return _parentidsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [JHNetworkManager sharedJHNetworkManager].getOrguserDelegate = self;
    // Do any additional setup after loading the view.
    [self addScrollView];
    [self addTableViewToScrollView];

}
- (void)addScrollView {
    self.scroller.backgroundColor = [UIColor brownColor];
    self.scroller.showsVerticalScrollIndicator = YES;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width / 2 * 3, self.view.frame.size.height);
    self.scroller.frame = rect;
    [self.view addSubview:self.scroller];
}
- (void)addTableViewToScrollView {
    self.tVC = [[JHOrguserTableView alloc]initWithFrame:TABLEVIEWFRAMEL];
    self.tVC.dataSource = self;
    self.tVC.delegate = self;
    [self.scroller addSubview:self.tVC];
}
#pragma UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parentidsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHOrguserTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier:cellIdentifier];
    }
    
    JHOrguserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.parentidsArray[indexPath.row][@"DisplayValue"];
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[JHNetworkManager sharedJHNetworkManager]getUsersWithDic:[JHOrguserManger sharedJHOrguserManger].parentidsArray[indexPath.row]];
    NSLog(@"%@",[JHOrguserManger sharedJHOrguserManger].parentidsArray[indexPath.row]);
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
