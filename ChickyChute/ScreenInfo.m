//
//  ScreenInfo.m
//  ChickyChute
//
//  Created by Shachar Udi on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenInfo.h"

@implementation ScreenInfo

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    ScreenInfo *layer = [ScreenInfo node];
    [scene addChild: layer];
    return scene;
}

-(void) kirbyLinkClick {
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://rklancaster.com"]];
}

-(void) clickCocoEcco {
    UIApplication *app = [UIApplication sharedApplication];
    
    [app openURL:[NSURL URLWithString:@"http://www.cocoecco.com"]];
    
}

-(void) clickBack {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[ScreenWelcome scene]]];
}

-(id) init
{
    
	if( (self=[super init])) {
		self.isTouchEnabled = YES;
        
        background = [CCSprite spriteWithFile:@"iBackground.png"];
        background.position = ccp(240,160);
        [self addChild:background];
        
        
        CCMenuItem *kirbyLink = [CCMenuItemImage itemFromNormalImage:@"infoPageRklancasterLinkButton.png" selectedImage:@"infoPageRklancasterLinkButton.png" target:self selector:@selector(kirbyLinkClick)];
        
        
        CCMenuItem *mnuCocoEcco = [CCMenuItemImage itemFromNormalImage:@"iCocoEcco2012.png" selectedImage:@"iCocoEcco2012.png" target:self selector:@selector(clickCocoEcco)];
        
        
        CCMenuItem *btnBack = [CCMenuItemImage itemFromNormalImage:@"infoPageBackStatic.png" selectedImage:@"infoPageBackEngaged.png" target:self selector:@selector(clickBack)];
        
        kirbyLink.anchorPoint = CGPointZero;
        mnuCocoEcco.position = CGPointZero;
        
        kirbyLink.position = ccp(20,20);
        mnuCocoEcco.position = ccp(110,50);

        btnBack.position = ccp(380,40);
        
        CCMenu *infoMenu = [CCMenu menuWithItems:kirbyLink,btnBack,mnuCocoEcco, nil];
        infoMenu.position = CGPointZero;
        [background addChild:infoMenu];

	}
	return self;
}


@end







