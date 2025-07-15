//
//  AdModel.m
//  BookListApp
//
//  Created by ByteDance on 2025/7/14.
//

#import "AdModel.h"

@implementation AdModel

#pragma mark - 便利构造
+ (instancetype)adWithDictionary:(NSDictionary *)dict{
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]){
        NSLog(@"adModel : 传入的字典类型为空或者类型错误");
        return nil;
    }
    AdModel *ad = [[AdModel alloc] init];
    
    return ad;
}

+ (NSString *)safeStringFromDict:(NSDictionary *)dict key:(NSString *)key{
    if(!dict || !key){
        return @"";
    }
    id value = dict[key];
    if([value isKindOfClass:[NSString class]]) return value;
    else if([value isKindOfClass:[NSNumber class]]) return [value stringValue];
    else if([value isKindOfClass:[NSNull class]] || value == nil) return @"";
    else{
        NSLog(@"AdModel : 意外的数据类型 %@", NSStringFromClass([value class]));
        return [value description]?:@"";
    }
}

#pragma mark - 数值转换
- (CGFloat)appRatingValue{
    if(!self.appLike || self.appLike.length == 0) return 0.0;
    return [self.appLike floatValue];
}

- (NSInteger)installCountValue{
    if(!self.appInstall || self.appInstall.length == 0) return 0;
    return [self.appInstall integerValue];
}

#pragma mark - 实用方法
- (NSString *)formattedRating{
    if(!self.appLike || self.appLike.length == 0) return @"暂无评分";
    if([self.appLike containsString:@"分"]) return self.appLike;
    return [NSString stringWithFormat:@"%@分",self.appLike];
}

- (NSString *)formattedInstallCount{
    if(!self.appInstall || self.appInstall.length == 0) return @"暂无数据";
    return [NSString stringWithFormat:@"下载数为 %@",self.appInstall];
}

- (BOOL)isVaildAD{
    BOOL hasTitle = (self.title && self.title.length > 0);
    BOOL hasAppID = (self.appId && self.appId.length > 0);
    BOOL hasButtonText = (self.buttonText && self.buttonText.length > 0);
    BOOL hasDownloadUrl = (self.downloadUrl && self.downloadUrl.length > 0);
    return (hasTitle && hasAppID && hasButtonText && hasDownloadUrl);
 }

- (BOOL)isVaildImageUrl{
    return (self.imageUrl && self.imageUrl.length > 0 && (
                                                          [self.imageUrl hasPrefix:@"http://"] || [self.imageUrl hasPrefix:@"https://"]
                                                          ));
}

#pragma mark - 重写NSobject方法
- (NSString *)description{
    return [NSString stringWithFormat:@"<%@: %p>\n%@",
            NSStringFromClass([self class]), self, [self description]];
}

//- (id)copyWithZone:(NSZone *)zone {
//    AdModel *copy = [[AdModel alloc] init];
//    copy.title = [self.title copy];
//    copy.subTitle = [self.subTitle copy];
//    copy.adDescription = [self.adDescription copy];
//    copy.buttonText = [self.buttonText copy];
//    copy.downloadUrl = [self.downloadUrl copy];
//    copy.imageUrl = [self.imageUrl copy];
//    copy.webTitle = [self.webTitle copy];
//    copy.appInstall = [self.appInstall copy];
//    copy.appLike = [self.appLike copy];
//    copy.appId = [self.appId copy];
//    copy.packageName = [self.packageName copy];
//    return copy;
//}

@end
