//
//  UserableViewCell.h
//  MVC
//
//  Created by ByteDance on 2025/7/11.
//

#import <UIKit/UIKit.h>
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;

- (void)configureWithUser:(User *)user;

@end

NS_ASSUME_NONNULL_END
