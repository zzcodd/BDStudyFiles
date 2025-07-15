//
//  Roles.h
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/3.
//

#import <Foundation/Foundation.h>
#import "ByteDancer.h"

NS_ASSUME_NONNULL_BEGIN

@interface PM : ByteDancer
@property(nonatomic, copy) NSString* productLine;
- (Task*)createProductTask:(NSString*)description;
@end


@interface RD : ByteDancer
@property(nonatomic, copy) NSString* programmingLanguage;
-(void)developTask:(Task*)task completion:(TaskCompletionBlock)completion;
-(void)mergeCode:(Task*)task;
@end


@interface QA : ByteDancer
@property (nonatomic, copy) NSArray *testingTools;  // 测试工具
-(void)testTask:(Task*)task completion:(TaskCompletionBlock)completion;
@end


@interface HR : ByteDancer<SocialSecurityDelegate>
@property (nonatomic, copy) NSDictionary *departmentResponsibilities;  // 部门及职责
- (void)arrangConfidentialityAgreementFor:(ByteDancer*)employee;
@end

NS_ASSUME_NONNULL_END
