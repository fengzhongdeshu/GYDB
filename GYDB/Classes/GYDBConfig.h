//
//  GYDBConfig.h
//  FBSnapshotTestCase
//
//  Created by liuguoyan on 2019/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDBConfig : NSObject

@property (nonatomic,assign) BOOL debug ;

@property (nonatomic,copy) NSString *dbName;

@end

NS_ASSUME_NONNULL_END
