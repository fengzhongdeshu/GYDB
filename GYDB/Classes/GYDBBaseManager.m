//
//  GYDBBaseManager.m
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/12.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import "GYDBBaseManager.h"

@implementation GYDBBaseManager


+(id)allocWithZone:(struct _NSZone *)zone
{
    static GYDBBaseManager *instance ;
    
    static dispatch_once_t onceToken ;
    
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance ;
}


+(id)shareInstance
{
    return [[self alloc]init] ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* dbPath = [[self class] getDBPathWithinDocumentDir:GYDB_DATABASE_NAME];
        // NSLog(@"%@",dbPath);
        //创建文件管理器
        NSFileManager* fileManager = [NSFileManager defaultManager];
        //判断文件是否存在
        BOOL existFile = [fileManager fileExistsAtPath:dbPath];
        if (existFile == NO) {
            NSString* poemDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:GYDB_DATABASE_NAME];
            [fileManager copyItemAtPath:poemDBPath toPath:dbPath error:nil];
        }
        _queue =  [FMDatabaseQueue databaseQueueWithPath:dbPath];
        
        //文件不存在，说明表也不存在，新建表
        if (existFile == NO) {
            [self createContentTable] ;
        }
    }
    return self;
}

- (BOOL)createContentTable
{
    BOOL __block success = NO ;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            success = [db executeUpdate:@"CREATE TABLE CONTENTTABLE ( m_id integer PRIMARY KEY AUTOINCREMENT , model TEXT, colume TEXT, bus_id integer, value TEXT );"];
        }
        [db close] ;
    }] ;
    return success;
}

/**
 记录总数
 @param model_name 即表名
 @return 数量
 */
-(int)countForModel:(NSString *)model_name
{
    NSString *sqlStr=[NSString stringWithFormat:@"select count(*) as tot from ( select bus_id from CONTENTTABLE WHERE model = '%@' GROUP BY bus_id  ) ",  model_name];
    
    int __block max = 0 ;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet* rs = [db executeQuery:sqlStr];
        
        if ([rs next]) {
            max = [rs intForColumn:@"tot"] ;
        }
        [rs close] ;
    }] ;
    
    return max ;
}

/**
 添加记录
 @param models 要添加的字段
 @return 是否添加成功
 */
-(BOOL)insertContent:(NSArray<GYDBModel *> *)models
{
    
    int bus_id = [self queryMaxBusId:models[0].model]+1;
    
    BOOL __block success = YES ;
    
    [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        for (int i = 0 ; i<models.count; i++) {
            
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO CONTENTTABLE (model,colume,bus_id,value) VALUES ('%@','%@',%d,'%@')",models[i].model ,models[i].colume ,bus_id , models[i].value] ;
            
            BOOL suc = [db executeUpdate:sql];
            
            if (!suc) {
                success = NO ;
                [db rollback] ;
                break ;
            }
        }
    }] ;
    
    return success ;
}


/**
 通过id获取记录
 @param modelStr model
 @param bus_id bus_id description
 @return return value description
 */
-(NSArray<GYDBModel *> *)getContentWithId:(NSString *)modelStr busId:(NSUInteger *)bus_id
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CONTENTTABLE WHERE model = '%@' AND bus_id = %tu ",modelStr , bus_id];
    
    return [self getModelsByQuerySQL:sql] ;
}

/**
 查询记录
 @param models 字段列表:字段值等于此列表中的字段值,如我们要查name=李四 只需要写一个model即可
 @return 实体对象
 */
-(NSArray<GYDBModel *> *)getContentWithFiledsEnques:(NSArray<GYDBModel *> *)models
{
    
    if (models.count==0) {
        GYDB_Log(@"param models can not be empty!!!");
        return nil ;
    }
    
    NSString *sql = @"SELECT * FROM CONTENTTABLE WHERE bus_id IN ( %@ ) ORDER BY bus_id ASC " ;
    NSString *condition = [self getConditionsIds:models];
    
    sql = [NSString stringWithFormat:sql , condition] ;
    
    return [self getModelsByQuerySQL:sql] ;
}



/**
 查询某个model的所有记录
 @param modelStr model名称
 @return 所有记录
 */
-(NSArray<GYDBModel *> *)getAllWithModelString:(NSString *)modelStr
{
    
    NSString *sql = [NSString stringWithFormat:@"select * from CONTENTTABLE WHERE model = '%@' ORDER BY bus_id ASC",modelStr] ;
    
    return [self getModelsByQuerySQL:sql] ;
}

/**
 删除
 @param models 条件
 @return return value description
 */
-(BOOL)removeContentWithFiledsEques:(NSArray<GYDBModel *>*)models
{
    if (models.count==0) {
        GYDB_Log(@"param models can not be empty!!!");
        return NO ;
    }
    
    NSString *sql = [NSMutableString stringWithString:@"DELETE FROM CONTENTTABLE WHERE bus_id IN ( %@ ) "] ;
    NSString *condition = [self getConditionsIds:models];
    
    sql = [NSString stringWithFormat:sql , condition] ;
    
    return [self executeUpdate:sql] ;
}

/**
 删除所有
 @param modelStr modelStr description
 @return return value description
 */
-(BOOL)removeAllWithModelString:(NSString *)modelStr
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM CONTENTTABLE WHERE model = '%@' " , modelStr];
    return [self executeUpdate:sql] ;
}

/**
 更新model
 @param files 要更新的字段
 @param models 条件
 @return return value description
 */
-(BOOL)update:(NSArray<GYDBModel*>*)files withFiledsEques:(NSArray<GYDBModel *>*)models
{
    
    NSArray<GYDBModel*>* findModels = [self getContentWithFiledsEnques:models] ;
    
    //没找到更新项
    if (!findModels) {
        return YES ;
    }
    
    BOOL __block success = YES ;
    
    [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        for (int i = 0; i<files.count; i++) {
            for (int j =0 ; j<findModels.count; j++) {
                if ([files[i].colume isEqualToString:findModels[j].colume]) {
                    NSString *sql  =[NSString stringWithFormat:@"UPDATE CONTENTTABLE SET value = '%@' WHERE m_id = %tu ",files[i].value , findModels[j].m_id] ;
                    BOOL b = [db executeUpdate:sql] ;
                    
                    if (!b || [db hadError]) {
                        success = NO ;
                        [db rollback] ;
                        NSString *err = [NSString stringWithFormat:@"execute sql error -> %@" , sql] ;
                        GYDB_LogObj(err) ;
                        break ;
                    }
                }
            }
            if (!success) {
                break;
            }
        }
    }] ;
    return success ;
}


#pragma mark --------------- 查询工具类 ---------------

/**
 通过models 获取符合条件的bus_id
 @param models models description
 @return return value description
 */
-(NSString *)getConditionsIds:(NSArray<GYDBModel *>*)models
{
    NSMutableString *condition = [NSMutableString string] ;
    
    for (int i = 0 ; i<models.count; i++) {
        
        NSString *com = models[i].condition ? models[i].condition : @"=" ;
        NSString *valueWrapper = [[self.class lowerTrimString:models[i].condition] isEqualToString:@"like"] ? @"%%%@%%" :@"%@" ;
        
        if (models[i].logic) {
            NSString * combine = [models[i].logic isEqualToString:@"AND"] ? @" INTERSECT " :
            ([models[i].logic isEqualToString:@"OR"] ? @" UNION " : @"") ;
            [condition appendString:combine] ;
        }
        
        NSString * con = [NSString stringWithFormat:@" SELECT bus_id FROM CONTENTTABLE WHERE model = '%@' AND colume ='%@' AND value %@ '%@' " , models[i].model , models[i].colume ,com ,  [NSString stringWithFormat:valueWrapper , models[i].value]] ;
        
        [condition appendString:con] ;
        
    }
    return condition ;
}


-(BOOL) executeUpdate:(NSString *)sql
{
    
    GYDB_LogObj(sql) ;
    
    BOOL __block suc = NO ;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL ret =  [db executeUpdate:sql] ;
        if (ret && ![db hadError]) {
            suc = YES ;
        }
    }] ;
    
    return suc ;
    
}

/**
 查询
 @param sql sql
 @return return value
 */
-(NSArray<GYDBModel *> *)getModelsByQuerySQL:(NSString *)sql
{
    
    GYDB_LogObj(sql) ;
    NSMutableArray* result = [[NSMutableArray alloc] init];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet* rs = [db executeQuery:sql];
        
        while ([rs next]) {
            GYDBModel *model = [[GYDBModel alloc]init] ;
            model.m_id = [rs intForColumn:@"m_id"];
            model.model = [rs stringForColumn:@"model"];
            model.colume = [rs stringForColumn:@"colume"];
            model.bus_id = [rs intForColumn:@"bus_id"];
            model.value = [rs stringForColumn:@"value"];
            [result addObject:model] ;
        }
        [rs close];
    }] ;
    return result ;
    
}

/** 查询最大的id号，用于插入记录之前使用
 * @model model名，类似于平表中的表名
 * @return 最大的行号  ，默认0
 */
-(int)queryMaxBusId:(NSString *)model_name
{
    int __block max = -1 ;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr=[NSString stringWithFormat:@"SELECT  bus_id  FROM CONTENTTABLE WHERE model = '%@' ORDER BY bus_id DESC LIMIT 1 ",  model_name];
        FMResultSet* rs = [db executeQuery:sqlStr];
        if ([rs next]) {
            max = [rs intForColumn:@"bus_id"] ;
        }
        [rs close] ;
    }] ;
    return max ;
}

#pragma mark --------------- 无关数据库工具类 ---------------

/**
 去除前后空格 , 并且全都转为小写
 @param str str
 @return str
 */
+(NSString*)lowerTrimString:(NSString *)str
{
    NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    str = [str stringByTrimmingCharactersInSet:set];
    return str ;
}

+ (NSString*)getDBPathWithinDocumentDir:(NSString*)aPath
{
    
    NSString* fullPath = nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0) {
        fullPath = (NSString*)[paths objectAtIndex:0];
        if ([aPath length] > 0) {
            fullPath = [fullPath stringByAppendingPathComponent:aPath];
        }
    }
    return fullPath;
}

@end
