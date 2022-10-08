; PasKernel Bootloader Stub
; For more info, see: https://wiki.osdev.org/Pascal_Bare_Bones#stub.asm

;
; Kernel stub
;
 
;
; We are in 32bits protected mode
;
[bits 32]
 
;
; Export entrypoint
;
[global KernelStart]
 
;
; Import kernel entrypoint
;
[extern KernelMain]
 
;
; Posible multiboot header flags
;
MULTIBOOT_MODULE_ALIGN          equ     1<<0
MULTIBOOT_MEMORY_MAP            equ     1<<1
MULTIBOOT_GRAPHICS_FIELDS       equ     1<<2
MULTIBOOT_ADDRESS_FIELDS        equ     1<<16
 
;
; Multiboot header defines
;
MULTIBOOT_HEADER_MAGIC          equ     0x1BADB002
MULTIBOOT_HEADER_FLAGS          equ     MULTIBOOT_MODULE_ALIGN | MULTIBOOT_MEMORY_MAP
MULTIBOOT_HEADER_CHECKSUM       equ     -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
 
;
; Kernel stack size
;
KERNEL_STACKSIZE                equ     0x4000
 
section .text
 
;
; Multiboot header
;
align 4
dd MULTIBOOT_HEADER_MAGIC
dd MULTIBOOT_HEADER_FLAGS
dd MULTIBOOT_HEADER_CHECKSUM
 
;
; Entrypoint
;
KernelStart:
        mov esp, KERNEL_STACK+KERNEL_STACKSIZE  ; Create kernel stack
        push eax                                ; Multiboot magic number
        push ebx                                ; Multiboot info
        call KernelMain                         ; Call kernel entrypoint
        cli                                     ; Clear interrupts
        hlt                                     ; Halt machine
 
section .bss
 
;
; Kernel stack location
;
align 32
KERNEL_STACK:
        resb KERNEL_STACKSIZE