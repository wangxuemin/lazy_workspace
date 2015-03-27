#include "didi_protocol_helper.h"
#include "kd_dd_protocol.pb.h"
#include <string.h>

namespace DidiPush {

NetHandler::NetHandler(size_t max_package_bytes)
    : _max_package_bytes(max_package_bytes) 
{
    assert(_max_package_bytes > sizeof(struct outer_header_t));
}
int NetHandler::CheckComplete(const void *message, size_t length)
{
    //is outer_header complete: = means sizeof(header) > 0
    if (length <= sizeof(struct outer_header_t)) {
        return 0;
    }

    //is outer_header valid
    const struct outer_header_t *outer_header = reinterpret_cast<const struct outer_header_t *>(message);
    if (outer_header->magic != static_cast<uint16_t>(DdKd::kMagic)) {
        return -1;
    }
    if (outer_header->data_length <= sizeof(struct outer_header_t) || outer_header->data_length > _max_package_bytes) {
        //bad package
        return -1;
    }
    if (outer_header->payload_offset <= sizeof(struct outer_header_t) ||
            outer_header->payload_offset > outer_header->data_length) {
        return -1;
    }

    //is full package complete
    if (length < outer_header->data_length) {
        //need more data
        return 0;
    }

    //full package is complete
    return outer_header->data_length;
}

Encoder::Encoder(void *encode_buf,size_t buf_size)
    : _data(encode_buf)
    , _size(buf_size)
    , _is_header_initialized(false)
{
    assert(encode_buf != NULL);
    assert(buf_size > sizeof(outer_header_t)); //header cannot be zero,so no =
    _message = reinterpret_cast<struct message_t *>(encode_buf);
}

size_t Encoder::MaxHeaderLength() const
{
    //payload can be nothing
    return _size - sizeof(outer_header_t);
}
size_t Encoder::MaxPayloadLength() const
{
    return _size - payload_offset();
}
bool Encoder::OnEncodeHeaderBegin(size_t header_length)
{
    if (header_length > MaxHeaderLength())
        return false;
    _message->outer_header.magic = static_cast<uint16_t>(kMagic);
    return true;
}

void Encoder::OnEncodeHeaderEnd(size_t header_length)
{
    _is_header_initialized = true;
    _message->outer_header.payload_offset = sizeof(outer_header_t) + header_length;
}

bool Encoder::EncodeHeader(const Header &header)
{
    const size_t header_length = header.ByteSize();

    if (!OnEncodeHeaderBegin(header_length))
        return false;

    if (!header.SerializeToArray(_message->header,header_length))
        return false;

    OnEncodeHeaderEnd(header_length);

    return true;
}
bool Encoder::EncodeHeader(const void* header,size_t header_length)
{
    if (!OnEncodeHeaderBegin(header_length))
        return false;

    memcpy(_message->header,header,header_length);

    OnEncodeHeaderEnd(header_length);

    return true;
}

bool Encoder::OnEncodeBegin(size_t payload_length)
{
    if (!_is_header_initialized)
        return false;

    assert(_size > sizeof(outer_header_t));
    assert(payload_offset() <= _size);

    if (payload_length > MaxPayloadLength())
        return false;

    return true;
}

bool Encoder::OnEncodeEnd(size_t payload_length)
{
    _message->outer_header.data_length = payload_offset() + payload_length;

    _is_header_initialized = false;
    return true;
}

bool Encoder::Encode(const void* payload,size_t payload_length)
{
    if (!OnEncodeBegin(payload_length))
        return false;

    memcpy(reinterpret_cast<char *>(_data) + payload_offset(),payload,payload_length);

    return OnEncodeEnd(payload_length);
}
bool Encoder::Encode(const ::google::protobuf::MessageLite &payload)
{
    const size_t payload_length = payload.ByteSize();
    if (!OnEncodeBegin(payload_length))
        return false;

    if (!payload.SerializeToArray(reinterpret_cast<char *>(_data) + payload_offset(),payload_length))
        return false;

    return OnEncodeEnd(payload_length);
}

bool Encoder::Encode(const Header &header,const ::google::protobuf::MessageLite &payload)
{
    if (!EncodeHeader(header))
        return false;
    return Encode(payload);
}

bool Decoder::DecodeHeader(const void *package,size_t package_size,Header *header)
{
    assert(header != NULL);
    if (package_size <= sizeof(outer_header_t)) {
        return false;
    }
    //NOTE: assume little endian
    _message = reinterpret_cast<const struct message_t *>(package);
    if (package_size != data_length()) {
        return false;
    }

    if (payload_offset() <= sizeof(struct outer_header_t) ||
            payload_offset() > data_length()) {
        return false;
    }

    return header->ParseFromArray(_message->header,payload_offset() - sizeof(struct outer_header_t));
}
bool Decoder::DecodePayload(::google::protobuf::MessageLite *pl)
{
    assert(pl != NULL);
    return pl->ParseFromArray(payload(), payload_length());
}

const void *Decoder::payload() const
{
    return reinterpret_cast<const char *>(_message) + payload_offset();
}

size_t Decoder::payload_length() const
{
    return data_length() - payload_offset();
}

} // namespace didi_protocol
