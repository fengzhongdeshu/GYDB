//
//  GYUser.h
//  ReserveStock
//
//  Created by liuguoyan on 2019/7/16.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYUser : NSObject

@property (nonatomic,assign) int _id ;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *hoppy;

@property (nonatomic,assign) int age ;

@property (nonatomic,assign) int score ;

@end

NS_ASSUME_NONNULL_END
