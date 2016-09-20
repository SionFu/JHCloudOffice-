//
//  JHDetailWebViewController.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/18.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHDetailWebViewController.h"

@interface JHDetailWebViewController ()//<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *detalWebView;

@end

@implementation JHDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector( reloadButtonClink:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}
- (void)reloadButtonClink:(id)sender {
    [self loadWebView];
}
- (void)loadWebView {
//    self.detalWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.detalWebView loadRequest:request];
    self.detalWebView.scrollView.bounces = NO;
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
