unit multiboot;
 
interface
 
const
        KERNEL_STACKSIZE = $4000;
 
        MULTIBOOT_BOOTLOADER_MAGIC = $2BADB002;
 
type
        Pelf_section_header_table_t = ^elf_section_header_table_t;
        elf_section_header_table_t = packed record
          num: DWord;
          size: DWord;
          addr: DWord;
          shndx: DWord;
        end;
 
        Pmultiboot_info_t = ^multiboot_info_t;
        multiboot_info_t = packed record
          flags: DWord;
          mem_lower: DWord; { Amount of memory available below 1mb }
          mem_upper: DWord; { Amount of memory available above 1mb }
          boot_device: DWord;
          cmdline: DWord;
          mods_count: DWord;
          mods_addr: DWord;
          elf_sec: elf_section_header_table_t;
          mmap_length: DWord;
          mmap_addr: DWord;
        end;
 
        Pmodule_t = ^module_t;
        module_t = packed record
          mod_start: DWord;
          mod_end: DWord;
          name: DWord;
          reserved: DWord;
        end;
 
        Pmemory_map_t = ^memory_map_t;
        memory_map_t = packed record
          size: DWord;
          { You can declare these two as a single qword if your compiler supports it }
          base_addr_low: DWord;
          base_addr_high: DWord;
          { And again, these can be made into one qword variable. }
          length_low: DWord;
          length_high: DWord;
          mtype: DWord;
        end;
 
implementation
 
end.