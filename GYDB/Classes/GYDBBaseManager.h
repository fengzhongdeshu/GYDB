//
//  GYDBBaseManager.h
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/12.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "GYDBModel.h"

#ifndef GYDB_DATABASE_NAME

#define GYDB_DATABASE_NAME @"gydb.db"

#define GYDB_DEBUG 1
#define GYDB_Log(info) if(GYDB_DEBUG) NSLog(info);
#define GYDB_LogObj(info) if(GYDB_DEBUG) NSLog(@"%@",info);

#endif

NS_ASSUME_NONNULL_BEGIN

@interface GYDBBaseManager : NSObject
{
    FMDatabaseQueue *_queue ;
}

+(id)shareInstance ; 


/**
 记录总数
 @param model_name 即表名
 @return 数量
 */
-(int)countForModel:(NSString *)model_name ;

/**
 添加记录
 @param models 要添加的字段
 @return 是否添加成功
 */
-(BOOL)insertContent:(NSArray<GYDBModel *> *)models ;

/**
 通过id获取记录
 @param modelStr model
 @param bus_id bus_id description
 @return return value description
 */
-(NSArray<GYDBModel *> *)getContentWithId:(NSString *)modelStr busId:(NSUInteger *)bus_id ;

/**
 查询记录
 @param models 字段列表:字段值等于此列表中的字段值
 @return 实体对象
 */
-(NSArray<GYDBModel *> *)getContentWithFiledsEnques:(NSArray<GYDBModel *> *)models;

/**
 查询某个model的所有记录
 @param modelStr model名称
 @return 所有记录
 */
-(NSArray<GYDBModel *> *)getAllWithModelString:(NSString *)modelStr ;

/**
 删除
 @param models 条件
 @return return value description
 */
-(BOOL)removeContentWithFiledsEques:(NSArray<GYDBModel *>*)models ;

/**
 删除所有
 @param modelStr modelStr description
 @return return value description
 */
-(BOOL)removeAllWithModelString:(NSString *)modelStr ;


/**
 更新model
 @param files 要更新的字段
 @param models 条件
 @return return value description
 */
-(BOOL)update:(NSArray<GYDBModel*>*)files withFiledsEques:(NSArray<GYDBModel *>*)models ;


@end

NS_ASSUME_NONNULL_END
