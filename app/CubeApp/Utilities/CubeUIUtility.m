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

#import "CubeUIUtility.h"

@implementation CubeUIUtility

+ (void)showLoading:(NSString *)title {
    [SVProgressHUD showWithStatus:title];
}

+ (void)hideLoading {
    [CubeUIUtility hideLoadingWithCompletion:nil];
}

+ (void)hideLoadingWithDelay:(NSTimeInterval)delay {
    [CubeUIUtility hideLoadingWithDelay:delay completion:nil];
}

+ (void)hideLoadingWithCompletion:(void (^)(void))completion {
    [SVProgressHUD dismissWithCompletion:completion];
}

+ (void)hideLoadingWithDelay:(NSTimeInterval)delay completion:(void (^)(void))completion {
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

+ (BOOL)isLoadingVisible {
    return [SVProgressHUD isVisible];
}

+ (void)showSuccessHint:(NSString *)hintText {
    [SVProgressHUD showSuccessWithStatus:hintText];
}

+ (void)showErrorHint:(NSString *)hintText {
    [SVProgressHUD showErrorWithStatus:hintText];
}

+ (void)showInfoHint:(NSString *)hintText {
    [SVProgressHUD showInfoWithStatus:hintText];
}

@end
