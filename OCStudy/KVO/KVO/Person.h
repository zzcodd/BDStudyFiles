//
//  Person.h
//  KVO
//
//  Created by ByteDance on 2025/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END
