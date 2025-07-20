//
//  AdViewController.h
//  BookListApp
//
//  Created by ByteDance on 2025/7/15.
//

#import <UIKit/UIKit.h>
#import "../../Models/BookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdViewController : UIViewController

// 公开方法，用于传递书籍信息
- (void)loadAdWithBookInfo:(BookModel *)book;

@end

NS_ASSUME_NONNULL_END
