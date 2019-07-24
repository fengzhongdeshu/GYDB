//
//  GYDBConfig.m
//  FBSnapshotTestCase
//
//  Created by liuguoyan on 2019/7/24.
//

#import "GYDBConfig.h"

@implementation GYDBConfig

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static GYDBConfig *instance ;
    
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance ;
}

+(instancetype)shareInstance
{
    return [[self alloc]init] ;
}

-(BOOL)debug
{
    return _debug ;
}

-(NSString *)dbName
{
    return _dbName ? _dbName : @"gydb.db";
}

@end
