//
//  STToneRecognitionManager.h
//  SoftToneRecognition
//
//  Created by Xuchen Wu on 3/02/2015.
//  Copyright (c) 2015 LogicSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LGAction.h"
#import <AVFoundation/AVFoundation.h>

@protocol LGToneManagerDelegate <NSObject>
- (void)actionListUpdated:(NSArray *)actions;
- (void)notificationTapped;
@end

@interface LGToneManager : NSObject
/**
 *  The singleton instance of the class
 *
 *  @return the singleton instance
 */
+ (instancetype)sharedManager;

/**
 *  Block to return AVPlayer instance when it is ready
 */
typedef void (^OnPlayerReadyBlock)(AVPlayer*, NSError *);

/**
 *  This method should be called in the AppDelegate.m under 
 *  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions method
 *
 *  @param application   pass from AppDelegate
 *  @param launchOptions pass from AppDelegate
 *
 *  @return true if operation is success, false otherwise
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 *  THis method should be called in the AppDelegate.m under 
 *  - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification method
 *
 *  @param application  pass from AppDelegate
 *  @param notification pass from AppDelegate
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

/**
 *  Configuration method for the framework manager
 *
 *  @param clientName The name of the client (customer Ex: "Patala")
 *  @param hostName   The host name of the client's backend server (Ex : "tone.lab.inciteinformatics.com")
 */
- (void)configureManagerClientName:(NSString*)clientName hostName:(NSString*)hostName;

/**
 *  Prepare AVPlayer by initialising it with the URL and adding a tap to recognize tones from the played audio stream
 *
 *  @param url audio resource URL
 *  @param onPlayerReady returns AVPlayer intance when ready.
 */
- (void) prepareAVPlayerForURL:(NSURL*)url onPlayerReady:(OnPlayerReadyBlock)playerReady;

/**
 *  if set to YES and when a notification is created about an action while app is in background, The framework will process
 *  the action, if set to false, the client will be notified by LGToneManagerDelegate.notificationTapped
 *
 *  @param value BOOL
 */
- (void)handleNotificationsInFramework:(BOOL)value;

/**
 *  whether the framework should ignore the same sequence within 15 seconds.
 *  if set to yes, the action will be notified to user after 15 seconds when the same sequence is detected.
 *  if set to no, the action will be notified as soon as the sequence is detected
 *
 *  default is yes.
 *
 *  @param value BOOL
 */
- (void)shouldIgnoreSameSequenceInFramework:(BOOL)value;

/**
 *  Start the tone recognition through mic input
 */
- (void)start;

/**
 *  Stop the tone recognition through mic input
 */
- (void)stop;

/**
 *  Get all the actions in the cache that maybe missed by client
 *
 *  @return the array of all recognized actions
 */
- (NSArray*)getActions;

/**
 *  Get all the actions in the cache that maybe missed by client, the actions will be sorted by actionDateTime
 *
 *  @param value BOOL
 *  @return the array of all recognized actions
 */
- (NSArray*)getSortedActions:(BOOL)ascending;
/**
 *  Delete action at given index
 *
 *  @param index the index of the action to be deleted
 */
- (void) deleteActionAtIndex:(int) index;


/**
 *  Deletes all the actions in the cache
 */
- (void) deleteAllActions;

/**
 *  The delegate object that should be notified once an action is recognized.
 */
@property (strong, nonatomic) id<LGToneManagerDelegate> delegate;
@end
