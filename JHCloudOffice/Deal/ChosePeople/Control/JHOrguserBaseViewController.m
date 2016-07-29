//
//  JHOrguserBaseViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/25.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHOrguserBaseViewController.h"
#import "JHOrguserTableViewCell.h"
#import "JHOrguserManger.h"
#import "JHNetworkManager.h"
#define TABLEVIEWFRAMEL CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height)
@interface JHOrguserBaseViewController ()<UITableViewDataSource,UITableViewDelegate,JHOrguser>
//声明表视图子类用这个表格初始化
@property (nonatomic,strong) UITableView* tableView;
//声明表视图子类用这个表格初始化
@property (nonatomic, strong) NSArray *parentidsArray;
@property (nonatomic ,strong ) UINib *nib;
@end

@implementation JHOrguserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    [JHNetworkManager sharedJHNetworkManager].getOrguserDelegate = self;
    //注册自定义cell
//    [self.tableView registerNib:[UINib nibWithNibName:@"JHOrguserTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuseIdentifier"];
    self.view.backgroundColor = [UIColor blackColor];
}
- (void)drawRact:(CGRect* )rect {
    
}
-(void)getOrguserSuccess{
    NSLog(@"刷新 tableView");
//    [self.tableView reloadData];
//    [self.view setNeedsDisplay];
}
-(NSArray *)parentidsArray {
    if (_parentidsArray == nil) {
        _parentidsArray = [NSArray arrayWithArray:[JHOrguserManger sharedJHOrguserManger].parentidsArray];
    }return _parentidsArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.parentidsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"reuseIdentifier";
    if (_nib == nil) {
        _nib = [UINib nibWithNibName:@"JHOrguserTableViewCell" bundle:nil];
        [tableView registerNib:_nib forCellReuseIdentifier: cellIdentifier];
        tableView.frame = TABLEVIEWFRAMEL;
    }
    JHOrguserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.parentidsArray[indexPath.row][@"DisplayValue"];
    
    
    return cell;
    
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
