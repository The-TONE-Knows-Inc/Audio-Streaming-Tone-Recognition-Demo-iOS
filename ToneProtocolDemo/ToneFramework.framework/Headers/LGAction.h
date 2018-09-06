//
//  LGAction.h
//  SoftToneRecognition
//
//  Created by Xuchen Wu on 20/01/2015.
//  Copyright (c) 2015 logicsolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LGActionType){
    kActionTypeNone,
    kActionTypeUrl,
    kActionTypeImage,
    kActionTypeEmail,
};

@interface LGAction : NSObject
+ (instancetype)actionWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, assign, readonly) LGActionType actionType;
@property (nonatomic, strong, readonly) NSString* actionURL;
@property (nonatomic, strong, readonly) NSString* actionTypeString;
@property (nonatomic, strong) NSDate* actionDateTime;
@end
