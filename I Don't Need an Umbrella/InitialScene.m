//
//  InitialScene.m
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/10/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import "InitialScene.h"
@import AudioToolbox;
@implementation InitialScene
{
    BOOL _loaded;
     SystemSoundID titleSlamSound;
    int _timer;
    int _poopFrequency;
    SystemSoundID dropsound;
}
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _loaded = NO;
        [self createSceneContents];
        self.physicsWorld.contactDelegate = self;
        _timer = 0;
        _poopFrequency = 30;
    }
    return self;
}


- (void)createSceneContents {
    // sound
    NSString *dropSoundFile = [[NSBundle mainBundle]pathForResource:@"waterdroplet" ofType:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:dropSoundFile], &dropsound);
    
    // title
    SKSpriteNode *background = [Background generateBackground];
    self.physicsWorld.gravity = CGVectorMake(0, -4);
    self.background = background;
    self.background.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, groundLevel - 10) toPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width, groundLevel - 10)];
    
    [self addChild:self.background];
    
    
    

    // options
    SKSpriteNode *titleLabel = [SKSpriteNode spriteNodeWithImageNamed:@"titleLabel.png"];
    titleLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, [UIScreen mainScreen].applicationFrame.size.height/2+120);
    if ([UIScreen mainScreen].applicationFrame.size.height < 500) {
        titleLabel.size = CGSizeMake(270, 230);
    } else {
        titleLabel.size = CGSizeMake(300,300);
    }
    
    titleLabel.zPosition = 100;
    [self addChild:titleLabel];
    _loaded = YES;
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    SKNode * touchedNode = [self nodeAtPoint:[touch locationInNode:self]];
    
    
    
    
    if ([touchedNode.name isEqualToString: @"StartLabel"]) {
        SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:@"splash.png"];
        splash.size = CGSizeMake(50, 50);
        splash.name = @"splash";
        splash.zPosition = 101;
        splash.position = [touch locationInNode:self];
        [self addChild: splash];
        
        
        [self performSelector:@selector(start) withObject:nil afterDelay:0.2];
        
        
    } else if ([touchedNode.name isEqualToString: @"RateLabel"]) {
        SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:@"splash.png"];
        splash.size = CGSizeMake(50, 50);
        splash.name = @"splash";
        splash.zPosition = 101;
        splash.position = [touch locationInNode:self];
        [self addChild: splash];
        
        [self performSelector:@selector(rate) withObject:nil afterDelay:0.2];
        
    } else if ([touchedNode.name isEqualToString: @"ShareLabel"]) {
        SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:@"splash.png"];
        splash.size = CGSizeMake(50, 50);
        splash.name = @"splash";
        splash.zPosition = 101;
        splash.position = [touch locationInNode:self];
        [self addChild: splash];
        
        [self performSelector:@selector(share) withObject:nil afterDelay:0.2];

        
    } else if ([touchedNode.name isEqualToString:@"RankLabel"]) {
        SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:@"splash.png"];
        splash.size = CGSizeMake(50, 50);
        splash.name = @"splash";
        splash.zPosition = 101 ;
        splash.zPosition = 101;
        splash.position = [touch locationInNode:self];
        [self addChild: splash];

        [self performSelector:@selector(rank) withObject:nil afterDelay:0.2];
    }
    
}
- (void)start {

    SKScene * scene = [MyScene sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
    [self.view presentScene:scene transition: transition];
}
- (void)rate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-apps://itunes.apple.com/app/" stringByAppendingString: @"id908870781"]]];
}
- (void)share {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookShare" object:nil];
    
    
}
- (void)rank {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLeaderboard" object:nil];
}

- (void)update:(NSTimeInterval)currentTime {
    _timer += 1;
    if (_timer % _poopFrequency == 0) {
        SKSpriteNode * p = [[Poop alloc] init];
        NSInteger random_x = arc4random_uniform([[UIScreen mainScreen]applicationFrame].size.width);
        p.position = CGPointMake(random_x, [[UIScreen mainScreen]applicationFrame].size.height);
        p.size = CGSizeMake(15, 25);
        [self addChild: p];
        
        [self enumerateChildNodesWithName:@"poop" usingBlock: ^(SKNode *node, BOOL *stop) {
            Poop *poop = (Poop *) node;
            
            if (!poop.isDropping) {
                poop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(poopSize_x - 2, poopSize_y - 2)];
                poop.physicsBody.affectedByGravity = YES;
                poop.physicsBody.collisionBitMask = 0 | groundCategory;
                poop.physicsBody.categoryBitMask = poopCategory;
                poop.physicsBody.contactTestBitMask = groundCategory;
                poop.physicsBody.restitution = 0;
                poop.physicsBody.mass = 10000;
                poop.isDropping = YES;
            }
        }];
        
        
    }

    if (_loaded) {
        SKSpriteNode *startButton = [[SKSpriteNode alloc] initWithImageNamed:@"StartLabel.png"];
        startButton.name = @"StartLabel";
        startButton.size = CGSizeMake(160, 80);
        startButton.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 - 50, groundLevel + 150);
        [startButton runAction:[SKAction rotateByAngle:M_PI/20 duration:0.01]];
        
        startButton.zPosition = 100;
        [self addChild:startButton];
        
        [self addColumnWIthWidth:33 andHeight:200 withRotationalAngle:M_PI/20 atPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 - 50, groundLevel + 90)];
        
        
        SKSpriteNode *shareButton = [[SKSpriteNode alloc] initWithImageNamed:@"ShareLabel.png"];
        shareButton.name = @"ShareLabel";
        shareButton.size = CGSizeMake(100, 50);
        [shareButton runAction:[SKAction rotateByAngle:-M_PI/11 duration:0.01]];
        shareButton.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 + 90 ,  groundLevel + 90);

        shareButton.zPosition = 100;
        [self addChild:shareButton];
        [self addColumnWIthWidth:30 andHeight:140 withRotationalAngle:-M_PI/11 atPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 +85, groundLevel + 60)];
       
        
        SKSpriteNode *rankButton = [[SKSpriteNode alloc] initWithImageNamed:@"RankLabel.png"];
        rankButton.name = @"RankLabel";
        rankButton.size = CGSizeMake(110, 55);
        rankButton.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 - 100,  groundLevel + 65);
        [rankButton runAction: [SKAction rotateByAngle:M_PI/50 duration:0.01]];

        
        rankButton.zPosition = 100;
        [self addChild:rankButton];
        [self addColumnWIthWidth:25 andHeight:110 withRotationalAngle:M_PI/50 atPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 - 100, groundLevel + 50)];

        
        
        SKSpriteNode *rateButton = [[SKSpriteNode alloc] initWithImageNamed:@"RateLabel.png"];
        rateButton.name = @"RateLabel";
        rateButton.size = CGSizeMake(90, 45);
        rateButton.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 + 20 , groundLevel + 40);
        [rateButton runAction: [SKAction rotateByAngle:M_PI/10 duration:0.01]];

        rateButton.zPosition = 100;
        [self addChild:rateButton];
        [self addColumnWIthWidth:20 andHeight:80 withRotationalAngle:M_PI/10 atPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 +20, groundLevel + 30)];

        
        
        _loaded = NO;
        
        
        
    }
    
    
    [self enumerateChildNodesWithName:@"splash" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[[SKAction waitForDuration:1], [SKAction fadeOutWithDuration:1], [SKAction waitForDuration:3], [SKAction removeFromParent]]]];
    }];
    
}

-(void)addColumnWIthWidth:(CGFloat) width andHeight:(CGFloat) height withRotationalAngle:(CGFloat) radians atPoint: (CGPoint) position{
    SKSpriteNode *column = [SKSpriteNode spriteNodeWithImageNamed:@"column.png"];
    column.size = CGSizeMake(width, height);
    [column runAction:[SKAction rotateByAngle:radians duration:0.01]];
    column.position = position;
    column.zPosition = 70;
    [self addChild:column];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    if ([contact.bodyA.node.name isEqualToString:@"poop"] && [contact.bodyB.node.name isEqualToString:@"ground"]) {
        AudioServicesPlaySystemSound(dropsound);
        contact.bodyA.node.name = @"expired_poop";
        [contact.bodyA.node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"waterdropsplash.png"]]];
        [contact.bodyA.node runAction:[SKAction fadeOutWithDuration:0.1] completion:^{[contact.bodyA.node removeFromParent];}];
    } else if ([contact.bodyA.node.name isEqualToString:@"ground"] && [contact.bodyB.node.name isEqualToString:@"poop"]){
        AudioServicesPlaySystemSound(dropsound);
        contact.bodyB.node.name = @"expired_poop";
        [contact.bodyB.node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"waterdropsplash.png"]]];
        [contact.bodyB.node runAction:[SKAction fadeOutWithDuration:0.1] completion:^{[contact.bodyB.node removeFromParent];}];
    }
}
@end
