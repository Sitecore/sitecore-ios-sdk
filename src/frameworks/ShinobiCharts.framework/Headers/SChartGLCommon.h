//
//  SChartGLCommon.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#ifndef SChart_SChartGLCommon_h
#define SChart_SChartGLCommon_h

#define DATAPOINT_QUALITY 20

double sinLookup(int i);
double cosLookup(int i);


#pragma mark -
#pragma mark Structures

/* @name GLVertex3D */
/* Updates the height and width of the view in pixels */
typedef struct GLVertex3D {
    float Position[3];
    float Colour[4];
} GLVertex3D;

typedef struct GLVertex3DWithTexture {
    GLVertex3D  vertex;
    int         texture;
} GLVertex3DWithTexture;

typedef struct GLVertex3DWithOffset {
    GLVertex3D  vertex;
    float offset[2];
} GLVertex3DWithOffset;

typedef struct GLColour4f {
    float red;
    float green;
    float blue;
    float alpha;
} GLColour4f;

typedef struct GLVertex3DWithWidth {
    GLVertex3D Vertex;
    float Width;
} GLVertex3DWithWidth;

typedef struct GLVertex3DWithTextureAndWidth {
    GLVertex3DWithWidth VertexWithWidth;
    int texture;
} GLVertex3DWithTextureAndWidth;

typedef struct GLVertex3DWithUV {
    float Position[3];
    float Colour[4];
    float uv[2];
} GLVertex3DWithUV;

typedef struct GLTranslation {
    float x;
    float y;
    float z;
} GLTranslation;

typedef struct GLTriangle3D {
    GLVertex3D Corners[3];
} GLTriangle3D;


#pragma mark -
#pragma mark Conversion Methods

/* @name convertSeries2DToGLVertex3D */
/* Converts an array of x,y coordinates into GLVertex3Ds. */
/* GLVertex3Ds interleaves x,y,z coordinates with 4f colours. */
void convertSeries2DToGLVertex3D(float *series2D, GLVertex3D *vSeries, GLColour4f colour, int size);

void convertSeries2DToGLVertex3DWithBaseline(float *series2D, GLVertex3D *vSeries, float baseline, int orientation, GLColour4f* colour, GLColour4f *colourBelowBaseline, int size);

void convertSeries2DToGLVertex3DWithBaseSeries(float *series2D, float *baseSeries, GLVertex3D *vSeries, int orientation, GLColour4f *colour, GLColour4f *colourBelowBaseline, int size);

void convertSeries2DToGLVertex3DForBand(float *series1, float *series2, GLVertex3D *vSeries, int orientation, GLColour4f* highColour, GLColour4f *lowColour, int size);

void convertSeries2DToGLVertex3DWithGradientFill(float *series2D, GLVertex3D *vSeries, GLColour4f colour, GLColour4f colourBelowBaseline, GLColour4f gradientColour, GLColour4f gradientColourBelowBaseline, bool gradientColourProvided, bool gradientColourBelowBaselineProvided, bool usePremultipliedAlpha, int size, float baseline, float maxOffsetAboveBaseline, float maxOffsetBelowBaseline, int baselineIndex);

void convertSeries2DToGLVertex3DWithTexture(float *series2D, int *textures, GLVertex3DWithTexture *vSeries, float baseline, int orientation, GLColour4f *colour, GLColour4f *colourBelowBaseline, int size);

void createGLVertex3DWithXYAndColor(GLVertex3D *vertex, float x, float y, GLColour4f colour);

#pragma mark -
#pragma mark Utility Methods

/* @name isNearerToBaseline */
/* Returns 1 if the first Y is nearer to the baseline Y than the second Y */
int isNearerToBaseline(float firstY, float secondY, float baseline);

/* @name doesCrossBaseline */
/* Returns 1 if the first Y is below the baseline and the second Y is above it, or vice versa  */
int doesCrossBaseline(float firstY, float secondY, float baseline);

/* @name angleBetweenLines */
/* Calculates the angle between three points */
float angleBetweenLines(GLVertex3D *points);

/* @name baselineInterceptPoint */
/* Returns the point where the line between two vertices crosses the y baseline  */
GLVertex3D yBaselineInterceptPoint(GLVertex3D first, GLVertex3D second, float baseline);

/* @name baselineInterceptPoint */
/* Returns the point where the line between two vertices crosses the x baseline  */
GLVertex3D xBaselineInterceptPoint(GLVertex3D first, GLVertex3D second, float baseline);

/* @name setColour */
/* Assigns a colour to a vertex  */
void setColour(GLVertex3D *v, GLColour4f c);


#pragma mark -
#pragma mark Geometry Methods

/* @name createCircle */
/* Generates a circle using triangles around the centre point */
void createCircle(GLVertex3D centrepoint, GLTriangle3D *vSeries, GLColour4f colour, float radius, float quality, float fade, float aspectratio);

/* @name createTextureDataForCircleWithRadius */
/* Generates RGBA texture data for a circle of given radius (texture width/height is 2 * radius) */
unsigned char* createTextureDataForCircleWithRadius(float radius, float antialias);

/* @name createTextureDataForRoundEffect */
/* Generates RGBA texture data for a circle effect of given width and ligthing parameters */
unsigned char *createTextureDataForRoundEffect(int width, float strength, float reflectivity, float specular);

#endif
