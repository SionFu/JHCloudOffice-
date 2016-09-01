//
//  JHDocModel.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/8/29.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHDocModel.h"

@implementation JHDocModel
-(NSDictionary *)docData {
    if (_docData == nil) {
        _docData = [NSDictionary dictionary];
    }return _docData;
}
-(NSArray *)firDicArray {
    if (_firDicArray == nil) {
        _firDicArray = self.docData[@"data"];
    }return _firDicArray;
}
singleton_implementation(JHDocModel)
@end
