//
//  MyScene.h
//  Rainy Poops
//

//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "Background.h"
#import "common.h"
#import "Poop.h"
#import "InitialScene.h"
#import <AVFoundation/AVFoundation.h>
@import AudioToolbox;
@interface MyScene : SKScene <SKPhysicsContactDelegate,  AVAudioPlayerDelegate>
{
    SystemSoundID backgroundMusic;
}
@property (nonatomic, strong) SKSpriteNode * player;
@property (nonatomic, strong) Background *currentBackground;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) SKLabelNode *scoreLabel;

@property (assign) int level;
@property (assign) NSInteger score;

@end
