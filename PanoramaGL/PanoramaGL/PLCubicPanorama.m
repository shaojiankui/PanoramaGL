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

#import "PLPanoramaBaseProtected.h"
#import "PLCubicPanorama.h"

#pragma mark -
#pragma mark constants

#define R kRatio

#pragma mark -
#pragma mark static variables

static GLfloat cube[] = 
{
	// Front Face
	-R, -R,  R,
	 R, -R,  R,
	-R,  R,  R,
	 R,  R,  R,
	// Back Face
	-R, -R, -R,
	-R,  R, -R,
	 R, -R, -R,
	 R,  R, -R,
	// Right Face
	-R, -R,  R,
	-R,  R,  R,
	-R, -R, -R,
	-R,  R, -R,
	// Left Face
	 R, -R, -R,
	 R,  R, -R,
	 R, -R,  R,
	 R,  R,  R,
	// Top Face
	-R,  R,  R,
	 R,  R,  R,
	-R,  R, -R,
	 R,  R, -R,
	// Bottom Face
	-R, -R,  R,
	-R, -R, -R,
	 R, -R,  R,
	 R, -R, -R,
};

static GLfloat textureCoords[] = 
{
	// Front Face
	1.0f, 1.0f,
	0.0f, 1.0f,	
	1.0f, 0.0f,
	0.0f, 0.0f,
	// Back Face
	0.0f, 1.0f,
	0.0f, 0.0f,
	1.0f, 1.0f,
	1.0f, 0.0f,
	// Right Face
	0.0f, 1.0f,
	0.0f, 0.0f,
	1.0f, 1.0f,
	1.0f, 0.0f,
	// Left Face
	0.0f, 1.0f,
	0.0f, 0.0f,
	1.0f, 1.0f,
	1.0f, 0.0f,
	// Top Face
	1.0f, 1.0f,
	0.0f, 1.0f,
	1.0f, 0.0f,
	0.0f, 0.0f,
	// Bottom Face
	1.0f, 0.0f,
	1.0f, 1.0f,
	0.0f, 0.0f,
	0.0f, 1.0f,
};

@interface PLCubicPanorama(Private)

-(BOOL)bindTextureBySide:(int)side;

@end

@implementation PLCubicPanorama

#pragma mark -
#pragma mark init methods

+(id)panorama
{
    return [[[PLCubicPanorama alloc] init] autorelease];
}

#pragma mark -
#pragma mark property methods

-(PLSceneElementType)getType
{
	return PLSceneElementTypePanorama;
}

-(int)getPreviewSides
{
    return 6;
}

-(int)getSides
{
	return 6;
}

-(void)setImage:(PLImage *)image face:(PLCubeFaceOrientation)face
{
    if(image)
        [self setTexture:[PLTexture textureWithImage:image] face:face];
}

-(void)setTexture:(PLTexture *)texture face:(PLCubeFaceOrientation)face
{
    if(texture)
    {
        @synchronized(self)
        {
			PLTexture **textures = [self getTextures];
			PLTexture *currentTexture = textures[(int)face];
			if(currentTexture)
				[currentTexture release];
			textures[(int)face] = [texture retain];
		}
	}
}

+(GLfloat *)coordinates
{
	return cube;
}

#pragma mark -
#pragma mark render methods

-(BOOL)bindTextureBySide:(int)side
{
	BOOL result = NO;
	@try
	{
		PLTexture **textures = [self getTextures];
		PLTexture *texture = textures[side];
		if(texture && texture.textureID != 0)	
		{
			glBindTexture(GL_TEXTURE_2D, texture.textureID);
			result = YES;
            PLTexture **previewTextures = [self getPreviewTextures];
			texture = previewTextures[side];
            if(texture)
                [self removePreviewTextureAtIndex:side];
		}
		else
		{
			PLTexture **previewTextures = [self getPreviewTextures];
			texture = previewTextures[side];
			if(texture && texture.textureID != 0)
			{
				glBindTexture(GL_TEXTURE_2D, texture.textureID);
				result = YES;
			}
		}
	}
	@catch(NSException *e)
	{
	}
	return result;
}

-(void)internalRender
{	
	glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
	
	glEnable(GL_TEXTURE_2D);
	
	glVertexPointer(3, GL_FLOAT, 0, cube);
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glEnable(GL_CULL_FACE);
	glCullFace(GL_FRONT);
	glShadeModel(GL_SMOOTH);
	
	// Front Face
	if([self bindTextureBySide:kCubeFrontFaceIndex])
	{
		glNormal3f(0.0f, 0.0f, 1.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	}
	
	// Back Face
	if([self bindTextureBySide:kCubeBackFaceIndex])
	{
		glNormal3f(0.0f, 0.0f, -1.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
	}
	
	// Right Face
	if([self bindTextureBySide:kCubeRightFaceIndex])
	{
		glNormal3f(-1.0f, 0.0f, 0.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 8, 4);
	}
	
	// Left Face
	if([self bindTextureBySide:kCubeLeftFaceIndex])
	{
		glNormal3f(1.0f, 0.0f, 0.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 12, 4);
	}
	
	// Top Face
	if([self bindTextureBySide:kCubeTopFaceIndex])
	{
		glNormal3f(0.0f, 1.0f, 0.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 16, 4);
	}
	
	// Bottom Face
	if([self bindTextureBySide:kCubeBottomFaceIndex])
	{
		glNormal3f(0.0f, -1.0f, 0.0f);
		glDrawArrays(GL_TRIANGLE_STRIP, 20, 4);
	}
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);	
	glDisable(GL_CULL_FACE);
	glDisable(GL_TEXTURE_2D);
	
	[super internalRender];
}

@end
