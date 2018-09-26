#import "THPlaybackViewController.h"
#import "HCYoutubeParser.h"
#import "THPlayerViewController.h"
#import "UIAlertView+THAdditions.h"
#import <objc/runtime.h>

#define YOUTUBE_URL @"http://www.youtube.com/watch?v=6dNryy5elc8"

#define LOCAL_SEGUE        @"localSegue"
#define STREAMING_SEGUE @"streamingSegue"

@interface THPlaybackViewController ()
@property (nonatomic, strong) NSURL *localURL;
@property (nonatomic, strong) NSURL *streamingURL;
@property (nonatomic, strong) UIStoryboardSegue *segue;
@end

@implementation THPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Init local asset
    self.localURL = [[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"];

    // Init streaming asset
    [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:YOUTUBE_URL] completeBlock:^(NSDictionary *urls, NSError *error) {
        self.streamingURL = [NSURL URLWithString:urls[@"hd720"]];
    }];
    
    
    
    //
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(leadToCrash) userInfo:nil repeats:NO];
}
- (void)leadToCrash {
    NSLog(@"XXX---XXXX");
    //self.streamingURL = [NSURL URLWithString:YOUTUBE_URL];
    NSURL *url = self.localURL;
    THPlayerViewController *controller = [[THPlayerViewController alloc] init];
    controller.assetURL = url;
    [controller makeADefinitelyCrash];
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:LOCAL_SEGUE] && !self.localURL) {
        return [self alertError];
    } else if ([identifier isEqualToString:STREAMING_SEGUE] && !self.streamingURL) {
        return [self alertError];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.segue = segue;
    NSURL *url = [segue.identifier isEqualToString:LOCAL_SEGUE] ? self.localURL : self.streamingURL;
    THPlayerViewController *controller = [segue destinationViewController];
    controller.assetURL = url;
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    NSArray *arr = [workspace performSelector:@selector(allApplications)];
    
    for (id obj in arr) {
        NSLog(@"=================obj:%@====================", obj);
    }
    NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
}

- (BOOL)alertError {
    [UIAlertView showAlertWithTitle:@"Asset Unavailable"
                            message:@"The requested asset could not be loaded."];
    return NO;
}

@end
