//
//  ToneFramework.h
//  ToneFramework
//
//  Created by Xuchen Wu on 10/02/2015.
//  Copyright (c) 2015 LogicSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ToneFramework.
FOUNDATION_EXPORT double ToneFrameworkVersionNumber;

//! Project version string for ToneFramework.
FOUNDATION_EXPORT const unsigned char ToneFrameworkVersionString[];

/*
 - Version: 0.0.4
 
 - Required frameworks:
 1. Foundation.framework
 2. UIKit.framework
 3. CoreLocation.framework
 
 - Supported Action Type:
 1. Open URL   e.g. actionType returns "webpage" and the framework will try to open this url
 2. Open Image e.g. actionType returns "image" and the framework will try to open this image
 3. TBC
 
 - Integrate instructions
 1. Open your Xcode and create a new iOS project in Objective-C, let's Call it "PROJECT"
 2. Go to your "PROJECT" folder and then copy the framework "ToneFramework.framework" from you svn to anywhere you like in the "PROJECT"
 3. In your Xcode, drag and drop the framework file from the finder to the Xcode project hierarchy
 4. Select your project in the right side of the Xcode and in the middle window of Xcode, then select the target, then navigate to "Build Phrases" ->  "Embed Frameworks", then add "ToneFramework.framework"
 5. (iOS8+ required) Add "NSLocationWhenInUseUsageDescription" key in "info.plist"
    Select your project in the right side of the Xcode and in the middle window of Xcode, then select the target, then navigate to "Info" -> "Custom iOS Target Properties", add key "NSLocationWhenInUseUsageDescription" and set type to "String", set value to "THE_INFO_YOU_WANT_TO_SHOW"
    (Note: the location service will be started/stopped when the manager invokes start/stop)
 
 6. Add "Required background modes" key in "info.plist" (Background Mode Configuration, do this part if the app need to run on background)
    Select your project in the right side of the Xcode and in the middle window of Xcode, then select the target, then navigate to "Info" -> "Custom iOS Target Properties", add key
        "Required background modes" and set type to "Array"
        Add one item in the array and set type to "String", set value to "App registers for location updates"
        Add another item in the array and set type to "String", set value to "App plays audio or streams audio/video using AirPlay"
 
 - API Interface:
 1. #import <ToneFramework/ToneFramework.h>
 2. Create your own manager
    LGToneManager* manager = [LGToneManager sharedManager];
 3. Configure your mananger
	[manager configureManagerClientName:@"CLIENT_NAME" hostName:@"HOST_NAME"]
 4. When you want to start call
	[manager start];
 5. When you want to stop call
	[manager stop];
 */



#import <ToneFramework/LGToneManager.h>
#import <ToneFramework/LGAction.h>
