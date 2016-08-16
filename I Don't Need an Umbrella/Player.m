//
//  Player.m
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/6/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import "Player.h"
#import "common.h"
@implementation Player
- (instancetype)init {

    self = [super initWithImageNamed:@"player.png"];
    [self setAnimation];
    self.name = @"player";
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(14, 27)];
    self.physicsBody.dynamic = YES;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.affectedByGravity = YES;
    self.physicsBody.collisionBitMask = ~poopCategory | groundCategory | boundaryCategory;
    self.physicsBody.categoryBitMask = playerCategory;
    self.physicsBody.contactTestBitMask = poopCategory;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.zPosition = 100;
    self.physicsBody.friction = friction;
    //self.anchorPoint = CGPointMake(0.5, 0);
    
    return self;
}

- (void)setAnimation {
    SKTextureAtlas *stanceAtlas = [SKTextureAtlas atlasNamed:@"PlayerStance"];
    self.stanceFrames = [NSMutableArray new];
    for (int i = 0; i < [stanceAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"player_stance_%i", i];
        SKTexture *tempTexture = [stanceAtlas textureNamed:tempName];
        
        if (tempTexture) {
            [self.stanceFrames addObject: tempTexture];
        }
    }
    
    SKTexture *tempTexture = [stanceAtlas textureNamed: @"player_stance_2"];
    if (tempTexture) {
        [self.stanceFrames addObject:tempTexture];
    }
    
    tempTexture = [stanceAtlas textureNamed: @"player_stance_1"];
    if (tempTexture) {
        [self.stanceFrames addObject:tempTexture];
    }
    
    
    tempTexture = [stanceAtlas textureNamed: @"player_stance_0"];
    if (tempTexture) {
        [self.stanceFrames addObject:tempTexture];
    }
    
    
    SKTextureAtlas *runAtlas = [SKTextureAtlas atlasNamed:@"PlayerRunRight"];
    self.runFramesRight = [NSMutableArray new];
    for (int i = 8; i < [runAtlas.textureNames count]; i ++) {
        NSString *tempName = [NSString stringWithFormat:@"player_run_%i", i];
        SKTexture *tempTexture = [runAtlas textureNamed: tempName];
        if (tempTexture) {
            [self.runFramesRight addObject: tempTexture];
        }
    }
    
    for (int i = (int)[runAtlas.textureNames count] - 2; i > 8; i--) {
        NSString *tempName = [NSString stringWithFormat:@"player_run_%i", i];
        SKTexture *tempTexture = [runAtlas textureNamed: tempName];
        if (tempTexture) {
            [self.runFramesRight addObject: tempTexture];
        }
    }
    
    runAtlas = [SKTextureAtlas atlasNamed:@"PlayerRunLeft"];
    
    self.runFramesLeft = [NSMutableArray new];
    for (int i = 0; i < [runAtlas.textureNames count]; i ++) {
        NSString *tempName = [NSString stringWithFormat:@"player_run_%i", i];
        SKTexture *tempTexture = [runAtlas textureNamed: tempName];
        if (tempTexture) {
            [self.runFramesLeft addObject: tempTexture];
        }
    }
    
    for (int i = (int)[runAtlas.textureNames count] - 2; i > 0; i--) {
        NSString *tempName = [NSString stringWithFormat:@"player_run_%i", i];
        SKTexture *tempTexture = [runAtlas textureNamed: tempName];
        if (tempTexture) {
            [self.runFramesLeft addObject: tempTexture];
        }
    }
    
    SKTextureAtlas *fallAtlas = [SKTextureAtlas atlasNamed:@"PlayerFall"];
    self.fallFrames = [NSMutableArray new];
    
    for (int i = 0; i < [fallAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString stringWithFormat:@"PlayerFall-%i", i];
        SKTexture *tempTexture = [fallAtlas textureNamed: tempName];
        if (tempTexture) {
            [self.fallFrames addObject: tempTexture];
        }
    }
}


@end
