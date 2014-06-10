//
//  EventCell.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 6/2/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellSpeakerPhoto;
@property (weak, nonatomic) IBOutlet UILabel *cellDayValue;
@property (weak, nonatomic) IBOutlet UILabel *cellMonth;
@property (weak, nonatomic) IBOutlet UILabel *cellSpeakerName;
@property (weak, nonatomic) IBOutlet UILabel *cellEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellEventType;
@property (weak, nonatomic) IBOutlet UILabel *cellYear;

@end
