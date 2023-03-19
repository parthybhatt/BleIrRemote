/********************************************************************************
* Filename    : ir_send.c

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
#include "ir_send.h"
#include "nrf_drv_pwm.h"
#include "nrf_gpio.h"

/*******************************************************************************
* Constants and macros
********************************************************************************/
#define MARK_DUTY_CYCLE         50
#define SPACE_DUTY_CYCLE        0
#define NUM_MARKS_IN_ONE        2
#define NUM_MARKS_IN_START      4
#define NUM_MARKS_IN_ZERO       1
#define NUM_SPACES              1

#define PERIOD_40KHZ_USEC       25

#define SONY_UNIT_PERIOD_USEC   600
#define SONY_CYCLES_PER_UNIT    (SONY_UNIT_PERIOD_USEC / PERIOD_40KHZ_USEC)

#define MAX_BITS_PER_CODE       12

// Each 600ms is 24 cycles of 40kHz frequency
// 1 takes 3 sony units (1200ms 40kHz signal 600ms blank) and
// 0 takes 2 sony units (600ms 40kHz signal 600ms blank)
// If all 12 bits are 1s, it would take 24*3*12 cycles
// Adding 4 units of start signal, we get 960 cycles
#define MAX_CYCLES_PER_CODE     960     
/*******************************************************************************
* Data types (Structs, enum)
********************************************************************************/

/*******************************************************************************
* Static Variables
********************************************************************************/
static uint16_t TotalCycleCount = 0;
static nrf_drv_pwm_t m_pwm0 = NRF_DRV_PWM_INSTANCE(0);
static nrf_pwm_values_common_t seq0_values[MAX_CYCLES_PER_CODE];
static nrf_pwm_values_common_t seq1_values[] =
{ SPACE_DUTY_CYCLE, SPACE_DUTY_CYCLE, SPACE_DUTY_CYCLE, SPACE_DUTY_CYCLE, SPACE_DUTY_CYCLE};

nrf_pwm_sequence_t seq0 =
{
  .values.p_common = seq0_values,
  .length = NRF_PWM_VALUES_LENGTH(seq0_values),
  .repeats = 0,
  .end_delay = 0
};

nrf_pwm_sequence_t const seq1 =
{
  .values.p_common = seq1_values,
  .length = NRF_PWM_VALUES_LENGTH(seq1_values),
  .repeats = 250,
  .end_delay = 0
};

/*******************************************************************************
* Static Functions Declaration
********************************************************************************/
static void PwmInit(uint8_t irPin);
static void ResetTransmission();
static void AddStartPulse();
static void AddOne();
static void AddZero();
static void AddMark(uint8_t numMarks);
static void AddSpace(uint8_t numSpaces);

/*******************************************************************************
* Public Functions
********************************************************************************/
void IrSend_Init(uint8_t pinNum)
{
    PwmInit(pinNum);
    nrf_gpio_cfg(pinNum,
            NRF_GPIO_PIN_DIR_OUTPUT,
            NRF_GPIO_PIN_INPUT_DISCONNECT,
            NRF_GPIO_PIN_PULLUP,
            NRF_GPIO_PIN_H0H1,
            NRF_GPIO_PIN_NOSENSE);
}

void IrSend_Transmit(uint16_t irCode)
{
    ResetTransmission();
    AddStartPulse();
    for (uint32_t tMask = (1UL << (MAX_BITS_PER_CODE - 1)); tMask; tMask >>= 1)
    {
        if (irCode & tMask)
        {
            AddOne();
        }
        else
        {
            AddZero();
        }
    }
    if(TotalCycleCount < MAX_CYCLES_PER_CODE)
    {
        seq0.length = TotalCycleCount;
        ret_code_t errCode = nrf_drv_pwm_complex_playback(&m_pwm0, &seq0, &seq1, 3, NRFX_PWM_FLAG_STOP);
        APP_ERROR_CHECK(errCode);
    }
    else
    {
        ResetTransmission();
    }
}

/*******************************************************************************
* Static Functions
********************************************************************************/

static void PwmInit(uint8_t irPin)
{
    nrf_drv_pwm_config_t const config0 =
    {
        .output_pins =
        {
        irPin,
        NRF_DRV_PWM_PIN_NOT_USED,
        NRF_DRV_PWM_PIN_NOT_USED,
        NRF_DRV_PWM_PIN_NOT_USED,
        },
        .irq_priority = APP_IRQ_PRIORITY_LOWEST,
        .base_clock   = NRF_PWM_CLK_4MHz,
        .count_mode   = NRF_PWM_MODE_UP,
        .top_value    = 100,
        .load_mode    = NRF_PWM_LOAD_COMMON,
        .step_mode    = NRF_PWM_STEP_AUTO
    };

    // Init PWM without error handler
    ret_code_t errCode = nrf_drv_pwm_init(&m_pwm0, &config0, NULL);
    APP_ERROR_CHECK(errCode);
}

static void ResetTransmission()
{
    TotalCycleCount = 0;
}

static void AddStartPulse()
{
    AddMark(NUM_MARKS_IN_START);
    AddSpace(NUM_SPACES);
}

static void AddOne()
{
    AddMark(NUM_MARKS_IN_ONE);
    AddSpace(NUM_SPACES);
}

static void AddZero()
{
    AddMark(NUM_MARKS_IN_ZERO);
    AddSpace(NUM_SPACES);
}

static void AddMark(uint8_t numMarks)
{
    uint16_t limit = TotalCycleCount + (SONY_CYCLES_PER_UNIT * numMarks);
    for(uint16_t j = TotalCycleCount; j < limit && j < MAX_CYCLES_PER_CODE; j++)
    {
        seq0_values[j] = MARK_DUTY_CYCLE;
    }
    TotalCycleCount += (SONY_CYCLES_PER_UNIT*numMarks);
}

static void AddSpace(uint8_t numSpaces)
{
    TotalCycleCount += (SONY_CYCLES_PER_UNIT*numSpaces);
    if(TotalCycleCount < MAX_CYCLES_PER_CODE)
    {
        memset(&seq0_values[TotalCycleCount], SPACE_DUTY_CYCLE, SONY_CYCLES_PER_UNIT*numSpaces);
    }
}