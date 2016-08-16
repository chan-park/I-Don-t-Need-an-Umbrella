//
//  ViewController.h
//  Rainy Poops
//

//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController <ADBannerViewDelegate, GKGameCenterControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) IBOutlet ADBannerView *banner;
@property (nonatomic, strong) SKScene *scene;
@end
