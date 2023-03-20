//-----------------------------------------------------------------------------
// Copyright (C) 2021 Merlok
//
// This code is licensed to you under the terms of the GNU GPL, version 2 or,
// at your option, any later version. See the LICENSE.txt file for the text of
// the license.
//-----------------------------------------------------------------------------
// CIPURSE transport cards data and commands
//-----------------------------------------------------------------------------

#ifndef __CIPURSECORE_H__
#define __CIPURSECORE_H__

#include <jansson.h>
#include <stdbool.h>
#include "common.h"
#include "iso7816/apduinfo.h"       // sAPDU
#include "cipurse/cipursecrypto.h"


#define CIPURSE_DEFAULT_KEY {0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73, 0x73}

void CIPURSEPrintInfoFile(uint8_t *data, size_t len);

int CIPURSESelect(bool activate_field, bool leave_field_on, uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);

int CIPURSEChallenge(uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);
int CIPURSEMutalAuthenticate(uint8_t keyIndex, uint8_t *params, uint8_t paramslen, uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);

int CIPURSECreateFile(uint8_t *attr, uint16_t attrlen, uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);
int CIPURSEDeleteFile(uint16_t fileid, uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);

int CIPURSESelectMFFile(uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw) ;
int CIPURSESelectFile(uint16_t fileid, uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);
int CIPURSEReadFileAttributes(uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);
int CIPURSEReadBinary(uint16_t offset, uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);
int CIPURSEUpdateBinary(uint16_t offset, uint8_t *data, uint16_t datalen, uint8_t *result, size_t max_result_len, size_t *result_len, uint16_t *sw);

bool CIPURSEChannelAuthenticate(uint8_t keyindex, uint8_t *key, bool verbose);
void CIPURSECSetActChannelSecurityLevels(CipurseChannelSecurityLevel req, CipurseChannelSecurityLevel resp);

void CIPURSEPrintFileAttr(uint8_t *attr, size_t len);

#endif /* __CIPURSECORE_H__ */
