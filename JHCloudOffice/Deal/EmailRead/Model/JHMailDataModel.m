//
//  JHMailDataModel.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/19.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHMailDataModel.h"

@implementation JHMailDataModel
-(NSArray *)mailDocsArray {
    return self.mailContentDataDic[@"maildocs"];
}
- (NSDictionary *)mailContentDataDic {
    if (_mailContentDataDic == nil) {
        _mailContentDataDic = [NSDictionary dictionary];
    }return _mailContentDataDic[@"data"];
}
-(NSDictionary *)mailListData {
    if (_mailListData == nil) {
        _mailListData = [NSDictionary dictionary];
    }return _mailListData[@"data"];
}
-(NSArray *)mailListArray {
    NSMutableArray *muMailListArray = [NSMutableArray array];
//    for (int i = 1; i < 8; i ++) {
//        NSString *oneWeek = [NSString stringWithFormat:@"day%d",i];
//    
//        for (NSDictionary *weekMailArry in self.mailListData[oneWeek]) {
//            [muMailListArray addObject:weekMailArry];
//        }
//    }
//    for (NSDictionary *lastweek in self.mailListData[@"lastweek"]) {
//        [muMailListArray addObject:lastweek];
//    }
//    for (NSDictionary *earlier in self.mailListData[@"earlier"]) {
//        [muMailListArray addObject:earlier];
//    }
        for (int i = 1; i < 8; i ++) {
            NSString *oneWeek = [NSString stringWithFormat:@"day%d",i];
            [muMailListArray addObjectsFromArray:self.mailListData[oneWeek]];
        }
        [muMailListArray addObjectsFromArray:self.mailListData[@"lastweek"]];
        [muMailListArray addObjectsFromArray:self.mailListData[@"earlier"]];
    return muMailListArray;

}
singleton_implementation(JHMailDataModel)
@end
