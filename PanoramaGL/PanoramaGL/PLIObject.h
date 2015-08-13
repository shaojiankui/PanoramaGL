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

#import <Foundation/Foundation.h>
#import "PLStructs.h"

@protocol PLIObject <NSObject>

@required

#pragma mark -
#pragma mark properties

@property(nonatomic, assign) BOOL isXAxisEnabled, isYAxisEnabled, isZAxisEnabled;
@property(nonatomic, assign) PLPosition position;
@property(nonatomic, getter=getX, setter=setX:) float x;
@property(nonatomic, getter=getY, setter=setY:) float y;
@property(nonatomic, getter=getZ, setter=setZ:) float z;
@property(nonatomic, assign) PLRange xRange, yRange, zRange;

@property(nonatomic, assign) BOOL isPitchEnabled, isYawEnabled, isRollEnabled, isReverseRotation, isYZAxisInverseRotation;
@property(nonatomic, assign) PLRotation rotation;
@property(nonatomic, getter=getPitch, setter=setPitch:) float pitch;
@property(nonatomic, getter=getYaw, setter=setYaw:) float yaw;
@property(nonatomic, getter=getRoll, setter=setRoll:) float roll;
@property(nonatomic, assign) PLRange pitchRange, yawRange, rollRange;
@property(nonatomic, assign) float rotateSensitivity;

@property(nonatomic, assign) float alpha, defaultAlpha;

#pragma mark -
#pragma mark reset methods

-(void)reset;

#pragma mark -
#pragma mark property methods

-(float)getX;
-(void)setX:(float)value;
-(float)getY;
-(void)setY:(float)value;
-(float)getZ;
-(void)setZ:(float)value;

-(float)getPitch;
-(void)setPitch:(float)value;
-(float)getYaw;
-(void)setYaw:(float)value;
-(float)getRoll;
-(void)setRoll:(float)value;

#pragma mark -
#pragma mark translate methods

-(void)translateWithX:(float)xValue y:(float)yValue;
-(void)translateWithX:(float)xValue y:(float)yValue z:(float)zValue;

#pragma mark -
#pragma mark rotate methods

-(void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue;
-(void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue roll:(float)rollValue;
-(void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint) endPoint;
-(void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint sensitivity:(float)sensitivity;

#pragma mark -
#pragma mark clone methods

-(void)clonePropertiesOf:(NSObject<PLIObject> *)value;

@end