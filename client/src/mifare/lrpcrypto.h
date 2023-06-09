/*-
 * Copyright (C) 2021 Merlok
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 * $Id$
 *
 * description here: Leakage Resilient Primitive (LRP) Specification, https://www.nxp.com/docs/en/application-note/AN12304.pdf
 *
 */

#ifndef __LRPCRYPTO_H
#define __LRPCRYPTO_H

#include "common.h"
#include "crypto/libpcrypto.h"

#define LRP_MAX_PLAINTEXTS_SIZE 16
#define LRP_MAX_UPDATED_KEYS_SIZE 4
#define LRP_MAX_COUNTER_SIZE (CRYPTO_AES128_KEY_SIZE * 4)

typedef struct {
    uint8_t key[CRYPTO_AES128_KEY_SIZE];

    bool useBitPadding;
    size_t plaintextsCount;
    uint8_t plaintexts[LRP_MAX_PLAINTEXTS_SIZE][CRYPTO_AES128_KEY_SIZE];
    size_t updatedKeysCount;
    uint8_t updatedKeys[LRP_MAX_UPDATED_KEYS_SIZE][CRYPTO_AES128_KEY_SIZE];
    size_t useUpdatedKeyNum;

    uint8_t counter[LRP_MAX_COUNTER_SIZE];
    size_t counterLenNibbles; // len in bytes * 2 (or * 2 - 1)
} LRPContext;

void LRPClearContext(LRPContext *ctx);
void LRPSetKey(LRPContext *ctx, uint8_t *key, size_t updatedKeyNum, bool useBitPadding);
void LRPSetKeyEx(LRPContext *ctx, uint8_t *key, uint8_t *counter, size_t counterLenNibbles, size_t updatedKeyNum, bool useBitPadding);
void LRPSetCounter(LRPContext *ctx, uint8_t *counter, size_t counterLenNibbles);
void LRPGeneratePlaintexts(LRPContext *ctx, size_t plaintextsCount);
void LRPGenerateUpdatedKeys(LRPContext *ctx, size_t updatedKeysCount);
void LRPEvalLRP(LRPContext *ctx, uint8_t *iv, size_t ivlen, bool final, uint8_t *y);
void LRPIncCounter(uint8_t *ctr, size_t ctrlen);
void LRPEncode(LRPContext *ctx, uint8_t *data, size_t datalen, uint8_t *resp, size_t *resplen);
void LRPDecode(LRPContext *ctx, uint8_t *data, size_t datalen, uint8_t *resp, size_t *resplen);
void LRPGenSubkeys(uint8_t *key, uint8_t *sk1, uint8_t *sk2);
void LRPCMAC(LRPContext *ctx, uint8_t *data, size_t datalen, uint8_t *cmac);

#endif // __LRPCRYPTO_H
