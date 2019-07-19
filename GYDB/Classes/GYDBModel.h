//
//  GYDBModel.h
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/12.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDBModel : NSObject

@property (nonatomic,assign) NSUInteger m_id ;

@property (nonatomic,copy) NSString *model;

@property (nonatomic,copy) NSString *colume;

@property (nonatomic,assign) NSUInteger bus_id ;

@property (nonatomic,copy) NSString *value;

/**
   搜索时的条件，如 < ,> ,= 等，默认是 =
 */
@property (nonatomic,copy) NSString *condition;

/**
  逻辑运算符   or , and
 */
@property (nonatomic,copy) NSString *logic;


+(instancetype)modelWithModel:(NSString *)model colume:(NSString *)colume value:(NSString *)value ;


@end

NS_ASSUME_NONNULL_END
