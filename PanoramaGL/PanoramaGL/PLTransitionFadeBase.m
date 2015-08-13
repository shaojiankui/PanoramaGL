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

#import "PLTransitionFadeBaseProtected.h"
#import "PLView.h"

@implementation PLTransitionFadeBase

@synthesize fadeStep;

#pragma mark -
#pragma mark init methods

-(void)initializeValues
{
	[super initializeValues];
	fadeStep = kDefaultStepFade;
}

#pragma mark -
#pragma mark reset methods

-(void)resetSceneAlpha
{
	if(self.view)
		[self.view resetSceneAlpha];
}

#pragma mark -
#pragma mark property methods

-(void)setFadeStep:(float)value
{
	if(value > 0.0f)
		fadeStep = value;
}

#pragma mark -
#pragma mark internal control methods

-(void)beginExecute
{
	PLScene *scene = self.scene;
	float alpha = 0.0f;
	switch(self.type)
	{
		case PLTransitionTypeFadeIn:
			alpha = 0.0f;
			break;
		case PLTransitionTypeFadeOut:
			alpha = 1.0f;
			break;
	}
	for(PLSceneElement *element in scene.elements)
	{
		if(element.type == PLSceneElementTypeHotspot)
		{
			PLHotspot *hotspot = (PLHotspot *)element;
			if(hotspot.touchStatus != PLHotspotTouchStatusOut)
			{
				[hotspot touchOut:self];
				[hotspot touchBlock];
			}
		}
		
	}
	scene.alpha = MIN(alpha, scene.defaultAlpha);
	[self.view drawView];
}

-(BOOL)processInternally
{
	BOOL isEnd = NO;
	PLScene *scene = self.scene;
	switch(self.type)
	{
		case PLTransitionTypeFadeIn:
			scene.alpha = MIN(scene.alpha + fadeStep, scene.defaultAlpha);
			[self setProgressPercentage:MIN(scene.alpha * 100, 100)];
			isEnd = (scene.alpha >= 1.0f);
			break;
		case PLTransitionTypeFadeOut:
			scene.alpha = MAX(0.0f, scene.alpha - fadeStep);
			[self setProgressPercentage:MAX((1.0f - scene.alpha) * 100, 0)];
			isEnd = (scene.alpha <= 0.0f);
			break;
	}
	if(isEnd)
	{
		for(PLSceneElement *element in self.scene.elements)
			if(element.type == PLSceneElementTypeHotspot)
				[(PLHotspot *)element touchUnblock];
	}
	return isEnd;
}

@end
