//
//  SplashViewController.h
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController{
    
    //View Related Properties
    IBOutlet UILabel *loadingLabel;
    IBOutlet UIProgressView *loadingProgressBar;
    
    //Data Acquring Related Properties
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSMutableArray *jsonReceivedData;
    
}

@property (nonatomic) float progressValue;
-(void) incrementProgressBar: (float) increment;

-(void) fetchEvents;

@end
