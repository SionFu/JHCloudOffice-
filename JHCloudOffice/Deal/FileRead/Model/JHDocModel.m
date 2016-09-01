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
    return self.allDataArray.lastObject;
}
-(NSArray *)firDicArray {
     return   self.docData[@"data"];
}
- (NSArray *)thiDicArray {
      return  self.docData[@"data"];
}
- (NSMutableArray *)allDataArray {
    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }return _allDataArray;
}
-(void)removeLasterDocArray {
    [self.allDataArray removeLastObject];
}
singleton_implementation(JHDocModel)
@end
