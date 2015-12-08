//
//  QueueTableViewCell.h
//  OHAdmin
//
//  Created by Vincent Do on 11/29/15.
//  Copyright © 2015 Vincent Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueueTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *studentCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *staffCountLabel;
@property (strong, nonatomic) IBOutlet UISwitch *loggedIn;

@end
