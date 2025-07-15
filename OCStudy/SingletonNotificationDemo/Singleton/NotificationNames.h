//
//  NotificationNames.h
//  Singleton
//
//  Created by ByteDance on 2025/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationNames : NSObject

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;
extern NSString *const DataDidUpdateNotification;

@end

NS_ASSUME_NONNULL_END
