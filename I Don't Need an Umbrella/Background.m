//
//  Background.m
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/7/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import "Background.h"
#import "common.h"
@implementation Background
+ (Background *) generateBackground {
    Background *background = [[Background alloc] initWithImageNamed:@"RPBackground.png"];

    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, -30, [UIScreen mainScreen].applicationFrame.size.width + 100);
    CGPathAddLineToPoint(path, nil, -30, groundLevel);
    CGPathAddLineToPoint(path, nil, [UIScreen mainScreen].applicationFrame.size.width + 30, groundLevel);
    CGPathAddLineToPoint(path, nil, [UIScreen mainScreen].applicationFrame.size.width + 30, [UIScreen mainScreen].applicationFrame.size.height + 100);
    background.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    background.physicsBody.categoryBitMask = groundCategory;
    background.physicsBody.collisionBitMask = poopCategory | playerCategory;
    background.physicsBody.contactTestBitMask = groundCategory;
    background.anchorPoint = CGPointMake(0, 0);
    background.position = CGPointMake(0, 0);
    background.zPosition = 0;
    background.name = @"ground";
    return background;
}
@end
