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

#import "PLRenderableElementBaseProtected.h"

@implementation PLRenderableElementBase

@synthesize isVisible, isValid;

#pragma mark -
#pragma mark init methods

-(void)initializeValues
{
	[super initializeValues];
	isVisible = YES;
	isValid = NO;
}

#pragma mark -
#pragma mark property methods

-(void)setIsValid:(BOOL)value
{
	isValid = value;
}

#pragma mark -
#pragma mark translate methods

-(void)translate
{
	PLPosition position = self.position;
	float yValue = self.isYZAxisInverseRotation ? position.z : position.y, zValue = self.isYZAxisInverseRotation ? position.y : position.z;
	glTranslatef(self.isXAxisEnabled ? position.x : 0.0f, self.isYAxisEnabled ? yValue : 0.0f, self.isZAxisEnabled ? zValue : 0.0f);
}

#pragma mark -
#pragma mark rotate methods

-(void)rotate
{
	[self internalRotate:self.rotation];
}

-(void)internalRotate:(PLRotation)rotationValue
{
	float yDirection = self.isYZAxisInverseRotation ? 0.0f : 1.0f, zDirection = self.isYZAxisInverseRotation ? 1.0f : 0.0f;
	if(self.isPitchEnabled)
		glRotatef(rotationValue.pitch * (self.isReverseRotation ? 1.0f : -1.0f), 1.0f, 0.0f, 0.0f);
	if(self.isYawEnabled)
		glRotatef(rotationValue.yaw * (self.isReverseRotation ? 1.0f : -1.0f), 0.0f, yDirection, zDirection);
	if(self.isRollEnabled)
		glRotatef(rotationValue.roll * (self.isReverseRotation ? 1.0f : -1.0f), 0.0f, yDirection, zDirection);
}

#pragma mark -
#pragma mark alpha methods

-(void)beginAlpha
{
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	glColor4f(1.0f, 1.0f, 1.0f, self.alpha);
}

-(void)endAlpha
{
	glDisable(GL_BLEND);
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}

#pragma mark -
#pragma mark render methods

-(void)beginRender
{
	glPushMatrix();
	[self rotate];
	[self translate];
	[self beginAlpha];
}

-(void)endRender
{
	[self endAlpha];
	glPopMatrix();
}

-(BOOL)render
{
	@try
	{
		if(isVisible && isValid)
		{
			[self beginRender];
			[self internalRender];
			[self endRender];
			return YES;
		}
	}
	@catch(NSException *e)
	{
	}
	return NO;
}

-(void)internalRender
{
}

@end
