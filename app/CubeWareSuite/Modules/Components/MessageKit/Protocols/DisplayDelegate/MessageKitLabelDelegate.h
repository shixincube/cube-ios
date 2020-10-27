//
//  MessageKitLabelDelegate.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A protocol used to handle tap events on detected text.
@protocol MessageKitLabelDelegate <NSObject>

/// Triggered when a tap occurs on a detected address.
- (void)didSelectAddress:(NSDictionary *)addressComponents;

/// Triggered when a tap occurs on a detected date.
- (void)didSelectDate:(NSDate *)date;

/// Triggered when a tap occurs on a detected phone number.
- (void)didSelectPhoneNumber:(NSString *)phoneNumber;

/// Triggered when a tap occurs on a detected URL.
- (void)didSelectURL:(NSURL *)url;

/// Triggered when a tap occurs on detected transit information.
- (void)didSelectTransitInformation:(NSDictionary *)transitInformation;

/// Triggered when a tap occurs on a mention
- (void)didSelectMention:(NSString *)mention;

/// Triggered when a tap occurs on a hashtag
- (void)didSelectHashtag:(NSString *)hashtag;

/// Triggered when a tap occurs on a custom regular expression
- (void)didSelectCustom:(NSString *)pattern match:(NSString *)match;

@end
