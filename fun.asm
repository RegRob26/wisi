.MODEL SMALL
public lee1
public lee2
public lee4
public des1
public des2
public des4
public spc
public reto
public leedec
public desdec
public carry
.DATA
.STACK
.CODE
;dato en AL

lee1:   mov ah, 01h       ;Dato en AL
        int 21h
        sub al, 30h
        cmp al, 09h
        jle sal1
        sub al, 07h
        cmp al, 0fh
        jle sal1
        sub al, 20h
 sal1: ret

lee2:  push bx 
       call lee1    ;Lectura del primer dato   3 en AL           ;Respaldar el dato 
       shl al, 4
       mov bl, al
       call lee1    ;Lectura del segundo dato  2 en AL
       add al, bl
       pop bx
       ret
;3b18
;3f22
;199b

lee4:  push bx
       call lee2
       mov bh,al    ;Respaldo del datoA
       call lee2
       mov ah,bh
       pop bx
       ret

des1:   add dl, 30h                ;Regresar todos DL a AL
        cmp dl, 39h
        jle imp1
        add dl, 07h


 imp1:  mov ah, 02h
        int 21h

        ret 

des2:   push bx;Respaldar dato

        mov bl, dl
        shr dl,4 
        call des1;Llamar a des1
        mov dl, bl
        and dl, 0fh
        call des1

        pop bx
        ret
        ;llamar a des1
        ;retornar


des4:   push bx
        
        mov bl, dl               ;Recuperar primer dato en dl
        mov dl, dh   

        call des2
        
        mov dl, bl
        call des2
        
        pop bx
        ret

reto:  push ax
       push dx

       mov ah, 02h
       mov dl, 0DH
       int 21h
       mov dl, 0AH
       int 21h

       pop dx
       pop ax
       ret
       
spc:  push ax
      push dx
      mov ah, 02h

      mov dl, ' '
      int 21h

      pop dx
      pop ax
      ret

carry:  push cx
        mov dl, '1'
        mov ah, 02h
        int 21h
        pop cx
        ret
      


leedec: push bx
        push cx
        push dx
        mov bx, 0
        mov ch, 0

 ldc:   call lee1
        cmp al, 0DDH
        je ld_s
        mov cl, al
        mov ax, 0Ah
        mul bx
        add ax, cx
        mov bx, ax
        jmp ldc

 ld_s:  mov ax, bx
        pop dx
        pop cx
        pop bx
        ret

desdec: push cx      
        push bx
        push ax
        mov ax, dx
        cmp ax, 0
        je sal_2
        mov bx, 0Ah
        mov cx, 0
 cicdec:cmp ax, 0h
        je sal_1
        mov dx, 0    ;Dato en DX-AX
        div bx       ;Dato en AX, residuo en DX
        inc cx
        push dx
        jmp cicdec

 sal_2: mov dx, 0h
        call des1
        jmp ext2
 sal_1: pop dx
        call des1
        loop sal_1
 ext2: pop ax
        pop bx
        pop cx
        ret 

end
