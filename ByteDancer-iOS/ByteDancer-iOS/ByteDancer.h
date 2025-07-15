//
//  ByteDancer.h
//  ByteDancer-iOS
//
//  Created by ByteDance on 2025/7/3.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,Gender){
    GenderMale = 0,
    GenderFemale,
};

@interface Task : NSObject
@property(nonatomic, copy) NSString* workDescription;
@property(nonatomic, copy) NSString* taskID;
@property(nonatomic, assign) BOOL isCompleted;

-(instancetype)initWithDescription:(NSString*)description taskID:(NSString*)taskID;
@end


@interface ByteDancer : NSObject<ConfidentialityAgreementProtocol>

@property(nonatomic, assign) Gender gender;
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, copy) NSString* name;
@property(nonatomic, strong) NSMutableString* impression;
@property(nonatomic, copy) NSString* department;
@property(nonatomic, copy) NSArray* perviousCompanies;
@property(nonatomic, strong) NSMutableArray* skills;
@property(nonatomic, strong) NSMutableDictionary* extraInfo;

@property(nonatomic, weak) id<SocialSecurityDelegate> socialSecurityDelegate;
@property(nonatomic, assign) BOOL hasSignedConfidentialityAgreement;

-(void)work;
-(NSString*)stringFromGender;

@end

NS_ASSUME_NONNULL_END
