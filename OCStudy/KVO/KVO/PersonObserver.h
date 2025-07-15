//
//  PersonObserver.h
//  KVO
//
//  Created by ByteDance on 2025/7/10.
//

#import <Foundation/Foundation.h>
#import "Person.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersonObserver : NSObject
@property(nonatomic, strong)Person *person;

- (instancetype)initWithPerosn:(Person *)person;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
@end

NS_ASSUME_NONNULL_END
