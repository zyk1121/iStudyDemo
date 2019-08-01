#ifndef GLTools_h
#define GLTools_h

#include <stdio.h>
#import <GLKit/GLKit.h>
#import <GLKit/GLKView.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGL.h>

void gluPerspective_igl(GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar);

static void __gluMakeIdentityf_igl(GLfloat m[16]);

static void normalize_igl(GLfloat v[3]);

static void cross_igl(GLfloat v1[3], GLfloat v2[3], GLfloat result[3]);


void gluLookAt_igl(GLfloat eyex, GLfloat eyey, GLfloat eyez, GLfloat centerx,
                     GLfloat centery, GLfloat centerz, GLfloat upx, GLfloat upy,
                     GLfloat upz);

GLint gluProject_igl(GLfloat objx, GLfloat objy, GLfloat objz,
                       const GLfloat modelMatrix[16],
                       const GLfloat projMatrix[16],
                       const GLint viewport[4],
                       GLfloat* winx, GLfloat* winy, GLfloat* winz);

// 根据图像数据生成纹理，返回纹理id
GLuint iglGetTextureIDFrom(unsigned char *imageData, GLsizei width, GLsizei height);
void   iglDelTextureID(GLsizei n, GLuint *textureIDs);

float  iglNormalizedPitch(float pitch);
float  iglNormalizedYaw(float yaw);
float  iglNormalizedZoom(float zoom);

#endif /* */
