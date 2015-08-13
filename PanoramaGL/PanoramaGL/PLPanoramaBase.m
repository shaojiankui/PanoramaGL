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

#pragma mark -
#pragma mark static variables

static int sPreviewFacesOrder[] = { 1, 3, 0, 2, 4, 5 };

@implementation PLPanoramaBase

#pragma mark -
#pragma mark init methods

+(id)panorama
{
    return nil;
}

-(void)initializeValues
{
	[super initializeValues];
	int sides = [self getSides];
    int previewSides = [self getPreviewSides];
	textures = (PLTexture **)malloc(sizeof(PLTexture *) * sides);
	previewTextures = (PLTexture **)malloc(sizeof(PLTexture *) * previewSides);
    int i;
	for(i = 0; i < sides; i++)
		textures[i] = nil;
	for(i = 0; i < previewSides; i++)
        previewTextures[i] = nil;
	[self setIsValid:YES];
}

#pragma mark -
#pragma mark property methods

-(PLTexture **)getTextures
{
	return textures;
}

-(int)getPreviewSides
{
    return 1;
}

-(int)getSides
{
	return 1;
}

#pragma mark -
#pragma mark preview texture methods

-(PLTexture **)getPreviewTextures
{
	return previewTextures;
}

-(void)setPreviewImage:(PLImage *)value
{
	@synchronized(self)
	{
		[self removeAllPreviewTextures];
		if(value && [value isValid])
		{
			value = [value retain];
			int width = [value getWidth];
			int height = [value getHeight];
			if([PLMath isPowerOfTwo:width] && (height % width == 0 || width % height == 0))
			{
				int sides = [self getPreviewSides], counter = 0;
				BOOL isSideByDefault = (sides == 1);
				for(int i = 0; i < sides; i++)
				{
					@try
					{
						PLImage *subImage = [value getSubImageWithRect:CGRectMake(0, ((isSideByDefault ? i : sPreviewFacesOrder[i]) * width), width, (isSideByDefault ? height : width))];
						previewTextures[counter++] = [[PLTexture alloc] initWithImage:subImage];
					}
					@catch(NSException *e)
					{
						[self removeAllPreviewTextures];
						[PLLog error:@"PLPanoramaBase::setPreviewTexture" format:@"setPreviewTexture fails: %@", e.reason];
						break;
					}
				}
			}
			[value release];
		}
	}
}

#pragma mark -
#pragma mark remove texture methods

-(void)removePreviewTextureAtIndex:(NSUInteger)index
{
    @synchronized(self)
    {
        if(index < [self getPreviewSides])
        {
            PLTexture *texture = previewTextures[index];
            if(texture)
            {
                [texture recycle];
				[texture release];
				previewTextures[index] = nil;
            }
        }
    }
}

-(void)removeAllPreviewTextures
{
	@synchronized(self)
	{
		int sides = [self getPreviewSides];
		for(int i = 0; i < sides; i++)
		{
			PLTexture *texture = previewTextures[i];
			if(texture)
			{
				[texture recycle];
				[texture release];
				previewTextures[i] = nil;
			}
		}
	}
}

-(void)removeAllTextures
{
	@synchronized(self)
	{
		int sides = [self getSides];
		for(int i = 0; i < sides; i++)
		{
			PLTexture *texture = textures[i];
			if(texture)
			{
				[texture release];
				textures[i] = nil;
			}
		}
	}
}

#pragma mark -
#pragma mark clear methods

-(void)clearPanorama
{
    [self removeAllPreviewTextures];
	[self removeAllTextures];
    [self removeAllHotspots];
}

#pragma mark -
#pragma mark hotspot methods

-(void)addHotspot:(PLHotspot *)hotspot
{
	[self addElement:hotspot];
}

-(void)removeHotspot:(PLHotspot *)hotspot
{
	[self removeElement:hotspot];
}

-(void)removeHotspotAtIndex:(NSUInteger)index
{
	[self removeElementAtIndex:index];
}

-(void)removeAllHotspots
{
	[self removeAllElements];
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc
{
	[self clearPanorama];
	free(previewTextures);
	free(textures);
	[super dealloc];
}					 

@end