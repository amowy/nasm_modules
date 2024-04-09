; Gyorgy Matyas 2236 512
;  Lab4 2. feladat
;Készítsünk el egy olyan stringbeolvasó eljárást, amely megfelelőképpen kezeli le a backspace billentyűt (azaz visszalépteti a kurzort és letörli az előző karaktert).
;Teszteljük ezt az eljárást különböző kritikus esetekre (pl. a string elején a backspace-nek ne legyen hatása,
; valamint ha már több karaktert vitt be a felhasználó, mint a megengedett hossz és lenyomja a backspace-t
; akkor nem az elmentett utolsó karaktert kell törölni, hanem az elmentetlenekből az utolsót). <Enter>-ig olvas.

;Ebben a feladatban C stringekkel dolgozunk, itt a string végét a bináris 0 karakter jelenti.

;Készítsünk el egy olyan IOSTR.ASM / INC modult, amely a következő eljárásokat tartalmazza:

;ReadStr(EDI vagy ESI, ECX max. hossz):()   – C-s (bináris 0-ban végződő) stringbeolvasó eljárás, <Enter>-ig olvas
;WriteStr(ESI):()                                – stringkiíró eljárás
;ReadLnStr(EDI vagy ESI, ECX):()   – mint a ReadStr() csak újsorba is lép
;WriteLnStr(ESI):()                            – mint a WriteStr() csak újsorba is lép
;NewLine():()                                     – újsor elejére lépteti a kurzort

%include 'mio.inc'

global ReadStr, WriteStr, ReadLnStr, WriteLnStr, NewLine

section .text

;esi-be
ReadStr:
    push    eax
    push    ebx
    xor     eax, eax
    xor     ebx, ebx
.read:
    call    mio_readchar
    call    mio_writechar
    cmp     al, 13
    je      .vege
    cmp     al, 8
    jne     .nembackspace
    cmp     ebx, 0
    je      .read
    mov     al, ' '
    call    mio_writechar
    mov     al, 8
    call    mio_writechar
    dec     ebx
    jmp     .read
.nembackspace:
    mov     [esi + ebx], al
    inc     ebx
    jmp     .read
.vege:
    cmp     ebx, ecx
    jle     .kiir
    mov     ebx, ecx
.kiir:
    mov     eax, 0
    mov     [esi + ebx], eax
    pop     ebx
    pop     eax
        ret

;esi-bol
WriteStr:
    push    eax
    push    edx
    xor     edx, edx
.writecycle:
        xor     eax, eax 
        mov     al, [esi + edx]
        cmp     al, 0
        je      .cyclevege
        call    mio_writechar
        inc     edx
        jmp     .writecycle
.cyclevege:
    pop     edx
    pop     eax
        ret    

;esi-be
ReadLnStr:
    push    eax
    push    ebx
    xor     ebx, ebx
.read:
    call    mio_readchar
    call    mio_writechar
    cmp     al, 13
    je      .vege
    cmp     al, 8
    jne     .nembackspace
    cmp     ebx, 0
    je      .read
    mov     al, ' '
    call    mio_writechar
    mov     al, 8
    call    mio_writechar
    dec     ebx
    jmp     .read
.nembackspace:
    mov     [esi + ebx], al
    inc     ebx
    jmp     .read
.vege:
    cmp     ebx, ecx
    jle     .kiir
    mov     ebx, ecx
.kiir:
    mov     eax, 0
    mov     [esi + ebx], eax
    mov     eax, 10
    call    mio_writechar
    pop     ebx
    pop     eax
        ret

;esi-bol
WriteLnStr:
    push    eax
    push    edx
    xor     edx, edx
.writecycle:
        xor     eax, eax 
        mov     al, [esi + edx]
        cmp     al, 0
        je      .cyclevege
        call    mio_writechar
        inc     edx
        jmp     .writecycle
.cyclevege:
    mov     eax, 10
    call    mio_writechar
    pop     edx
    pop     eax
        ret

NewLine:
    push    eax
    mov     eax, 12
    call    mio_writechar
    pop     eax
        ret