//
//  AppDelegate.m
//  SmallTwitterClient
//
//  Created by Gorf on 10/3/14.
//  Copyright (c) 2014 Gorf. All rights reserved.
//

#import "AppDelegate.h"
#import "TimelineViewController.h"

@implementation AppDelegate

@synthesize Window;
@synthesize NavController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.Window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.Window makeKeyAndVisible];
    self.NavController = [[UINavigationController alloc] init];
//    btnTest = [[UIButton alloc] initWithFrame:CGRectMake(20,20, 40, 40)];
//    [btnTest setBackgroundImage:[AppDelegate imageFromColor:[UIColor greenColor]] forState:UIControlStateNormal];
//    [btnTest setTitle:@"title" forState:UIControlStateNormal];
//    [btnTest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnTest addTarget:self action:@selector(btnTestClick) forControlEvents:UIControlEventTouchUpInside];
//    self.NavController.
//    self.NavController
//    [NavController.view addSubview:btnTest];
//    [btnTest release];
//    [btnTest setHidden:TRUE];
    [self.Window setRootViewController:NavController];
    TimelineViewController *timelineViewController = [[TimelineViewController alloc] initWithNibName:@"TimelineViewController" bundle:NULL];
    [NavController pushViewController:timelineViewController animated:FALSE];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"myapp"] == NO) return NO;
    
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    
    TimelineViewController *vc = (TimelineViewController *)[((UINavigationController *)([[self Window] rootViewController])) topViewController];
    [vc setOAuthToken:token oauthVerifier:verifier];
    
    return YES;
}

@end
