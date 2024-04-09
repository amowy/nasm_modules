; Gyorgy Matyas 2236 512
;  Lab4 3. feladat
;Készítsük el a következő stringkezelő eljárásokat és helyezzük el őket egy STRINGS.ASM / INC nevű modulba.

;StrLen(ESI):(EAX)              – EAX-ben visszatéríiti az ESI által jelölt string hosszát, kivéve a bináris 0-t
;StrCat(EDI, ESI):()             – összefűzi az ESI és EDI által jelölt stringeket (azaz az ESI által jelöltet az EDI után másolja)
;StrUpper(ESI):()                 – nagybetűssé konvertálja az ESI stringet
;StrLower(ESI):()                 – kisbetűssé konvertálja az ESI stringet
;StrCompact(ESI, EDI):()      – EDI-be másolja át az ESI stringet, kivéve a szóköz, tabulátor (9), kocsivissza (13) és soremelés (10) karaktereket

%include 'mio.inc'

global StrLen, StrCat, StrUpper, StrLower, StrCompact

section .text

;esi hossza eax-ba
StrLen:
    push    ebx
    xor     eax, eax
.vizsga:
    xor     ebx, ebx
    mov     bl, [esi + eax]
    cmp     bl, 0
    je      .veg
    inc     eax
    jmp     .vizsga
.veg:
    pop     ebx
        ret

;edi-vere esi rak
StrCat:
    push    eax
    push    ebx
    push    ecx
    xor     ebx, ebx
.elsovizsga:
    xor     eax, eax
    mov     al, [edi + ebx]
    cmp     eax, 0
    je      .elsostringvege
    inc     ebx
    jmp     .elsovizsga
.elsostringvege:

    xor     ecx, ecx
.masodikberak:
    xor     eax, eax
    mov     al, [esi + ecx]
    mov     [edi + ebx], al
    inc     ebx
    cmp     eax, 0
    je      .masodikvege
    inc     ecx
    jmp     .masodikberak
.masodikvege:
    pop    ecx
    pop    ebx
    pop    eax
        ret

;esi nagybetus lesz
StrUpper:
    push    eax
    push    ebx
    xor     ebx, ebx   ;ebx, eax
.vizsgal:
    xor     eax, eax
    mov     al, [esi + ebx]
    cmp     al, 0
    je     .vege
    cmp     eax, 'a'
    jl      .nemkisbetu
    cmp     eax, 'z'
    jg      .nemkisbetu
    sub     eax, 32
    mov     [esi + ebx], al
.nemkisbetu:
    inc     ebx
    jmp     .vizsgal
.vege:
    pop     ebx
    pop     eax
        ret

;esi kisbetus lesz
StrLower:
    push    eax
    push    ebx
    xor     ebx, ebx   ;ebx, eax
.vizsgal:
    xor     eax, eax
    mov     al, [esi + ebx]
    cmp     al, 0
    je     .end
    cmp     eax, 'A'
    jl      .nemkisbetu
    cmp     eax, 'Z'
    jg      .nemkisbetu
    add     eax, 32
    mov     [esi + ebx], al
.nemkisbetu:
    inc     ebx
    jmp     .vizsgal
.end:
    pop     ebx
    pop     eax
        ret

;esi kompakt
StrCompact:
    push    eax
    push    ebx
    push    ecx
    xor     ebx, ebx
    xor     ecx, ecx
.vegigmegy:
    xor     eax, eax
    mov     al, [esi + ebx]
    cmp     eax, 0
    je      .vege
    
    cmp     eax, ' '
    je      .nemrak
    cmp     eax, 9
    je      .nemrak
    cmp     eax, 10
    je      .nemrak
    cmp     eax, 13
    je      .nemrak
    mov     [edi + ecx], al
    inc     ecx
.nemrak:
    inc     ebx
    jmp     .vegigmegy
.vege:
    xor     eax, eax
    mov     [edi + ecx], eax
    pop     ecx
    pop     ebx
    pop     eax
        ret