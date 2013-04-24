#import "SCSitecoreCredentials.h"

#include <openssl/crypto.h>
#include <openssl/bn.h>
#include <openssl/rsa.h>

#import <AmberFoundation/AmberFoundation.h>

#include <vector>
#include <algorithm>
#import <ObjcScopedGuard/ObjcScopedGuard.h>

using namespace ::Utils;

@interface SCSitecoreCredentials ()

@property ( nonatomic ) NSString* encryptedLogin;
@property ( nonatomic ) NSString* encryptedPassword;

@end

@implementation SCSitecoreCredentials


@dynamic encryptedLogin;
@dynamic encryptedPassword;


-(NSString*)password
{
    return self->_password ?: @"";
}



-(NSString*)RSA_encryptString:( NSString* )plainText_
{
    NSParameterAssert( nil != self.modulus  );
    NSParameterAssert( nil != self.exponent );
    
    @autoreleasepool
    {
        if ( ![ plainText_ hasSymbols ] )
        {
            return @"";
        }
        
        
        RSA* key = NULL;
        // After base64 decryption modulus length matches the one for .NET 
        NSData* decodedModulus_  = [ NSData dataWithBase64String: self.modulus  ];
        NSData* decodedExponent_ = [ NSData dataWithBase64String: self.exponent ];
        
        const unsigned char* modulusCStr_ = reinterpret_cast<const unsigned char*>(            decodedModulus_.bytes );
        const unsigned char* exp_ = reinterpret_cast<const unsigned char*>(
            decodedExponent_.bytes );
        const unsigned char *plain = reinterpret_cast<const unsigned char*>(
            [ plainText_ cStringUsingEncoding: NSUTF8StringEncoding ] );
        
        size_t modulusSize_  = decodedModulus_.length ;
        size_t exponentSize_ = decodedExponent_.length;
        size_t plainSize_    = [ plainText_ lengthOfBytesUsingEncoding: NSUTF8StringEncoding ];
        
        BIGNUM* bn_mod = NULL;
        BIGNUM* bn_exp = NULL;

        bn_mod = BN_bin2bn(modulusCStr_, static_cast<int>( modulusSize_ ), NULL); // Convert both values to BIGNUM
        ObjcScopedGuard bn_mod_guard( ^void(){ BN_free( bn_mod ); } );
        
        bn_exp = BN_bin2bn(exp_, static_cast<int>( exponentSize_ ), NULL);
        ObjcScopedGuard bn_exp_guard( ^void(){ BN_free( bn_exp ); } );

        
        key = RSA_new(); // Create a new RSA key
        ObjcScopedGuard keyGuard_( ^void(){ RSA_free( key ); } );
        bn_mod_guard.Release();
        bn_exp_guard.Release();
        
        key->n = bn_mod; // Assign in the values
        key->e = bn_exp;
        key->d = NULL;
        key->p = NULL;
        key->q = NULL;

        int maxSize = RSA_size(key); // Find the length of the cipher text
//        NSAssert( 0 != maxSize, @"OpenSSL error - invalid maxSize" );

        if ( 0 == maxSize )
        {
            // @adk : error handling should be performed in the calling code
            return nil;
        }



        std::vector<unsigned char> cipherVt( maxSize, 0 );
        unsigned char* cipher = &cipherVt[0];

        int cipherTextSize = RSA_public_encrypt
        (
            static_cast<int>( plainSize_ )
          , plain
          , cipher
          , key
          , RSA_PKCS1_PADDING
        ); // Encrypt plaintext
        
        if ( 0 == cipherTextSize )
        {
            return @"";
        }
        cipherVt.resize( static_cast<size_t>( cipherTextSize ) );
        cipher = &cipherVt[0]; // Just in case resize does reallocation. It should not do it though.
        
        NSData* data_ = [ [ NSData alloc ] initWithBytes: cipher
                                                  length: static_cast<NSUInteger>( maxSize ) ];
        NSString* result_ = [ NSString base64StringFromData: data_
                                                     length: 0 ];

        return result_;
    }
}

-(NSString*)encryptedPassword
{
    return [ self RSA_encryptString: self->_password ];
}

-(NSString*)encryptedLogin
{
    return [ self RSA_encryptString: self->_login ];
}

@end
