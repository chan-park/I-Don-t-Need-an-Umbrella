//
//  InitialScene.h
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/10/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Background.h"
#import "Poop.h"
#import "MyScene.h"
#import <Social/Social.h>
@import AudioToolbox;
@interface InitialScene : SKScene <SKPhysicsContactDelegate>
@property (nonatomic, strong) SKSpriteNode * background;

@end
