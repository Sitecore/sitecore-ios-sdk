#import "SCSitecoreCredentials.h"

#include <openssl/crypto.h>
#include <openssl/bn.h>
#include <openssl/rsa.h>

@interface SCSitecoreCredentials ()

@property ( nonatomic ) NSString* encryptedPassword;

@end

@implementation SCSitecoreCredentials

@synthesize login   = _login
, password          = _password
, modulus           = _modulus
, exponent          = _exponent
, encryptedPassword = _encryptedPassword;

-(NSString*)password
{
    return self->_password ?: @"";
}

-(NSString*)RSA_encryptCredentials
{
    RSA* key;

    const unsigned char* modulusCStr_ =
    (const unsigned char*)[ self.modulus cStringUsingEncoding: NSUTF8StringEncoding ];
    const unsigned char* exp_ =
    (const unsigned char*)[ self.exponent cStringUsingEncoding: NSUTF8StringEncoding ];

    BIGNUM * bn_mod = NULL;
    BIGNUM * bn_exp = NULL;

    bn_mod = BN_bin2bn(modulusCStr_, strlen( (const char*)modulusCStr_ ), NULL); // Convert both values to BIGNUM
    bn_exp = BN_bin2bn(exp_, strlen( (const char*)exp_ ), NULL);

    key = RSA_new(); // Create a new RSA key
    key->n = bn_mod; // Assign in the values
    key->e = bn_exp;
    key->d = NULL;
    key->p = NULL;
    key->q = NULL;

    int maxSize = RSA_size(key); // Find the length of the cipher text

    const char *plain = [ self.password cStringUsingEncoding: NSUTF8StringEncoding ]; 

    const char * cipher = malloc( maxSize*sizeof( char ) );
    memset((void*)cipher, 0, maxSize );
    RSA_public_encrypt( strlen(plain)
                       , (unsigned char *)plain
                       , (unsigned char *)cipher
                       , key
                       , RSA_PKCS1_PADDING); // Encrypt plaintext
    RSA_free( key );

    NSData* data_ = [ [ NSData alloc ] initWithBytes: cipher length: maxSize ];
    NSString* result_ = [ NSString base64StringFromData: data_ length: 0 ];

    free( (void*)cipher );

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
