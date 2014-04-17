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
    self = [self initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:nil];
    if(self){
        [[self navigationItem] setTitle:@"My Event Details"];
        eventDetailView = detailView;
        notesViewController = [[UIViewController alloc] init];
        [notesViewController.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        UIScrollView *textFieldScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];

        UITextField *textField = [[UITextField alloc] initWithFrame:
        CGRectMake(0,
                   0,
                   320,
                   320)];
        [textField setText:@""];
        [textField setBackgroundColor:[UIColor grayColor]];
        [textField.layer setCornerRadius:5.0f];
        [textField setDelegate:self];
        
        [textFieldScrollView addSubview:textField];
        [notesViewController.view  addSubview:textFieldScrollView];
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:eventDetailView, nil];
        [self setViewControllers: viewControllers
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:nil];
        
        [self setDelegate:self];
        [self setDataSource:self];

    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if(viewController == notesViewController){
        return eventDetailView;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if(viewController == eventDetailView){
        return notesViewController;
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
