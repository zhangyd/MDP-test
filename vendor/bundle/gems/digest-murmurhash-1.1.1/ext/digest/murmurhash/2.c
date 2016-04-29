/*
 * MurmurHash2 (C) Austin Appleby
 */

#include "init.h"

static uint32_t
murmur_hash_process2(const char *data, uint32_t length, uint32_t seed)
{
  const uint32_t m = MURMURHASH_MAGIC;
  const uint8_t r = 24;
  uint32_t h, k;

  h = seed ^ length;

  while (4 <= length) {
    k = *(uint32_t*)data;
    k *= m;
    k ^= k >> r;
    k *= m;

    h *= m;
    h ^= k;

    data += 4;
    length -= 4;
  }

  switch (length) {
    case 3: h ^= data[2] << 16;
    case 2: h ^= data[1] << 8;
    case 1: h ^= data[0];
            h *= m;
  }

  h ^= h >> 13;
  h *= m;
  h ^= h >> 15;

  return h;
}

VALUE
murmur2_finish(VALUE self)
{
  uint8_t digest[4];
  uint32_t h;

  h = _murmur_finish32(self, murmur_hash_process2);
  assign_by_endian_32(digest, h);
  return rb_str_new((const char*) digest, 4);
}

VALUE
murmur2_s_digest(int argc, VALUE *argv, VALUE klass)
{
  uint8_t digest[4];
  uint32_t h;
  h = _murmur_s_digest32(argc, argv, klass, murmur_hash_process2);
  assign_by_endian_32(digest, h);
  return rb_str_new((const char*) digest, 4);
}

VALUE
murmur2_s_rawdigest(int argc, VALUE *argv, VALUE klass)
{
  return ULONG2NUM(_murmur_s_digest32(argc, argv, klass, murmur_hash_process2));
}
