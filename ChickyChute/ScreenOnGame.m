//
//  ScreenOnGame.m
//  ChickyChute
//
//  Created by Shachar Udi on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenOnGame.h"

#define kNumLasers 5


@implementation ScreenOnGame
@synthesize theChicken;
@synthesize moveChicken;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    ScreenOnGame *layer = [ScreenOnGame node];
    [scene addChild: layer];
    return scene;
}

-(void) runGameOver {
    globalGameTime = gameRunningTime;
    globalChicksCought = collectedChickens;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[ScreenGameOver scene]]];
}

-(void) removeLabel:(CCLabelTTF *) theLabel {
    [background removeChild:theLabel cleanup:YES];
}

-(void) produceEggRainCounter {
    eggRainCounter = (arc4random() % 20) + 20;
}

-(void) explodeRainEgg:(id) sender {
    CCSprite *explodingRain = (CCSprite *)sender;
    [chickensArray removeObject:explodingRain];
    [background removeChild:explodingRain cleanup:YES];
}

-(void) explodeChicken:(id) sender {
    CCSprite *explodingChicken = (CCSprite *)sender;
 
    if (explodingChicken.tag == 2) {
        if (playerLife == 0) {
            [playerLifeLabel setString:[NSString stringWithFormat:@"%d",playerLife]];
            [self runGameOver];
        }
        
        if (playerLife > 0) {
            CCLabelTTF *oneLife = [CCLabelTTF labelWithString:@"Careful, don't let the Chickys fall!" fontName:@"Marker Felt" fontSize:32];
            oneLife.position = ccp(240,240);
            oneLife.color = ccc3(222, 28, 36);
            [oneLife runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
            playerLife = playerLife - 1;
            [playFile playEffect:@"Boom.wav"];
            [playerLifeLabel setString:[NSString stringWithFormat:@"%d",playerLife]];

            
            CCLabelTTF *oneLifeBack = [CCLabelTTF labelWithString:@"Careful, don't let the Chickys fall!" fontName:@"Marker Felt" fontSize:32];
            oneLifeBack.position = ccp(239,239);
            [background addChild:oneLifeBack];
            oneLifeBack.color = ccc3(255, 255, 255);
            [oneLifeBack runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
         
            [background addChild:oneLife];

        }
    }
}

-(void) addChickens {
    NSString *chickenName = [NSString stringWithString:@"eggFall"];
    int chickenNumber = arc4random() % 2;
    chickenName = [chickenName stringByAppendingFormat:@"%d", chickenNumber];
    chickenName = [chickenName stringByAppendingString:@".png"];
    
    CCSprite *aChicken = [CCSprite spriteWithFile:chickenName];
    aChicken.position = ccp((arc4random() % 440) + 20, 340);
    [background addChild:aChicken];
    
    float fallingTime = gameSpeed + ((arc4random() % 3) + 1);
    gameSpeed = gameSpeed - 0.1;
    
    if (gameSpeed < 1.4) gameSpeed = 1.6;
            
    [aChicken runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:fallingTime position:ccp(aChicken.position.x  , -20)],
                     [CCCallFuncN actionWithTarget:self selector:@selector(explodeChicken:)],
                     nil]];
    aChicken.tag = 2;

    [chickensArray addObject:aChicken];
    
    specialChickenTimer++;
    if (specialChickenTimer == 8) {
        CCSprite *specialChicken = [CCSprite spriteWithFile:@"specialChickyEgg.png"];
        int theDirection = -50;
        int specialDirection = arc4random() % 10;
        if (specialDirection > 4) theDirection = 530;
        specialChicken.position = ccp(theDirection, 520);
        [background addChild:specialChicken];
        
        [specialChicken runAction:[CCSequence actions:
                             [CCMoveTo actionWithDuration:fallingTime position:ccp(240  , -20)],
                             [CCCallFuncN actionWithTarget:self selector:@selector(explodeChicken:)],
                             nil]];
        specialChicken.tag = 4;
        
        [chickensArray addObject:specialChicken];
        
        specialChickenTimer = 0;
    }
    
    eggRainTimer++;
    if (eggRainTimer == eggRainCounter) {
        CCSprite *rainEgg = [CCSprite spriteWithFile:@"specialEggBlue.png"];
        rainEgg.position = ccp((arc4random() % 440) + 20, 340);
        [background addChild:rainEgg];
        
        [rainEgg runAction:[CCSequence actions:
                             [CCMoveTo actionWithDuration:fallingTime position:ccp(rainEgg.position.x  , -20)],
                             [CCCallFuncN actionWithTarget:self selector:@selector(explodeRainEgg:)],
                             nil]];
        rainEgg.tag = 6;
        
        [chickensArray addObject:rainEgg];
        eggRainTimer = 0;
        [self produceEggRainCounter];
    }
    
}

-(void) timerUpdate {
    [self addChickens];
    
    gameRunningTime++;
    int minuts;
    minuts = gameRunningTime / 60;
    int seconds = gameRunningTime - (minuts * 60);
    
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%.2d%", minuts, seconds];
    [timeCounterLabel setString:timerOutput];
    
    [timeCounterLabelBack setString:timerOutput];

    
}


-(void) buildChicken {
    
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"chickenWalk1.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"chickenWalk2.png"]];
    
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.5f];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.theChicken = [CCSprite spriteWithSpriteFrameName:@"chickenWalk1.png"];        
    theChicken.position = ccp(winSize.width/2, 80);
    self.moveChicken = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    [theChicken runAction:moveChicken];
    [spriteSheet addChild:theChicken];
}

-(void) createLasers {
    cornLaser = [[CCArray alloc] initWithCapacity:kNumLasers];
    for(int i = 0; i < kNumLasers; ++i) {
        CCSprite *chickenLaser = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"corn.png"]];
        
//        chickenLaser.scale = 1.5;
        chickenLaser.visible = NO;
        [background addChild:chickenLaser];
        [cornLaser addObject:chickenLaser];
    }
}

-(void) buildParallaxCloud {
    //GameCloudA.png
    CCSprite *skyA = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"GameCloudA.png"]];
    CCSprite *skyB = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"GameCloudB.png"]];
    CCSprite *skyC = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"GameCloudC.png"]];
    CCSprite *skyD = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"GameCloudD.png"]];

    
    skyParallaxNode = [CCParallaxNode node];
    
    [skyParallaxNode addChild:skyA z:-1 parallaxRatio:ccp(0.9f,1.0f) positionOffset:ccp(10,280)];
    [skyParallaxNode addChild:skyB z:1 parallaxRatio:ccp(1.0f,1.0f) positionOffset:ccp(100,250)];
    [skyParallaxNode addChild:skyC z:2 parallaxRatio:ccp(1.1f,1.0f) positionOffset:ccp(180,300)];
    [skyParallaxNode addChild:skyD z:2 parallaxRatio:ccp(1.1f,1.0f) positionOffset:ccp(240,275)];


//    [background addChild:skyParallaxNode z:0 tag:1];
    
    cloudsSprite = [CCSprite spriteWithFile:@"CloudsLayer.png"];
    cloudsSprite.position = ccp(1400,150);
    [background addChild:cloudsSprite];
    

}

-(void) dissapearChicken:(id) sender {
    CCSprite *gonnerCat = (CCSprite *)sender;
    [chickensArray removeObject:gonnerCat];
    [background removeChild:gonnerCat cleanup:YES];
}

-(void) removePera:(id) sender {
    CCSprite *peraSprite = (CCSprite *)sender;
    [peraSprite removeAllChildrenWithCleanup:YES];
    
    id blinkCat = [CCSequence actions:[CCFadeOut actionWithDuration:0.5],[CCFadeIn actionWithDuration:0.5], nil];
    id blinkAndDe=[CCRepeat actionWithAction:blinkCat times:3];
    id callRem = [CCCallFuncN actionWithTarget:self selector:@selector(dissapearChicken:)];
    
    CCTexture2D *chickenChange = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"chickyLanded.png"]];
    [peraSprite setTexture: chickenChange];
    
    int chickenWidth = chickenChange.contentSize.width;
    int chickenHeight= chickenChange.contentSize.height;
    
    [peraSprite setTextureRect:CGRectMake(0, 0, chickenWidth, chickenHeight)];
    
    [peraSprite runAction:[CCSequence actions:blinkAndDe,callRem, nil]];
    
}

-(void) removeDrop:(id) sender {
    CCSprite *dropToRemove = (CCSprite*) sender;
    dropToRemove.position = ccp(-100,-100);
    [background removeChild:dropToRemove cleanup:YES];
}
-(void) rainUpdate {
    rainChickensAdded++;
    CCSprite *rainSprite = [CCSprite spriteWithFile:@"specialChickLightBlue.png"];
    rainSprite.position = ccp((arc4random() % 440) + 20, 340);
    [background addChild:rainSprite];
    
    float fallingTime = 2.0;
    
    [rainSprite runAction:[CCSequence actions:
                         [CCMoveTo actionWithDuration:fallingTime position:ccp(rainSprite.position.x  , -20)],
                         [CCCallFuncN actionWithTarget:self selector:@selector(removeDrop:)],
                         nil]];
    rainSprite.tag = 8;
    
    [chickensArray addObject:rainSprite];
    
    if (rainChickensAdded > 20) {
        [self unschedule:@selector(rainUpdate)];
        [self schedule:@selector(timerUpdate) interval:1.0];
    }
    
}

-(void) startRain {
    rainChickensAdded = 0;
    [self  unschedule:@selector(timerUpdate)];
    [self schedule:@selector(rainUpdate) interval:0.5];
}

- (void)update:(ccTime)dt {
    CGPoint backgroundScrollVel = ccp(-20, 0);
    cloudsSprite.position = ccpAdd(cloudsSprite.position, ccpMult(backgroundScrollVel, dt));
        
    if (cloudsSprite.position.x < -1000) {
        [cloudsSprite setPosition:ccp(-980,150)];
        
        id moveCloudsBack = [CCMoveTo actionWithDuration:2.5 position:ccp(1400,150)];
        [cloudsSprite runAction:moveCloudsBack];
    }
    
    for (CCSprite *chickenItem in chickensArray) {
        for (CCSprite *cornItem in cornLaser) {
            //regular chicken
            if ((CGRectIntersectsRect(cornItem.boundingBox, chickenItem.boundingBox)) && (chickenItem.tag==2)) {  
                chickenItem.tag = 1;
                
                CCTexture2D *chickenChange = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"gpChickyParachuteRed.png"]];
                [chickenItem setTexture: chickenChange];
                
                int chickenWidth = chickenChange.contentSize.width;
                int chickenHeight= chickenChange.contentSize.height;

                [chickenItem setTextureRect:CGRectMake(0, 0, chickenWidth, chickenHeight)];
                
                [chickenItem stopAllActions];
                
                id moveTheChicken = [CCMoveTo actionWithDuration:3.0 position:ccp(chickenItem.position.x, 73)];
                id callRem = [CCCallFuncN actionWithTarget:self selector:@selector(removePera:)];
                
                [chickenItem runAction:[CCSequence actions:moveTheChicken,callRem, nil]];
                
            } 
            
            //special chicken
            if ((CGRectIntersectsRect(cornItem.boundingBox, chickenItem.boundingBox)) && (chickenItem.tag==4)) {  
                chickenItem.tag = 1;
                CCTexture2D *chickenChange = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"specialChickyParachute.png"]];
                [chickenItem setTexture: chickenChange];
                
                int chickenWidth = chickenChange.contentSize.width;
                int chickenHeight= chickenChange.contentSize.height;
                
                [chickenItem setTextureRect:CGRectMake(0, 0, chickenWidth, chickenHeight)];
                
                [chickenItem stopAllActions];
                
                id moveTheChicken = [CCMoveTo actionWithDuration:3.0 position:ccp(chickenItem.position.x, 73)];
                id callRem = [CCCallFuncN actionWithTarget:self selector:@selector(removePera:)];
                
                [chickenItem runAction:[CCSequence actions:moveTheChicken,callRem, nil]];
                
                CCLabelTTF *greatJob = [CCLabelTTF labelWithString:@"Great!, 5 Chickys Bonus!" fontName:@"Marker Felt" fontSize:32];
                greatJob.position = ccp(240,240);
                greatJob.color = ccc3(222, 28, 36);
                [greatJob runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
                
                CCLabelTTF *greatJobBack = [CCLabelTTF labelWithString:@"Great!, 5 Chickys Bonus!" fontName:@"Marker Felt" fontSize:32];
                greatJobBack.position = ccp(239,239);
                [background addChild:greatJobBack];
                [background addChild:greatJob];

                greatJobBack.color = ccc3(255, 255, 255);
                [greatJobBack runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
                
                collectedChickens = collectedChickens + 5;
                [safeChicksLabel setString:[NSString stringWithFormat:@"%d", collectedChickens]];
                [safeChicksLabelBack setString:[NSString stringWithFormat:@"%d", collectedChickens]];
                [playFile playEffect:@"Ching.wav"];
                
            }
            
            if ((CGRectIntersectsRect(cornItem.boundingBox, chickenItem.boundingBox)) && (chickenItem.tag==6)) {  
                CCLabelTTF *bonusLabel = [CCLabelTTF labelWithString:@"Bonus Points!" fontName:@"Marker Felt" fontSize:32];
                bonusLabel.position = ccp(240,240);
                bonusLabel.color = ccc3(222, 28, 36);
                [bonusLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
                
                CCLabelTTF *bonusLabelBack = [CCLabelTTF labelWithString:@"Bonus Points!" fontName:@"Marker Felt" fontSize:32];
                bonusLabelBack.position = ccp(239,239);
                [background addChild:bonusLabelBack];
                [background addChild:bonusLabel];
                
                bonusLabelBack.color = ccc3(255, 255, 255);
                [bonusLabelBack runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
                [self startRain];
                chickenItem.position = ccp(-100,-100);
                [background removeChild:chickenItem cleanup:YES];

            }
            
            if ((CGRectIntersectsRect(cornItem.boundingBox, chickenItem.boundingBox)) && (chickenItem.tag==8)) {  
                CCLabelTTF *bonusPointsLabel = [CCLabelTTF labelWithString:@"+3" fontName:@"Marker Felt" fontSize:32];
                bonusPointsLabel.position = ccp(chickenItem.position.x,chickenItem.position.y);
                bonusPointsLabel.color = ccc3(222, 28, 36);
                [bonusPointsLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
                
                CCLabelTTF *bonusPointsLabelBack = [CCLabelTTF labelWithString:@"+3" fontName:@"Marker Felt" fontSize:32];
                bonusPointsLabelBack.position = ccp(239,239);
                [background addChild:bonusPointsLabelBack];
                [background addChild:bonusPointsLabel];
                
                bonusPointsLabelBack.color = ccc3(255, 255, 255);
                [bonusPointsLabelBack runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)], nil]];
                
                collectedChickens = collectedChickens + 3;
                [safeChicksLabel setString:[NSString stringWithFormat:@"%d", collectedChickens]];
                [safeChicksLabelBack setString:[NSString stringWithFormat:@"%d", collectedChickens]];
                
                chickenItem.position = ccp(-100,-100);
                [background removeChild:chickenItem cleanup:YES];
            } 
        }
    }
}

-(void) loadAds {
//    CGSize size = [[CCDirector sharedDirector] winSize];
//    controller = [[RootViewController alloc]init];
//    controller.view.frame = CGRectMake(0,0,size.width,size.height);
//        
//    bannerView = [[GADBannerView alloc]
//                  initWithFrame:CGRectMake(75,275,
//                                           GAD_SIZE_320x50.width,
//                                           GAD_SIZE_320x50.height)];
//    
//    
//    bannerView.adUnitID = @"a14f66df4b9c771"; // your admob id
//    bannerView.rootViewController = controller;
//    
//    [bannerView loadRequest:[GADRequest request]];
//    
//    [controller.view addSubview:bannerView];
//    [[[CCDirector sharedDirector] openGLView]addSubview : controller.view];
}

-(void) loadHills {

    CCSprite *hillsSprite = [CCSprite spriteWithFile:@"grassHill.png"];
    hillsSprite.position = ccp(240,70);
    [background addChild:hillsSprite];
}

-(void) removeTilt:(id) sender {
    CCLabelTTF *tiltRemove = (CCLabelTTF*) sender;
    [background removeChild:tiltRemove cleanup:YES];
}

-(void) startTiltToMove {
    
    CCSprite *tiltToSprite = [CCSprite spriteWithFile:@"tiltToMoveDark.png"];
    tiltToSprite.position = ccp(240,130);
    [background addChild:tiltToSprite];
    
    [tiltToSprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:5.0],[CCCallFuncN actionWithTarget:self selector:@selector(removeTilt:)], nil]];
}

-(void) pauseTheGame {
    [[CCDirector sharedDirector] pause];
    pauseItem.visible = NO;
    playItem.visible = YES;
    [playFile pauseBackgroundMusic];
    allowTilting = NO;
    
    chickyPausedLabelBack = [CCLabelTTF labelWithString:@"Game Paused" fontName:@"marker felt" fontSize:56];
    chickyPausedLabelBack.position = ccp(239,181);
    chickyPausedLabelBack.color = ccc3(255, 255, 255);
    [background addChild:chickyPausedLabelBack];
    
    
    chickyPausedLabel = [CCLabelTTF labelWithString:@"Game Paused" fontName:@"marker felt" fontSize:56];
    chickyPausedLabel.position = ccp(240,180);
    chickyPausedLabel.color = ccc3(0, 113, 188);
    [background addChild:chickyPausedLabel];
    
}

-(void) playGameRestart {
    [[CCDirector sharedDirector] resume];
    pauseItem.visible = YES;
    playItem.visible = NO;
    [playFile resumeBackgroundMusic];
    [background removeChild:chickyPausedLabel cleanup:YES];
    [background removeChild:chickyPausedLabelBack cleanup:YES];
    allowTilting = YES;
}

-(void) buildPauseMenu {
    pauseItem = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseTheGame)];
    pauseItem.position = ccp(280,20);
    
    playItem = [CCMenuItemImage itemFromNormalImage:@"play.png" selectedImage:@"play.png" target:self selector:@selector(playGameRestart)];
    playItem.position = ccp(310,20);
    
    pauseMenu = [CCMenu menuWithItems:pauseItem, playItem, nil];
    pauseMenu.position = CGPointZero;
    [background addChild:pauseMenu];
    
    playItem.visible = NO;
}

-(id) init
{
    
	if( (self=[super init])) {
		self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        
        background = [CCSprite spriteWithFile:@"mainBackground.png"];
        background.position = ccp(240,160);
        [self addChild:background];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Animations.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"Animations.png"];
        [background addChild:spriteSheet z:3];        
        
        [self buildParallaxCloud];
        [self loadHills];
        [self buildChicken];
        [self createLasers];

        chickensArray = [[NSMutableArray alloc] init];
        
        // initial game settings
        collectedChickens = 0;     
        gameRunningTime = 0;
        gameSpeed = 4.0;
        playerLife = 4;
        specialChickenTimer = 0;
        chickenAttachedSum = 0;
        allowTilting = YES;
        
        miniX = 10;
        miniY = 5;
        
        timeCounterLabel = [CCLabelTTF labelWithString:@"" fontName:@"marker felt" fontSize:26];
        timeCounterLabel.position = ccp(60,20);
        timeCounterLabel.color = ccc3(222, 28, 36);
        [timeCounterLabel setString:@"0:00"];
        
        timeCounterLabelBack = [CCLabelTTF labelWithString:@"" fontName:@"marker felt" fontSize:26];
        timeCounterLabelBack.position = ccp(59,19);
        timeCounterLabelBack.color = ccc3(255, 255, 255);
        [timeCounterLabelBack setString:@"0:00"];
        
        [background addChild:timeCounterLabelBack];
        [background addChild:timeCounterLabel];

        CCSprite *chickenLife = [CCSprite spriteWithFile:@"chickenSmallLives.png"];
        chickenLife.position = ccp(220,20);
        [background addChild:chickenLife];
        
        playerLifeLabel = [CCLabelTTF labelWithString:@"" fontName:@"marker felt" fontSize:20];
        playerLifeLabel.position = ccp(240,20);
        playerLifeLabel.color = ccc3(222, 28, 36);
        [playerLifeLabel setString:[NSString stringWithFormat:@"%d",playerLife]];
        [background addChild:playerLifeLabel];
        
        safeChicksLabel = [CCLabelTTF labelWithString:@"0" fontName:@"marker felt" fontSize:26];
        safeChicksLabel.position = ccp(420,20);
        safeChicksLabel.color = ccc3(222, 28, 36);
        
        safeChicksLabelBack = [CCLabelTTF labelWithString:@"0" fontName:@"marker felt" fontSize:26];
        safeChicksLabelBack.position = ccp(419,19);
        safeChicksLabelBack.color = ccc3(255, 255, 255);
        
        [background addChild:safeChicksLabelBack];        
        [background addChild:safeChicksLabel];

        eggRainTimer = 0;
        [self schedule:@selector(timerUpdate) interval:1.0];
        [self scheduleUpdate];

        [playFile stopBackgroundMusic];
        [playFile playBackgroundMusic:@"MainLoop.mp3"];
        
        [self startTiltToMove];
        [self buildPauseMenu];
        eggRainCounter = 15;
        
	}
	return self;
}

-(void) pushChicken {
//    CCTexture2D *miniChicken = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"chickyLanded.png"]];
//    
//    if (chickenAttachedSum < 5) {
//        CCSprite *miniChickenSprite = [CCSprite spriteWithTexture:miniChicken];
//        miniChickenSprite.position = ccp(miniX,miniY);
//        [self.theChicken addChild:miniChickenSprite];
//        chickenAttachedSum = 0;
//        miniX = miniX + 10;
//    }
}

-(void) removeTheSun:(id) sender {
    CCSprite *sunSprite = (CCSprite*) sender;
    [background removeChild:sunSprite cleanup:YES];
}

-(void) removeTheLabel:(id) sender {
    CCLabelTTF *sunLabel = (CCLabelTTF*) sender;
    [background removeChild:sunLabel cleanup:YES];
}

-(void) checkSun:(CGPoint) hitPoint {
    chickenAttachedSum ++;
    if (chickenAttachedSum == 10) {
        CCSprite *sunSprite = [CCSprite spriteWithFile:@"TheSun.png"];
        hitPoint.y   = hitPoint.y + (arc4random() % 100);
        sunSprite.position = hitPoint;
        [background addChild:sunSprite];
        
        CCLabelTTF *sunLabel = [CCLabelTTF labelWithString:@"" fontName:@"marker felt" fontSize:16];
        sunLabel.position = hitPoint;
        sunLabel.color = ccc3(0, 113, 188);
        
        id desolveLabel = [CCFadeOut actionWithDuration:5.0];
        id removeLabel = [CCCallFuncN actionWithTarget:self selector:@selector(removeTheLabel:)];
         
        [sunLabel setString:[NSString stringWithFormat:@"%d", collectedChickens]];
        [sunLabel runAction:[CCSequence actions:desolveLabel,removeLabel, nil]];
        [background addChild:sunLabel];
        
        
        id desolveSun = [CCFadeOut actionWithDuration:5.0];
        id removeSun = [CCCallFuncN actionWithTarget:self selector:@selector(removeTheSun:)];
        id rotateSun = [CCRotateBy actionWithDuration:10.0 angle:100]; 
        [sunSprite runAction:rotateSun]; 
        [sunSprite runAction:[CCSequence actions:desolveSun,removeSun, nil]];
        
        chickenAttachedSum = 0;
    }
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if (allowTilting == YES) {
        int dataX = theChicken.position.x;
        
        if(acceleration.y < -0.25) {  // tilting the device to the right
            dataX = dataX - (acceleration.y * 50);
            theChicken.flipX = YES;
        }
        else if (acceleration.y > 0.25) {  // tilting the device to the left
            dataX = dataX - (acceleration.y * 50);
            theChicken.flipX = NO;
            
        }
        
        if (dataX < 60) dataX = 65;
        if (dataX > 420) dataX = 420;
        
        
        theChicken.position = ccp(dataX, theChicken.position.y);
        
        for (CCSprite *dropingChickens in chickensArray) {
            if ((CGRectIntersectsRect(dropingChickens.boundingBox, theChicken.boundingBox)) && (dropingChickens.tag == 1)) {  
                CGPoint theHit = dropingChickens.position;
                [self checkSun:theHit];            
                dropingChickens.position = ccp(-50,-50);
                [background removeChild:dropingChickens cleanup:YES];  
                collectedChickens++;
                [safeChicksLabel setString:[NSString stringWithFormat:@"%d", collectedChickens]];
                [safeChicksLabelBack setString:[NSString stringWithFormat:@"%d", collectedChickens]];
                [playFile playEffect:@"Ching.wav"];
            }
        }
    }
} 

- (void)setInvisible:(CCNode *)node {
    node.position = ccp(-5,-50);
    node.visible = NO;
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CCSprite *newCornLaser = [cornLaser objectAtIndex:nextCornLaser];
    nextCornLaser++;
    if (nextCornLaser >= cornLaser.count) nextCornLaser = 0;
    
    int laserOutX = theChicken.position.x;//  (theCar.contentSize.width / 2);
    
    if (theChicken.flipX==YES) {
        laserOutX = laserOutX -25;
    }
    else {
        laserOutX = laserOutX + 25;
    }
    
    
    newCornLaser.position = ccp(laserOutX,100);
    newCornLaser.visible = YES;
    [newCornLaser stopAllActions];
    [newCornLaser runAction:[CCSequence actions:
                         [CCMoveTo actionWithDuration:0.3 position:ccp(location.x, location.y)],
                         [CCCallFuncN actionWithTarget:self selector:@selector(setInvisible:)],
                         nil]];
    [playFile playEffect:@"Tap.wav"];
}


- (void) dealloc
{
    
	[super dealloc];
}


@end


















