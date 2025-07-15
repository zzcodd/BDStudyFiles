//
//  Protocols.h
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/3.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class ByteDancer;

// 保密协议
@protocol ConfidentialityAgreementProtocol <NSObject>
-(void)signConfidentialityAgreement;
-(BOOL)hasSignedAgreement;
@end

// 社保代理协议
@protocol SocialSecurityDelegate <NSObject>
- (void)paySocialSecurityForEmployee:(ByteDancer*)employee;
@end

// 工作流程回调Block
typedef void(^TaskCompletionBlock)(BOOL success, NSString *message);

NS_ASSUME_NONNULL_END
