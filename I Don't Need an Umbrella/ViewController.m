//
//  ViewController.m
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/6/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "InitialScene.h"
@interface ViewController () {
    BOOL _gameCenterEnabled;
    NSString *_leaderboardIdentifier;
}
- (void)authenticateLocalPlayer;
- (void)showLeaderboard;
@end


@implementation ViewController
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self authenticateLocalPlayer];
    self.banner.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    self.banner.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"facebookShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"reportScore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showLeaderboard" object:nil];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    skView.multipleTouchEnabled = YES;
    // Create and configure the scene.
    self.scene = [InitialScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    
    
    //self.canDisplayBannerAds = YES; /* This causes error when iAd is clicked */
    
    // Present the scene.
    [skView presentScene:self.scene];

}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

        
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (banner.isBannerLoaded) {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.alpha = 0;
        banner.frame = CGRectOffset(banner.frame, 0,banner.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!banner.isBannerLoaded) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {

    
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark notifications
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) {
        [self hideBanner];
    }else if ([notification.name isEqualToString:@"showAd"]) {
        [self showBanner];
    } else if ([notification.name isEqualToString:@"facebookShare"]) {
        [self facebookShare:notification];
    } else if ([notification.name isEqualToString:@"reportScore"]) {
        [self reportScore:notification];
    } else if ([notification.name isEqualToString:@"showLeaderboard"]) {
        [self showLeaderboard];
    }
}

- (void)facebookShare: (NSNotification *) notification {
    BOOL shareScore = [[notification.userInfo objectForKey:@"showOffScore"] boolValue];
    NSInteger score = [[notification.userInfo objectForKey:@"score"] integerValue];
    
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        
        if (shareScore) {
            [facebookPost setInitialText:[NSString stringWithFormat:@"I just got %li from I Don't Need an Umbrella!\nCheck out this game if you haven't already!", (long)score]];
        } else {
            [facebookPost setInitialText:[NSString stringWithFormat:@"Check out this awesome game called I Don't Need an Umbrella!\nAvoid the rain.\n"]];
        }
        [facebookPost addURL:[NSURL URLWithString:[@"itms-apps://itunes.apple.com/app/" stringByAppendingString: @"id908870781"]]];
        
        [self presentViewController:facebookPost animated:YES completion:nil];
    } else {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Sorry, you have to log into Facebook first before sharing! \nGo to Settings->Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
        [alertview show];
    }
}
- (void)hideBanner {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    self.banner.alpha = 0;
    [UIView commitAnimations];
}

- (void)showBanner {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.banner.alpha = 1;
    [UIView commitAnimations];
}

#pragma mark leaderboard 
- (void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                NSLog(@"authenticated");
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    NSLog(@"%@", leaderboardIdentifier);
                    if (error != nil) {
                        NSLog(@"here");
                        NSLog(@"%@", [error description]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}


- (void)reportScore:(NSNotification *) notification {
    if (_gameCenterEnabled) {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *score = [userInfo objectForKey:@"highestScore"];
        GKScore *gkscore = [[GKScore alloc]initWithLeaderboardIdentifier:_leaderboardIdentifier];
        gkscore.shouldSetDefaultLeaderboard = YES;
        gkscore.value = [score integerValue];
        [GKScore reportScores:@[gkscore] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }

    
}

- (void)showLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
    
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    NSLog(@"%@", _leaderboardIdentifier);
    [self presentViewController:gcViewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
