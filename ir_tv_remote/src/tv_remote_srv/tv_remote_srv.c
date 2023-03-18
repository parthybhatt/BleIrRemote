/********************************************************************************
* Filename    : volume_control_srv.c

* Author      : Parth Bhatt

* Date        : January 11, 2023

* Description : 

********************************************************************************/

/*******************************************************************************
* Include Files
********************************************************************************/
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "tv_remote_srv.h"
#include "sdk_common.h"
#include "ble.h"
#include "ble_srv_common.h"
#include "nrf_sdh_ble.h"

/*******************************************************************************
* Constants and macros
********************************************************************************/

/*******************************************************************************
* Data types (Structs, enum)
********************************************************************************/

/*******************************************************************************
* Static Variables
********************************************************************************/

/*******************************************************************************
* Static Functions Declaration
********************************************************************************/
static void on_write(ble_trs_t * p_trs, ble_evt_t const * p_ble_evt);

/*******************************************************************************
* Public Functions
********************************************************************************/
ret_code_t ble_trs_init(ble_trs_t* p_trs, ble_trs_init_t* p_init)
{
    ret_code_t              err_code;
    ble_uuid_t              ble_uuid;
    ble_add_char_params_t   char_params;

    p_trs->ir_decode_handler = p_init->ir_decode_handler;
    
    ble_uuid128_t  base_uuid = {TRS_UUID_BASE}; 
    err_code = sd_ble_uuid_vs_add(&base_uuid, &p_trs->uuid_type);
    VERIFY_SUCCESS(err_code);

    ble_uuid.type = p_trs->uuid_type;
    ble_uuid.uuid = TRS_UUID_SERVICE;

    err_code = sd_ble_gatts_service_add(BLE_GATTS_SRVC_TYPE_PRIMARY, &ble_uuid, &p_trs->service_handle);
    VERIFY_SUCCESS(err_code);

    memset(&char_params, 0, sizeof(char_params));
    char_params.uuid        = TRS_UUID_IR_DECODE_CHAR;
    char_params.uuid_type   = p_trs->uuid_type;
    char_params.init_len    = sizeof(uint16_t);
    char_params.max_len     = sizeof(uint16_t);
    char_params.write_access= SEC_OPEN;
    char_params.char_props.write = 1;

    return characteristic_add(p_trs->service_handle, &char_params, &p_trs->ir_decode_char_handle);
}

void ble_trs_on_ble_evt(ble_evt_t const * p_ble_evt, void * p_context)
{
    ble_trs_t* p_trs = (ble_trs_t*)p_context;
    
    switch (p_ble_evt->header.evt_id)
    {
        case BLE_GATTS_EVT_WRITE:
            on_write(p_trs, p_ble_evt);
            break;

        default:
            // No implementation needed.
            break;
    }
}

/*******************************************************************************
* Static Functions
********************************************************************************/

static void on_write(ble_trs_t * p_trs, ble_evt_t const * p_ble_evt)
{
    ble_gatts_evt_write_t const * p_evt_write = &p_ble_evt->evt.gatts_evt.params.write;

    if (   (p_evt_write->handle == p_trs->ir_decode_char_handle.value_handle)
        && (p_evt_write->len == 2)
        && (p_trs->ir_decode_handler != NULL))
    {
        uint16_t data = 0;
        memcpy(&data, &p_evt_write->data, sizeof(data));
        p_trs->ir_decode_handler(p_ble_evt->evt.gap_evt.conn_handle, p_trs, data);
    }
}