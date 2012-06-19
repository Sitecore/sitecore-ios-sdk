//
//  SChartGLView.h
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "SChartAnimationCurve.h"

#define SHINOBI_MAX_THIN_LINE_WIDTH 2.0f

typedef struct
{
    float zoomX, zoomY;
    float minX,  minY;
} SChartGLTranslation;

typedef struct {
    BOOL   useStencilTest;
    BOOL   incrementStencilPlane;
    GLenum stencilOp;
    GLenum stencilFunc;
} SChartGLStencilParams;

typedef struct {
    float                duration;
    SChartAnimationCurve curve;
    float                scale[2];
    float                refPoint[2];
} SChartGLAnimationParams;

@interface SChartGLView : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    UIColor *areaColor;
    
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    GLuint _lineVertexBuffer;
    GLuint _radialVertexBuffer;
    GLuint _offsetVertexBuffer;
    GLuint _vertexWithWidthBuffer;
    
    GLuint _framebuffer;
    GLuint _colorRenderBuffer;
    GLuint _depthStencilRenderBuffer;
    
    GLuint _framebufferMSAA;
    GLuint _colorRenderBufferMSAA;
    
    GLuint vertexShader;
    GLuint vertexShaderAnimate;
    GLuint vertexShaderOffset;
    GLuint vertexShaderOffsetThickLine;
    GLuint vertexShaderPoint;
    GLuint vertexShaderPointWithRadius;
    GLuint vertexShaderDisplaceRotate;
    GLuint vertexShaderDisplaceRotateTexture;
    GLuint fragmentShader;
    GLuint fragmentShaderTexture;
    GLuint fragmentShaderPoint;
    GLuint fragmentShaderThickLine;
    GLuint programHandle;
    GLuint programHandleAnimate;
    GLuint programHandlePoint;
    GLuint programHandlePointWithRadius;
    GLuint programHandleThickLine;
    GLuint programHandleOffset;
    GLuint programHandleOffsetThickLine;
    GLuint programHandleRadialSlice;
    GLuint programHandleRadialEffect;
    GLuint lastUsedProgram;
    GLuint _positionSlot;
    GLuint _colourSlot;
    GLuint _positionSlotAnimate;
    GLuint _colourSlotAnimate;
    GLuint _positionSlotOffset;
    GLuint _colourSlotOffset;
    GLuint _offsetMultiplerSlot;
    GLuint _positionSlotOffsetThickLine;
    GLuint _colourSlotOffsetThickLine;
    GLuint _offsetMultiplerSlotThickLine;
    GLuint _positionSlotPoint;
    GLuint _colourSlotPoint;
    GLuint _positionSlotPointWithRadius;
    GLuint _colourSlotPointWithRadius;
    GLuint _radiusSlotPointWithRadius;
    GLuint _positionSlotThickLine;
    GLuint _colourSlotThickLine;
    GLuint _positionSlotRadialSlice;
    GLuint _colourSlotRadialSlice;
    GLuint _positionSlotRadialEffect;
    GLuint _colourSlotRadialEffect;
    GLuint _uvSlotRadialEffect;
    
    BOOL performCalculations;
    BOOL updateLineTriangles;
    BOOL needsResize;
    BOOL usePremultipliedAlpha;
    NSMutableArray *allTextures;
    
    NSMutableArray *allVertices;
    NSMutableArray *allIndices;
    NSMutableArray *allDynamicVertices;
    NSMutableArray *allRadialVertices;
    NSMutableArray *allOffsetVertices;
    NSMutableArray *allVerticesWithWidth;
    
    NSMutableArray *depthValuesForDynamicBatches;
    NSMutableArray *radialSliceIndices;
    NSMutableArray *renderDataIndicesOpaque;
    NSMutableArray *renderDataIndicesTransparent;
    
    NSMutableArray *renderQueueOpaque;
    NSMutableArray *renderQueueTransparent;
    NSMutableArray *renderQueueDeferredEffect;

    float renderBufferWidth;
    float renderBufferHeight;
    
    // Uniform index.
    GLint *uniforms;
    GLint *uniformsAnimate;
    GLint *uniformsOffset;
    GLint *uniformsOffsetThickLine;
    GLint *uniformsPoint;
    GLint *uniformsPointWithRadius;
    GLint *uniformsThickLine;
    GLint *uniformsRadialSlice;
    GLint *uniformsRadialEffect;
    
    GLuint spriteTexture;
    GLuint spriteTextureOpaque;
    GLuint bevelEffectTexture;
    GLuint bevelEffectTextureLight;
    GLuint bevelPieEffectTexture;
    GLuint bevelPieEffectTextureLight;
    GLuint roundEffectTexture;
    GLuint roundEffectTexturePie;
    GLuint roundEffectTextureLight;
    GLuint roundEffectTextureLightPie;
    
    float spriteTextureSize;
    
    float currentDepth;
    double animationTime;
    double lastFrameTime;
    BOOL animationActive;
    BOOL animationPaused;
    int dynamicVertexCounter;
    int numDynamicVertexBatches;
    int numRadialSlices;
    int numRenderDataOpaque;
    int numRenderDataTransparent;
}

#pragma mark -
#pragma mark OpenGL Initialisation Methods

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic, readonly) CGRect glBounds;

- (float) glWidth;
- (float) glHeight;

@property (nonatomic, assign) BOOL performCalculations;
@property (nonatomic, assign) BOOL updateLineTriangles;
@property (nonatomic, retain) NSMutableArray *allTextures;

// Setting up the OpenGL ES 2.0 pipeline */

// @name setupLayer */
// Sets up a CAEAGLLayer */
- (void)setupLayerWithBackgroundColor:(UIColor*)backgroundColor;
@property (nonatomic, retain) UIColor *areaColor;

// Resize the render buffer and recalculate the viewport
- (void)resize;

// @name setupContext */
// Sets up a EAGLContext */
- (void)setupContext;

// @name setupFrameBuffer */
// Sets up a FrameBuffer */
- (void)setupFrameBuffer;

// @name deleteFrameBuffer */
// Deletes the FrameBuffer */
- (void)deleteFrameBuffer;

// @name compileShader */
// Compiles a GLSL shader */
- (GLuint)compileShader:(const char *)shaderName withType:(GLenum)shaderType;

// @name compileShaders */
// Compiles vertex and fragment shaders */
- (void)compileShaders;

// @name setupVBOs */
// Sets up VBOs */
- (void)setupVBOs;

// @name setupVBOs */
// Deletes VBOs */
- (void)deleteVBOs;

#pragma mark -
#pragma mark Wrappers
// Eminem lives here
// Guns don't kill people, wrappers do?
typedef struct GLTriangle3D          GLTriangle3D;
typedef struct GLVertex3D            GLVertex3D;
typedef struct GLVertex3DWithTexture GLVertex3DWithTexture;
typedef struct GLVertex3DWithOffset  GLVertex3DWithOffset;
typedef struct GLVertex3DWithUV      GLVertex3DWithUV;
typedef struct GLColour4f            GLColour4f;

-(void)addTriangles       :(GLTriangle3D *)triangles        
                     count:(int)count 
                    opaque:(BOOL)opaque 
         stencilParameters:(SChartGLStencilParams *)stencilParams 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addTriangleStrip   :(GLVertex3D *)vertices        
                     count:(int)count 
                    opaque:(BOOL)opaque 
         stencilParameters:(SChartGLStencilParams *)stencilParams 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addIndexedTriangles:(GLVertex3D *)vertices           
                     count:(int)count 
               withIndices:(int *)indices 
            withIndexCount:(int)indexCount 
                    opaque:(BOOL)opaque  
         stencilParameters:(SChartGLStencilParams *)stencilParams 
       animationParameters:(const SChartGLAnimationParams *)animationParams 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addLines           :(GLVertex3D *)vertices           
                     count:(int)count 
              withDrawMode:(GLenum)drawMode 
                 withWidth:(float)width 
           roundThickLines:(BOOL)round 
     roundThickLineTexture:(int)texture 
                    opaque:(BOOL)opaque 
         stencilParameters:(SChartGLStencilParams *)stencilParams 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addIndexedLines    :(GLVertex3D *)vertices           
                     count:(int)count 
               withIndices:(int *)indices 
            withIndexCount:(int)indexCount 
              withDrawMode:(GLenum)drawMode 
                 withWidth:(float)width 
           roundThickLines:(BOOL)round 
                    opaque:(BOOL)opaque 
         stencilParameters:(SChartGLStencilParams *)stencilParams 
       animationParameters:(const SChartGLAnimationParams *)animationParams 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addLinesWithOffset :(GLVertex3DWithOffset *)vertices           
                     count:(int)count 
              withDrawMode:(GLenum)drawMode 
                 withWidth:(float)width 
                    opaque:(BOOL)opaque 
         stencilParameters:(SChartGLStencilParams *)stencilParams 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addPoints          :(GLVertex3DWithTexture *)points  
                     count:(int)count 
                withRadius:(float)radius 
           withRadiusArray:(float*)radii
                    opaque:(BOOL)opaque 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addDynamicTriangles:(GLTriangle3D *)triangles        
                     count:(int)count 
                    opaque:(BOOL)opaque 
         stencilParameters:(SChartGLStencilParams *)stencilParams 
                  forLines:(BOOL)forLines 
           withTranslation:(const SChartGLTranslation *)translation
    isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addIndexedDynamicTriangles:(GLVertex3D *)vertices     
                            count:(int)count 
                      withIndices:(int *)indices 
                   withIndexCount:(int)indexCount 
                           opaque:(BOOL)opaque 
                stencilParameters:(SChartGLStencilParams *)stencilParams 
                         forLines:(BOOL)forLines 
                  withTranslation:(const SChartGLTranslation *)translation
           isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addIndexedOffsetTriangles:(GLVertex3DWithOffset *)vertices     
                            count:(int)count 
                      withIndices:(int *)indices 
                   withIndexCount:(int)indexCount 
                           opaque:(BOOL)opaque 
                stencilParameters:(SChartGLStencilParams *)stencilParams 
                         forLines:(BOOL)forLines 
                  withTranslation:(const SChartGLTranslation *)translation
          isLastInTransformBatch:(BOOL)endTransformBatch;

-(void)addPieSlice        :(GLVertex3DWithUV *)vertices     
                     count:(int)count 
               withIndices:(int *)indices 
            withIndexCount:(int)indexCount 
            withFillColour:(GLColour4f *)fillColour 
            withLineColour:(GLColour4f *)lineColour 
             withLineWidth:(float)lineWidth 
                 withAngle:(float)angle 
          withDisplacement:(float)displacement 
               withTexture:(int)texture;

- (GLuint)getPointTextureOfSize:(float)size isOpaque:(BOOL)opaque;

#pragma mark -
#pragma mark Drawing Methods

// @name beginRender */
// Clears the canvas and buffers and resets the buffers */
- (void)beginRenderWithPointRecalc:(BOOL)recalcPoints didReloadData:(BOOL)reloadedData isRadialChart:(BOOL)radialChart;

// @name endRender */
// Displays objects drawn since beginRender was last called, returns true if needs to redraw next frame */
- (BOOL)endRender;

// @name convertUIColorToGLColour4f */
// Converts a UIColor to a GLColour4f */
- (GLColour4f)convertUIColorToGLColour4f:(UIColor *) uiC;

@end

