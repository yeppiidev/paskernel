# PasKernel Makefile
#
# For additional info, see: https://wiki.osdev.org/Pascal_Bare_Bones

# Replace this with your cross compiler path
CROSS_BIN = ~/zync/cross/bin
LD = $(CROSS_BIN)/i686-elf-ld
LDSCRIPT = meta/linker.ld
GRUB_CFG = meta/grub.cfg
ISOOUTDIR = build
ISOFILE = $(ISOOUTDIR)/PasKernel.iso
ISODIR = iso
ISODIR_BOOT = $(ISODIR)/boot
ISODIR_GRUB = $(ISODIR_BOOT)/grub
ISODIR_GRUB_CFG  = $(ISODIR_GRUB)/grub.cfg
OBJDIR = obj

# Compiler parameters
NASMPARAMS = -f elf32 -o $(OBJDIR)/boot.o
LDPARAMS = -A elf-i386 --gc-sections -s -T$(LDSCRIPT) -o $(OBJDIR)/kernel.obj
FPCPARAMS = -Aelf -n -O3 -Op3 -Si -Sc -Sg -Xd -CX -XXs -Pi386 -Rintel -Tlinux -o$(OBJDIR)/kernel.o

# Define source files here
SOURCES = $(OBJDIR)/boot.o \
		  $(OBJDIR)/kernel.o  \
		  $(OBJDIR)/multiboot.o \
		  $(OBJDIR)/console.o \
		  $(OBJDIR)/serial.o \
		  $(OBJDIR)/system.o \
		  $(OBJDIR)/systemio.o

# Doing this for convenience
all: dirs Kernel Asm Linker iso run clean

Kernel:
	$(info Compiling kernel...)
	fpc $(FPCPARAMS) src/kernel.pas

Asm:
	$(info Compiling bootloader...)
	nasm $(NASMPARAMS) src/boot.asm
 
Linker:
	$(info Linking objects...)
	$(LD) $(LDPARAMS) $(SOURCES)

dirs:
	mkdir -p $(OBJDIR)
	mkdir -p $(ISOOUTDIR)

run: 
	$(info Using 'qemu-system-i386'...)
	qemu-system-i386 $(ISOFILE) -serial stdio

iso:
	$(info Creating ISO...)

	mkdir -p $(ISODIR)
	mkdir -p $(ISODIR_BOOT)
	mkdir -p $(ISODIR_GRUB)
	cp $(OBJDIR)/kernel.obj $(ISODIR_BOOT)/kernel.obj
	cat $(GRUB_CFG) >> $(ISODIR_GRUB_CFG)
	grub-mkrescue --output=$(ISOFILE) $(ISODIR)
	rm -rf $(ISODIR)
 
clean:
	rm -rf $(ISOOUTDIR)
	rm -rf $(OBJDIR)
	rm -rf $(ISODIR)
	rm -f *.o
	rm -f *.ppu
	rm -f *.iso
	rm -f *.obj