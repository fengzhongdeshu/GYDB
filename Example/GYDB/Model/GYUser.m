//
//  GYUser.m
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/16.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import "GYUser.h"

@implementation GYUser

-(NSString *)description
{
    NSString * str = [NSString stringWithFormat:@"id[%tu],name[%@],hobby[%@],age[%d],score[%d]" , self._id , self.name , self.hoppy , self.age,self.score];
    
    return str ;
}

@end
