//
//  AppDelegate.m
//  FIU CIS Events Calendar
//
//The MIT License (MIT)
//
//Copyright (c) 2014 Raul Carvajal, Eduardo Toledo, Ebtissam Wahman
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "EventsViewController.h"
#import "EventsView.h"
#import "MyEventsView.h"

#define kDarkBlueColor [UIColor colorWithRed:32/255.0f green:55/255.0f blue:106/255.0f alpha:1.0f]
#define kGoldColor [UIColor colorWithRed:203/255.0f green:183/255.0f blue:72/255.0f alpha:1.0f]


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    SplashViewController *splashScreen = [[SplashViewController alloc] init];
    [self.window setRootViewController:splashScreen];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIBarButtonItem appearance] setTintColor:kGoldColor];
    [[UINavigationBar appearance] setTintColor:kDarkBlueColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self saveContext];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Application Terminating");
    [self saveContext];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) callMainAppView{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AppStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    [self.window setRootViewController:vc];
}

//-(void) callMainAppView{
//    EventsView *eventsView = [[EventsView alloc] init];
//    MyEventsView *myEventsView = [[MyEventsView alloc] init];
//    
//    
//    UINavigationController *eventsNavigation = [[UINavigationController alloc]initWithRootViewController:eventsView];
//    
//    UINavigationController *myEventsNavigation = [[UINavigationController alloc]initWithRootViewController:myEventsView];
//
//    UITabBarController *mainTabsController = [[UITabBarController alloc] init];
//    
//    NSArray *viewControllers = [NSArray arrayWithObjects:eventsNavigation,myEventsNavigation,nil];
//    
//    [mainTabsController setViewControllers:viewControllers];
//    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
//        
//        UIViewController *mainView = [[UIViewController alloc] init];
//        [mainView.view setBackgroundColor:[UIColor colorWithRed:20.0/255.0
//                                                          green:38.0/255.0
//                                                           blue:74.0/255.0
//                                                          alpha:255]];
//        
//        UIImageView *fiuLogo = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"FIUCISLogo"]];
//        
//        CGPoint center = CGPointMake((mainView.view.bounds.size.width/2),
//                                     (mainView.view.bounds.size.height/2) - fiuLogo.frame.size.height);
//        
//        [fiuLogo setCenter:center];
//        
//        [mainView.view addSubview:fiuLogo];
//        
//        
//        splitViewController.viewControllers = [NSArray arrayWithObjects:mainTabsController, mainView, nil];
//        
//        [self.window setRootViewController:splitViewController];
//    }else{
//        [self.window setRootViewController:mainTabsController];
//    }
//    
//}


#pragma mark - Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [managedObjectContext setUndoManager:nil];
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        NSLog(@"Making a Context");
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EventsModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSLog(@"Making a Model");

    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"eventsData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
