//
//  GYDBModel.m
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/12.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import "GYDBModel.h"

@implementation GYDBModel

+(instancetype)modelWithModel:(NSString *)model colume:(NSString *)colume value:(NSString *)value
{
    GYDBModel *m = [[GYDBModel alloc]init];
    m.model = model ;
    m.colume = colume ;
    m.value = value ;
    return m ;
}

@end
