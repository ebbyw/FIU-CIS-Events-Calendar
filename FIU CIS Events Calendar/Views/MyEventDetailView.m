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
        eventDetailView = detailView;
    }
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    firstView = eventDetailView.view;
    firstView.bounds = self.view.frame;
    
    notesView = [[UIView alloc] initWithFrame:self.view.frame];
    
    CGRect thisFrame = self.view.frame;
    NSLog(@"Frame Origin is: %f %f", thisFrame.origin.x, thisFrame.origin.y);
    
    CGRect scrollViewFrame = thisFrame;
    
    scrollViewFrame.size = CGSizeMake(2*thisFrame.size.width,
                                       thisFrame.size.height);
    
    scrollView = [[UIScrollView alloc] initWithFrame: thisFrame];
    
    scrollView.contentSize = scrollViewFrame.size ;
    scrollView.showsHorizontalScrollIndicator = YES;
    [scrollView setPagingEnabled:YES];
    [scrollView addSubview:firstView];
    [scrollView addSubview:notesView];
    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
