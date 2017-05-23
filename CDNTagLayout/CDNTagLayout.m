//
//  CDNTagLayout.m
//  CDNTagLayout
//
//  Created by 陈栋楠 on 2017/5/22.
//  Copyright © 2017年 陈栋楠. All rights reserved.
//

#import "CDNTagLayout.h"
#import "UIView+CDNKit.h"
@interface CDNTagLayout ()

@property (nonatomic, assign,readonly) CGRect lastItemFrame;
@property (nonatomic, strong,readonly) NSMutableArray<UICollectionViewLayoutAttributes *> *allAttr;
@property (nonatomic, assign) BOOL loadFrame;

@end


@implementation CDNTagLayout

-(instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self =[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    _marginX = 8;
    _marginY = 8;
    _itemHeight = 16;
    _lastItemFrame = CGRectZero;
    _horizontalPadding = 4 *2;
    _allAttr = [[NSMutableArray alloc] init];
}

-(CGSize)collectionViewContentSize {
    CGSize size = CGSizeMake(self.collectionView.width, self.lastItemFrame.origin.y + self.lastItemFrame.size.height);
    return size;
}

-(void)prepareLayout {
    [super prepareLayout];
    
    if (self.allAttr.count >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    self.minimumInteritemSpacing = _marginX;
    self.sectionInset = UIEdgeInsetsZero;
    self.minimumLineSpacing = _marginY;
    for (int i = 0; i<[self.collectionView numberOfItemsInSection:0]; i++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.allAttr addObject:attr];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.allAttr;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadFrame) {
        return nil;
    }
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat x,y,w;
    CGFloat h = _itemHeight;
    
    NSString *str =[_delegate tagLayout:self titleForIndexPath:indexPath];
    UIFont *font = [_delegate tagLayout:self fontForIndexPath:indexPath];
    
    w = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width + _horizontalPadding;
    if (_lastItemFrame.origin.x + _lastItemFrame.size.width +_marginX +w +self.sectionInset.right > self.collectionView.width) {
        /** 超出一行换行 */
        x = self.sectionInset.left;
        y = _lastItemFrame.origin.y +_lastItemFrame.size.height + _marginY;
    }
    else {
        x = indexPath.item == 0? self.sectionInset.left : (_lastItemFrame.origin.x + _lastItemFrame.size.width + _marginX);
        y = MAX(_lastItemFrame.origin.y, self.sectionInset.top);
    }
    _lastItemFrame = CGRectMake(x, y, w, h);
    attr.frame = _lastItemFrame;
    return  attr;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - public
- (CGFloat)collctionViewHeightWithWidth:(CGFloat)width {
    CGFloat x,y,w;
    CGFloat h = _itemHeight;
    CGFloat horizontalPadding = _horizontalPadding;
    CGFloat marginX = _marginX;
    CGFloat marginY = _marginY;
    
    CGRect lastItemFrame = _lastItemFrame;
    NSInteger count = [_delegate numberOfTagsWithLayout:self];
    for (int i =0; i<count; i++) {
        UIFont *font = [_delegate tagLayout:self fontForIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSString *str = [_delegate tagLayout:self titleForIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        w = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width + horizontalPadding;
        if (lastItemFrame.origin.x + lastItemFrame.size.width + marginX + w +self.sectionInset.right >width) {
            x = self.sectionInset.left;
            y = lastItemFrame.origin.y + lastItemFrame.size.height + marginY;
        }
        else {
            x = i == 0? self.sectionInset.left : (lastItemFrame.origin.x +lastItemFrame.size.width + marginX);
            y = MAX(lastItemFrame.origin.y, self.sectionInset.top);
        }
        
        lastItemFrame = CGRectMake(x, y, w, h);
    }
    return lastItemFrame.size.height + lastItemFrame.origin.y;
}









@end
