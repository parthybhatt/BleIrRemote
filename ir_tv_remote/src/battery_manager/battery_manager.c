/********************************************************************************
* Filename    : battery_manager.c

* Author      : Parth Bhatt

* Date        : May 17, 2023

* Description : 

********************************************************************************/

/*******************************************************************************
* Include Files
********************************************************************************/
#include <stdint.h>
#include "battery_manager.h"
#include "nrf_gpio.h"
#include "nrfx_saadc.h"

/*******************************************************************************
* Constants and macros
********************************************************************************/
#define BATTERY_MEAS_ADC_RESOLUTION          NRF_SAADC_RESOLUTION_10BIT

// expansion values of the NRF_SAADC_RESOLUTION macros are 0,1,2,3 for 8bit, 10bit,
// 12bit and 14bit respectively. Hence, to get the number of bits, we use the following
// macro - NUM_BITS_IN_ADC_OUTPUT 
#define NUM_BITS_IN_ADC_OUTPUT              (2 * (BATTERY_MEAS_ADC_RESOLUTION + 4))
#define MAX_SAMPLE_VAL                      (1 << NUM_BITS_IN_ADC_OUTPUT)

#define VOLTAGE_DIVIDER_RH_KOHMS             (1000.0f)
#define VOLTAGE_DIVIDER_RL_KOHMS             (510.0f)
#define BATTERY_VOLTAGE_CALC_SCALE_FACTOR   (\
                VOLTAGE_DIVIDER_RL_KOHMS / \
                (VOLTAGE_DIVIDER_RH_KOHMS + VOLTAGE_DIVIDER_RL_KOHMS) \
                                            )
#define VREF                                (3.3f)
#define NUM_ADC_CNTS_10BIT_RES_3V3_VBATT    (346)

#define VBATT_TO_ADC_COUNTS(Vbatt)          ( (Vbatt* BATTERY_VOLTAGE_CALC_SCALE_FACTOR) / \
                                                (VREF/MAX_SAMPLE_VAL) )

/*******************************************************************************
* Data types (Structs, enum)
********************************************************************************/

/*******************************************************************************
* Static Variables
********************************************************************************/
static uint32_t batt_enable_pin = NRF_GPIO_PIN_MAP(0,14);
static int16_t  last_sample_val = 0xFFFF;
static int16_t  percent_0_adc_cnts = NUM_ADC_CNTS_10BIT_RES_3V3_VBATT;
static int16_t  percent_100_adc_cnts = MAX_SAMPLE_VAL;

/*******************************************************************************
* Static Functions Declaration
********************************************************************************/
static void AdcConversionCompleteCallback(nrfx_saadc_evt_t const * p_event);

/*******************************************************************************
* Public Functions
********************************************************************************/

void BatteryManager_Init(float minBattLvl, float maxBattLvl)
{
    percent_0_adc_cnts = (int16_t) VBATT_TO_ADC_COUNTS(minBattLvl);
    percent_100_adc_cnts = (int16_t) VBATT_TO_ADC_COUNTS(maxBattLvl);

    nrf_gpio_cfg_output(batt_enable_pin);
    nrf_gpio_pin_clear(batt_enable_pin);

    nrfx_saadc_config_t sdaac_config = 
    {
        .resolution = BATTERY_MEAS_ADC_RESOLUTION,
        .oversample = NRF_SAADC_OVERSAMPLE_DISABLED,
        .interrupt_priority = 6,
        .low_power_mode = true,
    };
    nrfx_saadc_init(&sdaac_config, AdcConversionCompleteCallback);
    
    nrf_saadc_channel_config_t channel_config = 
    {
      .resistor_p = NRF_SAADC_RESISTOR_DISABLED,      
      .resistor_n = NRF_SAADC_RESISTOR_DISABLED,      
      .gain       = NRF_SAADC_GAIN1_4,                
      .reference  = NRF_SAADC_REFERENCE_VDD4,     
      .acq_time   = NRF_SAADC_ACQTIME_10US,           
      .mode       = NRF_SAADC_MODE_SINGLE_ENDED,      
      .burst      = NRF_SAADC_BURST_DISABLED,         
      .pin_p      = (nrf_saadc_input_t)(NRF_SAADC_INPUT_AIN7),       
      .pin_n      = NRF_SAADC_INPUT_DISABLED          
    };
    nrfx_saadc_channel_init(7, &channel_config);        

    ret_code_t err_code;
    err_code = nrfx_saadc_buffer_convert(&last_sample_val, 1);

}

void BatteryManager_SampleBattery()
{
    nrfx_err_t err = nrfx_saadc_sample();
}

float BatteryManager_GetLevelVolts()
{
    if(last_sample_val >= 0)
    {
        float adcV = VREF * last_sample_val / MAX_SAMPLE_VAL;
        float scale = BATTERY_VOLTAGE_CALC_SCALE_FACTOR;
        return (adcV / scale);
    }
    else
    {
        return 0;
    }
}

uint8_t BatteryManager_GetBatteryPercent()
{
    uint8_t percent = 0;

    if(last_sample_val < percent_0_adc_cnts)
    {
        percent = 128;
    }
    else
    {
        percent = ( 100 * (last_sample_val - percent_0_adc_cnts) ) / (percent_100_adc_cnts - percent_0_adc_cnts);
    }
    return percent;
}

int16_t BatteryManager_GetLevelADCCounts()
{
    return last_sample_val;
}

/*******************************************************************************
* Static Functions
********************************************************************************/
static void AdcConversionCompleteCallback(nrfx_saadc_evt_t const * p_event)
{
    if(p_event->type == NRFX_SAADC_EVT_DONE)
    {
        ret_code_t err_code;

        err_code = nrfx_saadc_buffer_convert(p_event->data.done.p_buffer, 1);
        APP_ERROR_CHECK(err_code);

        last_sample_val = p_event->data.done.p_buffer[0];
    }
}
