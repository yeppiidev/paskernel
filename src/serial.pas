{
  References:
  - https://wiki.osdev.org/Serial_Ports

  FIXME: This code does not work. Why?
}
unit serial;

{$MODE FPC}

interface

uses systemio;

const
    PORT_COM = $3f8;

procedure SerialWriteChar(Ch: Char);
function CheckTransmitEmpty(): Integer;
function SerialInit(): Integer;

implementation

function CheckTransmitEmpty(): Integer;
begin
  Exit(ReadPortByte(PORT_COM + 5) and $20);
end;

procedure SerialWriteChar(Ch: Char);
begin
  repeat until (CheckTransmitEmpty() = 0);

  WritePortByte(PORT_COM, Byte(Ch));
end;

// https://wiki.osdev.org/Serial_Ports#Initialization
function SerialInit(): Integer;
begin
  WritePortByte(PORT_COM + 1, $00); // Disable all interrupts
  WritePortByte(PORT_COM + 3, $80); // Enable DLAB (set baud rate divisor)
  WritePortByte(PORT_COM + 0, $03); // Set divisor to 3 (lo byte) 38400 baud
  WritePortByte(PORT_COM + 1, $00); //                  (hi byte)
  WritePortByte(PORT_COM + 3, $03); // 8 bits, no parity, one stop bit
  WritePortByte(PORT_COM + 2, $C7); // Enable FIFO, clear them, with 14-byte threshold
  WritePortByte(PORT_COM + 4, $0B); // IRQs enabled, RTS/DSR set
  WritePortByte(PORT_COM + 4, $1E); // Set in loopback mode, test the serial chip
  WritePortByte(PORT_COM + 0, $AE); // Test serial chip (send byte 0xAE and check if serial returns same byte)

  // Check if serial is faulty (i.e: not same byte as sent)
  if ReadPortByte(PORT_COM) <> $AE then
  begin
    Exit(1);
  end;

   // If serial is not faulty set it in normal operation mode
   // (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
  WritePortByte(PORT_COM + 4, $0F);

  Exit(0);
end;

end.