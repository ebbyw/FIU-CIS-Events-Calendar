//
//  EventCellTableViewCell.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/12/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellEventDate;
@property (weak, nonatomic) IBOutlet UIImageView *cellEventPhoto;

@end
