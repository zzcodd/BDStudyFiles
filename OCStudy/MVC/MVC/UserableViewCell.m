//
//  UserableViewCell.m
//  MVC
//
//  Created by ByteDance on 2025/7/11.
//

#import "UserableViewCell.h"

@implementation UserableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithUser:(User *)user {
    self.nameLabel.text = user.name;
    self.emailLabel.text = user.email;
    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁", (long)user.age];
}

@end
