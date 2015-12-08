//
//  EscalatedStudentTableViewCell.h
//  OHAdmin
//
//  Created by Vincent Do on 12/1/15.
//  Copyright © 2015 Vincent Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EscalatedStudentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;

@end
