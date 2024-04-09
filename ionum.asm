; Gyorgy Matyas 2236 512
;  Lab4 1. feladat
;Készítsünk el egy olyan saját IONUM.ASM / INC modult, amely a következő eljárásokat tartalmazza, a megadott pontos paraméterezéssel (az első zárójelben a bemeneti, a másodikban a kimeneti paramétereket adtuk meg, az eljárások globálisak!). Hexa olvasásnál kis- és nagybetűket is el kell fogadjon. Hexa és bináris olvasásnál nem kötelező az összes számjegyet beírni (azaz nem lehet a számjegyek száma az egyetlen leállási feltétel). Az olvasás kell kezelje a túlcsordulást és a backspace-t (hasonlóan a második feladathoz, érdemes egyszer annak az első részét megoldani). Minden függvény kötelezően <Enter>-ig olvas. Csak az <Enter> lenyomása után tekintünk egy beírt adatot hibásnak. A függvény a hibát a CF beállításával jelzi a főprogramnak. Hiba esetén a főprogram írja ki, hogy Hiba és utána kérje újra az adatot.

;ReadInt():(EAX)                  – 32 bites előjeles egész beolvasása
;WriteInt(EAX):()                  – 32 bites előjeles egész kiírása
;ReadInt64():(EDX:EAX)      – 64 bites előjeles egész beolvasása
;WriteInt64(EDX:EAX):()      – 64 bites előjeles egész kiírása
;ReadBin():(EAX)                 – 32 bites bináris pozitív egész beolvasása
;WriteBin(EAX):()                 –                    - || -                   kiírása
;ReadBin64():(EDX:EAX)     – 64 bites bináris pozitív egész beolvasása
;WriteBin64(EDX:EAX):()     –                    - || -                   kiírása
;ReadHex():(EAX)                – 32 bites pozitív hexa beolvasása
;WriteHex(EAX):()                –                    - || -                   kiírása
;ReadHex64():(EDX:EAX)     – 64 bites pozitív hexa beolvasása
;WriteHex64(EDX:EAX):()     –                    - || -                   kiírása

%include 'iostr.inc'

global ReadInt, WriteInt, ReadInt64, ReadInt64, WriteInt64, ReadBin, WriteBin, ReadBin64, WriteBin64, ReadHex, WriteHex, ReadHex64, WriteHex64

section .text
;eax-be olvas int
ReadInt:
    push     ebx
    push     edx
    push     edi
    push     ecx
    push     esi
    mov     ecx, 255
    mov     esi, seged_string
    call    ReadLnStr
    xor     eax, eax
    xor     ebx, ebx
    xor     edx, edx
    xor     edi, edi
    xor     ecx, ecx

.olvas:
    xor     eax, eax
    mov     al, [esi + ebx]
    cmp     al, 0
    je      .vege
    cmp     al, '-'
    jne     .nemminusz
    inc     edx
    cmp     edx, 1
    jg      .er
    inc     ebx
    jmp     .olvas
.nemminusz:
    cmp     al, '0'
    jl      .er
    cmp     al, '9'
    jg      .er
    imul    edi, 10
    jc      .er
    sub     al, '0'
    add     edi, eax
    inc     ebx
    jmp     .olvas
.er:
    stc
    jmp     .rat

.vege:
    mov     eax, edi
    cmp     edx, 0
    clc
    je     .folytat
    neg     eax
.folytat:
    clc
.rat:
    pop     esi
    pop     edi
    pop     edx
    pop     ecx
    pop     ebx
        ret

WriteInt:
    pusha
    xor     ebx, ebx
    xor     edx, edx
    xor     edi, edi
    mov     esi, seged_string
    cmp     eax, 0
    je      .nulla
    jmp     .feldolgoz
.nulla:
    add     eax, '0'
    mov     [esi], al
    inc     ebx
    jmp     .vege

.feldolgoz:
    xor     edx, edx
    push    edx
    cmp     eax, 0
    jg      .feldolgozloop
    inc     edi
    neg     eax
.feldolgozloop:
    xor     edx, edx
    mov     ecx, 10
    cdq
    idiv    ecx
    add     dl, '0'
    push    edx
    inc     ebx
    cmp     eax, 0
    jne     .feldolgozloop
    cmp     edi, 0
    je      .nemkellminusz
    xor     edx, edx
    mov     dl, '-'
    push    edx
    inc     ebx
.nemkellminusz:
    xor     ecx, ecx
    

.visszadolgoz:
    pop     edx
    cmp     edx, 0
    je      .vege
    mov     [esi+ecx],dl
    inc     ecx
    cmp     ebx, ecx
    jmp     .visszadolgoz
    
    
.vege:
    xor     eax, eax
    mov     [esi + ebx], al
    call    WriteStr
    popa
        ret

ReadInt64:
    push     ebx
    push     ecx
    push     edi
    push     esi
    mov     ecx, 256
    mov     esi, seged_string
    call    ReadLnStr
    xor     eax, eax
    xor     ebx, ebx
    xor     edx, edx
    xor     edi, edi
    xor     ecx, ecx

;elso karakter, hogy tudjuk - e
    xor     eax, eax
    mov     al, [esi + ebx]
    cmp     al, 0
    je      .vege
    cmp     al, '-'
    jne     .berakelso ;ha nem minusz berakom
    inc     ebx
    jmp     .olvas_neg
.berakelso:
    cmp     al, '0'
    jl      .er
    cmp     al, '9'
    jg      .er
    push    eax
    push    edx
    mov     eax, 10
    mul     edi
    mov     edi, eax
    mov     ecx, edx
    pop     edx
    pop     eax
    sub     eax, '0'
    add     edi, eax
    imul    edx, 10
    jc      .er
    add     edx, ecx
    jo      .er
    inc     ebx

.olvas_pozitiv:
    xor     eax, eax
    mov     al, [esi + ebx]
    cmp     al, 0
    je      .vege
    cmp     al, '0'
    jl      .er
    cmp     al, '9'
    jg      .er
    push    eax
    push    edx
    mov     eax, 10
    mul     edi
    mov     edi, eax
    mov     ecx, edx
    pop     edx
    pop     eax
    sub     al, '0'
    add     edi, eax
    imul    edx, 10
    jc      .er
    add     edx, ecx
    jo      .er
    inc     ebx
    jmp     .olvas_pozitiv


.olvas_neg:
    xor     eax, eax
    mov     al, [esi + ebx]
    cmp     al, 0
    je      .negativvaalakit
    cmp     al, '0'
    jl      .er
    cmp     al, '9'
    jg      .er

    push    eax
    push    edx
    mov     eax, 10
    mul     edi
    mov     edi, eax
    mov     ecx, edx
    pop     edx
    pop     eax
    sub     eax, '0'
    add     edi, eax
    imul    edx, 10
    jc      .er
    add     edx, ecx
    jo      .er
    inc     ebx
    jmp     .olvas_neg

.er:
    stc
    jmp     .rat

.negativvaalakit:
    neg     edi
    not     edx

.vege:
    mov     eax, edi
    clc
.rat:
    pop     esi
    pop     edi
    pop     ecx
    pop     ebx
        ret
    
WriteInt64:
    pusha
    xor     esi, esi
    push    esi
    mov     esi, seged_string
    mov     ebx, 10
    cmp     edx, 0
    jg      .pushcycle
    jne     .minusz
    cmp     eax, 0
    jne     .minusz
    mov     eax, '0'
    push    eax
    jmp     .beepit
.minusz:
    neg     eax
    not     edx
    mov     cl, '-'
    mov     [esi], cl
    inc     esi
.pushcycle:
    cmp     eax, 0
    jne     .folytat
    cmp     edx, 0
    jne     .folytat
    jmp     .beepit
.folytat:
    push    eax
    mov     eax, edx
    xor     edx, edx
    div     ebx
    mov     ecx, eax
    pop     eax
    div     ebx
    add     edx, '0'
    push    edx
    mov     edx, ecx
    jmp    .pushcycle
.beepit:
    pop     edx
    cmp     edx, 0
    je      .vege
    mov     [esi], dl
    inc     esi
    jmp     .beepit
.vege:
    xor     edx, edx
    mov     [esi], edx
    mov     esi, seged_string
    call    WriteStr
    popa
        ret

ReadBin:
    push     ebx
    push     ecx
    push     edx
    push     edi
    push     esi
    mov     esi, seged_string
    mov     ecx, 256
    call    ReadLnStr
    xor     ebx, ebx
.feldolgoz:
    xor     eax, eax
    mov     al, [esi]
    cmp     eax, 0
    je      .vege
    cmp     al, '0'
    jl      .er
    cmp     al,'1'
    jg      .er
    sub     al, '0'
    shl     ebx, 1
    add     ebx, eax
    inc     esi
    jmp     .feldolgoz

.er:
    stc
.vege:
    mov     eax, ebx
    pop     esi
    pop     edi
    pop     edx
    pop     ecx
    pop     ebx
    ret

WriteBin:
    pusha
    mov     esi, seged_string
    xor     ecx, ecx
    xor     edi, edi
    mov     ecx, 32
.kiir:
    cmp     edi, 4
    jne     .nemkellspace
    mov     ebx, ' '
    mov     [esi], ebx
    inc     esi
    xor     edi, edi
.nemkellspace:
    xor     ebx, ebx
    shl     eax, 1
    jnc     .nulla
    mov     ebx, '1'
    mov     [esi], bl
    jmp     .folyt
.nulla:
    mov     ebx, '0'
    mov     [esi], bl
.folyt:
    inc     esi
    inc     edi
    loop    .kiir

    xor     ebx, ebx
    mov     [esi], ebx
    mov     esi, seged_string
    call    WriteStr
    popa
        ret

ReadBin64:
    push     ebx
    push     ecx
    push     edi
    push     esi
    mov     ecx, 256
    mov     esi, seged_string
    call    ReadLnStr 
    xor     edx, edx
    xor     ebx, ebx
.feldolgoz:
    xor     eax, eax
    mov     al, [esi]
    cmp     eax, 0
    jz      .vege
    cmp     al, '0'
    jl      .er
    cmp     al, '1'
    jg      .er
    sub     al, '0'
    shl     edx, 1
    jc      .er
    shl     ebx, 1
    jnc     .folyat
    add     edx, 1
.folyat:
    add     ebx, eax
    inc     esi
    jmp     .feldolgoz

.er:
    stc
.vege:
    mov     eax, ebx
    pop     esi
    pop     edi
    pop     ecx
    pop     ebx
        ret


WriteBin64:
    pusha
    mov     esi, seged_string
    xor     ecx, ecx
    xor     edi, edi
    mov     ecx, 32
.kiiredx:
    cmp     edi, 4
    jne     .nemkellspace
    mov     ebx, ' '
    mov     [esi], ebx
    inc     esi
    xor     edi, edi
.nemkellspace:
    xor     ebx, ebx
    shl     edx, 1
    jnc     .nulla
    mov     ebx, '1'
    mov     [esi], bl
    jmp     .folyt
.nulla:
    mov     ebx, '0'
    mov     [esi], bl
.folyt:
    inc     esi
    inc     edi
    cmp     edx, 0
    loop    .kiiredx

    mov     ecx, 32
.kiireax:
    cmp     edi, 4
    jne     .nemkellspaceeax
    mov     ebx, ' '
    mov     [esi], ebx
    inc     esi
    xor     edi, edi
.nemkellspaceeax:
    xor     ebx, ebx
    shl     eax, 1
    jnc     .nullaeax
    mov     ebx, '1'
    mov     [esi], bl
    jmp     .folyteax
.nullaeax:
    mov     ebx, '0'
    mov     [esi], bl
.folyteax:
    inc     esi
    inc     edi
    cmp     eax, 0
    loop    .kiireax

    xor     ebx, ebx
    mov     [esi], ebx
    mov     esi, seged_string
    call    WriteStr
    popa
        ret

ReadHex:
    push     ebx
    push     ecx
    push     edx
    push     edi
    push     esi
    mov     ecx, 256
    mov     esi, seged_string
    call    ReadLnStr
    xor     ebx, ebx
.feldolgoz:
    xor     eax, eax
    mov     al, [esi]
    cmp     al, 0
    je      .vege
.szame:
    cmp     al, '0'
    jl      .er
    cmp     al, '9'
    jg      .nagybetue
    sub     al, '0'
    jmp     .berak
.nagybetue:
    cmp     al, 'A'
    jl      .er
    cmp     al, 'F'
    jg      .kisbetue
    sub     al, 55
    jmp     .berak
.kisbetue:
    cmp     al, 'a'
    jl      .er
    cmp     al, 'f'
    jg      .er
    sub     al, 87
    jmp     .berak
.berak:
    shl     ebx, 4
    jc      .er
    add     ebx, eax
    inc     esi
    jmp     .feldolgoz
.er:
    stc
.vege:
    mov     eax, ebx
    pop     esi
    pop     edi
    pop     edx
    pop     ecx
    pop     ebx
        ret

WriteHex:
    pusha
    mov     esi, seged_string
    mov     ebx, '0'
    mov     [esi], bl
    inc     esi
    mov     ebx, 'x'
    mov     [esi], bl
    inc     esi
    mov     ebx, eax
    xor     edi, edi
    mov     ecx, 8
.berak:
    shr     eax, 28
    cmp     eax, 10
    jl      .szam
    add     eax, 7 ;legyen nagybetu amiutan hozzaadjuk a '0'-t
.szam:
    add     eax, '0'
    mov     [esi], al
    shl     ebx, 4
    mov     eax, ebx
    inc     esi
    loop     .berak
.vege:
    xor     eax, eax
    mov     [esi], eax
    mov     esi, seged_string
    call    WriteStr
    popa
        ret

ReadHex64:
    push     ebx
    push     ecx
    push     edi
    push     esi
    mov     ecx, 256
    mov     esi, seged_string
    call    ReadLnStr
    xor     ebx, ebx
    xor     edx, edx
.feldolgoz:
    xor     eax, eax
    mov     al, [esi]
    cmp     al, 0
    je      .vege
.szame:
    cmp     al, '0'
    jl      .er
    cmp     al, '9'
    jg      .nagybetue
    sub     al, '0'
    jmp     .berak
.nagybetue:
    cmp     al, 'A'
    jl      .er
    cmp     al, 'F'
    jg      .kisbetue
    sub     al, 55
    jmp     .berak
.kisbetue:
    cmp     al, 'a'
    jl      .er
    cmp     al, 'f'
    jg      .er
    sub     al, 87
    jmp     .berak
.berak:
    mov     edi, ebx
    shr     edi, 28
    shl     edx, 4
    jc      .er
    add     edx, edi
    shl     ebx, 4
    add     ebx, eax
    inc     esi
    jmp     .feldolgoz
.er:
    stc
.vege:
    mov     eax, ebx
    pop     esi
    pop     edi
    pop     ecx
    pop     ebx
        ret

WriteHex64:
    pusha
    mov     esi, seged_string
    mov     ebx, '0'
    mov     [esi], bl
    inc     esi
    mov     ebx, 'x'
    mov     [esi], bl
    inc     esi
    push    eax
    mov     eax, edx
    pop     edx
    mov     edi, 2
.ujra:
    shr     edi, 1
    mov     ebx, eax
    mov     ecx, 8
.berak:
    shr     eax, 28
    cmp     eax, 10
    jl      .szam
    add     eax, 7 ;legyen nagybetu amiutan hozzaadjuk a '0'-t
.szam:
    add     eax, '0'
    mov     [esi], al
    shl     ebx, 4
    mov     eax, ebx
    inc     esi
    loop     .berak
.vege:
    cmp     edi, 1
    jne     .rat
    mov     eax, edx
    jmp     .ujra
.rat:
    xor     eax, eax
    mov     [esi], eax
    mov     esi, seged_string
    call    WriteStr
    popa
        ret

section .bss
    seged_string resb 256
