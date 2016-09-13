//
//  JHWebContentViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/12.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHWebContentViewController.h"
#import "JHSubscribeViewController.h"
#import "NSString+FDGetTopUrl.h"
#import "JHSubscribeWebViewActivity.h"
@interface JHWebContentViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@property (weak, nonatomic) IBOutlet UILabel *htmlFromString;
@end

@implementation JHWebContentViewController
- (void)viewWillAppear:(BOOL)animated {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.hidden = NO;
}
-(NSString *)urlStr {
    _urlStr = [[JHSubscribeWebViewActivity new]getUserAndSsoUrlWithUrl:_urlStr];
    return _urlStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.poiDic[@"PUBLICNAME"];
    self.htmlFromString.text = [NSString getTopUrlWithAnyString:self.urlStr];
    self.contentWebView.delegate = self;
    NSURL* url = [NSURL URLWithString:self.urlStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.contentWebView loadRequest:request];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"····" style:UIBarButtonItemStylePlain target:self action:@selector(detalButtonClink:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detalButtonClink:(id)sender {
    JHSubscribeViewController *subView = [JHSubscribeViewController new];
    subView.poiDic = self.poiDic;
    [self.navigationController pushViewController:subView animated:YES];
}
@end
