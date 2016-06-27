//
//  JHHoneHeadView.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/23.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHHoneHeadView.h"
#import "JHUIControl.h"
#import "JHMenuData.h"
@interface JHHoneHeadView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *meneData;
@property (nonatomic, strong) UIPageControl *pageController;
@end

@implementation JHHoneHeadView
-(NSArray *)meneData{
    if (_meneData == nil) {
        NSString *pilstPath = [[NSBundle mainBundle]pathForResource:@"menuData.plist" ofType:nil];
        _meneData = [NSArray arrayWithContentsOfFile:pilstPath];
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in _meneData) {
        JHMenuData *menuData = [JHMenuData new];
        [menuData setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:menuData];
    }
    return [mutableArray copy];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat secreenWith = [UIScreen mainScreen].bounds.size.width;
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(secreenWith * 2, secreenWith * 0.3);
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, secreenWith, secreenWith / 2)];
        CGFloat quartScreenWith = secreenWith * 0.33;
        for (int i = 0; i < 6 ; i ++) {
            CGRect constFrame = CGRectMake(quartScreenWith * (i % 3), quartScreenWith * (i / 3), quartScreenWith , quartScreenWith);
            JHUIControl *control = [[[NSBundle mainBundle]loadNibNamed:@"JHUIControl" owner:self options:nil]lastObject];
            control.frame = constFrame;
            control.tag = 100 + i;
            [control addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            JHMenuData *menuData = self.meneData[i];
            control.imageView.image = [UIImage imageNamed:menuData.image];
            control.categorylabel.text = menuData.title;
            [firstView addSubview:control];
        }
        UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(secreenWith, 0, secreenWith, secreenWith/2)];
        for (int i = 0 ; i < self.meneData.count - 6; i ++) {
            CGRect constFrame = CGRectMake(quartScreenWith * (i%4), quartScreenWith * (i / 3), quartScreenWith, quartScreenWith);
            JHUIControl *control = [[[NSBundle mainBundle]loadNibNamed:@"JHUIControl" owner:self options:nil]lastObject];
            control.tag = i + 106;
            [control addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            control.frame = constFrame;
            JHMenuData *menuData = self.meneData[i + 6];
            control.imageView.image = [UIImage imageNamed:menuData.image];
            control.categorylabel.text = menuData.title;
            [secondView addSubview:control];
        }
        [scrollView addSubview:firstView];
        [scrollView addSubview:secondView];
        [self addSubview:scrollView];
        _pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(secreenWith / 2, secreenWith / 2 + 60, 0, 20)];
        _pageController.currentPage = 0;
        _pageController.numberOfPages = 2;
        _pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:0.3137 green:0.7647 blue:0.6706 alpha:1.0];
        _pageController.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageController];
    }return self;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewWith = scrollView.frame.size.width;
    CGFloat xOffSet = scrollView.contentOffset.x;
    int page = xOffSet / scrollViewWith + 0.5;
    _pageController.currentPage = page;
}

- (void)clickButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickHomeMenuButton:)]) {
        [self.delegate clickHomeMenuButton:(NSInteger)sender.tag];
    }
    NSLog(@"=====%ld",(long)sender.tag);
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
