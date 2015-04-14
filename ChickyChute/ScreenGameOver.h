//
//  ScreenGameOver.h
//  ChickyChute
//
//  Created by Shachar Udi on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Globals.h"
#import "ScreenWelcome.h"
#import "Facebook.h"
#import "FBConnect.h"
#import "AppDelegate.h"

@interface ScreenGameOver : CCLayer 
{
    CCSprite *background;
    BOOL isFacebookConnected;
    AppDelegate *myAppDelegate;

}

+(CCScene *) scene;
+(void)showPostMessege:(NSString*) returnMessege;

@property (nonatomic, retain) Facebook *facebook;

@end
