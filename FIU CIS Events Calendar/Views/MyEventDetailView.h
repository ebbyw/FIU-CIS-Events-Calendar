//
//  MyEventDetailView.h
//  FIU CIS Events Calendar
//
//  Created by Ebby Wahman on 4/14/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventDetailView;


@interface MyEventDetailView : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>{
    EventDetailView *eventDetailView;
    UIViewController *notesVieController;
    UIView *firstView;
    UIView *notesView;
    __weak IBOutlet UIImageView *eventImage;
    __weak IBOutlet UITextView *notesField;
}

-(id) initWithDetailView:(EventDetailView *) detailView;

@end
