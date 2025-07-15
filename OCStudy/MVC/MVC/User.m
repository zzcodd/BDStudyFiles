//
//  User.m
//  MVC
//
//  Created by ByteDance on 2025/7/11.
//

#import "User.h"

@implementation User

- (instancetype)initWithName:(NSString *)name email:(NSString *)email age:(NSInteger)age{
    self = [super init];
    if(self){
        _name = name;
        _email = email;
        _age = age;
    }
    return self;
}

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.email];
}

- (NSDictionary *)toDictionary{
    return @{
        @"userID " : _userID,
        @"name " : _name,
        @"age " : @(_age),
        @"eamil " : _email,
    };
}

- (NSString *)description{
    return [NSString stringWithFormat:@"User: %@ (%@), Age:%ld",self.name,self.email,self.age];
}

@end
