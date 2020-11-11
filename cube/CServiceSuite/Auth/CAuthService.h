//
//  CAuthService.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CModule.h"
#import "CPipeline.h"
#import "CAuthToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAuthService : CModule

@property (nonatomic , class , readonly) NSString *mName;

@property (nonatomic , strong) CAuthToken *token;

@property (nonatomic , weak) id <CPipelineListener> pipeListener;

-(void)check:(NSString *)domain appKey:(NSString *)appKey address:(NSString *)address completion:(void(^)(CAuthToken *token))completion;

- (void)applyToken:(NSString *)domain appkey:(NSString *)appKey completion:(void(^)(CAuthToken *))completion;

- (void)checkToken:(void(^)(void))success failure:(void(^)(void))failure;




@end

NS_ASSUME_NONNULL_END
