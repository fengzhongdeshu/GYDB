//
//  GYDBOprator.m
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/16.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import "GYDBOprator.h"
#import "GYDBModel.h"
#import "GYDBBaseManager.h"
#import <objc/runtime.h>

@interface GYDBOprator()

/**
 条件
 */
@property (nonatomic,strong) NSMutableArray *wheres;

/**
 更新的models
 */
@property (nonatomic,strong) NSMutableArray *uppers;

/**
 要保存的model列表
 */
@property (nonatomic,strong) NSMutableArray *saveModels;

@end

@implementation GYDBOprator


+(instancetype)opratorWithModel:(Class)clazz
{
    GYDBOprator *op = [[GYDBOprator alloc]init] ;
    op.clazz = clazz ;
    [op resetEnviroment];
    return op ;
}

/**
 恢复运行环境
 */
-(void)resetEnviroment
{
    [self.wheres removeAllObjects] ;
    [self.uppers removeAllObjects] ;
    [self.saveModels removeAllObjects] ;
}


#pragma mark --------------- 执行方法前的准备方法 ---------------

/**
 条件组装器
 @param colume 字段名
 @param comp 比较符号:< , > = 等
 @param value 比较的值
 @return instance
 */
-(instancetype)whereColume:(NSString *)colume compare:(NSString *)comp value:(NSString *)value
{
    return [self commWhereColume:colume compare:comp value:value logic:nil] ;
}

-(instancetype)andWhereColume:(NSString *)colume compare:(NSString *)comp value:(NSString *)value
{
    return [self commWhereColume:colume compare:comp value:value logic:@"AND"] ;
}

-(instancetype)orWhereColume:(NSString *)colume compare:(NSString *)comp value:(NSString *)value
{
    return [self commWhereColume:colume compare:comp value:value logic:@"OR"] ;
}

-(instancetype)commWhereColume:(NSString *)colume compare:(NSString *)comp value:(NSString *)value logic:(NSString *)logic
{
    NSString *name = [self modelNameWithClass:self.clazz];
    GYDBModel *dbm = [GYDBModel modelWithModel:name colume:colume value:value] ;
    dbm.condition = comp ;
    dbm.logic = logic ;
    [self.wheres addObject:dbm] ;
    return self ;
}

/**
 更新容器，用于存放更新的字段的值
 @param colume 要更新的字段
 @param value 字段值
 @return return value description
 */
-(instancetype)updateColume:(NSString *)colume toValue:(NSString *)value
{
    NSString *name = [self modelNameWithClass:self.clazz];
    GYDBModel *dbm = [GYDBModel modelWithModel:name colume:colume value:value] ;
    [self.uppers addObject:dbm] ;
    
    return self ;
}

/**
 添加要保存的model
 @param model model description
 @return return value description
 */
-(instancetype)addSaveModel:(id)model
{
    [self.saveModels addObject:model] ;
    return self ;
}

/**
 批量添加要保存的model
 @param models models description
 @return return value description
 */
-(instancetype)addSaveModelArray:(NSArray<id>*)models
{
    [self.saveModels addObjectsFromArray:models] ;
    return self ;
}

#pragma mark --------------- 执行方法 ---------------

/**
 保存
 @return return 返回存储失败的model , 返回nil 表示全部存储成功
 */
-(NSArray*)save
{
    NSMutableArray *faileModel = [NSMutableArray array];
    if (self.saveModels && self.saveModels.count>0) {
        for (int i =0; i<self.saveModels.count; i++) {
            id model = self.saveModels[i] ;
            BOOL saveb = [self saveOneModel:model] ;
            if (!saveb) {
                [faileModel addObject:model] ;
            }
        }
    }
    [self resetEnviroment];
    return faileModel ;
}


/**
 查询
 @return result
 */
-(NSArray*)query
{
    
    NSArray<GYDBModel *>*models = nil ;
    if (self.wheres && self.wheres.count>0) {
        models = [[GYDBBaseManager shareInstance]getContentWithFiledsEnques:self.wheres] ;
    }else{
        models = [[GYDBBaseManager shareInstance]getAllWithModelString:[self modelNameWithClass:self.clazz]] ;
    }
    
    NSMutableArray *bizModels = [NSMutableArray array] ;
    
    NSUInteger bus_id = -1 ;
    id m = nil ;
    for (int i = 0; i<models.count; i++){
        GYDBModel *mod = models[i] ;
        if (bus_id != mod.bus_id) {
            m = [[self.clazz alloc]init] ;
            [bizModels addObject:m] ;
            bus_id = mod.bus_id ;
        }
        [m setValue:mod.value forKey:mod.colume] ;
    }
    [self resetEnviroment];
    return bizModels  ;
}

/**
 删除
 @return result
 */
-(BOOL)remove
{
    BOOL ret = NO ;
    if (self.wheres && self.wheres.count>0) {
        ret = [[GYDBBaseManager shareInstance] removeContentWithFiledsEques:self.wheres] ;
    }else{
        ret = [[GYDBBaseManager shareInstance] removeAllWithModelString:[self modelNameWithClass:self.clazz]] ;
    }
    [self resetEnviroment];
    return ret ;
}

/**
 更新
 @return return value description
 */
-(BOOL)update
{
    BOOL bol = [[GYDBBaseManager shareInstance]update:self.uppers withFiledsEques:self.wheres] ;
    [self resetEnviroment];
    return bol ;
    
}

#pragma mark --------------- 工具方法 ---------------

-(BOOL)saveOneModel:(id)model
{
    NSArray *array = [[self class]getAllPropertiesWithClass:[model class]] ;
    NSMutableArray<GYDBModel *>*models = [NSMutableArray array] ;
    
    for (int i = 0; i<array.count; i++) {
        NSString *key = array[i] ;
        NSString *value = [model valueForKey:key] ;
        value = value ? value : @"";
        NSLog(@"%@ -> %@" , array[i] , value);
        
        GYDBModel *m = [GYDBModel modelWithModel:[self modelName:model] colume:key value:value] ;
        [models addObject:m] ;
    }
    return [[GYDBBaseManager shareInstance]insertContent:models] ;
}


- (NSMutableArray *)saveModels
{
    if (!_saveModels) {
        _saveModels = [NSMutableArray array];
    }
    return _saveModels ;
}

-(NSMutableArray *)wheres
{
    if (!_wheres) {
        _wheres = [NSMutableArray array] ;
    }
    return _wheres ;
}

- (NSMutableArray *)uppers
{
    if (!_uppers) {
        _uppers = [NSMutableArray array] ;
    }
    return _uppers ;
}

-(NSString *)modelNameWithClass:(Class)clazz
{
    return NSStringFromClass(clazz) ;
}

- (NSString *)modelName:(NSObject *)model
{
    return [NSString stringWithUTF8String:object_getClassName(model)];
}

/**
 获取类中所有的属性
 @param clazz clazz
 @return properties array
 */
+ (NSArray *)getAllPropertiesWithClass:(Class)clazz
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(clazz, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

@end
