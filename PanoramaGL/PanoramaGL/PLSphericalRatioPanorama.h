//
//  PLSphericalRatioPanorama.h
//  PanoramaGL
//
//  Created by Jakey on 2017/9/28.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "PLPanoramaBase.h"
/// image等比即可
@interface PLSphericalRatioPanorama : PLPanoramaBase
{
#pragma mark -
#pragma mark member variables
@private
    NSUInteger divs,previewDivs;
    GLUquadric *quadratic;
}

#pragma mark -
#pragma mark properties

@property(nonatomic, assign) NSUInteger divs,previewDivs;

#pragma mark -
#pragma mark property methods

- (void)setImage:(PLImage *)image ifNoPowerOfTwoConvertUpDimension:(BOOL)convertUpDimension;

//-(void)setTexture:(PLTexture *)texture;
@end
