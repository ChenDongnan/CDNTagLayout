//
//  CDNTagLayout.h
//  CDNTagLayout
//
//  Created by 陈栋楠 on 2017/5/22.
//  Copyright © 2017年 陈栋楠. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDNTagLayout;

@protocol CDNTagLayoutDelegate <NSObject>

@required
/** 标签内容 */
- (NSString *)tagLayout:(CDNTagLayout *)layout titleForIndexPath:(NSIndexPath *)indexPath;
/** 标签内容字体 */
- (UIFont *)tagLayout:(CDNTagLayout *)layout fontForIndexPath:(NSIndexPath *)indexPath;
/** 标签个数 */
- (NSInteger)numberOfTagsWithLayout:(CDNTagLayout *)layout;

@end

@interface CDNTagLayout : UICollectionViewFlowLayout
/** 每个item的横向间距,默认8.0 */
@property (nonatomic, assign) CGFloat marginX;
/** 每个item的纵向间距,默认8.0 */
@property (nonatomic, assign) CGFloat marginY;
/** item的高度,默认16.0 */
@property (nonatomic, assign) CGFloat itemHeight;
/** 每个item的水平文字内间距，即文字左右两边和边框的距离，需要调整上下内间距的话直接改itemHeight即可，默认左右都为8.0（左、右4.0），注意，必须设置label文字横向居中 */
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, weak) IBOutlet id<CDNTagLayoutDelegate> delegate;
@end
