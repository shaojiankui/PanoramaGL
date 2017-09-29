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
    //    divs = kDefaultHemisphereDivs;
    //    previewDivs = kDefaultHemispherePreviewDivs;
    divs = kDefaultSphereDivs;
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
    return 1;
}

-(void)setImage:(PLImage *)image
{
    [self setTexture:[PLTexture textureWithImage:image] face:0];
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
    
    glEnable(GL_TEXTURE_2D); //启用二维文理
    
    PLTexture *previewTexture = [self getPreviewTextures][0];
    PLTexture *texture = [self getTextures][0];
    
    BOOL previewTextureIsValid = (previewTexture && previewTexture.textureID);
    
    if(texture && texture.textureID)
    {
        glBindTexture(GL_TEXTURE_2D, texture.textureID);
        if(previewTextureIsValid)
            [self removePreviewTextureAtIndex:0];
    }
    else if(previewTextureIsValid)
        glBindTexture(GL_TEXTURE_2D, previewTexture.textureID);
    
    gluSphere(quadratic, kRatio, (GLint)divs, (GLint)divs);
    
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
