//
//  SplashViewController.m
//  FIU CIS Events Calendar
//
//  Created by Ebtissam Wahman on 4/11/14.
//  Copyright (c) 2014 Ebby Wahman. All rights reserved.
//

#import "SplashViewController.h"
#import "EventsView.h"
#import "Events.h"
#import "AppDelegate.h"

#define kJSONKey  "Th@nkY0uJ05H"

@interface SplashViewController ()

@end

@implementation SplashViewController

@synthesize progressValue;

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
    // Do any additional setup after loading the view from its nib.
    [self fetchEvents];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Retrieve Events Data from FIU Servers

-(void) fetchEvents{
    progressValue = 0;
    [loadingProgressBar setProgress: progressValue animated:YES];
    jsonData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:
                  @"http://www.cis.fiu.edu/datarepo/?key="
                  @kJSONKey];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
    progressValue += 0.8f;
    [loadingProgressBar setProgress: progressValue animated:YES];
}

-(void) connection: (NSURLConnection *) conn didReceiveData:(NSData *)data{
    [jsonData appendData:data];
}

-(void) connectionDidFinishLoading: (NSURLConnection *) conn{
    //    NSString *jsonCheck = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSLog(@"JSON Check = %@",jsonCheck);
    NSError *error;
    jsonReceivedData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
    if(error){
        NSLog(@"Error occured %@",[error localizedDescription]);
    }else{
        
        //check if dictionary exists
        if(jsonReceivedData){
//            progressValue += 0.2f;
//            [loadingProgressBar setProgress: progressValue animated:YES];
            //Display what values we have
            for(NSDictionary* dict in jsonReceivedData){
                NSLog(@"%@",[dict allKeys]);
                break;
            }
            
            Events *eventsData = [Events defaultEvents];
            
            //Send the JSON Object to Our Events Class
            [eventsData setJsonObject: [NSArray arrayWithArray: jsonReceivedData]];
            [eventsData setSplashView:self];
            [eventsData loadEventsList];
            
            //release these variables, we don't need them anymore
            jsonReceivedData = nil;
            jsonData = nil;
            connection = nil;
            
//            [loadingProgressBar setProgress: 1.0f animated:YES];
            [self callNextView];
        }
    }
}

-(void) incrementProgressBar: (float) increment{
    progressValue += increment;
    [loadingProgressBar setProgress: progressValue animated:NO];
}

-(void) connection: (NSURLConnection *) conn didFailWithError:(NSError *)error{
    connection = nil;
    jsonData = nil;
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
                             [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                 message:errorString
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
}



-(void) callNextView{
    [loadingProgressBar setProgress: 1 animated:YES];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] callMainAppView];
}

@end
