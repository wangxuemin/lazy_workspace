#include "crypto.h"

int hashData(const char *hashName, const unsigned char *in, int inlen, unsigned char *out, int *outlen)
{
    int idx, err;
    unsigned long hashlen = MAXBLOCKSIZE;

    /* get the index of the hash */
    idx = find_hash(hashName);

    unsigned char *hashcode = new unsigned char[MAXBLOCKSIZE];

    /* call the hash */
    if ((err = hash_memory(idx, in, (unsigned long)inlen, hashcode, &hashlen)) != CRYPT_OK)
    {
        printf("Error hashing data: %s\n", error_to_string(err));
        return -1;
    }

    /* dump to screen */
    for (unsigned int x = 0; x < hash_descriptor[idx].hashsize; x++)
        sprintf((char *)(out + x * 2), "%02x", hashcode[x]);

    *(out + hash_descriptor[idx].hashsize * 2) = '\0';
    delete [] hashcode;

    *outlen = (int)hashlen * 2;
    return 0;

}

int initCipher()
{
    /* register twofish first */
    if (register_cipher(&twofish_desc) == -1)
    {
        printf("Error registering cipher.\n");
        return -1;
    }

    /* register the hash */
    if (register_hash(&md5_desc) == -1)
    {
        printf("Error registering hash cipher.\n");
        return -1;
    }

    if (register_hash(&sha1_desc) == -1)
    {
        printf("Error registering hash cipher.\n");
        return -1;

    }

    return 0;
}

int encryptData(const char *cipherName, unsigned char *key, unsigned char *in, int inlen, unsigned char *out, int *outlen)
{
    int err;
    symmetric_ECB ecb;
    unsigned char in_buffer[CIPHER_BLOCKSZIE];

    /* start up ecb mode */
    if ((err = ecb_start(
                   find_cipher(cipherName), /* index of desired cipher */
                   key, /* the secret key */
                   CIPHER_BLOCKSZIE, /* length of secret key (16 bytes) */
                   0, /* 0 == default # of rounds */
                   &ecb) /* where to store the CTR state */
        ) != CRYPT_OK)
    {
        printf("ecb_start error: %s\n", error_to_string(err));
        return -1;
    }

    /* somehow fill buffer than encrypt it */
    int ipos = 0, ireserved = inlen;
    while (ipos < inlen)
    {
        if (ireserved < CIPHER_BLOCKSZIE)
        {
            //zerobyte padding
            memset(in_buffer, 0, sizeof(in_buffer));
            memcpy(in_buffer, in + ipos, ireserved);
        }
        else
        {
            memcpy(in_buffer, in + ipos, CIPHER_BLOCKSZIE);
        }

        if ((err = ecb_encrypt(
                       in_buffer, /* plaintext */
                       out + ipos, /* ciphertext */
                       CIPHER_BLOCKSZIE, /* length of plaintext pt */
                       &ecb) /* ECB state */
            ) != CRYPT_OK)
        {
            printf("ecb_encrypt error: %s\n", error_to_string(err));
            return -1;
        }

        ipos += CIPHER_BLOCKSZIE;
        ireserved = inlen - ipos;
    }

    *(out + ipos) = '\0';
    *outlen = ipos;

    /* terminate the stream */
    if ((err = ecb_done(&ecb)) != CRYPT_OK)
    {
        printf("ecb_done error: %s\n", error_to_string(err));
        return -1;
    }

    /* clear up and return */
    zeromem(&ecb, sizeof(ecb));

    return 0;

}

int decryptData(const char *cipherName, unsigned char *key, unsigned char *in, int inlen, unsigned char *out, int *outlen)
{
    int err;
    symmetric_ECB ecb;
    unsigned char in_buffer[CIPHER_BLOCKSZIE];

    /* start up ecb mode */
    if ((err = ecb_start(
                   find_cipher(cipherName), /* index of desired cipher */
                   key, /* the secret key */
                   CIPHER_BLOCKSZIE, /* length of secret key (16 bytes) */
                   0, /* 0 == default # of rounds */
                   &ecb) /* where to store the CTR state */
        ) != CRYPT_OK)
    {
        printf("ecb_start error: %s\n", error_to_string(err));
        return -1;
    }

    /* somehow fill buffer than encrypt it */
    int ipos = 0, ireserved = inlen;
    while (ipos < inlen)
    {
        if (ireserved < CIPHER_BLOCKSZIE)
        {
            //zerobyte padding
            memset(in_buffer, 0, sizeof(in_buffer));
            memcpy(in_buffer, in + ipos, ireserved);
        }
        else
        {
            memcpy(in_buffer, in + ipos, CIPHER_BLOCKSZIE);
        }

        if ((err = ecb_decrypt(
                       in_buffer, /* plaintext */
                       out + ipos, /* ciphertext */
                       CIPHER_BLOCKSZIE, /* length of plaintext pt */
                       &ecb) /* ECB state */
            ) != CRYPT_OK)
        {
            printf("ecb_decrypt error: %s\n", error_to_string(err));
            return -1;
        }

        ipos += CIPHER_BLOCKSZIE;
        ireserved = inlen - ipos;
    }

    *(out + ipos) = '\0';
    *outlen = ipos;

    /* terminate the stream */
    if ((err = ecb_done(&ecb)) != CRYPT_OK)
    {
        printf("ecb_done error: %s\n", error_to_string(err));
        return -1;
    }

    /* clear up and return */
    zeromem(&ecb, sizeof(ecb));

    return 0;

}

int getKey(const unsigned char *orginal, int orginallen, unsigned char *key, int *keylen)
{
    int ipos = 0;
    int istep = orginallen / CIPHER_KEY_LEN;

    for (int i = 0; i < CIPHER_KEY_LEN; i++)
    {
        memcpy(&ipos, orginal + i * istep, sizeof(unsigned char));
        ipos = ipos << 1;
        *(key + i) = *(orginal + ipos);
        ipos = 0;
    }

    *keylen = CIPHER_KEY_LEN;

    return 0;
}