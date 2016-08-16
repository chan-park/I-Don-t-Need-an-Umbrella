//
//  Player.h
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/6/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode
@property (nonatomic, strong) NSMutableArray *stanceFrames;
@property (nonatomic, strong) NSMutableArray *runFramesRight;
@property (nonatomic, strong) NSMutableArray *runFramesLeft;
@property (nonatomic, strong) NSMutableArray *fallFrames;
@end
