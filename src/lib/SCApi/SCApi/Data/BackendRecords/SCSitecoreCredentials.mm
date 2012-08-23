#import "SCSitecoreCredentials.h"

#include <openssl/crypto.h>
#include <openssl/bn.h>
#include <openssl/rsa.h>

#include <vector>
#include <algorithm>
#import <ObjcScopedGuard/ObjcScopedGuard.h>

using namespace ::Utils;

@interface SCSitecoreCredentials ()

@property ( nonatomic ) NSString* encryptedPassword;

@end

@implementation SCSitecoreCredentials

-(NSString*)password
{
    return self->_password ?: @"";
}

-(NSString*)RSA_encryptCredentials
{
    if ( ![ self.password hasSymbols ] )
    {
        return @"";
    }
    
    
    RSA* key = NULL;

    const unsigned char* modulusCStr_ = reinterpret_cast<const unsigned char*>(
        [ self.modulus cStringUsingEncoding: NSUTF8StringEncoding ] );
    const unsigned char* exp_ = reinterpret_cast<const unsigned char*>(
        [ self.exponent cStringUsingEncoding: NSUTF8StringEncoding ] );
    const unsigned char *plain = reinterpret_cast<const unsigned char*>(
        [ self.password cStringUsingEncoding: NSUTF8StringEncoding ] );
    
    size_t modulusSize_  = [ self.modulus  lengthOfBytesUsingEncoding: NSUTF8StringEncoding ];
    size_t exponentSize_ = [ self.exponent lengthOfBytesUsingEncoding: NSUTF8StringEncoding ];
    size_t plainSize_    = [ self.password lengthOfBytesUsingEncoding: NSUTF8StringEncoding ];
    
    BIGNUM* bn_mod = NULL;
    BIGNUM* bn_exp = NULL;

    bn_mod = BN_bin2bn(modulusCStr_, modulusSize_, NULL); // Convert both values to BIGNUM
    ObjcScopedGuard bn_mod_guard( ^void(){ BN_free( bn_mod ); } );
    
    bn_exp = BN_bin2bn(exp_, exponentSize_, NULL);
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
    NSAssert( 0 != maxSize, @"OpenSSL error - invalid maxSize" );



    std::vector<unsigned char> cipherVt( maxSize, 0 );
    unsigned char* cipher = &cipherVt[0];

    RSA_public_encrypt
    (
        plainSize_
      , plain
      , cipher
      , key
      , RSA_PKCS1_PADDING
    ); // Encrypt plaintext
    
    
    
    // http://msdn.microsoft.com/ru-ru/library/system.security.cryptography.rsacryptoserviceprovider.aspx
    // RSACryptoServiceProvider reverts byte order
    std::reverse( cipherVt.begin(), cipherVt.end() );
    cipher = &cipherVt[0]; // just in case
    
    NSData* data_ = [ [ NSData alloc ] initWithBytes: cipher
                                              length: maxSize ];
    NSString* result_ = [ NSString base64StringFromData: data_
                                                 length: 0 ];

    return result_;
}

-(NSString*)encryptedPassword
{
    if ( !self->_encryptedPassword )
    {
        self->_encryptedPassword = [ self RSA_encryptCredentials ];
    }
    return self->_encryptedPassword;
}

@end
