//
//  MyEventDetailView.m
//  FIU CIS Events Calendar
//
//  Created by Ebby Wahman on 4/14/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "MyEventDetailView.h"
#import "EventDetailView.h"

@interface MyEventDetailView ()

@end

@implementation MyEventDetailView


-(id) initWithDetailView:(EventDetailView *) detailView {
    self = [super init];
    if(self){
        [[self navigationItem] setTitle:@"My Event Details"];
        eventDetailView = detailView;
        notesVieController = [[UIViewController alloc] initWithNibName:@"MyEventDetailViewNotes" bundle:nil];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if(viewController == notesVieController){
        return eventDetailView;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if(viewController == eventDetailView){
        return notesVieController;
    }
    
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
