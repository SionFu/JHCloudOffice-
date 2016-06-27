//
//  JHModules.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/6/24.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHModules.h"

@implementation JHModules
-(NSString *)description{
  return   [NSString stringWithFormat: @"%@====%@",self.ModuleType,self.Category];
}
@end
