{
    Paskernel "console.pas"
    (VGA-Console related functions)
}
 
unit console;
 
interface

uses serial;

var
    ConsoleCursorX: Integer = 0;
    ConsoleCursorY: Integer = 0;
 
procedure ClearScreen();
procedure NewLine(times: Integer);
procedure WriteChar(Ch: Char);
procedure WriteString(s: PChar);
procedure WriteInteger(i: Integer);
procedure WriteDWord(i: DWord);
 
implementation
 
var
        VideoMemory: PChar = PChar($b8000);
 
procedure ClearScreen(); [public, alias: 'ClearScreen'];
var
        i: Integer;
begin
        for i := 0 to 3999 do
                VideoMemory[i] := #0;
end;

procedure NewLine(times: Integer);
begin
    ConsoleCursorX := 0;
    ConsoleCursorY += times;
end;

procedure WriteChar(Ch: Char); [public, alias: 'WriteChar'];
var
        offset: Integer;
begin
        if (ConsoleCursorY > 24) then
                ConsoleCursorY := 0;
 
        if (ConsoleCursorX > 79) then
                ConsoleCursorX := 0;
 
        offset := (ConsoleCursorX shl 1) + (ConsoleCursorY * 160);
        VideoMemory[offset] := Ch;
        offset += 1;
        VideoMemory[offset] := #7;
        offset += 1;
 
        ConsoleCursorX := (offset mod 160);
        ConsoleCursorY := (offset - ConsoleCursorX) div 160;
        ConsoleCursorX := ConsoleCursorX shr 1;
end;
 
procedure WriteString(s: PChar); [public, alias: 'WriteString'];
var
        offset, i: Integer;
begin
        if (ConsoleCursorY > 24) then
                ConsoleCursorY := 0;
 
        if (ConsoleCursorX > 79) then
                ConsoleCursorX := 0;
 
        offset := (ConsoleCursorX shl 1) + (ConsoleCursorY * 160);
        i := 0;
 
        while (s[i] <> Char($0)) do
        begin
            VideoMemory[offset] := s[i];
            offset += 1;
            VideoMemory[offset] := #7;
            offset += 1;
            i += 1;
        end;
 
        ConsoleCursorX := (offset mod 160);
        ConsoleCursorY := (offset - ConsoleCursorX) div 160;
        ConsoleCursorX := ConsoleCursorX shr 1;
end;
 
procedure WriteInteger(i: Integer); [public, alias: 'WriteInteger'];
var
        buffer: array [0..11] of Char;
        str: PChar;
        digit: DWord;
        minus: Boolean;
begin
        str := @buffer[11];
        str^ := #0;
 
        if (i < 0) then
        begin
                digit := -i;
                minus := True;
        end
        else
        begin
                digit := i;
                minus := False;
        end;
 
        repeat
                Dec(str);
                str^ := Char((digit mod 10) + Byte('0'));
                digit := digit div 10;
        until (digit = 0);
 
        if (minus) then
        begin
                Dec(str);
                str^ := '-';
        end;
 
        WriteString(str);
end;
 
procedure WriteDWord(i: DWord); [public, alias: 'WriteDWord'];
var
        buffer: array [0..11] of Char;
        str: PChar;
        digit: DWord;
begin
        for digit := 0 to 10 do
                buffer[digit] := '0';
 
        str := @buffer[11];
        str^ := #0;
 
        digit := i;
        repeat
                Dec(str);
                str^ := Char((digit mod 10) + Byte('0'));
                digit := digit div 10;
        until (digit = 0);
 
        WriteString(str);
end;
 
end.