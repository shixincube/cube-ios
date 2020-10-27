//
//  MessageKitMessageLabel.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitMessageLabel.h"

static NSDictionary * defaultAttributes = nil;

@interface MessageKitMessageLabel ()

@property (nonatomic , strong) NSTextStorage *textStorage;

@property (nonatomic , strong) NSLayoutManager *layoutManager;

@property (nonatomic , strong) NSTextContainer *textContainer;

@property (nonatomic , strong) NSMutableDictionary *rangesForDetectors;


@property (nonatomic , assign) BOOL isConfiguring;

@property (nonatomic , assign) BOOL attributesNeedUpdate;

@end

@implementation MessageKitMessageLabel

#pragma mark - Getter

-(NSTextStorage *)textStorage{
    if (!_textStorage) {
        _textStorage = [[NSTextStorage alloc] init];
        [_textStorage addLayoutManager:self.layoutManager];
    }
    return _textStorage;
}

-(NSLayoutManager *)layoutManager{
    if (_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc] init];
        [_layoutManager addTextContainer:self.textContainer];
    }
    return _layoutManager;
}

-(NSTextContainer *)textContainer{
    if (!_textContainer) {
        _textContainer = [[NSTextContainer alloc] init];
        _textContainer.lineFragmentPadding = 0;
        _textContainer.maximumNumberOfLines = self.numberOfLines;
        _textContainer.lineBreakMode = self.lineBreakMode;
        _textContainer.size = self.bounds.size;
    }
    return _textContainer;
}

- (NSDictionary *)defaultAttributes{
    if (!defaultAttributes) {
        defaultAttributes = @{
            NSForegroundColorAttributeName : [UIColor darkTextColor],
            NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle],
            NSUnderlineColorAttributeName : [UIColor darkTextColor],
        };
    }
    return defaultAttributes;
}


#pragma mark - Setter

// Override

-(void)setNumberOfLines:(NSInteger)numberOfLines{
    [super setNumberOfLines:numberOfLines];
    self.textContainer.maximumNumberOfLines = numberOfLines;
    if (!self.isConfiguring) {
        [self setNeedsDisplay];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self _setTextStorage:self.attributedText shouldParse:YES];
}

-(void)setEnabledDetectors:(NSArray<MessageKitDetectorType *> *)enabledDetectors{
    _enabledDetectors = enabledDetectors;
    [self _setTextStorage:self.attributedText shouldParse:YES];
}

-(void)setText:(NSString *)text{
    [super setText:text];
    [self _setTextStorage:self.attributedText shouldParse:YES];
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    [self _setTextStorage:self.attributedText shouldParse:NO];
}

-(void)setTextColor:(UIColor *)textColor{
    [super setTextColor:textColor];
    [self _setTextStorage:self.attributedText shouldParse:NO];
}

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    [super setLineBreakMode:lineBreakMode];
    self.textContainer.lineBreakMode = lineBreakMode;
    if (self.isConfiguring) {
        [self setNeedsDisplay];
    }
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    [super setTextAlignment:textAlignment];
    [self _setTextStorage:self.attributedText shouldParse:NO];
}

-(void)setTextInsets:(UIEdgeInsets)textInsets{
    _textInsets = textInsets;
    if (!self.isConfiguring) {
        [self setNeedsDisplay];
    }
}

-(CGSize)intrinsicContentSize{
    CGSize size = super.intrinsicContentSize;
    size.width += self.textInsets.left + self.textInsets.right;
    size.height += self.textInsets.top + self.textInsets.bottom;
    return size;
}


#pragma mark - Public

-(void)configure:(void (^)(void))block{
    self.isConfiguring = YES;
    block();
    if (self.attributesNeedUpdate) {
        [self _updateAttributes:self.enabledDetectors];
    }
    self.attributesNeedUpdate = NO;
    self.isConfiguring = NO;
    [self setNeedsDisplay];
}

-(void)setAttributes:(NSDictionary *)attributes detector:(MessageKitDetectorType *)detector{
//    switch detector {
//    case .phoneNumber:
//        phoneNumberAttributes = attributes
//    case .address:
//        addressAttributes = attributes
//    case .date:
//        dateAttributes = attributes
//    case .url:
//        urlAttributes = attributes
//    case .transitInformation:
//        transitInformationAttributes = attributes
//    case .mention:
//        mentionAttributes = attributes
//    case .hashtag:
//        hashtagAttributes = attributes
//    case .custom(let regex):
//        customAttributes[regex] = attributes
//    }
//    if isConfiguring {
//        attributesNeedUpdate = true
//    } else {
//        updateAttributes(for: [detector])
//    }
}

#pragma mark - Private
- (void)_updateAttributes:(NSArray <MessageKitDetectorType *>*)detectors{
    
}


- (void)_setTextStorage:(NSAttributedString *)newText shouldParse:(BOOL)shouldParse{
    
}



#pragma mark - Private
- (int)_stringIndex:(CGPoint)location{
    return 1;
}

-(BOOL)handleGesture:(CGPoint)touchLocation{
    int index = [self _stringIndex:touchLocation];
    return YES;
}

@end
