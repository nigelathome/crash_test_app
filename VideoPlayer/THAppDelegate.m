#import "THAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@interface THAppDelegate ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation THAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMoviePlayback error:nil];
    
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
//    
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//    }];
    
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestAlwaysAuthorization];
    
    
    
    return YES;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

{
    
    NSURL *requestURL = [ request URL ];
    
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        
        return ![ [ UIApplication sharedApplication ] openURL: requestURL ];
        
    }
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
