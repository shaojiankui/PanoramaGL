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

#import "PLObjectProtected.h"

@implementation PLObject

@synthesize isXAxisEnabled, isYAxisEnabled, isZAxisEnabled;
@synthesize position;
@synthesize xRange, yRange, zRange;

@synthesize isPitchEnabled, isYawEnabled, isRollEnabled, isReverseRotation, isYZAxisInverseRotation;
@synthesize rotation;
@synthesize pitchRange, yawRange, rollRange;
@synthesize rotateSensitivity;

@synthesize alpha, defaultAlpha;

#pragma mark -
#pragma mark init methods

-(void)initializeValues
{
	[super initializeValues];
	xRange = yRange = zRange = PLRangeMake(kFloatMinValue, kFloatMaxValue);
	
	pitchRange = PLRangeMake(kDefaultPitchMinRange, kDefaultPitchMaxRange);
	yawRange = PLRangeMake(kDefaultYawMinRange, kDefaultYawMaxRange);
	rollRange = PLRangeMake(kDefaultRotateMinRange, kDefaultRotateMaxRange);
	
	isXAxisEnabled = isYAxisEnabled = isZAxisEnabled = YES;
	isPitchEnabled = isYawEnabled = isRollEnabled = YES;
	
	rotateSensitivity = kDefaultRotateSensitivity;	
	isReverseRotation = NO;
	
	isYZAxisInverseRotation = YES;
	
	position = PLPositionMake(0.0f, 0.0f, 0.0f);
	
	defaultAlpha = kObjectDefaultAlpha;
	
	[self reset];
}

#pragma mark -
#pragma mark reset methods

-(void)reset
{
	rotation = PLRotationMake(0.0f, 0.0f, 0.0f);
	alpha = defaultAlpha;
}

#pragma mark -
#pragma mark property methods

-(void)setPosition:(PLPosition)value
{
	[self setX:value.x];
	[self setY:value.y];
	[self setZ:value.z];
}

-(float)getX
{
	return position.x;
}

-(void)setX:(float)value
{
	if(isXAxisEnabled)
		position.x = [PLMath valueInRange:value range:xRange];
}

-(float)getY
{
	return position.y;
}

-(void)setY:(float)value
{
	if(isYAxisEnabled)
		position.y = [PLMath valueInRange:value range:yRange];
}

-(float)getZ
{
	return position.z;
}

-(void)setZ:(float)value
{
	if(isZAxisEnabled)
		position.z = [PLMath valueInRange:value range:zRange];
}

-(void)setRotation:(PLRotation)value
{
	[self setPitch:value.pitch];
	[self setYaw:value.yaw];
	[self setRoll:value.roll];
}

-(float)getPitch
{
	return rotation.pitch;
}

-(void)setPitch:(float)value
{
	if(isPitchEnabled)
		rotation.pitch = [PLMath normalizeAngle:value range:pitchRange];
}

-(float)getYaw
{
	return rotation.yaw;
}

-(void)setYaw:(float)value
{
	if(isYawEnabled)
		rotation.yaw = [PLMath normalizeAngle:value range:PLRangeMake(-yawRange.max, -yawRange.min)];
}

-(float)getRoll
{
	return rotation.roll;
}

-(void)setRoll:(float)value
{
	if(isRollEnabled)
		rotation.roll = [PLMath normalizeAngle:value range:rollRange];
}

-(void)setDefaultAlpha:(float)value
{
	defaultAlpha = value;
	alpha = value;
}

#pragma mark -
#pragma mark translate methods

-(void)translateWithX:(float)xValue y:(float)yValue
{
	position.x = xValue;
	position.y = yValue;
}

-(void)translateWithX:(float)xValue y:(float)yValue z:(float)zValue
{
	position = PLPositionMake(xValue, yValue, zValue);
}

#pragma mark -
#pragma mark rotate methods

-(void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue
{
	self.pitch = pitchValue;
	self.yaw = yawValue;
}

-(void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue roll:(float)rollValue
{
	self.rotation = PLRotationMake(pitchValue, yawValue, rollValue);
}

-(void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
	[self rotateWithStartPoint:startPoint endPoint:endPoint sensitivity:rotateSensitivity];
}

-(void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint sensitivity:(float)sensitivity
{
	self.pitch += (endPoint.y - startPoint.y) / sensitivity;
	self.yaw += (startPoint.x - endPoint.x) / sensitivity;
}

#pragma mark -
#pragma mark clone methods

-(void)clonePropertiesOf:(NSObject<PLIObject> *)value
{	
	self.isXAxisEnabled = value.isXAxisEnabled;
	self.isYAxisEnabled = value.isYAxisEnabled;
	self.isZAxisEnabled = value.isZAxisEnabled;
	
	self.isPitchEnabled = value.isPitchEnabled;
	self.isYawEnabled = value.isYawEnabled;
	self.isRollEnabled = value.isRollEnabled;
	
	self.isReverseRotation = value.isReverseRotation;
	
	self.isYZAxisInverseRotation = value.isYZAxisInverseRotation;
	
	self.rotateSensitivity = value.rotateSensitivity;
	
	self.xRange = value.xRange;
	self.yRange = value.yRange;
	self.zRange = value.zRange;
	
	self.pitchRange = value.pitchRange;
	self.yawRange = value.yawRange;
	self.rollRange = value.rollRange;
	
	self.x = value.x;
	self.y = value.y;
	self.z = value.z;
	
	self.pitch = value.pitch;
	self.yaw = value.yaw;
	self.roll = value.roll;
	
	self.defaultAlpha = value.defaultAlpha;
	self.alpha = value.alpha;
}

@end

