//
//  ScreenGameOver.m
//  ChickyChute
//
//  Created by Shachar Udi on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenGameOver.h"

@implementation ScreenGameOver
@synthesize facebook;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    ScreenGameOver *layer = [ScreenGameOver node];
    [scene addChild: layer];
    return scene;
}

-(void) clickStartGame {
    [playFile playEffect:@"Tap.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[ScreenWelcome scene]]];
}



-(void) postScreenShot {
//    UIImage *screenshot = [[CCDirector sharedDirector] screenshotUIImage];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:screenshot, @"picture",nil];
//    
//    [facebook requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:self];
    
}

+(void)showPostMessege:(NSString*) returnMessege {


}

-(void) fbDidLogout {
    
}

-(void) removeLabel:(CCLabelTTF*) theLabel {
    [background removeChild:theLabel cleanup:YES];
}

-(void) clickFacebook {
    [playFile playEffect:@"Tap.wav"];
    if (![facebook isSessionValid])
    {
        facebook = [[Facebook alloc] initWithAppId:@"319215194800679"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        if (![facebook isSessionValid]) {
            NSArray *permissions = [[NSArray alloc] initWithObjects:
                                    @"user_likes", 
                                    @"read_stream",
                                    @"publish_stream",
                                    @"offline_access",
                                    nil];        
            
            [facebook authorize:permissions delegate:myAppDelegate];
        }
    } 
    else
    {   
        UIImage *screenshot = [[CCDirector sharedDirector] screenshotUIImage];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       screenshot, @"picture",
                                       nil];
        
        [facebook requestWithGraphPath:@"me/photos"
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:myAppDelegate];
    }

    
}




-(void) clickLogout {
    [playFile playEffect:@"Tap.wav"];
    [facebook logout:myAppDelegate];
    
    UIView* view = [[CCDirector sharedDirector] openGLView];
    
    UIAlertView *topScore = [[UIAlertView alloc] initWithTitle: @"Logout" message: @"Facebook Logout. Login to your account to post your high score" delegate: self cancelButtonTitle: @"Great!" otherButtonTitles: nil, nil];
    [view addSubview: topScore];
    [topScore show];
    
}

-(void) clickRate {
    [playFile playEffect:@"Tap.wav"];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/chicky-chute/id511456133?ls=1&mt=8"]];
}

-(void) clickCocoEcco {
    [playFile playEffect:@"Tap.wav"];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://www.cocoecco.com"]];
}

-(void) clickKirby {
    [playFile playEffect:@"Tap.wav"];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://rklancaster.com"]];
}

-(void) setLabels {
    
    CCLabelTTF *timeLabel = [CCLabelTTF labelWithString:@"0:00" fontName:@"marker felt" fontSize:22];
    timeLabel.anchorPoint  = ccp(0,0);
    timeLabel.position = ccp(350,100);
    
    CCLabelTTF *timeLabelBack = [CCLabelTTF labelWithString:@"0:00" fontName:@"marker felt" fontSize:22];
    timeLabelBack.anchorPoint  = ccp(0,0);
    timeLabelBack.position = ccp(349,99);
    timeLabelBack.color = ccc3(255, 255, 255);
    [background addChild:timeLabelBack];  
    [background addChild:timeLabel];

    
    CCLabelTTF *countLabel = [CCLabelTTF labelWithString:@"Safe" fontName:@"marker felt" fontSize:22];
    countLabel.anchorPoint = ccp(0,0);
    countLabel.position = ccp(355,140);
        
    CCLabelTTF *countLabelBack = [CCLabelTTF labelWithString:@"Safe" fontName:@"marker felt" fontSize:22];
    countLabelBack.anchorPoint = ccp(0,0);
    countLabelBack.position = ccp(354,139);
    countLabelBack.color = ccc3(255, 255, 255);
    [background addChild:countLabelBack];
    [background addChild:countLabel];    

    
    timeLabel.color = ccc3(222, 28, 36);
    countLabel.color = ccc3(222, 28, 36);
    
    

    
    int minuts;
    minuts = globalGameTime / 60;
    int seconds = globalGameTime - (minuts * 60);
    
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%.2d%", minuts, seconds];
    [timeLabel setString:timerOutput];
    [timeLabelBack setString:timerOutput];

    
    NSString *coughtChickens = [NSString stringWithString:@""];
    coughtChickens = [coughtChickens stringByAppendingFormat:@"%d", globalChicksCought];
    [countLabel setString:coughtChickens];
    [countLabelBack setString:coughtChickens];

    
    
    //Chicky Menu :)
    CCMenuItem *btnRate = [CCMenuItemImage itemFromNormalImage:@"gsEggStatic.png" selectedImage:@"gsEggEngaged.png" target:self selector:@selector(clickRate)];
    CCMenuItem *btnStartGame = [CCMenuItemImage itemFromNormalImage:@"gsEggStatic.png" selectedImage:@"gsEggEngaged.png" target:self selector:@selector(clickStartGame)];
    CCMenuItem *btnFacebook = [CCMenuItemImage itemFromNormalImage:@"gsFaceYellow.png" selectedImage:@"gsFaceYellow.png" target:self selector:@selector(clickFacebook)];    

    CCMenuItem *logoutMenu = [CCMenuItemImage itemFromNormalImage:@"gsFacebookOutline.png" selectedImage:@"gsFacebookOutline.png" target:self selector:@selector(clickLogout)]; 
    
    CCMenuItem *mnuCocoEcco = [CCMenuItemImage itemFromNormalImage:@"gsCocoEcco2012.png" selectedImage:@"gsCocoEcco2012.png" target:self selector:@selector(clickCocoEcco)]; 
    CCMenuItem *mnuKirby = [CCMenuItemImage itemFromNormalImage:@"gsGraphicDesign.png" selectedImage:@"gsGraphicDesign.png" target:self selector:@selector(clickKirby)]; 
    
    mnuCocoEcco.anchorPoint = CGPointZero;
    mnuKirby.anchorPoint = CGPointZero;
    
    mnuCocoEcco.position = ccp(30,30);
    mnuKirby.position = ccp(30,10);
    
    myAppDelegate = [[AppDelegate alloc] init];
    
    btnRate.position = ccp(440,72);
    btnStartGame.position = ccp(440,32);
    
    btnFacebook.position = ccp(40,120);
    logoutMenu.position = ccp(40,80);

    
    CCMenu *welcomeMenu = [CCMenu menuWithItems:btnRate, btnStartGame,btnFacebook,logoutMenu,mnuCocoEcco,mnuKirby, nil];
    welcomeMenu.position = CGPointZero;
    [background addChild:welcomeMenu];
    
//    int scaleNumber = 0;
//    if (globalChicksCought > 2) scaleNumber = 1;
//    if (globalChicksCought > 4) scaleNumber = 2;
//    if (globalChicksCought > 6) scaleNumber = 3;
//    if (globalChicksCought > 8) scaleNumber = 4;
//    if (globalChicksCought > 10) scaleNumber = 5;
//    if (globalChicksCought > 12) scaleNumber = 6;
//    if (globalChicksCought > 14) scaleNumber = 7;
//
//    NSString *scaleFileName = [NSString stringWithString:@"Scale"];
//    scaleFileName = [scaleFileName stringByAppendingFormat:@"%d", scaleNumber];
//    scaleFileName = [scaleFileName stringByAppendingString:@".png"];
//    
//    CCSprite *scaleSprite = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:scaleFileName]];
//    scaleSprite.position = ccp(40,75);
//    [background addChild:scaleSprite];
}

-(void) askToFacebookPost {
    UIView* view = [[CCDirector sharedDirector] openGLView];
    
    UIAlertView *topScore = [[UIAlertView alloc] initWithTitle: @"New High Score!" message: @"New High Score! You can post this screen to facebook using the yellow facebook button!" delegate: self cancelButtonTitle: @"Great!" otherButtonTitles: nil, nil];
    [view addSubview: topScore];
    [topScore show];
}

-(void) checkRecord {
    NSUserDefaults *gameRecord = [NSUserDefaults standardUserDefaults];
    NSNumber *gameRecordInt = [gameRecord objectForKey:@"record"];
    if (gameRecordInt == nil) {
        gameRecordInt = [NSNumber numberWithInt:0];
    }
    
    if ([gameRecordInt intValue] < globalChicksCought) {
        NSNumber *newRecord = [NSNumber numberWithInt:globalChicksCought];
        [gameRecord setObject:newRecord forKey:@"record"];
        [gameRecord synchronize];
        
        if (globalChicksCought > 50) {
            [self askToFacebookPost];
        }
        
    }
    
    NSUserDefaults *recordInfo = [NSUserDefaults standardUserDefaults];
    NSNumber *recordNumber = [recordInfo objectForKey:@"record"];
    
    CCSprite *recordSprite = [CCSprite spriteWithFile:@"highScore.png"];
    recordSprite.position = ccp(300,240);
    [background addChild:recordSprite];
    
    CCLabelTTF *highScoreLabelBack = [CCLabelTTF labelWithString:@"" fontName:@"marker felt" fontSize:20];
    highScoreLabelBack.position = ccp(375,230);
    highScoreLabelBack.anchorPoint = ccp(0,0);
    highScoreLabelBack.color = ccc3(255, 255, 255);
    [highScoreLabelBack setString:[NSString stringWithFormat:@"%d",[recordNumber intValue]]];
    [background addChild:highScoreLabelBack];
    
    CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"marker felt" fontSize:20];
    highScoreLabel.position = ccp(376,229);
    highScoreLabel.anchorPoint = ccp(0,0);
    highScoreLabel.color = ccc3(222, 28, 36);
    [highScoreLabel setString:[NSString stringWithFormat:@"%d",[recordNumber intValue]]];
    [background addChild:highScoreLabel];
    
    
}


-(id) init
{
    
	if( (self=[super init])) {
		self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        background = [CCSprite spriteWithFile:@"gsBackground.png"];
        background.position = ccp(240,160);
        [self addChild:background];
        
        [self checkRecord];
        
        CCSprite *endGameTitle = [CCSprite spriteWithFile:@"gsChickyChuteLOGOSmall.png"];
        endGameTitle.position = ccp(100,260);
        [background addChild:endGameTitle];
        
        // Scale Title
        endGameTitle.scale = 0.2;
        id scaleTitle = [CCScaleTo actionWithDuration:0.5 scale:1.0];
        [endGameTitle runAction:scaleTitle];
        
        CCSprite *endScoresTitle = [CCSprite spriteWithFile:@"gsGameScore.png"];
        endScoresTitle.position = ccp(288,200);
        [background addChild:endScoresTitle];
        endScoresTitle.scale = 0.2;
        id scaleScores = [CCScaleTo actionWithDuration:1.5 scale:1];
        [endScoresTitle runAction:scaleScores];
        
        
        
        
        [playFile stopBackgroundMusic];
        [playFile playEffect:@"End.mp3"];
        
        
        
        [self setLabels];
	}
	return self;
}



- (void) dealloc
{
    
	[super dealloc];
}




@end









