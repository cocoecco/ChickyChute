//
//  ScreenWelcome.m
//  ChickyChute
//
//  Created by Shachar Udi on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenWelcome.h"

@implementation ScreenWelcome

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    ScreenWelcome *layer = [ScreenWelcome node];
    [scene addChild: layer];
    return scene;
}



-(void) clickStartGame {
    [playFile playEffect:@"Tap.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[ScreenOnGame scene]]];
}

-(void) clickInfo {
    [playFile playEffect:@"Tap.wav"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[ScreenInfo scene]]];
}

-(void) clickMute {
    [CDAudioManager sharedManager].mute = TRUE;
    muteItem.visible = FALSE;
    unMuteItem.visible = TRUE;
}

-(void) clickUnMute {
    [CDAudioManager sharedManager].mute = FALSE;
    unMuteItem.visible = FALSE;
    muteItem.visible = TRUE;
}


-(id) init
{

	if( (self=[super init])) {
		background = [CCSprite spriteWithFile:@"WelcomeBackground.png"];
        background.position = ccp(240,160);
        [self addChild:background];
        
        CCSprite *chickyTitle = [CCSprite spriteWithFile:@"ChickyTitle.png"];
        chickyTitle.position = ccp(240,200);
        [background addChild:chickyTitle];
        
        // Scale Title
        chickyTitle.scale = 0.2;
        id scaleChicky = [CCScaleTo actionWithDuration:0.5 scale:1.0];
        [chickyTitle runAction:scaleChicky];
        
        //Chicky Menu :)
        CCMenuItem *btnStartGame = [CCMenuItemImage itemFromNormalImage:@"BtnStartUp.png" selectedImage:@"BtnStartDown.png" target:self selector:@selector(clickStartGame)];
        CCMenuItem *btnInfo = [CCMenuItemImage itemFromNormalImage:@"infoStatic.png" selectedImage:@"infoEngaged.png" target:self selector:@selector(clickInfo)];
        
        muteItem = [CCMenuItemImage itemFromNormalImage:@"MuteUp.png" selectedImage:@"MuteUp.png" target:self selector:@selector(clickMute)];
        muteItem.position = ccp(440,280);
                
        unMuteItem = [CCMenuItemImage itemFromNormalImage:@"MuteDown.png" selectedImage:@"MuteDown.png" target:self selector:@selector(clickUnMute)];
        unMuteItem.position = ccp(440,280);
        unMuteItem.visible = FALSE;
        
        btnStartGame.position = ccp(350,50);
        btnInfo.position      = ccp(110,50);
        
        welcomeMenu = [CCMenu menuWithItems:btnStartGame, btnInfo,muteItem,unMuteItem, nil];
        welcomeMenu.position = CGPointZero;
        [background addChild:welcomeMenu];
    
        [playFile stopBackgroundMusic];
        [playFile playBackgroundMusic:@"EndLoop.mp3"];
        
        [self clickUnMute];
        
	}
	return self;
}

- (void) dealloc
{

	[super dealloc];
}


@end












