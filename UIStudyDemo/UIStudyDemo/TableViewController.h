//
//  TableViewController.h
//  UIStudyDemo
//
//  Created by ByteDance on 2025/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableview;
@property(nonatomic, strong) NSArray *dataSource;

@end

NS_ASSUME_NONNULL_END
