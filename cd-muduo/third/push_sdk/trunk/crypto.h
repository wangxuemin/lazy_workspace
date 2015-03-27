#ifndef CRYPTO_H_
#define CRYPTO_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <tomcrypt.h>

const char HASH_MD5[] = "md5";
const char HASH_SHA1[] = "sha1";
const char CIPHER[] = "twofish";
const int  CIPHER_KEY_LEN = 16;
const int  CIPHER_BLOCKSZIE = 16;

int hashData(const char *hashName, const unsigned char *in, int inlen, unsigned char *out, int *outlen);

int initCipher();
int encryptData(const char *cipherName, unsigned char *key, unsigned char *in, int inlen, unsigned char *out, int *outlen);
int decryptData(const char *cipherName, unsigned char *key, unsigned char *in, int inlen, unsigned char *out, int *outlen);

int getKey(const unsigned char *orginal, int orginallen, unsigned char *key, int *keylen);

#endif