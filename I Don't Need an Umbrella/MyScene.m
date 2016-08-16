//
//  MyScene.m
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/6/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    int _timer;
    int _poopFrequency;
    double _force;
    BOOL _leftPressed;
    BOOL _rightPressed;
    BOOL _isGameOver;
    BOOL _readyForPoop;
    BOOL _soundIsOn;
    int _lastPressed;
    
    SKLabelNode *levelLabel;
    SKSpriteNode *soundStatus;
    // 0 for left 1 for right
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _poopFrequency = 10;
        _isGameOver = NO;
        _readyForPoop = NO;
        _lastPressed = 1;
        _soundIsOn = YES;
        self.level = 0;
        self.score = 0;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        NSArray *songTitles = @[@"Funny_Steps", @"ABouquetOfThistles", @"MickeyMouse", @"PeacefulRoads", @"TinyTickles", @"WaterCloud"];
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:[songTitles objectAtIndex:arc4random_uniform((int)[songTitles count])] ofType:@"wav"];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error: nil];
        self.audioPlayer.numberOfLoops = -1;
    
        
        
        [self createSceneContents];
        [self performSelector:@selector(turnOnPoops) withObject:nil afterDelay:1];
        
       
       
        
    }
    return self;
}

-(void)turnOnPoops {
    _readyForPoop = YES;
}
-(void)createSceneContents {
    // sound
    BOOL soundIsOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"soundStatus"];
    if (soundIsOn) {

        _soundIsOn = YES;
        [self.audioPlayer play];
        soundStatus = [SKSpriteNode spriteNodeWithImageNamed:@"SoundOn.png"];
    } else {

        _soundIsOn = NO;
        [self.audioPlayer pause];
        soundStatus = [SKSpriteNode spriteNodeWithImageNamed:@"SoundOff1.png"];
    }
    
    soundStatus.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width - 30, [UIScreen mainScreen].applicationFrame.size.height - 25);
    soundStatus.size = CGSizeMake(50, 50);
    soundStatus.alpha = 0.5;
    soundStatus.zPosition = 200;
    soundStatus.name = @"sound";
    [self addChild:soundStatus];
    
    // background
    self.currentBackground = [Background generateBackground];
    [self addChild: self.currentBackground];

    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"American Typewriter"];
    self.scoreLabel.fontColor = [SKColor redColor];
    self.scoreLabel.fontSize = 20;
    self.scoreLabel.alpha = 0.5;
    self.scoreLabel.position = CGPointMake(30, [UIScreen mainScreen].applicationFrame.size.height - 30);

    [self addChild:self.scoreLabel];
    // arrows
    SKSpriteNode *rightArrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
    rightArrow.alpha = 0.5;
    rightArrow.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2+ 100, [UIScreen mainScreen].applicationFrame.size.height/2);
    
    
    SKSpriteNode *leftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow.png"];
    leftArrow.alpha = 0.5;
    leftArrow.xScale = -1;
    leftArrow.position =CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 -100, [UIScreen mainScreen].applicationFrame.size.height/2);
    
    SKSpriteNode *guideLine = [SKSpriteNode spriteNodeWithImageNamed:@"middleline.png"];
    guideLine.alpha = 0.5;
    guideLine.size = CGSizeMake(10, [UIScreen mainScreen].applicationFrame.size.height);
    guideLine.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, [UIScreen mainScreen].applicationFrame.size.height/2);
    
    
    [self addChild:rightArrow];
    [self addChild:leftArrow];
    [self addChild:guideLine];
    
    
    [rightArrow runAction: [SKAction sequence:@[[SKAction waitForDuration:2], [SKAction fadeOutWithDuration:1], [SKAction waitForDuration:2],  [SKAction removeFromParent]]]];
    [leftArrow runAction: [SKAction sequence:@[[SKAction waitForDuration:2], [SKAction fadeOutWithDuration:1], [SKAction waitForDuration:2],  [SKAction removeFromParent]]]];
    [guideLine runAction: [SKAction sequence:@[[SKAction waitForDuration:2], [SKAction fadeOutWithDuration:1], [SKAction waitForDuration:2],  [SKAction removeFromParent]]]];
    
    
    // setting up boundary for the player (but not the poops)
    SKSpriteNode *boundary = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
    boundary.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
    boundary.physicsBody.affectedByGravity = NO;
    boundary.physicsBody.categoryBitMask = boundaryCategory;
    boundary.physicsBody.collisionBitMask = ~poopCategory | playerCategory;
    [self addChild:boundary];
    
    self.physicsWorld.gravity = CGVectorMake(0, gravity);
    self.physicsWorld.contactDelegate = self;
    
    
    // player
    SKSpriteNode *player = [[Player alloc]init];

    // for stance
    player.size = CGSizeMake(25, 38);
    
    // for running
    player.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, groundLevel+20);
    self.player = player;
    [self addChild:self.player];
    
    
    
    [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).stanceFrames timePerFrame:.08]] withKey:@"stance"];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint: touchLocation];
    if ([node.name isEqualToString:@"againLabel"]) {
        SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:@"splash.png"];
        splash.size = CGSizeMake(50, 50);
        splash.name = @"splash";
        splash.zPosition = 101;
        splash.position = [touch locationInNode:self];
        [self addChild: splash];
        [self performSelector:@selector(again) withObject:nil afterDelay:0.1];
    } else if([node.name isEqualToString:@"mainLabel"]) {
        SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:@"splash.png"];
        splash.size = CGSizeMake(50, 50);
        splash.name = @"splash";
        splash.zPosition = 101;
        splash.position = [touch locationInNode:self];
        [self addChild: splash];
        [self performSelector:@selector(main) withObject:nil afterDelay:0.1];
    } else if ([node.name isEqualToString:@"shareLabel"]) {
        SKSpriteNode *splash = [SKSpriteNode spriteNodeWithImageNamed:@"splash.png"];
        splash.size = CGSizeMake(50, 50);
        splash.name = @"splash";
        splash.zPosition = 101;
        splash.position = [touch locationInNode:self];
        [self addChild: splash];
        NSDictionary *userInfo = @{@"score": [NSNumber numberWithInteger:self.score], @"showOffScore": [NSNumber numberWithBool:YES]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"facebookShare" object:nil userInfo:userInfo];
    }
    
    if ([node.name isEqualToString:@"sound"]) {
        if (_soundIsOn) {
            _soundIsOn = NO;
            [[NSUserDefaults standardUserDefaults] setBool:_soundIsOn forKey:@"soundStatus"];
            soundStatus.texture = [SKTexture textureWithImageNamed:@"SoundOff1.png"];
            [self.audioPlayer pause];
        } else {
            _soundIsOn = YES;
            [[NSUserDefaults standardUserDefaults] setBool:_soundIsOn forKey:@"soundStatus"];
            soundStatus.texture = [SKTexture textureWithImageNamed:@"SoundOn.png"];
            [self.audioPlayer play];
        }
    } else if (touchLocation.x < [UIScreen mainScreen].applicationFrame.size.width/2 && !_isGameOver) {
        
        [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).runFramesLeft timePerFrame:.01]]withKey:@"run"];
        _leftPressed = YES;
        _lastPressed = 0;
        
    } else if (touchLocation.x > [UIScreen mainScreen].applicationFrame.size.width/2 && !_isGameOver){
       
        [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).runFramesRight timePerFrame:.01]] withKey:@"run"];
        _rightPressed = YES;
        _lastPressed = 1;
    }
    
    if ([[event allTouches] count] == 2 && !_isGameOver) {
        if (_lastPressed  == 0) {
            _leftPressed = YES;
            _rightPressed = NO;
            [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).runFramesLeft timePerFrame:.01]]withKey:@"run"];
        } else if (_lastPressed == 1) {
            _leftPressed = NO;
            _rightPressed = YES;
            [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).runFramesRight timePerFrame:.01]] withKey:@"run"];
        }
    }
    
    
   
}
    
-(void)again {
    SKScene *myScene = [MyScene sceneWithSize: self.view.bounds.size];
    myScene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:myScene];
}
- (void)main {
    SKScene *main = [InitialScene sceneWithSize: self.view.bounds.size];
    main.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:main];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isGameOver) {
        if ([[event allTouches] count] == 2) {
            if (_lastPressed == 1) {
                [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).runFramesRight timePerFrame:.01]] withKey:@"run"] ;
                _rightPressed = YES;
                _leftPressed = NO;
            } else if (_lastPressed == 0) {
                [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).runFramesLeft timePerFrame:.01]] withKey:@"run"] ;
                _leftPressed = YES;
                _rightPressed = NO;
            }
        } else if ([[event allTouches] count] == 1){
             [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:((Player *)self.player).stanceFrames timePerFrame:.08]] withKey:@"stance"];
            _leftPressed = NO;
            _rightPressed = NO;
        }
    }
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    _timer+=1;
    
    
    
    if (_poopFrequency == 3) {
        _poopFrequency = 3;
    } else if ((_timer % 500 == 0 || _timer == 1) && !_isGameOver) {
        _poopFrequency--;
        self.level++;
        // Level label transition
        levelLabel = [SKLabelNode labelNodeWithFontNamed:@"American Typewriter"];
        
        if (self.level == 1) {
            levelLabel.fontSize = 25;
            levelLabel.text = [NSString stringWithFormat:@"AVOID THE RAIN!"];
            levelLabel.alpha = 0.4;
        } else {
            levelLabel.fontSize = 40;
            levelLabel.text = [NSString stringWithFormat:@"MORE RAIN!"];
            levelLabel.alpha = 0.4;
        }
        levelLabel.fontColor = [SKColor redColor];
        levelLabel.alpha = 0.4;
        levelLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, [UIScreen mainScreen].applicationFrame.size.height/2+20);
        [self addChild:levelLabel];
        //SKAction *moveToMiddle = [SKAction moveTo:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, [UIScreen mainScreen].applicationFrame.size.height/2+ 50) duration:1];
        
        SKAction *wait = [SKAction waitForDuration:0.5];
        
        //SKAction *moveOutofScreen = [SKAction moveTo:CGPointMake(- 200, [UIScreen mainScreen].applicationFrame.size.height/2 + 50)  duration:1];
        
        SKAction *remove = [SKAction removeFromParent];
        //[levelLabel runAction: [SKAction sequence:@[moveToMiddle, wait, moveOutofScreen, remove]]];
        SKAction *appear = [SKAction fadeInWithDuration:0.1];

        SKAction *disappear = [SKAction fadeOutWithDuration:0.1];
        SKAction *blink = [SKAction sequence:@[appear, wait, disappear, wait, appear, wait, disappear, wait, appear, wait, disappear, remove]];
        [levelLabel runAction: blink withKey:@"level"];
    }
    
    //NSLog(@"%i", _timer);
    if (_rightPressed && !_isGameOver) {
        [self.player.physicsBody applyForce:CGVectorMake(speed, 0)];
    } else if (_leftPressed && !_isGameOver) {
        [self.player.physicsBody applyForce:CGVectorMake(-speed, 0)];
    } else {
        
    }
    
    if (_timer % _poopFrequency == 0 && !_isGameOver && _readyForPoop) {
        SKSpriteNode * p = [[Poop alloc] init];
        NSInteger random_x = arc4random_uniform([[UIScreen mainScreen]applicationFrame].size.width);
        p.position = CGPointMake(random_x, [[UIScreen mainScreen]applicationFrame].size.height);
        p.size = CGSizeMake(15, 25);
        [self addChild: p];
        self.score++;
        self.scoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.score];
    
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
    

}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    if ([contact.bodyA.node.name isEqualToString:@"poop"] && [contact.bodyB.node.name isEqualToString:@"ground"]) {

        contact.bodyA.node.name = @"expired_poop";
        [contact.bodyA.node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"waterdropsplash.png"]]];
        [contact.bodyA.node runAction:[SKAction fadeOutWithDuration:0.1] completion:^{[contact.bodyA.node removeFromParent];}];
    } else if ([contact.bodyA.node.name isEqualToString:@"ground"] && [contact.bodyB.node.name isEqualToString:@"poop"]){
        contact.bodyB.node.name = @"expired_poop";
        [contact.bodyB.node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"waterdropsplash.png"]]];
        [contact.bodyB.node runAction:[SKAction fadeOutWithDuration:0.1] completion:^{[contact.bodyB.node removeFromParent];}];
    } else if ([contact.bodyA.node.name isEqualToString:@"player"] && [contact.bodyB.node.name isEqualToString:@"poop"]){
        if (!_isGameOver) {
            
              AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            _isGameOver = YES;
            [levelLabel removeActionForKey:@"level"];
            [levelLabel removeFromParent];
            [self.player removeActionForKey:@"stance"];
            [self.player removeActionForKey:@"run"];
            
            //self.player.texture = [SKTexture textureWithImageNamed:@"PlayerFall.png"];
            if (_rightPressed || _lastPressed == 1) {
                [self.player runAction:[SKAction animateWithTextures:((Player*)self.player).fallFrames timePerFrame:0.015 resize:NO restore:NO] withKey:@"fall"];
            } else if (_leftPressed || _lastPressed == 0){
                self.player.xScale = -1;
                [self.player runAction:[SKAction animateWithTextures:((Player*)self.player).fallFrames timePerFrame:0.015 resize:NO restore:NO] withKey:@"fall"];
            }
           
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
            [self performSelector:@selector(gameOver) withObject:nil afterDelay:2.5];
            //[self gameOver];
        }
        
        
        
        
    }
}

- (void)gameOver {
    soundStatus.hidden = YES;
    [self.audioPlayer pause];
    self.scoreLabel.hidden = YES;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"highestScore"] < self.score) {
        
        // beat highest score
        [userDefault setInteger:  self.score forKey:@"highestScore"];
        
        
        // label for best score!
        SKSpriteNode *bestStamp = [SKSpriteNode spriteNodeWithImageNamed:@"BestStamp.png"];
        bestStamp.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2- 100, [UIScreen mainScreen].applicationFrame.size.height /2+ 60);
        [self addChild:bestStamp];
    } else {
        // label for the best score at the bottom of the current score
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"American Typewriter"];
        bestScoreLabel.fontSize = 20;
        bestScoreLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, [UIScreen mainScreen].applicationFrame.size.height /2 - 30);
        bestScoreLabel.fontColor = [SKColor blackColor];
        bestScoreLabel.text = [NSString stringWithFormat:@"Best Score:  %li",(long) [userDefault integerForKey:@"highestScore"]];
        [self addChild:bestScoreLabel];
    }
    // report score
    NSDictionary *userinfo = @{@"highestScore": [NSNumber numberWithInteger: self.score], @"showOffScore": [NSNumber numberWithBool:NO]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reportScore" object:nil userInfo:userinfo];
    
   
    
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"American Typewriter"];
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    scoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.score];
    scoreLabel.fontSize = 80;
    scoreLabel.fontColor = [SKColor redColor];
    scoreLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, [UIScreen mainScreen].applicationFrame.size.height /2);
    [self addChild:scoreLabel];
    
    
    
    SKSpriteNode *gameoverLabel = [SKSpriteNode spriteNodeWithImageNamed:@"gameoverlabel"];
    SKSpriteNode *againLabel = [SKSpriteNode spriteNodeWithImageNamed:@"AgainLabel"];
    SKSpriteNode *mainLabel = [SKSpriteNode spriteNodeWithImageNamed:@"MainLabel"];
    SKSpriteNode *shareLabel = [SKSpriteNode spriteNodeWithImageNamed:@"ShareLabel"];
 
    gameoverLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 , [UIScreen mainScreen].applicationFrame.size.height - 120);
    //gameLabel.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(200, 100)];
    gameoverLabel.alpha = 0.0f;
    gameoverLabel.size = CGSizeMake(300, 200);
    [self addChild:gameoverLabel];
    [gameoverLabel runAction:[SKAction fadeInWithDuration:0.1]];
    
    againLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 - 100, groundLevel + 60);
    
    againLabel.size = CGSizeMake(90, 45);
    againLabel.alpha = 0.0f;
    againLabel.name = @"againLabel";
    againLabel.zPosition = 100;
    [self addChild:againLabel];
    [againLabel runAction:[SKAction fadeInWithDuration:0.1]];
    [self addColumnWIthWidth:25 andHeight:80 withRotationalAngle:0 atPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 - 100, groundLevel + 30)];
    
    mainLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, groundLevel + 60);
    mainLabel.size = CGSizeMake(90, 45);
    mainLabel.alpha = 0.0f;
    mainLabel.name = @"mainLabel";
    mainLabel.zPosition = 100;
    [self addChild:mainLabel];
    [mainLabel runAction:[SKAction fadeInWithDuration:0.1]];
    [self addColumnWIthWidth:25 andHeight:80 withRotationalAngle:0 atPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2, groundLevel + 30)];
    
    shareLabel.position = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 + 100, groundLevel + 60);
    
    shareLabel.size = CGSizeMake(90, 45);
    shareLabel.alpha = 0.0f;
    shareLabel.name = @"shareLabel";
    shareLabel.zPosition = 100;
    [self addChild:shareLabel];
    [shareLabel runAction:[SKAction fadeInWithDuration:0.1]];
    [self addColumnWIthWidth:25 andHeight:80 withRotationalAngle:0 atPoint:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2 + 100, groundLevel + 30)];
    
    
    
}

-(void)addColumnWIthWidth:(CGFloat) width andHeight:(CGFloat) height withRotationalAngle:(CGFloat) radians atPoint: (CGPoint) position{
    SKSpriteNode *column = [SKSpriteNode spriteNodeWithImageNamed:@"column.png"];
    column.size = CGSizeMake(width, height);
    [column runAction:[SKAction rotateByAngle:radians duration:0.1]];
    column.position = position;
    column.alpha = 0;
    [self addChild:column];
    [column runAction:[SKAction fadeInWithDuration:0.1]];
}


@end
