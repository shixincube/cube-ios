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

#import "CubeMessagePanelView+Delegate.h"
#import "CubeMessageFrame.h"

@implementation CubeMessagePanelView (Delegate)

- (void)registerCellClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[CubeTextMessageCell class] forCellReuseIdentifier:@"CubeTextMessageCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMessage * message = self.data[indexPath.row];
    if (message.type == CMessageTypeText) {
        CubeTextMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CubeTextMessageCell"];
        [cell updateMessage:message];
        cell.delegate = self;
        return cell;
    }

    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.data.count) {
        return 0.0f;
    }
    
    CMessage * message = self.data[indexPath.row];
    if (!message.customData) {
        return 0.0f;
    }

    return ((CubeMessageFrame *)message.customData).height;
}

#pragma mark - CubeMessageCellDelegate

- (void)messageCellDidClickAvatarForContact:(CContact *)contact {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagePanelView:didClickContactAvatar:)]) {
        [self.delegate messagePanelView:self didClickContactAvatar:contact];
    }
}

- (void)messageCellDidClick:(CMessage *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagePanelView:didClickMessage:)]) {
        [self.delegate messagePanelView:self didClickMessage:message];
    }
}

- (void)messageCellDidLongPress:(CMessage *)message targetRect:(CGRect)targetRect {
    // TODO
}

- (void)messageCellDidDoubleClick:(CMessage *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagePanelView:didDoubleClickMessage:)]) {
        [self.delegate messagePanelView:self didDoubleClickMessage:message];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagePanelViewDidTouched:)]) {
        [self.delegate messagePanelViewDidTouched:self];
    }
}

@end
