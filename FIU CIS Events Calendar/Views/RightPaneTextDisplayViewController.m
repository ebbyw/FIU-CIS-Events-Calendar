//
//  RightPaneTextDisplayViewController.m
//  FIU CIS Events Calendar
//
//  Created by Ebby Wahman on 6/3/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "RightPaneTextDisplayViewController.h"

@interface RightPaneTextDisplayViewController (){
    NSString *textToDisplay;
}

@end

@implementation RightPaneTextDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textViewField setValue:textToDisplay forKey:@"contentToHTMLString"];
    self.textViewField.font = [UIFont systemFontOfSize:18];
    
    //    [self.textViewField setText:textToDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) receiveTextForField: (NSString *) incomingText{
    NSLog(@"Received String:\n%@",incomingText);
    textToDisplay = incomingText;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
