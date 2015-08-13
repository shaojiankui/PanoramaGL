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
#import <UIKit/UIKit.h>
#pragma mark -
#pragma mark structs definitions

struct PLRange 
{
	CGFloat min;
	CGFloat max;
};
typedef struct PLRange PLRange;

struct PLVertex 
{
//	CGFloat x, y, z;
    GLfloat x, y, z;
};
typedef struct PLVertex PLVertex;
typedef struct PLVertex PLPosition;

struct PLRotation
{
//	CGFloat pitch, yaw, roll;
    GLfloat pitch, yaw, roll;
};
typedef struct PLRotation PLRotation;

struct PLShakeData
{
	long lastTime;
	PLPosition shakePosition;
	PLPosition shakeLastPosition;
};
typedef struct PLShakeData PLShakeData;

struct PLRect
{
	PLPosition leftTop;
	PLPosition rightBottom;
};
typedef struct PLRect PLRect;

struct PLRGBA
{
	float red, green, blue, alpha;
};
typedef struct PLRGBA PLRGBA;

#pragma mark -
#pragma mark structs constructors

CG_INLINE PLRange
PLRangeMake(CGFloat min, CGFloat max)
{
	PLRange range = {min, max};
	return range;
}

CG_INLINE PLVertex
PLVertexMake(CGFloat x, CGFloat y, CGFloat z)
{
	PLVertex vertex = {x, y, z};
	return vertex;
}

CG_INLINE PLPosition
PLPositionMake(CGFloat x, CGFloat y, CGFloat z)
{
	PLPosition position = {x, y, z};
	return position;
}

CG_INLINE PLRotation
PLRotationMake(CGFloat pitch, CGFloat yaw, CGFloat roll)
{
	PLRotation rotation = {pitch, yaw, roll};
	return rotation;
}

CG_INLINE PLShakeData
PLShakeDataMake(long lastTime)
{
	PLShakeData shakeData = {lastTime, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
	return shakeData;
}

CG_INLINE PLRect
PLRectMake(CGFloat left, CGFloat top, CGFloat zLeftTop, CGFloat right, CGFloat bottom, CGFloat zRightBottom)
{
	PLRect rect = {left, top, zLeftTop, right, bottom, zRightBottom};
	return rect;
}

CG_INLINE PLRGBA
PLRGBAMake(float red, float green, float blue, float alpha)
{
	PLRGBA rgb = {red, green, blue, alpha};
	return rgb;
}