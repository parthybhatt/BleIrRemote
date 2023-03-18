/********************************************************************************
* Filename    : volume_control_srv.h

* Author      : Parth Bhatt

* Date        : January 11, 2023

* Description : 

********************************************************************************/

#ifndef __TV_REMOTE_SRV_H__
#define __TV_REMOTE_SRV_H__

/*******************************************************************************
* Include Files
********************************************************************************/
#include <stdint.h>
#include <stdbool.h>
#include "ble.h"
#include "ble_srv_common.h"
#include "nrf_sdh_ble.h"

/*******************************************************************************
* Constants and macros
********************************************************************************/
#define BLE_TRS_BLE_OBSERVER_PRIO                   2

#define BLE_TRS_DEF(_name)                          \
    static ble_trs_t _name;                         \
    NRF_SDH_BLE_OBSERVER(_name ## _obs,             \
                         BLE_TRS_BLE_OBSERVER_PRIO, \
                         ble_trs_on_ble_evt,        \
                         &_name)

#define TRS_UUID_BASE       {0x23, 0xD1, 0xBC, 0xEA, 0x5F, 0x78, 0x23, 0x15, \
                              0xDE, 0xEF, 0x12, 0x12, 0x00, 0x00, 0x00, 0x00}

//{0x2f, 0xfa, 0x49, 0xb1, 0x26, 0xd5, 0x42, 0x46, \
//                             0x93, 0xac, 0x92, 0x01, 0x00, 0x00, 0x00, 0x00}
#define TRS_UUID_SERVICE            0x1484
#define TRS_UUID_IR_DECODE_CHAR     0x1485

/*******************************************************************************
* Data types
********************************************************************************/
typedef struct ble_trs_s    ble_trs_t;

typedef void (*ble_ir_decode_handler_t)   (uint16_t conn_handle, ble_trs_t * p_trs, uint16_t ir_code);

typedef struct
{
    ble_ir_decode_handler_t     ir_decode_handler;
} ble_trs_init_t;

struct ble_trs_s
{
    uint16_t                    service_handle;
    ble_gatts_char_handles_t    ir_decode_char_handle;
    uint8_t                     uuid_type;
    ble_ir_decode_handler_t     ir_decode_handler;
};


/*******************************************************************************
* Global Variables
********************************************************************************/

/*******************************************************************************
* Functions
********************************************************************************/

ret_code_t ble_trs_init(ble_trs_t* p_trs, ble_trs_init_t* p_init);
void ble_trs_on_ble_evt(ble_evt_t const * p_ble_evt, void * p_context);

#endif