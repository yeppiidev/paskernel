{
    PasKernel "kernel.pas"
    (Kernel Entry Point)
}
 
unit kernel;
 
interface
 
uses
        multiboot,
        console,
        serial;
 
procedure KernelMain(MBInfo: Pmultiboot_info_t; MBMagic: DWord); stdcall;
procedure HaltLoop();
procedure HaltTerminate();

implementation

procedure HaltTerminate();
begin
    // Terminates the kernel
    asm
        cli
        hlt
    end;
end;

procedure HaltLoop();
begin
    // Loops forever
    asm
            @loop:
            jmp @loop
    end;
end; 

procedure KernelMain(MBInfo: Pmultiboot_info_t; MBMagic: DWord); stdcall; [public, alias: 'KernelMain'];
begin
        ClearScreen();
        WriteString('PasKernel (Written in FreePascal)');
        
        if SerialInit() = 1 then
        begin
          NewLine(1);
          WriteString('Error initializing serial port!');
          NewLine(1);
        end;
        
        NewLine(2);
 
        if (MBMagic <> MULTIBOOT_BOOTLOADER_MAGIC) then
        begin
                WriteString('Halting system, a multiboot-compliant boot loader is needed.');
                HaltTerminate;
        end
        else
        begin   
                // We add #13 to the end of the string to indicate a carriage return
                // that is a line break (\n in C-bas)
                WriteString('Multiboot-compliant bootloader found!');
                NewLine(1);
                WriteString('Multiboot information:');
                NewLine(1);
                WriteString('  Lower memory  = ');
                WriteInteger(MBInfo^.mem_lower);
                WriteString('KB');
                NewLine(1);
                WriteString('  Higher memory = ');
                WriteInteger(MBInfo^.mem_upper);
                WriteString('KB');
                NewLine(1);
                WriteString('  Total memory  = ');
                WriteInteger(((MBInfo^.mem_upper + 1000) div 1024) +1);
                WriteString('MB');
                NewLine(1);
        end;

        HaltLoop;
end;
 
end.