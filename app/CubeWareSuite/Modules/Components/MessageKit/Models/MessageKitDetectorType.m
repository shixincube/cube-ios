//
//  MessageKitDetectorType.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitDetectorType.h"

@implementation MessageKitDetectorType


#pragma mark - Getter

-(NSTextCheckingType)resultType{
    switch (self.type) {
        case MKDetectorType_address:
            return NSTextCheckingTypeAddress;
            break;
        case MKDetectorType_date:
            return NSTextCheckingTypeDate;
            break;
        case MKDetectorType_phoneNumber:
            return NSTextCheckingTypePhoneNumber;
            break;
        case MKDetectorType_url:
            return NSTextCheckingTypeLink;
            break;
        case MKDetectorType_transitInformation:
            return NSTextCheckingTypeTransitInformation;
            break;
        case MKDetectorType_custom:
            return NSTextCheckingTypeRegularExpression;
            break;
        default:
            return NSTextCheckingTypeRegularExpression;
            break;
    }
}

-(BOOL)isCustom{
    return self.type == MKDetectorType_custom;
}


-(NSUInteger)hash{
    return [self toInt];
}

-(BOOL)isEqual:(id)object{
    if ([[self class] isKindOfClass:[object class]] && ((MessageKitDetectorType *)object).type == self.type && ((MessageKitDetectorType *)object).regex.hash == self.regex.hash) {
        return YES;
    }
    return NO;
}

#pragma mark - Private
- (NSUInteger)toInt{
    switch (self.type) {
        case MKDetectorType_address:
            return 0;
        case MKDetectorType_date:
            return 1;
        case MKDetectorType_phoneNumber:
            return 2;
        case MKDetectorType_url:
            return 3;
        case MKDetectorType_transitInformation:
            return 4;
        case MKDetectorType_custom:
            return self.regex.hash;
        default:
            return MKDetectorType_address;
            break;
    }
}


@end
