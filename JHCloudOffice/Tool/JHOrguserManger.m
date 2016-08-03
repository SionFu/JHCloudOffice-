//
//  JHOrguserManger.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/7/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHOrguserManger.h"

@implementation JHOrguserManger
singleton_implementation(JHOrguserManger)
- (NSDictionary *)saveUserDic {
    if (_saveUserDic == nil) {
        _saveUserDic = [NSDictionary dictionary];
    }return _saveUserDic;
}
- (NSMutableArray *)orguserTableViewArray {
    if (_orguserTableViewArray == nil) {
        _orguserTableViewArray = [NSMutableArray array];
    }return _orguserTableViewArray;
}
-(NSMutableArray *)displaysArray{
    if (_displaysArray == nil) {
        _displaysArray = [NSMutableArray array];
    }return _displaysArray;
}
-(NSArray *)parentidsArray{
    if (_parentidsArray == nil) {
        _parentidsArray = [NSArray array];
    }return _parentidsArray;
}
- (NSMutableArray *)superiorParentidsArray {
    if (_superiorParentidsArray == nil) {
        _superiorParentidsArray = [NSMutableArray array];
    }return _superiorParentidsArray;
}
-(void)getDisplaysValue {
    for (NSDictionary *display in self.parentidsArray) {
        [self.displaysArray addObject:display[@"DisplayValue"]];
    }
}
- (void)addParentidsArray {
    [self.superiorParentidsArray addObject:self.parentidsArray];
}
- (void)removerLastParentidsArray {
    [self.superiorParentidsArray removeLastObject];
    [self.orguserTableViewArray removeLastObject];
}
@end
