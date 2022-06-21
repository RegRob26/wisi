
;Declaración de los comandos existentes
.MODEL SMALL
.386
include ..\fun\macros.asm
public verificador
public ejecutador
.DATA

outhandle dw ?
cexit 	db "exit-"
ccd		db "cd-"
ctouch	db "touch-"
cdir	db "dir-"
cmkdir 	db "mkdir-"	
crm		db "rm-"
crmdir	db "rmdir-"
ccls	db "cls-"

.STACK
.CODE

;comando [bp+4], lencomando [bp+6], flagverifica [bp+8]
verificador:
		push bp 
		mov bp, sp

		cld
		mov si,[bp+4]
		mov di,offset cexit
		mov cx,[bp+6]
		repe cmpsb 						;Se detendrá en dos posibles casos:
		jne com_cd					; -encontró una diferencia				; -CX llegó a 0.			
		
		mov bx, [bp+8]
		mov word ptr [bx], 1h
        jmp ret_ver

 com_cd:
		cld 
		mov si, [bp+4]
		mov di, offset ccd
		mov cx, [bp+6]
		repe cmpsb
		jne com_dir

		mov bx, [bp+8]
		mov word ptr [bx], 2h


		jmp ret_ver
 com_dir:
		cld 
		mov si, [bp+4]
		mov di, offset cdir
		mov cx, [bp+6]
		repe cmpsb
		jne com_touch
		;print "Es dir"
		mov bx, [bp+8]
		mov word ptr [bx], 3h

		jmp ret_ver
 com_touch:
		cld 
		mov si, [bp+4]
		mov di, offset ctouch
		mov cx, [bp+6]
		repe cmpsb
		jne com_mkdir
		;print "Es touch"
		
		mov bx, [bp+8]
		mov word ptr [bx], 4h

		jmp ret_ver
 com_mkdir:
		cld 
		mov si, [bp+4]
		mov di, offset cmkdir
		mov cx, [bp+6]
		repe cmpsb
		jne com_rm
		;print "Es mkdir"
		mov bx, [bp+8]
		mov word ptr [bx], 5h

		jmp ret_ver
 com_rm:
		cld 
		mov si, [bp+4]
		mov di, offset crm
		mov cx, [bp+6]
		repe cmpsb
		jne com_rmdir
		
		mov bx, [bp+8]
		mov word ptr [bx], 6h


		
		jmp ret_ver

 com_rmdir:
		cld 
		mov si, [bp+4]
		mov di, offset crmdir
		mov cx, [bp+6]
		repe cmpsb
		jne com_cls
		;print "Es rmdir "
		
		mov bx, [bp+8]
		mov word ptr [bx], 7h

		jmp ret_ver


 com_cls:
		cld 
		mov si, [bp+4]
		mov di, offset ccls
		mov cx, [bp+6]
		repe cmpsb
		jne ret_ver

		mov bx, [bp+8]
		mov word ptr [bx], 8h


		jmp ret_ver

 ret_ver:
		mov sp, bp
		pop bp
 		ret

;flagverifica [bp+4], instrucciones [bp+6], renglon [bp+8]

ejecutador:

		push bp
		mov bp, sp

		mov bx, 0
		cmp [bp+4], bx
		jne flag_exit

		jmp ret_eje
 flag_exit:
		mov bx, 1
		cmp [bp+4], bx
		jne flag_cd
		.exit 0
 flag_cd:
		mov bx, 2
		cmp [bp+4], bx
		jne flag_dir
	
		mov ah, 3BH
		mov dx, [bp+6]
		int 21h

		jmp ret_eje
 flag_dir:
		cmp word ptr[bp+4], 3h
		jne flag_touch
		
		mov ah, 3BH
		mov dx, [bp+6]
		int 21h

		jmp ret_eje
 flag_touch:

		cmp word ptr[bp+4], 4h
		jne flag_mkdir

		mov dx, offset [bp+6]
    	mov cx, 0
    	mov ah, 3Ch
    	int 21h
    	mov outhandle, ax
    	jc  error_ex ;Aquí va salto a error
    	mov ah, 3Eh
    	mov bx, outhandle
	    int 21h

		jmp ret_eje

 flag_mkdir:
		cmp word ptr[bp+4], 5h
		jne flag_rm

		mov ah, 39h
		mov dx, [bp+6]
		int 21h
		jc error_ex

		jmp ret_eje
 flag_rm:
		cmp word ptr[bp+4], 6h
		jne flag_rmdir

		mov ah, 41h
		mov dx,[bp+6]
		int 21h
		jc error_ex

		jmp ret_eje

 flag_rmdir:
		cmp word ptr[bp+4], 7h
		jne flag_cls

		mov ah, 3Ah
		mov dx,[bp+6]
		int 21h
		jc error_ex

		jmp ret_eje

 flag_cls:
		cmp word ptr[bp+4], 8h
		jne flag_cls

		mov ax, 3
		int 10h
		mov bx, [bp+8]
		mov byte ptr [bx], -2
		int 10h
		
		
		jmp ret_eje
 ret_eje:
		mov sp, bp
		pop bp
		ret

 error_ex:
		print "error de ejecución"
		mov sp, bp
		pop bp
		ret

end