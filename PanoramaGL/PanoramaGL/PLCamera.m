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

#import "PLCameraProtected.h"

@implementation PLCamera

@synthesize isFovEnabled;
@synthesize fov, fovSensitivity;
@synthesize fovFactor;
@synthesize fovRange;
@synthesize minDistanceToEnableFov;
@synthesize initialLookAt;

#pragma mark -
#pragma mark init methods

+(id)camera
{
	return [[[PLCamera alloc] init] autorelease];
}

-(void)initializeValues
{
	fovRange = PLRangeMake(kDefaultFovMinValue, kDefaultFovMaxValue);
	self.fov = kDefaultFov;
	isFovEnabled = YES;
	fovSensitivity = kDefaultFovSensitivity;
	minDistanceToEnableFov = kDefaultMinDistanceToEnableFov;
	initialLookAt = PLRotationMake(0.0f, 0.0f, 0.0f);
	[super initializeValues];
    [self setIsReverseRotation:YES];
	[self setIsValid:YES];
}

#pragma mark -
#pragma mark reset methods

-(void)reset
{
	self.fov = kDefaultFov;
	[super reset];
	[self lookAtWithPitch:initialLookAt.pitch yaw:initialLookAt.yaw];
}

#pragma mark -
#pragma mark property methods

-(void)setFovRange:(PLRange)value
{
	if(value.max >= value.min)
	{			
		fovRange = PLRangeMake(value.min < kFovMinValue ? kFovMinValue : value.min, value.max > kFovMaxValue ? kFovMaxValue : value.max);
		self.fov = fov;
	}
}

-(void)setMinDistanceToEnableFov:(NSUInteger)value
{
	if(value > 0)
		minDistanceToEnableFov = value;
}

-(void)setFovSensitivity:(float)value
{
	if(value > 0.0f)
		fovSensitivity = value;
}

-(void)setFov:(float)value
{
	if(isFovEnabled)
	{
		fov = [PLMath normalizeFov:value range:fovRange];
		if(fov < 0.0f)
			fovFactor = kFovFactorOffsetValue + kFovFactorNegativeOffsetValue * (fov / kDefaultFovFactorMinValue);
		else if(fov >= 0.0f)
			fovFactor = kFovFactorOffsetValue + kFovFactorPositiveOffsetValue * (fov / kDefaultFovFactorMaxValue);
	}
}

-(float)getFOVFactorCorrected
{
	float value = 1.0f;
	if(fov < 0.0f)
		value = kFovFactorOffsetValue + kFOVFactorCorrectedNegativeOffsetValue * (fov / kDefaultFOVFactorCorrectedMinValue);
	else if(fov >= 0.0f)
		value = kFovFactorOffsetValue + kFOVFactorCorrectedPositiveOffsetValue * (fov / kDefaultFOVFactorCorrectedMaxValue);
	return value;
}

-(PLRotation)getAbsoluteRotation
{
	PLRotation rotation = self.rotation;
	return PLRotationMake(-rotation.pitch, -rotation.yaw, rotation.roll);
}

#pragma mark -
#pragma mark fov methods

-(void)addFovWithDistance:(float)distance;
{
	self.fov += ((distance < 0 ? distance / 2.5 : distance) / fovSensitivity);
}

-(void)addFovWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint sign:(int)sign
{
	[self addFovWithDistance: [PLMath distanceBetweenPoints:startPoint :endPoint] * (sign < 0 ? -1 : 1)];
}

#pragma mark -
#pragma mark render methods

-(void)beginRender
{
	[self rotate];
	[self translate];
}

-(void)endRender
{
}

-(void)internalRender
{
}

#pragma mark -
#pragma mark lookat methods

-(void)lookAtWithPitch:(float)pitch yaw:(float)yaw
{
	[self rotateWithPitch:-pitch yaw:-yaw];
}

-(void)setInitialLookAtWithPitch:(float)pitch yaw:(float)yaw
{
	initialLookAt.pitch = pitch;
	initialLookAt.yaw = yaw;
}

#pragma mark -
#pragma mark clone methods

-(void)cloneCameraProperties:(PLCamera *)value
{
	[super clonePropertiesOf:(PLObject *)value];
	fovRange = value.fovRange;
	isFovEnabled = value.isFovEnabled;
	fovSensitivity = value.fovSensitivity;
	minDistanceToEnableFov = value.minDistanceToEnableFov;
	self.fov = value.fov;
}

@end
