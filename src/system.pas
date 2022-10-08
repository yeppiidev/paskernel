{
    References:
    - https://wiki.osdev.org/Pascal_Bare_Bones#system.pas
    - https://wiki.freepascal.org/System_unit
}

unit system;

{$MODE FPC}

interface

type
 Cardinal = 0..$FFFFFFFF;
 hresult = Cardinal;
 DWord = Cardinal;
 Integer = LongInt;
 PChar = ^Char;
 TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat, tkSet,
 tkMethod, tkSString, tkLString, tkAString, tkWString, tkVariant, tkArray,
 tkRecord, tkInterface, tkClass, tkObject, tkWChar, tkBool, tkInt64, tkQWord,
 tkDynArray, tkInterfaceRaw, tkProcVar, tkUString, tkUChar, tkHelper, tkFile,
 tkClassRef, tkPointer);
 jmp_buf = packed record
   rbx, rbp, r12, r13, r14, r15, rsp, rip: QWord;
 end;

 Pjmp_buf = ^jmp_buf;
 PExceptAddr = ^TExceptAddr;
 TExceptAddr = record 
   buf: Pjmp_buf;
   next: PExceptAddr;
   frametype: LongInt;
 end;

 PGuid = ^TGuid;
 TGuid = packed record
   case Integer of
   1:
    (Data1: DWord;
     Data2: word;
     Data3: word;
     Data4: array [0 .. 7] of byte;
   );
   2:
    (D1: DWord;
     D2: word;
     D3: word;
     D4: array [0 .. 7] of byte;
   );
   3:
   ( { uuid fields according to RFC4122 }
     time_low: DWord; // The low field of the timestamp
     time_mid: word; // The middle field of the timestamp
     time_hi_and_version: word;
     // The high field of the timestamp multiplexed with the version number
     clock_seq_hi_and_reserved: byte;
     // The high field of the clock sequence multiplexed with the variant
     clock_seq_low: byte; // The low field of the clock sequence
     node: array [0 .. 5] of byte; // The spatially unique node identifier
   );
 end;

procedure InitializeSystem();

implementation

procedure InitializeSystem();
begin
    // Initialize stuff here i guess?
end;
end.
