//
//  RightPaneTextDisplayViewController.h
//  FIU CIS Events Calendar
//
//  Created by Ebby Wahman on 6/3/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightPaneTextDisplayViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *textViewField;
-(void) receiveTextForField: (NSString *) incomingText;
- (IBAction)goBack:(id)sender;
@end
