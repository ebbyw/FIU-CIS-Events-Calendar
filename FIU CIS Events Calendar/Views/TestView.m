//
//  TestView.m
//  FIU CIS Events Calendar
//
//  Created by ebtissam ahmed wahman on 4/13/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "TestView.h"

@interface TestView ()

@end

@implementation TestView

-(id) initWithEvent: (Event *) theEvent{
    
    self = [self initWithNibName:@"TestView" bundle:nil];
    
    if(self){
        currentEvent = theEvent;
        [[self navigationItem] setTitle:[currentEvent eventType]];
            }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageWithData:[[currentEvent speaker] photo]];
    [theImage setImage:image];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
