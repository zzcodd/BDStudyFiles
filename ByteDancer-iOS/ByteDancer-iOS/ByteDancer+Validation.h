//
//  ByteDancer+Validation.h
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/4.
//

#import <Foundation/Foundation.h>
#import "ByteDancer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ByteDancer (Validation)
- (BOOL) isQualifiedByteDancer;
- (NSString *) getQualificationReport;
@end

NS_ASSUME_NONNULL_END
