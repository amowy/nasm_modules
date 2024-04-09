; Gyorgy Matyas 2236 512
;  Lab4 4. feladat elso resze
;beolvas egy előjeles 32 bites egész számot 10-es számrendszerben;
;kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;beolvas egy 32 bites hexa számot;
;kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;beolvas egy 32 bites bináris számot;
;kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;kiírja a három beolvasott érték összegét 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
;ez előző lépéseket elvégzi 64 bites értékekre is.
%include 'ionum.inc'
%include 'iostr.inc'

global main

section .text

main:
    mov     esi, int32_beolvas
    call    WriteStr
    call    ReadInt
    jc      .er
    mov     esi, int32_kiir
    call    WriteStr
    call    WriteInt
    call    NewLine
    mov     esi, hex32_kiir
    call    WriteStr
    call    WriteHex
    call    NewLine
    mov     esi, bin32_kiir
    call    WriteStr
    call    WriteBin
    call    NewLine
    mov     [int32] , eax
    
    mov     esi, hex32_beolvas
    call    WriteStr
    call    ReadHex
    jc      .er
    mov     esi, int32_kiir
    call    WriteStr
    call    WriteInt
    call    NewLine
    mov     esi, hex32_kiir
    call    WriteStr
    call    WriteHex
    call    NewLine
    mov     esi, bin32_kiir
    call    WriteStr
    call    WriteBin
    call    NewLine
    mov     [hex32] , eax
    
    mov     esi, bin32_beolvas
    call    WriteStr
    call    ReadBin
    jc      .er
    mov     esi, int32_kiir
    call    WriteStr
    call    WriteInt
    call    NewLine
    mov     esi, hex32_kiir
    call    WriteStr
    call    WriteHex
    call    NewLine
    mov     esi, bin32_kiir
    call    WriteStr
    call    WriteBin
    call    NewLine
    ;eredmeny:
    mov     ebx, [int32]
    add     eax, ebx
    mov     ebx, [hex32]
    add     eax, ebx
    mov     esi, eredmeny32
    call    WriteLnStr
    mov     esi, int32_kiir
    call    WriteStr
    call    WriteInt
    call    NewLine
    mov     esi, hex32_kiir
    call    WriteStr
    call    WriteHex
    call    NewLine
    mov     esi, bin32_kiir
    call    WriteStr
    call    WriteBin
    call    NewLine

    mov     esi, int64_beolvas
    call    WriteStr
    call    ReadInt64
    jc      .er
    mov     esi, int64_kiir
    call    WriteStr
    call    WriteInt64
    call    NewLine
    mov     esi, hex64_kiir
    call    WriteStr
    call    WriteHex64
    call    NewLine
    mov     esi, bin64_kiir
    call    WriteStr
    call    WriteBin64
    call    NewLine
    mov     [int32] , eax
    mov     [int64] , edx
    
    mov     esi, hex64_beolvas
    call    WriteStr
    call    ReadHex64
    jc      .er
    mov     esi, int64_kiir
    call    WriteStr
    call    WriteInt64
    call    NewLine
    mov     esi, hex64_kiir
    call    WriteStr
    call    WriteHex64
    call    NewLine
    mov     esi, bin64_kiir
    call    WriteStr
    call    WriteBin64
    call    NewLine
    mov     [hex32] , eax
    mov     [hex64] , edx
    
    mov     esi, bin64_beolvas
    call    WriteStr
    call    ReadBin64
    jc      .er
    mov     esi, int64_kiir
    call    WriteStr
    call    WriteInt64
    call    NewLine
    mov     esi, hex64_kiir
    call    WriteStr
    call    WriteHex64
    call    NewLine
    mov     esi, bin64_kiir
    call    WriteStr
    call    WriteBin64
    call    NewLine
    
    mov     esi, eredmeny64
    call    WriteLnStr
    mov     ebx, [int32]
    add     eax, ebx
    mov     ecx, [int64]
    adc     edx, ecx
    mov     ebx, [hex32]
    add     eax, ebx
    mov     ecx, [hex64]
    adc     edx, ecx
    mov     esi, int64_kiir
    call    WriteStr
    call    WriteInt64
    call    NewLine
    mov     esi, hex64_kiir
    call    WriteStr
    call    WriteHex64
    call    NewLine
    mov     esi, bin64_kiir
    call    WriteStr
    call    WriteBin64
    call    NewLine


    jmp     .rat
.er:
    mov     esi, er
    call    WriteLnStr
    jmp     .rat
.rat:
        ret

section .data
    int32 dd 0
    hex32 dd 0
    bin32 dd 0
    int64 dd 0
    hex64 dd 0
    bin64 dd 0
    er    db 'Hiba: ', 0
    int32_beolvas  db "Beolvas int 32bit: ", 0
    bin32_beolvas  db 'Beolvas bin 32bit: ', 0
    hex32_beolvas  db 'Beolvas hex 32bit: ', 0
    int64_beolvas  db "Beolvas int 64bit: ", 0
    bin64_beolvas  db 'Beolvas bin 64bit: ', 0
    hex64_beolvas  db 'Beolvas hex 64bit: ', 0
    int32_kiir  db 'int.32:', 0
    bin32_kiir  db 'bin.32:', 0
    hex32_kiir  db 'hex.32:', 0
    int64_kiir  db 'int.64:', 0
    bin64_kiir  db 'bin.64:', 0
    hex64_kiir  db 'hex.64:', 0
    eredmeny32  db 'eredmeny.32:', 0
    eredmeny64  db 'eredmeny.64:', 0
section .bss
    str_a resb 256