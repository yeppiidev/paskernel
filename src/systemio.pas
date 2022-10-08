unit systemio;

{$MODE FPC}

interface

procedure WritePortByte(DataPort: Word; ByteData: Byte);
function ReadPortByte(DataPort: Word): Byte;

implementation

procedure WritePortByte(DataPort: Word; ByteData: Byte);
begin;
    asm
        mov dx, dataport
        mov al, bytedata
        out dx, al
    end;
end;

function ReadPortByte(DataPort: Word): Byte;
begin
    asm
        mov dx, dataport
        in al, dx
    end;
end;

end.