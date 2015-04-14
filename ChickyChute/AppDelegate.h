//
//  AppDelegate.h
//  ChickyChute
//
//  Created by Shachar Udi on 4/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "FBConnect.h"


@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>
{
	UIWindow			*window;
	RootViewController	*viewController;
    Facebook *facebook;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) Facebook *facebook;

@end
