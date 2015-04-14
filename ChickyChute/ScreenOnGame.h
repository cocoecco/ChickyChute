//
//  ScreenOnGame.h
//  ChickyChute
//
//  Created by Shachar Udi on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "ScreenGameOver.h"
#import "GADBannerView.h"
#import "RootViewController.h"


@interface ScreenOnGame : CCLayer
{

    GADBannerView *bannerView;
    RootViewController *controller;
    
    CCSprite *background;
    CCSprite *cloudsSprite;
    
    CCLabelTTF *timeCounterLabel;
    CCLabelTTF *safeChicksLabel;

    CCLabelTTF *timeCounterLabelBack;
    CCLabelTTF *safeChicksLabelBack;
    CCLabelTTF *playerLifeLabel;
    CCLabelTTF *chickyPausedLabel;
    CCLabelTTF *chickyPausedLabelBack;


    
    NSMutableArray *chickensArray;
    CCSpriteBatchNode *spriteSheet;
    
    CCParallaxNode *skyParallaxNode;
    
    CCMenu *pauseMenu;
    CCMenuItem *pauseItem;
    CCMenuItem *playItem;
    
    CCSprite *theChicken;
    CCAction *moveChicken;
    BOOL _moving;
    BOOL allowTilting;
    CCArray *cornLaser;
    int nextCornLaser;
    
    int gameRunningTime;
    int collectedChickens;
    float gameSpeed;
    int playerLife;
    
    int rainChickensAdded;
    
    int miniX,miniY;
    
    int specialChickenTimer;
    int eggRainCounter;
    int eggRainTimer;
    int chickenAttachedSum;
}

+(CCScene *) scene;
- (void)update:(ccTime)dt;
-(void) produceEggRainCounter;


@property (nonatomic, retain) CCSprite *theChicken;
@property (nonatomic, retain) CCAction *moveChicken;

@end






