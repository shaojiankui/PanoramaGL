/*
 * PanoramaGL library
 * Version 0.1
 * Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PLCylindricalPanorama.h"
#import "PLPanoramaBaseProtected.h"

@implementation PLCylindricalPanorama

@synthesize divs;
@synthesize isHeightCalculated;
@synthesize height;

#pragma mark -
#pragma mark init methods

+(id)panorama
{
    return [[[PLCylindricalPanorama alloc] init] autorelease];
}

-(void)initializeValues
{
    [super initializeValues];
    quadratic = gluNewQuadric();
    gluQuadricNormals(quadratic, GLU_SMOOTH);
	gluQuadricTexture(quadratic, YES);
    height = kDefaultCylinderHeight;
    divs = kDefaultCylinderDivs;
    isHeightCalculated = kDefaultCylinderHeightCalculated;
    self.pitchRange = PLRangeMake(0.0f, 0.0f);
    self.isXAxisEnabled = NO;
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
    if(image)
        [self setTexture:[PLTexture textureWithImage:image]];
}

-(void)setTexture:(PLTexture *)texture
{
    if(texture)
    {
        @synchronized(self)
        {
			PLTexture **textures = [self getTextures];
			PLTexture *currentTexture = textures[0];
			if(currentTexture)
				[currentTexture release];
			textures[0] = [texture retain];
            if(isHeightCalculated)
                height = -1.0f;
		}
	}
}

-(void)setHeight:(float)value
{
    if(!isHeightCalculated)
        height = ABS(value);
}

#pragma mark -
#pragma mark render methods

-(void)internalRender
{
    PLTexture *previewTexture = [self getPreviewTextures][0];
    PLTexture *texture = [self getTextures][0];
    
    BOOL previewTextureIsValid = (previewTexture && previewTexture.textureID);
    BOOL textureIsValid = (texture && texture.textureID);
    
    if(isHeightCalculated && textureIsValid && height == -1.0f)
    {
        int textureWidth = texture.width;
        int textureHeight = texture.height;
        height = (textureWidth > textureHeight ? (float)textureWidth/textureHeight : (float)textureHeight/textureWidth);
    }
    
    float h2 = height/2.0f;
    
    glRotatef(180.0f, 0.0f, 1.0f, 0.0f);
    glTranslatef(0.0f, 0.0f, -h2);
    
	glEnable(GL_TEXTURE_2D);
    
    if(textureIsValid)
    {
        glBindTexture(GL_TEXTURE_2D, texture.textureID);
        if(previewTextureIsValid)
            [self removePreviewTextureAtIndex:0];
    }
    else if(previewTextureIsValid)
        glBindTexture(GL_TEXTURE_2D, previewTexture.textureID);
    
	gluCylinder(quadratic, kRatio, kRatio, height, divs, divs);
    
	glDisable(GL_TEXTURE_2D);
    
    glTranslatef(0.0f, 0.0f, h2);
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
