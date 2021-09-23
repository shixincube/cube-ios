/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "CubeAppUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

@implementation CubeAppUtil


+ (NSString *)makeMD5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}


+ (NSString *)desensitizePhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length == 11) {
        return [NSString stringWithFormat:@"%@****%@",
                [phoneNumber substringToIndex:3],
                [phoneNumber substringFromIndex:7]];
    }
    else if (phoneNumber.length == 0) {
        return @"";
    }
    else {
        NSMutableString * buf = [[NSMutableString alloc] initWithString:[phoneNumber substringToIndex:2]];
        for (NSInteger i = 0, len = phoneNumber.length - 4; i < len; ++i) {
            [buf appendString:@"*"];
        }
        [buf appendString: [phoneNumber substringFromIndex: phoneNumber.length - 2]];
        return buf;
    }
}


+ (NSURLSessionDataTask *)postURL:(NSString *)url
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
    NSSet * acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 3;
    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    return [manager POST:url parameters:parameters headers:nil progress:nil success:success failure:failure];
}

+ (NSString *)explainAvatarName:(NSString *)avatarName {
    if ([avatarName isEqualToString:@"default"]) {
        return @"AvatarDefault";
    }
    else if ([avatarName isEqualToString:@"avatar01"]) {
        return @"Avatar01";
    }

    return avatarName;
}

+ (NSString*)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceModel;
}

@end
