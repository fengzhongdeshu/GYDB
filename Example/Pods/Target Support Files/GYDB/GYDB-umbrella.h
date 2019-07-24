#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GYDBBaseManager.h"
#import "GYDBConfig.h"
#import "GYDBModel.h"
#import "GYDBOprator.h"

FOUNDATION_EXPORT double GYDBVersionNumber;
FOUNDATION_EXPORT const unsigned char GYDBVersionString[];

