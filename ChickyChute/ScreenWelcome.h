//
//  ScreenWelcome.h
//  ChickyChute
//
//  Created by Shachar Udi on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "ScreenOnGame.h"
#import "ScreenInfo.h"

@interface ScreenWelcome : CCLayer
{
    CCSprite *background;
    CCMenu *welcomeMenu;
    CCMenuItem *muteItem;
    CCMenuItem *unMuteItem;
}


+(CCScene *) scene;
-(void) clickUnMute;

@end
