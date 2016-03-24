/*
 Copyright 2016-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "MDCHeaderStackView.h"

@implementation MDCHeaderStackView

- (CGSize)sizeThatFits:(CGSize)size {
  if (_bottomBar) {
    size.height = [_bottomBar sizeThatFits:size].height;
  } else {
    size.height = [_topBar sizeThatFits:size].height;
  }
  return size;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGSize boundsSize = self.bounds.size;

  CGSize topBarSize = [_topBar sizeThatFits:boundsSize];
  CGSize bottomBarSize = [_bottomBar sizeThatFits:boundsSize];

  CGFloat remainingHeight = boundsSize.height - topBarSize.height - bottomBarSize.height;

  CGRect topBarFrame = (CGRect){CGPointZero, topBarSize};
  CGRect bottomBarFrame = (CGRect){CGPointZero, bottomBarSize};

  if (remainingHeight > 0) {
    // Expand the top bar to fill the remaining height.
    topBarFrame.size.height += remainingHeight;

  } else if (remainingHeight < 0) {
    // Negative value causes the top bar to slide up and away.
    topBarFrame.origin.y += remainingHeight;
  }
  bottomBarFrame.origin.y = CGRectGetMaxY(topBarFrame);

  _topBar.frame = topBarFrame;
  _bottomBar.frame = bottomBarFrame;
}

#pragma mark - Public

- (void)setTopBar:(UIView *)topBar {
  if (_topBar == topBar) {
    return;
  }

  [_topBar removeFromSuperview];

  _topBar = topBar;

  [self addSubview:_topBar];
  [self setNeedsLayout];
}

- (void)setBottomBar:(UIView *)bottomBar {
  if (_bottomBar == bottomBar) {
    return;
  }

  [_bottomBar removeFromSuperview];

  _bottomBar = bottomBar;

  [self addSubview:_bottomBar];
  [self setNeedsLayout];
}

@end