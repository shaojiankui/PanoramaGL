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

#import "PLSceneElementProtected.h"
#import "PLHotspot.h"

@interface PLHotspot(Private)

-(void)array:(GLfloat *)result :(int)size, ...;

-(PLPosition)convertPitchAndYawToPosition:(float)pitch yaw:(float)yaw;
-(void)calculatePoints:(PLPosition[])result;
-(void)calculateCoords;

@end

@implementation PLHotspot

@synthesize width, height;
@synthesize atv, ath;
@synthesize faceOrientation;
@synthesize overAlpha, defaultOverAlpha;
@synthesize touchStatus, isTouchBlock;

#pragma mark -
#pragma mark init methods

-(id)initWithId:(long long)identifierValue atv:(float)atvValue ath:(float)athValue
{
	if(self = [super initWithId:identifierValue])
	{
		self.atv = atvValue;
		self.ath = athValue;
	}
	return self;
}

-(id)initWithId:(long long)identifierValue texture:(PLTexture *)texture atv:(float)atvValue ath:(float)athValue
{
	if(self = [super initWithId:identifierValue texture:texture])
	{
		self.atv = atvValue;
		self.ath = athValue;
	}
	return self;
}

-(id)initWithId:(long long)identifierValue texture:(PLTexture *)texture atv:(float)atvValue ath:(float)athValue width:(float)widthValue height:(float)heightValue
{
	if(self = [super initWithId:identifierValue texture:texture])
	{
		self.atv = atvValue;
		self.ath = athValue;
        self.width = widthValue;
        self.height = heightValue;
	}
	return self;
}

+(id)hotspotWithId:(long long)identifier atv:(float)atv ath:(float)ath
{
	return [[[PLHotspot alloc] initWithId:identifier atv:atv ath:ath] autorelease];
}

+(id)hotspotWithId:(long long)identifier texture:(PLTexture *)texture atv:(float)atv ath:(float)ath
{
	return [[[PLHotspot alloc] initWithId:identifier texture:texture atv:atv ath:ath] autorelease];
}

+(id)hotspotWithId:(long long)identifier texture:(PLTexture *)texture atv:(float)atv ath:(float)ath width:(float)width height:(float)height
{
	return [[[PLHotspot alloc] initWithId:identifier texture:texture atv:atv ath:ath width:width height:height] autorelease];
}

-(void)initializeValues
{
	[super initializeValues];
	width = height = kDefaultHotspotSize;
	self.isYZAxisInverseRotation = YES;
	cube = (GLfloat *)malloc(12 * sizeof(GLfloat));
	textureCoords = (GLfloat *)malloc(8 * sizeof(GLfloat));
	PLPosition position = self.position;
	position.z = kRatio - 0.05f;
	self.position = position;
	overAlpha = defaultOverAlpha = kDefaultHotspotOverAlpha;
	self.alpha = self.defaultAlpha = kDefaultHotspotAlpha;
	hasChangedCoordProperty = YES;
	touchStatus = PLHotspotTouchStatusOut;
}

#pragma mark -
#pragma mark reset methods

-(void)reset
{
	[super reset];
	isTouchBlock = NO;
	overAlpha = defaultOverAlpha;
}

#pragma mark -
#pragma mark property methods

-(PLRect)getRect
{
	if(cube)
		return PLRectMake(cube[0], cube[1], cube[2], cube[9], cube[10], cube[11]);
	return PLRectMake(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
}

-(GLfloat *)getVertexs
{
	return cube;
}

-(PLSceneElementType)getType
{
	return PLSceneElementTypeHotspot;
}

-(void)setX:(float)value
{
	if(self.position.x != value)
	{
		[super setX:value];
		hasChangedCoordProperty = YES;
	}
}

-(void)setY:(float)value
{
	if(self.position.y != value)
	{
		[super setY:value];
		hasChangedCoordProperty = YES;
	}
}

-(void)setZ:(float)value
{
	if(self.position.z != value)
	{
		[super setZ:value];
		hasChangedCoordProperty = YES;
	}
}

-(void)setWidth:(float)value
{
	if(width != value)
	{
		width = value;
		hasChangedCoordProperty = YES;
	}
}

-(void)setHeight:(float)value
{
	if(height != value)
	{
		height = value;
		hasChangedCoordProperty = YES;
	}
}

-(void)setAtv:(float)value
{
	if(atv != value)
	{
		atv = value;
		hasChangedCoordProperty = YES;
	}
}

-(void)setAth:(float)value
{
	if(ath != value)
	{
		ath = value;
		hasChangedCoordProperty = YES;
	}
}

-(void)setDefaultOverAlpha:(float)value
{
	defaultOverAlpha = value;
	overAlpha = value;
}

#pragma mark -
#pragma mark layout methods

-(void)setLayout:(float)xValue :(float)yValue :(float)widthValue :(float)heightValue
{
	[super setX:xValue];
	[super setY:yValue];
	width = widthValue;
	height = heightValue;
	hasChangedCoordProperty = YES;
}

#pragma mark -
#pragma mark utility methods

-(void)array:(GLfloat [])result :(int)size, ...
{
	va_list args;
    va_start(args, size);
    for(int i = 0; i < size; i++)
        result[i] = (GLfloat)va_arg(args, double);
    va_end(args);
}

#pragma mark -
#pragma mark calc methods

-(PLPosition)convertPitchAndYawToPosition:(float)pitch yaw:(float)yaw
{
	float r = self.position.z;
	double pr = (90.0f - pitch) * kPI / 180.0;
	double yr = -yaw * kPI / 180.0;
	
	float x = (float)(r * sin(pr) * cos(yr));
	float y = (float)(r * sin(pr) * sin(yr));
	float z = (float)(r * cos(pr));
	
	return PLPositionMake(y, z, x);
}

-(void)calculatePoints:(PLPosition[])result
{
	PLPosition pos = [self convertPitchAndYawToPosition:atv yaw:ath];
	PLPosition pos1 = [self convertPitchAndYawToPosition:atv + 0.0001f yaw:ath];
	//1
	PLVector3 *p1 = [PLVector3 vector3WithX:pos.x y:pos.y z:pos.z], *p2 = [PLVector3 vector3];
	PLVector3 *n = [PLVector3 vector3] , *p = [PLVector3 vector3WithX:pos1.x y:pos1.y z:pos1.z];
	PLVector3 *r = nil, *s = nil, *p2p1 = nil, *p0p1 = nil;
	
	//2
	p0p1 = [p sub:p1];
	p2p1 = [p2 sub:p1];
	r = [p2p1 crossProduct:p0p1];
	//3
	s = [p2p1 crossProduct:r];
	//4
	[r normalize];
	[s normalize];
	
	//5.1
	float w = width * kRatio, h = height * kRatio;
	double ratio = sqrt((w * w) + (h * h));
	//5.2
	double angle = 0;
	do
	{
		angle = asin(h/ratio);
	}
	while(isnan(angle));
	//5.3
	double angles[] = { kPI - angle, angle, kPI + angle, 2 * kPI - angle };
	for(int i = 0; i < 4; i++)
	{
		double theta = angles[i];
		double x = p1.x + (ratio * cos(theta) * r.x) + (ratio * sin(theta) * s.x);
		double y = p1.y + (ratio * cos(theta) * r.y) + (ratio * sin(theta) * s.y);
		double z = p1.z + (ratio * cos(theta) * r.z) + (ratio * sin(theta) * s.z);
		n.x = (float)x;
		n.y = (float)y;
		n.z = (float)z;
		[n normalize];
		result[i] = PLPositionMake(n.x, n.y, n.z);
	}
}

-(void)calculateCoords
{
	if(!hasChangedCoordProperty)
		return;
	
	hasChangedCoordProperty = NO;
	
	PLPosition positions[4];
	[self calculatePoints:positions];
	
	PLPosition position1 = positions[0];
	PLPosition position2 = positions[1];
	PLPosition position3 = positions[2];
	PLPosition position4 = positions[3];
	
	[self array:cube :12 ,
	 position1.x, position1.y, position1.z,
	 position2.x, position2.y, position2.z,
	 position3.x, position3.y, position3.z,
	 position4.x, position4.y, position4.z
	 ];

	[self array:textureCoords :8 ,
	 1.0f, 1.0f,	
	 0.0f, 1.0f,
	 1.0f, 0.0f,
	 0.0f, 0.0f
	 ];
}

#pragma mark -
#pragma mark render methods

-(void)translate
{
}

-(void)internalRender
{	
	[self calculateCoords];
	
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	glVertexPointer(3, GL_FLOAT, 0, cube);
	glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glEnable(GL_CULL_FACE);
	glCullFace(GL_FRONT);
	glShadeModel(GL_SMOOTH);
	
	glColor4f(1.0f, 1.0f, 1.0f, touchStatus == PLHotspotTouchStatusOut ? self.alpha : overAlpha);
	
	glBindTexture(GL_TEXTURE_2D, ((PLTexture *)[self.textures objectAtIndex:0]).textureID);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
}

#pragma mark -
#pragma mark touch methods

-(void)touchBlock
{
	isTouchBlock = YES;
}

-(void)touchUnblock
{
	isTouchBlock = NO;
}

-(void)touchOver:(NSObject *)sender
{
	if(!isTouchBlock)
		touchStatus = PLHotspotTouchStatusOver;
}

-(void)touchMove:(NSObject *)sender
{
	if(!isTouchBlock)
		touchStatus = PLHotspotTouchStatusMove;
}

-(void)touchOut:(NSObject *)sender
{
	if(!isTouchBlock)
		touchStatus = PLHotspotTouchStatusOut;
}

-(void)touchDown:(NSObject *)sender
{
	if(!isTouchBlock)
		touchStatus = PLHotspotTouchDown;
}

#pragma mark -
#pragma mark clone methods

-(void)clonePropertiesOf:(PLObject *)value
{
	if(value)
	{
		[super clonePropertiesOf:value];
		if([value isKindOfClass:[PLHotspot class]])
		{
			PLHotspot *hotspot = (PLHotspot *)value;
			self.defaultOverAlpha = hotspot.defaultOverAlpha;
			self.overAlpha = hotspot.overAlpha;
		}
	}
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc
{
	if(cube)
	{
		free(cube);
		cube = nil;
	}
	if(textureCoords)
	{
		free(textureCoords);
		textureCoords = nil;
	}
	[super dealloc];
}

@end
