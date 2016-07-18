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

#import "PLSphericalPanorama.h"
#import "PLPanoramaBaseProtected.h"

@implementation PLSphericalPanorama

@synthesize divs;

#pragma mark -
#pragma mark init methods

+(id)panorama
{
    return [[[PLSphericalPanorama alloc] init] autorelease];
}

-(void)initializeValues
{
    [super initializeValues];
	quadratic = gluNewQuadric();
	gluQuadricNormals(quadratic, GLU_SMOOTH);
	gluQuadricTexture(quadratic, YES);
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
