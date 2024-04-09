; Gyorgy Matyas 2236 512
;  Lab4 4. feladat masodik resze
; A stringek olvasását egyszerre lehet bemutatni a stringeken végzett műveletekkel.
; Mindkét stringnek kiírjuk a hosszát, kompaktált formáját, majd a kompaktált formát kis betűkre alakítva és nagy betűkre alakítva.
; Végül hozzáfűzzük az első string nagybetűs verziójához a második string kisbetűs verzióját és kiírjuk a hosszával együtt.
%include 'iostr.inc'
%include 'strings.inc'
%include  'ionum.inc'

global main

section .text

main:
    mov     esi, bekerA
    call    WriteStr
    mov     ecx, 256
	mov     esi, str_a
	call    ReadLnStr
    mov     esi, A_length
    call    WriteStr
    mov     esi, str_a
    call    StrLen
    call    WriteInt
    call    NewLine
    mov     esi, A.comp
    call    WriteStr
    mov     esi, str_a
    mov     edi, str_a
    call    StrCompact
    mov     esi, edi
    call    WriteLnStr
    mov     esi, A.complower
    call    WriteStr
    mov     esi, str_a
    call    StrLower
    call    WriteLnStr
    call    NewLine

    mov     esi, bekerB
    call    WriteStr
    mov     ecx, 256
	mov     esi, str_b
	call    ReadLnStr
    mov     esi, B_length
    call    WriteStr
    mov     esi, str_b
    call    StrLen
    call    WriteInt
    call    NewLine
    mov     esi, B.comp
    call    WriteStr
    mov     esi, str_b
    mov     edi, str_b
    call    StrCompact
    mov     esi, edi
    call    WriteLnStr
    mov     esi, B.compupper
    call    WriteStr
    mov     esi, str_b
    call    StrUpper    
    call    WriteLnStr
    call    NewLine

    mov     esi, str_a
    call    StrUpper
    mov     esi, str_b
    call    StrLower
    mov     edi, str_a
    call    StrCat
    mov     esi, edi
    push    esi
    mov     esi, ujstring
    call    WriteStr
    pop     esi
    call    WriteLnStr
    push    esi
    mov     esi, ujstring_length
    call    WriteStr
    pop     esi
    call    StrLen
    call    WriteInt

	ret
	

section .data
	bekerA db 'beolvas A: ', 0
	A_length db 'A hossza: ', 0
	A.comp db 'A kompakt: ', 0
	A.complower db 'A kompakt kisbetukkel: ', 0
	bekerB db 'beolvas B: ', 0
	B_length db 'B hossza: ', 0
	B.comp db 'B kompakt: ', 0
    B.compupper db 'B kompakt nagybetukkel: ', 0
	ujstring db 'az uj string(B kompakt&nagybetu + B kompakt&kisbetu): ', 0
	ujstring_length db 'uj string hossza: ', 0

	
section .bss
	str_a resb 256
	str_b resb 256