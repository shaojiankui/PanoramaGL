//
//  PLSphericalRatioPanorama.m
//  PanoramaGL
//
//  Created by Jakey on 2017/9/28.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "PLSphericalRatioPanorama.h"
#import "PLPanoramaBaseProtected.h"

@interface PLSphericalRatioPanorama(Private)

-(void)setTexture:(PLTexture *)texture face:(PLSpherical2FaceOrientation)face;

@end

@implementation PLSphericalRatioPanorama

@synthesize divs, previewDivs;

#pragma mark -
#pragma mark init methods

+(id)panorama
{
    return [[[PLSphericalRatioPanorama alloc] init] autorelease];
}


-(void)initializeValues
{
    [super initializeValues];
    quadratic = gluNewQuadric();
    gluQuadricNormals(quadratic, GLU_SMOOTH);
    gluQuadricTexture(quadratic, YES);
    divs = kDefaultHemisphereDivs;
    previewDivs = kDefaultHemispherePreviewDivs;
}

#pragma mark -
#pragma mark property methods

-(PLSceneElementType)getType
{
    return PLSceneElementTypePanorama;
}

-(int)getPreviewSides
{
    return 1;
}

-(int)getSides
{
    return 4;
}

-(void)setImage:(PLImage *)image ifNoPowerOfTwoConvertUpDimension:(BOOL)convertUpDimension
{
    //    if(image && [image getWidth] == 2048 && [image getHeight] == 1024)
    [image scale:CGSizeMake(kTextureMaxWidth, kTextureMaxWidth/2.0)];
    //如果图片不满足2点N次方，调整图片大小
    BOOL isResizableImage = NO;
    CGFloat width = image.width,height = image.height;
    if(![PLMath isPowerOfTwo:width] || width > kTextureMaxWidth)
    {
        isResizableImage = YES;
        width = [PLUtils convertValidValueForDimension:width ifNoPowerOfTwoConvertUpDimension:convertUpDimension];
    }
    if(![PLMath isPowerOfTwo:height] || height > kTextureMaxHeight)
    {
        isResizableImage = YES;
        height = [PLUtils convertValidValueForDimension:height ifNoPowerOfTwoConvertUpDimension:convertUpDimension];
    }
    
    if(isResizableImage)
        [image scale:CGSizeMake(width, height)];
    
    
    CGFloat scale = kTextureMaxWidth/2048.0;
    
    if(image && [image getWidth] == scale*2048 && [image getHeight] == scale*1024)
    {
        PLImage *frontImage = [[image clone] crop:CGRectMake(scale*768.0f, 0.0f, scale*512.0f, scale*1024.0f)];
        PLImage *backImage = [PLImage joinImagesHorizontally:[[image clone] crop:CGRectMake(scale*1792.0f, 0.0f, scale*256.0f, scale*1024.0f)] rightImage:[[image clone] crop:CGRectMake(0.0f, 0.0f, scale*256.0f, scale*1024.0f)]];
        PLImage *rightImage = [[image clone] crop:CGRectMake(scale*1024.0f, 0.0f, scale*1024.0f, scale*1024.0f)];
        [image crop:CGRectMake(0.0, 0.0f, scale*1024.0f, scale*1024.0f)];
        [self setTexture:[PLTexture textureWithImage:frontImage] face:PLSpherical2FaceOrientationFront];
        [self setTexture:[PLTexture textureWithImage:image] face:PLSpherical2FaceOrientationLeft];
        [self setTexture:[PLTexture textureWithImage:rightImage] face:PLSpherical2FaceOrientationRight];
        [self setTexture:[PLTexture textureWithImage:backImage] face:PLSpherical2FaceOrientationBack];
    }
}

-(void)setTexture:(PLTexture *)texture face:(PLSpherical2FaceOrientation)face
{
    if(texture)
    {
        @synchronized(self)
        {
            PLTexture **textures = [self getTextures];
            PLTexture *currentTexture = textures[face];
            if(currentTexture)
                [currentTexture release];
            textures[face] = [texture retain];
        }
    }
}

#pragma mark -
#pragma mark render methods

-(void)internalRender
{
    glRotatef(180.0f, 0.0f, 1.0f, 0.0f);
    
    glEnable(GL_TEXTURE_2D);
    
    PLTexture *previewTexture = [self getPreviewTextures][0];
    PLTexture **textures = [self getTextures];
    PLTexture *frontTexture = textures[PLSpherical2FaceOrientationFront];
    PLTexture *backTexture = textures[PLSpherical2FaceOrientationBack];
    PLTexture *leftTexture = textures[PLSpherical2FaceOrientationLeft];
    PLTexture *rightTexture = textures[PLSpherical2FaceOrientationRight];
    
    BOOL previewTextureIsValid = (previewTexture && previewTexture.textureID);
    BOOL frontTextureIsValud = (frontTexture && frontTexture.textureID);
    BOOL backTextureIsValid = (backTexture && backTexture.textureID);
    BOOL leftTextureIsValid = (leftTexture && leftTexture.textureID);
    BOOL rightTextureIsValid = (rightTexture && rightTexture.textureID);
    
    if(previewTextureIsValid)
    {
        if(frontTextureIsValud && backTextureIsValid && leftTextureIsValid && rightTextureIsValid)
            [self removePreviewTextureAtIndex:0];
        else
        {
            glBindTexture(GL_TEXTURE_2D, previewTexture.textureID);
            gluSphere(quadratic, kRatio + 0.05f, (GLint)previewDivs, (GLint)previewDivs);
        }
    }
    if(frontTextureIsValud)
    {
        glBindTexture(GL_TEXTURE_2D, frontTexture.textureID);
        glu3DArc(quadratic, M_PI_2, -M_PI_4, NO, kRatio, (GLint)divs, (GLint)divs);
    }
    if(backTextureIsValid)
    {
        glBindTexture(GL_TEXTURE_2D, backTexture.textureID);
        glu3DArc(quadratic, M_PI_2, -M_PI_4, YES, kRatio, (GLint)divs, (GLint)divs);
    }
    if(leftTextureIsValid)
    {
        glBindTexture(GL_TEXTURE_2D, leftTexture.textureID);
        gluHemisphere(quadratic, NO, kRatio, (GLint)divs, (GLint)divs);
    }
    if(rightTextureIsValid)
    {
        glBindTexture(GL_TEXTURE_2D, rightTexture.textureID);
        gluHemisphere(quadratic, YES, kRatio, (GLint)divs, (GLint)divs);
    }
    
    glDisable(GL_TEXTURE_2D);
    
    glRotatef(-180.0f, 0.0f, 1.0f, 0.0f);
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
    
    [super internalRender];
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc
{
    if(quadratic)
    {
        gluDeleteQuadric(quadratic);
        quadratic = nil;
    }
    [super dealloc];
}

@end
