//
//  GYDBOprator.h
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/16.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDBOprator : NSObject

@property (nonatomic,assign) Class clazz;

+(instancetype)opratorWithModel:(Class)clazz ; 

+(instancetype)oprator;

-(instancetype)initModel:(Class)clazz ;

/**
 条件组装器
 @param colume 字段名
 @param comp 比较符号:< , > = 等
 @param value 比较的值
 @return instance
 */
-(instancetype)whereColume:(NSString *)colume compare:(NSString *)comp value:(NSString *)value ;

-(instancetype)andWhereColume:(NSString *)colume compare:(NSString *)comp value:(NSString *)value ;

-(instancetype)orWhereColume:(NSString *)colume compare:(NSString *)comp value:(NSString *)value ;

/**
 更新容器，用于存放更新的字段的值
 @param colume 要更新的字段
 @param value 字段值
 @return return value description
 */
-(instancetype)updateColume:(NSString *)colume toValue:(NSString *)value ;


/**
 添加要保存的model
 @param model model description
 @return return value description
 */
-(instancetype)addSaveModel:(id)model ;


/**
 批量添加要保存的model
 @param models models description
 @return return value description
 */
-(instancetype)addSaveModelArray:(NSArray<id>*)models ;


/**
 查询
 @return result
 */
-(NSArray*)query ;

/**
 删除
 @return result
 */
-(BOOL)remove ;

/**
 更新
 @return return value description
 */
-(BOOL)update ;

/**
 保存
 @return return 返回存储失败的model , 返回nil 表示全部存储成功
 */
-(NSArray*)save ;




@end

NS_ASSUME_NONNULL_END
