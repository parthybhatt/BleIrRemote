MEMORY
{
  UNPLACED_SECTIONS (wx) : ORIGIN = 0x100000000, LENGTH = 0
  RAM1 (wx) : ORIGIN = 0x20000000, LENGTH = 0x00040000
  FLASH1 (wx) : ORIGIN = 0x00000000, LENGTH = 0x00100000
}

SECTIONS
{
  __RAM1_segment_start__ = 0x20000000;
  __RAM1_segment_end__ = 0x20040000;
  __RAM1_segment_size__ = 0x00040000;
  __FLASH1_segment_start__ = 0x00000000;
  __FLASH1_segment_end__ = 0x00100000;
  __FLASH1_segment_size__ = 0x00100000;

  __HEAPSIZE__ = 8192;
  __STACKSIZE_PROCESS__ = 0;
  __STACKSIZE__ = 8192;

  __reserved_ram_load_start__ = 0x20000000;
  .reserved_ram 0x20000000 (NOLOAD) : AT(0x20000000)
  {
    __reserved_ram_start__ = .;
    *(.reserved_ram .reserved_ram.*)
    . = MAX(__reserved_ram_start__ + 0x20002300-0x20000000 , .);
  }
  __reserved_ram_end__ = __reserved_ram_start__ + SIZEOF(.reserved_ram);
  __reserved_ram_size__ = SIZEOF(.reserved_ram);
  __reserved_ram_load_end__ = __reserved_ram_end__;

  . = ASSERT(__reserved_ram_start__ == __reserved_ram_end__ || (__reserved_ram_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .reserved_ram is too large to fit in RAM1 memory segment");

  __vectors_ram_load_start__ = 0x20002300;
  .vectors_ram 0x20002300 (NOLOAD) : AT(0x20002300)
  {
    __vectors_ram_start__ = .;
    __app_ram_start__ =   __vectors_ram_start__;
    *(.vectors_ram .vectors_ram.*)
  }
  __vectors_ram_end__ = __vectors_ram_start__ + SIZEOF(.vectors_ram);
  __vectors_ram_size__ = SIZEOF(.vectors_ram);
  __vectors_ram_load_end__ = __vectors_ram_end__;

  . = ASSERT(__vectors_ram_start__ == __vectors_ram_end__ || (__vectors_ram_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .vectors_ram is too large to fit in RAM1 memory segment");
  . = ASSERT(__reserved_ram_end__ <= __vectors_ram_start__ , "error: section .reserved_ram overlaps absolute placed section .vectors_ram");

  __nrf_sections_run_load_start__ = ALIGN(__vectors_ram_end__ , 4);
  .nrf_sections_run ALIGN(__vectors_ram_end__ , 4) (NOLOAD) : AT(ALIGN(__vectors_ram_end__ , 4))
  {
    __nrf_sections_run_start__ = .;
    __start_nrf_sections_run =   __nrf_sections_run_start__;
    KEEP(*(.nrf_sections_run .nrf_sections_run.*))
  }
  __nrf_sections_run_end__ = __nrf_sections_run_start__ + SIZEOF(.nrf_sections_run);
  __nrf_sections_run_size__ = SIZEOF(.nrf_sections_run);
  __nrf_sections_run_load_end__ = __nrf_sections_run_end__;

  . = ASSERT(__nrf_sections_run_start__ == __nrf_sections_run_end__ || (__nrf_sections_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .nrf_sections_run is too large to fit in RAM1 memory segment");

  __reserved_flash_load_start__ = 0x0;
  .reserved_flash 0x0 (NOLOAD) : AT(0x0)
  {
    __reserved_flash_start__ = .;
    *(.reserved_flash .reserved_flash.*)
    . = MAX(__reserved_flash_start__ + 0x27000-0x0 , .);
  }
  __reserved_flash_end__ = __reserved_flash_start__ + SIZEOF(.reserved_flash);
  __reserved_flash_size__ = SIZEOF(.reserved_flash);
  __reserved_flash_load_end__ = __reserved_flash_end__;

  . = ASSERT(__reserved_flash_start__ == __reserved_flash_end__ || (__reserved_flash_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .reserved_flash is too large to fit in FLASH1 memory segment");

  __vectors_load_start__ = 0x27000;
  .vectors 0x27000 : AT(0x27000)
  {
    __vectors_start__ = .;
    *(.vectors .vectors.*)
  }
  __vectors_end__ = __vectors_start__ + SIZEOF(.vectors);
  __vectors_size__ = SIZEOF(.vectors);
  __vectors_load_end__ = __vectors_end__;

  . = ASSERT(__vectors_start__ == __vectors_end__ || (__vectors_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .vectors is too large to fit in FLASH1 memory segment");
  . = ASSERT(__reserved_flash_end__ <= __vectors_start__ , "error: section .reserved_flash overlaps absolute placed section .vectors");

  __init_load_start__ = ALIGN(__vectors_end__ , 4);
  .init ALIGN(__vectors_end__ , 4) : AT(ALIGN(__vectors_end__ , 4))
  {
    __init_start__ = .;
    *(.init .init.*)
  }
  __init_end__ = __init_start__ + SIZEOF(.init);
  __init_size__ = SIZEOF(.init);
  __init_load_end__ = __init_end__;

  . = ASSERT(__init_start__ == __init_end__ || (__init_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .init is too large to fit in FLASH1 memory segment");

  __init_rodata_load_start__ = ALIGN(__init_end__ , 4);
  .init_rodata ALIGN(__init_end__ , 4) : AT(ALIGN(__init_end__ , 4))
  {
    __init_rodata_start__ = .;
    *(.init_rodata .init_rodata.*)
  }
  __init_rodata_end__ = __init_rodata_start__ + SIZEOF(.init_rodata);
  __init_rodata_size__ = SIZEOF(.init_rodata);
  __init_rodata_load_end__ = __init_rodata_end__;

  . = ASSERT(__init_rodata_start__ == __init_rodata_end__ || (__init_rodata_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .init_rodata is too large to fit in FLASH1 memory segment");

  __text_load_start__ = ALIGN(__init_rodata_end__ , 4);
  .text ALIGN(__init_rodata_end__ , 4) : AT(ALIGN(__init_rodata_end__ , 4))
  {
    __text_start__ = .;
    *(.text .text.* .gnu.linkonce.t.* .glue_7t .glue_7 .gcc_except_table .ARM.extab* .gnu.linkonce.armextab.*)
    . = ALIGN(MAX(__text_start__ + 0x4 , .), 4);
  }
  __text_end__ = __text_start__ + SIZEOF(.text);
  __text_size__ = SIZEOF(.text);
  __text_load_end__ = __text_end__;

  . = ASSERT(__text_start__ == __text_end__ || (__text_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .text is too large to fit in FLASH1 memory segment");

  __sdh_soc_observers_load_start__ = ALIGN(__text_end__ , 4);
  .sdh_soc_observers ALIGN(__text_end__ , 4) : AT(ALIGN(__text_end__ , 4))
  {
    __sdh_soc_observers_start__ = .;
    __start_sdh_soc_observers =   __sdh_soc_observers_start__;
    KEEP(*(SORT(.sdh_soc_observers*)))
  }
  __sdh_soc_observers_end__ = __sdh_soc_observers_start__ + SIZEOF(.sdh_soc_observers);
  __sdh_soc_observers_size__ = SIZEOF(.sdh_soc_observers);
  __stop_sdh_soc_observers =   __sdh_soc_observers_end__;
  __sdh_soc_observers_load_end__ = __sdh_soc_observers_end__;

  . = ASSERT(__sdh_soc_observers_start__ == __sdh_soc_observers_end__ || (__sdh_soc_observers_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .sdh_soc_observers is too large to fit in FLASH1 memory segment");

  __pwr_mgmt_data_load_start__ = ALIGN(__sdh_soc_observers_end__ , 4);
  .pwr_mgmt_data ALIGN(__sdh_soc_observers_end__ , 4) : AT(ALIGN(__sdh_soc_observers_end__ , 4))
  {
    __pwr_mgmt_data_start__ = .;
    __start_pwr_mgmt_data =   __pwr_mgmt_data_start__;
    KEEP(*(SORT(.pwr_mgmt_data*)))
  }
  __pwr_mgmt_data_end__ = __pwr_mgmt_data_start__ + SIZEOF(.pwr_mgmt_data);
  __pwr_mgmt_data_size__ = SIZEOF(.pwr_mgmt_data);
  __stop_pwr_mgmt_data =   __pwr_mgmt_data_end__;
  __pwr_mgmt_data_load_end__ = __pwr_mgmt_data_end__;

  . = ASSERT(__pwr_mgmt_data_start__ == __pwr_mgmt_data_end__ || (__pwr_mgmt_data_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .pwr_mgmt_data is too large to fit in FLASH1 memory segment");

  __sdh_ble_observers_load_start__ = ALIGN(__pwr_mgmt_data_end__ , 4);
  .sdh_ble_observers ALIGN(__pwr_mgmt_data_end__ , 4) : AT(ALIGN(__pwr_mgmt_data_end__ , 4))
  {
    __sdh_ble_observers_start__ = .;
    __start_sdh_ble_observers =   __sdh_ble_observers_start__;
    KEEP(*(SORT(.sdh_ble_observers*)))
  }
  __sdh_ble_observers_end__ = __sdh_ble_observers_start__ + SIZEOF(.sdh_ble_observers);
  __sdh_ble_observers_size__ = SIZEOF(.sdh_ble_observers);
  __stop_sdh_ble_observers =   __sdh_ble_observers_end__;
  __sdh_ble_observers_load_end__ = __sdh_ble_observers_end__;

  . = ASSERT(__sdh_ble_observers_start__ == __sdh_ble_observers_end__ || (__sdh_ble_observers_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .sdh_ble_observers is too large to fit in FLASH1 memory segment");

  __sdh_req_observers_load_start__ = ALIGN(__sdh_ble_observers_end__ , 4);
  .sdh_req_observers ALIGN(__sdh_ble_observers_end__ , 4) : AT(ALIGN(__sdh_ble_observers_end__ , 4))
  {
    __sdh_req_observers_start__ = .;
    __start_sdh_req_observers =   __sdh_req_observers_start__;
    KEEP(*(SORT(.sdh_req_observers*)))
  }
  __sdh_req_observers_end__ = __sdh_req_observers_start__ + SIZEOF(.sdh_req_observers);
  __sdh_req_observers_size__ = SIZEOF(.sdh_req_observers);
  __stop_sdh_req_observers =   __sdh_req_observers_end__;
  __sdh_req_observers_load_end__ = __sdh_req_observers_end__;

  . = ASSERT(__sdh_req_observers_start__ == __sdh_req_observers_end__ || (__sdh_req_observers_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .sdh_req_observers is too large to fit in FLASH1 memory segment");

  __sdh_state_observers_load_start__ = ALIGN(__sdh_req_observers_end__ , 4);
  .sdh_state_observers ALIGN(__sdh_req_observers_end__ , 4) : AT(ALIGN(__sdh_req_observers_end__ , 4))
  {
    __sdh_state_observers_start__ = .;
    __start_sdh_state_observers =   __sdh_state_observers_start__;
    KEEP(*(SORT(.sdh_state_observers*)))
  }
  __sdh_state_observers_end__ = __sdh_state_observers_start__ + SIZEOF(.sdh_state_observers);
  __sdh_state_observers_size__ = SIZEOF(.sdh_state_observers);
  __stop_sdh_state_observers =   __sdh_state_observers_end__;
  __sdh_state_observers_load_end__ = __sdh_state_observers_end__;

  . = ASSERT(__sdh_state_observers_start__ == __sdh_state_observers_end__ || (__sdh_state_observers_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .sdh_state_observers is too large to fit in FLASH1 memory segment");

  __sdh_stack_observers_load_start__ = ALIGN(__sdh_state_observers_end__ , 4);
  .sdh_stack_observers ALIGN(__sdh_state_observers_end__ , 4) : AT(ALIGN(__sdh_state_observers_end__ , 4))
  {
    __sdh_stack_observers_start__ = .;
    __start_sdh_stack_observers =   __sdh_stack_observers_start__;
    KEEP(*(SORT(.sdh_stack_observers*)))
  }
  __sdh_stack_observers_end__ = __sdh_stack_observers_start__ + SIZEOF(.sdh_stack_observers);
  __sdh_stack_observers_size__ = SIZEOF(.sdh_stack_observers);
  __stop_sdh_stack_observers =   __sdh_stack_observers_end__;
  __sdh_stack_observers_load_end__ = __sdh_stack_observers_end__;

  . = ASSERT(__sdh_stack_observers_start__ == __sdh_stack_observers_end__ || (__sdh_stack_observers_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .sdh_stack_observers is too large to fit in FLASH1 memory segment");

  __nrf_queue_load_start__ = ALIGN(__sdh_stack_observers_end__ , 4);
  .nrf_queue ALIGN(__sdh_stack_observers_end__ , 4) : AT(ALIGN(__sdh_stack_observers_end__ , 4))
  {
    __nrf_queue_start__ = .;
    __start_nrf_queue =   __nrf_queue_start__;
    KEEP(*(.nrf_queue*))
  }
  __nrf_queue_end__ = __nrf_queue_start__ + SIZEOF(.nrf_queue);
  __nrf_queue_size__ = SIZEOF(.nrf_queue);
  __stop_nrf_queue =   __nrf_queue_end__;
  __nrf_queue_load_end__ = __nrf_queue_end__;

  . = ASSERT(__nrf_queue_start__ == __nrf_queue_end__ || (__nrf_queue_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .nrf_queue is too large to fit in FLASH1 memory segment");

  __nrf_balloc_load_start__ = ALIGN(__nrf_queue_end__ , 4);
  .nrf_balloc ALIGN(__nrf_queue_end__ , 4) : AT(ALIGN(__nrf_queue_end__ , 4))
  {
    __nrf_balloc_start__ = .;
    __start_nrf_balloc =   __nrf_balloc_start__;
    KEEP(*(.nrf_balloc*))
  }
  __nrf_balloc_end__ = __nrf_balloc_start__ + SIZEOF(.nrf_balloc);
  __nrf_balloc_size__ = SIZEOF(.nrf_balloc);
  __stop_nrf_balloc =   __nrf_balloc_end__;
  __nrf_balloc_load_end__ = __nrf_balloc_end__;

  . = ASSERT(__nrf_balloc_start__ == __nrf_balloc_end__ || (__nrf_balloc_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .nrf_balloc is too large to fit in FLASH1 memory segment");

  __cli_command_load_start__ = ALIGN(__nrf_balloc_end__ , 4);
  .cli_command ALIGN(__nrf_balloc_end__ , 4) : AT(ALIGN(__nrf_balloc_end__ , 4))
  {
    __cli_command_start__ = .;
    __start_cli_command =   __cli_command_start__;
    KEEP(*(.cli_command*))
  }
  __cli_command_end__ = __cli_command_start__ + SIZEOF(.cli_command);
  __cli_command_size__ = SIZEOF(.cli_command);
  __stop_cli_command =   __cli_command_end__;
  __cli_command_load_end__ = __cli_command_end__;

  . = ASSERT(__cli_command_start__ == __cli_command_end__ || (__cli_command_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .cli_command is too large to fit in FLASH1 memory segment");

  __crypto_data_load_start__ = ALIGN(__cli_command_end__ , 4);
  .crypto_data ALIGN(__cli_command_end__ , 4) : AT(ALIGN(__cli_command_end__ , 4))
  {
    __crypto_data_start__ = .;
    __start_crypto_data =   __crypto_data_start__;
    KEEP(*(SORT(.crypto_data*)))
  }
  __crypto_data_end__ = __crypto_data_start__ + SIZEOF(.crypto_data);
  __crypto_data_size__ = SIZEOF(.crypto_data);
  __stop_crypto_data =   __crypto_data_end__;
  __crypto_data_load_end__ = __crypto_data_end__;

  . = ASSERT(__crypto_data_start__ == __crypto_data_end__ || (__crypto_data_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .crypto_data is too large to fit in FLASH1 memory segment");

  __log_const_data_load_start__ = ALIGN(__crypto_data_end__ , 4);
  .log_const_data ALIGN(__crypto_data_end__ , 4) : AT(ALIGN(__crypto_data_end__ , 4))
  {
    __log_const_data_start__ = .;
    __start_log_const_data =   __log_const_data_start__;
    KEEP(*(SORT(.log_const_data*)))
  }
  __log_const_data_end__ = __log_const_data_start__ + SIZEOF(.log_const_data);
  __log_const_data_size__ = SIZEOF(.log_const_data);
  __stop_log_const_data =   __log_const_data_end__;
  __log_const_data_load_end__ = __log_const_data_end__;

  . = ASSERT(__log_const_data_start__ == __log_const_data_end__ || (__log_const_data_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .log_const_data is too large to fit in FLASH1 memory segment");

  __log_backends_load_start__ = ALIGN(__log_const_data_end__ , 4);
  .log_backends ALIGN(__log_const_data_end__ , 4) : AT(ALIGN(__log_const_data_end__ , 4))
  {
    __log_backends_start__ = .;
    __start_log_backends =   __log_backends_start__;
    KEEP(*(SORT(.log_backends*)))
  }
  __log_backends_end__ = __log_backends_start__ + SIZEOF(.log_backends);
  __log_backends_size__ = SIZEOF(.log_backends);
  __stop_log_backends =   __log_backends_end__;
  __log_backends_load_end__ = __log_backends_end__;

  . = ASSERT(__log_backends_start__ == __log_backends_end__ || (__log_backends_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .log_backends is too large to fit in FLASH1 memory segment");

  __nrf_sections_load_start__ = ALIGN(__log_backends_end__ , 4);
  .nrf_sections ALIGN(__log_backends_end__ , 4) (NOLOAD) : AT(ALIGN(__log_backends_end__ , 4))
  {
    __nrf_sections_start__ = .;
    __start_nrf_sections =   __nrf_sections_start__;
    KEEP(*(.nrf_sections .nrf_sections.*))
  }
  __nrf_sections_end__ = __nrf_sections_start__ + SIZEOF(.nrf_sections);
  __nrf_sections_size__ = SIZEOF(.nrf_sections);
  __nrf_sections_load_end__ = __nrf_sections_end__;

  . = ASSERT(__nrf_sections_start__ == __nrf_sections_end__ || (__nrf_sections_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .nrf_sections is too large to fit in FLASH1 memory segment");

  __cli_sorted_cmd_ptrs_load_start__ = ALIGN(__nrf_sections_end__ , 4);
  .cli_sorted_cmd_ptrs ALIGN(__nrf_sections_run_end__ , 4) : AT(ALIGN(__nrf_sections_end__ , 4))
  {
    __cli_sorted_cmd_ptrs_start__ = .;
    KEEP(*(.cli_sorted_cmd_ptrs*))
  }
  __cli_sorted_cmd_ptrs_end__ = __cli_sorted_cmd_ptrs_start__ + SIZEOF(.cli_sorted_cmd_ptrs);
  __cli_sorted_cmd_ptrs_size__ = SIZEOF(.cli_sorted_cmd_ptrs);
  __cli_sorted_cmd_ptrs_load_end__ = __cli_sorted_cmd_ptrs_load_start__ + SIZEOF(.cli_sorted_cmd_ptrs);

  . = ASSERT(__cli_sorted_cmd_ptrs_load_start__ == __cli_sorted_cmd_ptrs_load_end__ || (__cli_sorted_cmd_ptrs_load_end__ - __FLASH1_segment_start__) <=  __FLASH1_segment_size__ , "error: .cli_sorted_cmd_ptrs is too large to fit in FLASH1 memory segment");

  .cli_sorted_cmd_ptrs_run ALIGN(__nrf_sections_run_end__ , 4) (NOLOAD) :
  {
    __cli_sorted_cmd_ptrs_run_start__ = .;
    __start_cli_sorted_cmd_ptrs =   __cli_sorted_cmd_ptrs_run_start__;
  }
  __cli_sorted_cmd_ptrs_run_end__ = __cli_sorted_cmd_ptrs_run_start__ + SIZEOF(.cli_sorted_cmd_ptrs);
  __cli_sorted_cmd_ptrs_run_size__ = __cli_sorted_cmd_ptrs_run_end__ - __cli_sorted_cmd_ptrs_run_start__;
  __stop_cli_sorted_cmd_ptrs =   __cli_sorted_cmd_ptrs_run_end__;
  __cli_sorted_cmd_ptrs_run_load_end__ = __cli_sorted_cmd_ptrs_run_end__;

  . = ASSERT(__cli_sorted_cmd_ptrs_run_start__ == __cli_sorted_cmd_ptrs_run_end__ || (__cli_sorted_cmd_ptrs_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .cli_sorted_cmd_ptrs_run is too large to fit in RAM1 memory segment");

  __fs_data_load_start__ = ALIGN(__cli_sorted_cmd_ptrs_load_start__ + SIZEOF(.cli_sorted_cmd_ptrs) , 4);
  .fs_data ALIGN(__cli_sorted_cmd_ptrs_run_end__ , 4) : AT(ALIGN(__cli_sorted_cmd_ptrs_load_start__ + SIZEOF(.cli_sorted_cmd_ptrs) , 4))
  {
    __fs_data_start__ = .;
    KEEP(*(.fs_data*))
  }
  __fs_data_end__ = __fs_data_start__ + SIZEOF(.fs_data);
  __fs_data_size__ = SIZEOF(.fs_data);
  __fs_data_load_end__ = __fs_data_load_start__ + SIZEOF(.fs_data);

  . = ASSERT(__fs_data_load_start__ == __fs_data_load_end__ || (__fs_data_load_end__ - __FLASH1_segment_start__) <=  __FLASH1_segment_size__ , "error: .fs_data is too large to fit in FLASH1 memory segment");

  .fs_data_run ALIGN(__cli_sorted_cmd_ptrs_run_end__ , 4) (NOLOAD) :
  {
    __fs_data_run_start__ = .;
    __start_fs_data =   __fs_data_run_start__;
  }
  __fs_data_run_end__ = __fs_data_run_start__ + SIZEOF(.fs_data);
  __fs_data_run_size__ = __fs_data_run_end__ - __fs_data_run_start__;
  __stop_fs_data =   __fs_data_run_end__;
  __fs_data_run_load_end__ = __fs_data_run_end__;

  . = ASSERT(__fs_data_run_start__ == __fs_data_run_end__ || (__fs_data_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .fs_data_run is too large to fit in RAM1 memory segment");

  __log_dynamic_data_load_start__ = ALIGN(__fs_data_load_start__ + SIZEOF(.fs_data) , 4);
  .log_dynamic_data ALIGN(__fs_data_run_end__ , 4) : AT(ALIGN(__fs_data_load_start__ + SIZEOF(.fs_data) , 4))
  {
    __log_dynamic_data_start__ = .;
    KEEP(*(SORT(.log_dynamic_data*)))
  }
  __log_dynamic_data_end__ = __log_dynamic_data_start__ + SIZEOF(.log_dynamic_data);
  __log_dynamic_data_size__ = SIZEOF(.log_dynamic_data);
  __log_dynamic_data_load_end__ = __log_dynamic_data_load_start__ + SIZEOF(.log_dynamic_data);

  . = ASSERT(__log_dynamic_data_load_start__ == __log_dynamic_data_load_end__ || (__log_dynamic_data_load_end__ - __FLASH1_segment_start__) <=  __FLASH1_segment_size__ , "error: .log_dynamic_data is too large to fit in FLASH1 memory segment");

  .log_dynamic_data_run ALIGN(__fs_data_run_end__ , 4) (NOLOAD) :
  {
    __log_dynamic_data_run_start__ = .;
    __start_log_dynamic_data =   __log_dynamic_data_run_start__;
  }
  __log_dynamic_data_run_end__ = __log_dynamic_data_run_start__ + SIZEOF(.log_dynamic_data);
  __log_dynamic_data_run_size__ = __log_dynamic_data_run_end__ - __log_dynamic_data_run_start__;
  __stop_log_dynamic_data =   __log_dynamic_data_run_end__;
  __log_dynamic_data_run_load_end__ = __log_dynamic_data_run_end__;

  . = ASSERT(__log_dynamic_data_run_start__ == __log_dynamic_data_run_end__ || (__log_dynamic_data_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .log_dynamic_data_run is too large to fit in RAM1 memory segment");

  __log_filter_data_load_start__ = ALIGN(__log_dynamic_data_load_start__ + SIZEOF(.log_dynamic_data) , 4);
  .log_filter_data ALIGN(__log_dynamic_data_run_end__ , 4) : AT(ALIGN(__log_dynamic_data_load_start__ + SIZEOF(.log_dynamic_data) , 4))
  {
    __log_filter_data_start__ = .;
    KEEP(*(SORT(.log_filter_data*)))
  }
  __log_filter_data_end__ = __log_filter_data_start__ + SIZEOF(.log_filter_data);
  __log_filter_data_size__ = SIZEOF(.log_filter_data);
  __log_filter_data_load_end__ = __log_filter_data_load_start__ + SIZEOF(.log_filter_data);

  . = ASSERT(__log_filter_data_load_start__ == __log_filter_data_load_end__ || (__log_filter_data_load_end__ - __FLASH1_segment_start__) <=  __FLASH1_segment_size__ , "error: .log_filter_data is too large to fit in FLASH1 memory segment");

  .log_filter_data_run ALIGN(__log_dynamic_data_run_end__ , 4) (NOLOAD) :
  {
    __log_filter_data_run_start__ = .;
    __start_log_filter_data =   __log_filter_data_run_start__;
  }
  __log_filter_data_run_end__ = __log_filter_data_run_start__ + SIZEOF(.log_filter_data);
  __log_filter_data_run_size__ = __log_filter_data_run_end__ - __log_filter_data_run_start__;
  __stop_log_filter_data =   __log_filter_data_run_end__;
  __log_filter_data_run_load_end__ = __log_filter_data_run_end__;

  . = ASSERT(__log_filter_data_run_start__ == __log_filter_data_run_end__ || (__log_filter_data_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .log_filter_data_run is too large to fit in RAM1 memory segment");

  __nrf_sections_run_end_load_start__ = ALIGN(__log_filter_data_run_end__ , 4);
  .nrf_sections_run_end ALIGN(__log_filter_data_run_end__ , 4) (NOLOAD) : AT(ALIGN(__log_filter_data_run_end__ , 4))
  {
    __nrf_sections_run_end_start__ = .;
    __end_nrf_sections_run =   __nrf_sections_run_end_start__;
    KEEP(*(.nrf_sections_run_end .nrf_sections_run_end.*))
  }
  __nrf_sections_run_end_end__ = __nrf_sections_run_end_start__ + SIZEOF(.nrf_sections_run_end);
  __nrf_sections_run_end_size__ = SIZEOF(.nrf_sections_run_end);
  __nrf_sections_run_end_load_end__ = __nrf_sections_run_end_end__;

  . = ASSERT(__nrf_sections_run_end_start__ == __nrf_sections_run_end_end__ || (__nrf_sections_run_end_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .nrf_sections_run_end is too large to fit in RAM1 memory segment");

  __dtors_load_start__ = ALIGN(__log_filter_data_load_start__ + SIZEOF(.log_filter_data) , 4);
  .dtors ALIGN(__log_filter_data_load_start__ + SIZEOF(.log_filter_data) , 4) : AT(ALIGN(__log_filter_data_load_start__ + SIZEOF(.log_filter_data) , 4))
  {
    __dtors_start__ = .;
    KEEP (*(SORT(.dtors.*))) KEEP (*(.dtors)) KEEP (*(.fini_array)) KEEP (*(SORT(.fini_array.*)))
  }
  __dtors_end__ = __dtors_start__ + SIZEOF(.dtors);
  __dtors_size__ = SIZEOF(.dtors);
  __dtors_load_end__ = __dtors_end__;

  . = ASSERT(__dtors_start__ == __dtors_end__ || (__dtors_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .dtors is too large to fit in FLASH1 memory segment");

  __ctors_load_start__ = ALIGN(__dtors_end__ , 4);
  .ctors ALIGN(__dtors_end__ , 4) : AT(ALIGN(__dtors_end__ , 4))
  {
    __ctors_start__ = .;
    KEEP (*(SORT(.ctors.*))) KEEP (*(.ctors)) KEEP (*(.init_array)) KEEP (*(SORT(.init_array.*)))
  }
  __ctors_end__ = __ctors_start__ + SIZEOF(.ctors);
  __ctors_size__ = SIZEOF(.ctors);
  __ctors_load_end__ = __ctors_end__;

  . = ASSERT(__ctors_start__ == __ctors_end__ || (__ctors_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .ctors is too large to fit in FLASH1 memory segment");

  __rodata_load_start__ = ALIGN(__ctors_end__ , 4);
  .rodata ALIGN(__ctors_end__ , 4) : AT(ALIGN(__ctors_end__ , 4))
  {
    __rodata_start__ = .;
    *(.rodata .rodata.* .gnu.linkonce.r.*)
    . = ALIGN(MAX(__rodata_start__ + 0x4 , .), 4);
  }
  __rodata_end__ = __rodata_start__ + SIZEOF(.rodata);
  __rodata_size__ = SIZEOF(.rodata);
  __rodata_load_end__ = __rodata_end__;

  . = ASSERT(__rodata_start__ == __rodata_end__ || (__rodata_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .rodata is too large to fit in FLASH1 memory segment");

  __ARM.exidx_load_start__ = ALIGN(__rodata_end__ , 4);
  .ARM.exidx ALIGN(__rodata_end__ , 4) : AT(ALIGN(__rodata_end__ , 4))
  {
    __ARM.exidx_start__ = .;
    __exidx_start =   __ARM.exidx_start__;
    *(.ARM.exidx .ARM.exidx.*)
  }
  __ARM.exidx_end__ = __ARM.exidx_start__ + SIZEOF(.ARM.exidx);
  __ARM.exidx_size__ = SIZEOF(.ARM.exidx);
  __exidx_end =   __ARM.exidx_end__;
  __ARM.exidx_load_end__ = __ARM.exidx_end__;

  . = ASSERT(__ARM.exidx_start__ == __ARM.exidx_end__ || (__ARM.exidx_end__ - __FLASH1_segment_start__) <= __FLASH1_segment_size__ , "error: .ARM.exidx is too large to fit in FLASH1 memory segment");

  __fast_load_start__ = ALIGN(__ARM.exidx_end__ , 4);
  .fast ALIGN(__nrf_sections_run_end_end__ , 4) : AT(ALIGN(__ARM.exidx_end__ , 4))
  {
    __fast_start__ = .;
    *(.fast .fast.*)
  }
  __fast_end__ = __fast_start__ + SIZEOF(.fast);
  __fast_size__ = SIZEOF(.fast);
  __fast_load_end__ = __fast_load_start__ + SIZEOF(.fast);

  . = ASSERT(__fast_load_start__ == __fast_load_end__ || (__fast_load_end__ - __FLASH1_segment_start__) <=  __FLASH1_segment_size__ , "error: .fast is too large to fit in FLASH1 memory segment");

  .fast_run ALIGN(__nrf_sections_run_end_end__ , 4) (NOLOAD) :
  {
    __fast_run_start__ = .;
  }
  __fast_run_end__ = __fast_run_start__ + SIZEOF(.fast);
  __fast_run_size__ = __fast_run_end__ - __fast_run_start__;
  __fast_run_load_end__ = __fast_run_end__;

  . = ASSERT(__fast_run_start__ == __fast_run_end__ || (__fast_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .fast_run is too large to fit in RAM1 memory segment");

  __data_load_start__ = ALIGN(__fast_load_start__ + SIZEOF(.fast) , 4);
  .data ALIGN(__fast_run_end__ , 4) : AT(ALIGN(__fast_load_start__ + SIZEOF(.fast) , 4))
  {
    __data_start__ = .;
    *(.data .data.* .gnu.linkonce.d.*)
  }
  __data_end__ = __data_start__ + SIZEOF(.data);
  __data_size__ = SIZEOF(.data);
  __data_load_end__ = __data_load_start__ + SIZEOF(.data);

  . = ASSERT(__data_load_start__ == __data_load_end__ || (__data_load_end__ - __FLASH1_segment_start__) <=  __FLASH1_segment_size__ , "error: .data is too large to fit in FLASH1 memory segment");

  .data_run ALIGN(__fast_run_end__ , 4) (NOLOAD) :
  {
    __data_run_start__ = .;
  }
  __data_run_end__ = __data_run_start__ + SIZEOF(.data);
  __data_run_size__ = __data_run_end__ - __data_run_start__;
  __data_run_load_end__ = __data_run_end__;

  . = ASSERT(__data_run_start__ == __data_run_end__ || (__data_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .data_run is too large to fit in RAM1 memory segment");

  __tdata_load_start__ = ALIGN(__data_load_start__ + SIZEOF(.data) , 4);
  .tdata ALIGN(__data_run_end__ , 4) : AT(ALIGN(__data_load_start__ + SIZEOF(.data) , 4))
  {
    __tdata_start__ = .;
    *(.tdata .tdata.*)
  }
  __tdata_end__ = __tdata_start__ + SIZEOF(.tdata);
  __tdata_size__ = SIZEOF(.tdata);
  __tdata_load_end__ = __tdata_load_start__ + SIZEOF(.tdata);

  __FLASH1_segment_used_end__ = ALIGN(__data_load_start__ + SIZEOF(.data) , 4) + SIZEOF(.tdata);
  __FLASH1_segment_used_size__ = __FLASH1_segment_used_end__ - __FLASH1_segment_start__;

  . = ASSERT(__tdata_load_start__ == __tdata_load_end__ || (__tdata_load_end__ - __FLASH1_segment_start__) <=  __FLASH1_segment_size__ , "error: .tdata is too large to fit in FLASH1 memory segment");

  .tdata_run ALIGN(__data_run_end__ , 4) (NOLOAD) :
  {
    __tdata_run_start__ = .;
  }
  __tdata_run_end__ = __tdata_run_start__ + SIZEOF(.tdata);
  __tdata_run_size__ = __tdata_run_end__ - __tdata_run_start__;
  __tdata_run_load_end__ = __tdata_run_end__;

  . = ASSERT(__tdata_run_start__ == __tdata_run_end__ || (__tdata_run_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .tdata_run is too large to fit in RAM1 memory segment");

  __bss_load_start__ = ALIGN(__tdata_run_end__ , 4);
  .bss ALIGN(__tdata_run_end__ , 4) (NOLOAD) : AT(ALIGN(__tdata_run_end__ , 4))
  {
    __bss_start__ = .;
    *(.bss .bss.* .gnu.linkonce.b.*) *(COMMON)
  }
  __bss_end__ = __bss_start__ + SIZEOF(.bss);
  __bss_size__ = SIZEOF(.bss);
  __bss_load_end__ = __bss_end__;

  . = ASSERT(__bss_start__ == __bss_end__ || (__bss_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .bss is too large to fit in RAM1 memory segment");

  __tbss_load_start__ = ALIGN(__bss_end__ , 4);
  .tbss ALIGN(__bss_end__ , 4) (NOLOAD) : AT(ALIGN(__bss_end__ , 4))
  {
    __tbss_start__ = .;
    *(.tbss .tbss.*)
  }
  __tbss_end__ = __tbss_start__ + SIZEOF(.tbss);
  __tbss_size__ = SIZEOF(.tbss);
  __tbss_load_end__ = __tbss_end__;

  . = ASSERT(__tbss_start__ == __tbss_end__ || (__tbss_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .tbss is too large to fit in RAM1 memory segment");

  __non_init_load_start__ = ALIGN(__tbss_end__ , 4);
  .non_init ALIGN(__tbss_end__ , 4) (NOLOAD) : AT(ALIGN(__tbss_end__ , 4))
  {
    __non_init_start__ = .;
    *(.non_init .non_init.*)
  }
  __non_init_end__ = __non_init_start__ + SIZEOF(.non_init);
  __non_init_size__ = SIZEOF(.non_init);
  __non_init_load_end__ = __non_init_end__;

  . = ASSERT(__non_init_start__ == __non_init_end__ || (__non_init_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .non_init is too large to fit in RAM1 memory segment");

  __heap_load_start__ = ALIGN(__non_init_end__ , 4);
  .heap ALIGN(__non_init_end__ , 4) (NOLOAD) : AT(ALIGN(__non_init_end__ , 4))
  {
    __heap_start__ = .;
    *(.heap .heap.*)
    . = ALIGN(MAX(__heap_start__ + __HEAPSIZE__ , .), 4);
  }
  __heap_end__ = __heap_start__ + SIZEOF(.heap);
  __heap_size__ = SIZEOF(.heap);
  __heap_load_end__ = __heap_end__;

  . = ASSERT(__heap_start__ == __heap_end__ || (__heap_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .heap is too large to fit in RAM1 memory segment");

  __stack_load_start__ = __RAM1_segment_start__ + (__RAM1_segment_size__ - 8192);
  .stack __RAM1_segment_start__ + (__RAM1_segment_size__ - 8192) (NOLOAD) : AT(__RAM1_segment_start__ + (__RAM1_segment_size__ - 8192))
  {
    __stack_start__ = .;
    __StackLimit =   __stack_start__;
    *(.stack .stack.*)
    . = ALIGN(MAX(__stack_start__ + __STACKSIZE__ , .), 8);
  }
  __stack_end__ = __stack_start__ + SIZEOF(.stack);
  __stack_size__ = SIZEOF(.stack);
  __StackTop =   __stack_end__;
  __stack_load_end__ = __stack_end__;

  . = ASSERT(__stack_start__ == __stack_end__ || (__stack_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .stack is too large to fit in RAM1 memory segment");
  . = ASSERT(__heap_end__ <= __stack_start__ , "error: section .heap overlaps absolute placed section .stack");

  __stack_process_load_start__ = ALIGN(__stack_end__ , 8);
  .stack_process ALIGN(__stack_end__ , 8) (NOLOAD) : AT(ALIGN(__stack_end__ , 8))
  {
    __stack_process_start__ = .;
    *(.stack_process .stack_process.*)
    . = ALIGN(MAX(__stack_process_start__ + __STACKSIZE_PROCESS__ , .), 8);
  }
  __stack_process_end__ = __stack_process_start__ + SIZEOF(.stack_process);
  __stack_process_size__ = SIZEOF(.stack_process);
  __stack_process_load_end__ = __stack_process_end__;

  __RAM1_segment_used_end__ = ALIGN(__stack_end__ , 8) + SIZEOF(.stack_process);
  __RAM1_segment_used_size__ = __RAM1_segment_used_end__ - __RAM1_segment_start__;

  . = ASSERT(__stack_process_start__ == __stack_process_end__ || (__stack_process_end__ - __RAM1_segment_start__) <= __RAM1_segment_size__ , "error: .stack_process is too large to fit in RAM1 memory segment");

}

