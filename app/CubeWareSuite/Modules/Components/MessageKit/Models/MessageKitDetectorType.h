//
//  MessageKitDetectorType.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MKDetectorType_address,
    MKDetectorType_date,
    MKDetectorType_phoneNumber,
    MKDetectorType_url,
    MKDetectorType_transitInformation,
    MKDetectorType_custom,
    MKDetectorType_hashtag,
    MKDetectorType_mention,
} MKDetectorType;

@interface MessageKitDetectorType : NSObject

@property (nonatomic , assign) MKDetectorType type;

@property (nonatomic , assign) NSTextCheckingType resultType;

@property (nonatomic , assign) BOOL isCustom;

// if is custome 
@property (nonatomic , strong) NSRegularExpression *regex;


@end

NS_ASSUME_NONNULL_END
