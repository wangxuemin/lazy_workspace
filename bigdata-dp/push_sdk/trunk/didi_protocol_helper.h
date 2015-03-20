/*
 * full package = outer_header + header + payload
 * outer_header = magic(2B) + payload_offset(2B,payload offset) + data_length(4B,full package length) ,see outer_header_t
 * header       = (outer_header.payload_offset - sizeof(outer_header)) bytes，see protobuf message Header
 * payload      = (data_length - outer_header.payload_offset) bytes, decided by Header.type
 * NOTE: assume little endian
 *
 */

#ifndef __DIDI_PROTOCOL_HELPER_H__
#define __DIDI_PROTOCOL_HELPER_H__

#include "didi_protocol.pb.h"

namespace DidiPush {

#pragma pack(push)
#pragma pack(1)
struct outer_header_t {
    uint16_t magic;
    uint16_t payload_offset;
    uint32_t data_length;
};
struct message_t {
    struct outer_header_t outer_header;
    unsigned char header[1];
};
#pragma pack(pop)

const uint64_t kNullMsgId = 0;
const uint64_t kNullAuthUserId = 0;

const size_t kDefaultMaxPackageBytes = 1048576; //1MB

class NetHandler
{
public:
    NetHandler(size_t max_package_bytes = kDefaultMaxPackageBytes);
    /*
     * check is received data include a full package
     *  Return
     *      0 : need receive more data
     *     -1 : message is bad, should disconnect
     *     >0 : full package's length(<= length)
     */
    int CheckComplete(const void *message, size_t length);
private:
    size_t _max_package_bytes;
};

class Encoder
{
public:
    Encoder(void *encode_buf,size_t buf_size);
    //build pattern: EncodeHeader -> Encode
    bool EncodeHeader(const Header &header);
    //build pattern: EncodeHeader -> Encode
    bool EncodeHeader(const void* header,size_t header_length);

    //build pattern: EncodeHeader -> Encode
    bool Encode(const ::google::protobuf::MessageLite &payload);

    //build pattern: EncodeHeader -> Encode
    bool Encode(const void* payload,size_t payload_length);

    //one build
    bool Encode(const Header &header,const ::google::protobuf::MessageLite &payload);

    void * Data() const { return _data; }
    size_t DataLen() const { return _message->outer_header.data_length; }
private:
    uint16_t payload_offset() const { return _message->outer_header.payload_offset; }
    bool OnEncodeHeaderBegin(size_t header_length);
    void OnEncodeHeaderEnd(size_t header_length);
    bool OnEncodeBegin(size_t payload_length);
    bool OnEncodeEnd(size_t payload_length);

    size_t MaxHeaderLength() const;
    size_t MaxPayloadLength() const;
private:
    void *_data;
    size_t _size;
    struct message_t *_message;
    bool _is_header_initialized;
};

class Decoder
{
public:
    Decoder():_message(NULL) {}
    bool DecodeHeader(const void *package,size_t package_size,DidiPush::Header *header);
    bool DecodePayload(::google::protobuf::MessageLite *payload);

    uint32_t data_length() const { return _message->outer_header.data_length; }
    uint16_t payload_offset() const { return _message->outer_header.payload_offset; }
    const void *payload() const;
    size_t payload_length() const;
private:
    const message_t *_message;
};
}  // namespace didi_protocol

#endif //__DIDI_PROTOCOL_HELPER_H__
