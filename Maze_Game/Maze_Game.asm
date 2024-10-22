.model small
.stack 100h

.data
arr db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)
	db 16 dup(?)


fname db 'file11.txt',0
fname1 db 'file22.txt',0
handle dw ?
buff db 256 dup('$')

pf1 db 9,"Path Finder$"

wrong db 10,13,"Maximum Wrong Move 3$"
uwrong db 10,13,"Wrong move# $"

operr db 10,13,"Error in file opening$"
clerr db 10,13,"Error in file closing$"
reerr db 10,13,"Error in file reading$"

inkey db 10,13,"Invalid key$"
prsag	db 10,13,"Press Again$"

invalid db 10,13,"Invalid move$"
gameover db 10,13,"You Lose GAME OVER$"

nextlel db 10,13,"Are you want to play next level $"

lel db 1 dup(00)


x dw 1 dup (?)
y dw 1 dup (?)

i dw 1 dup(?)
j dw 1 dup(?)

count db 1 dup(00)

done db 10,13,1, " Cograts You Won $"

.code
	main proc
	mov ax,@data
	mov ds,ax
	mov si,offset arr
	mov dx,offset fname
	call open
	mov dx,offset buff
	call read
	call close
	mov dx,offset pf1
	mov ah,09
	int 21h
	;call setbg
start:
	call clear
	call val
	call dis
	mov dx,offset wrong
	mov ah,09
	int 21h
	call path
	
	
	
	mov ah,4ch
	int 21h
	main endp
	
	clear proc   ;function to clear screen and move cursor at start...........

	mov ah,6    ;this will clear screen
	mov al,0
	mov bh,7
	mov cx,0
	mov dl,79
	mov dh,24
	int  10h
	
 

	mov ah,2       ;this will control cursor location
	mov bh,0
	mov dh,0
	mov dl,0
	int 10h
	mov dx,offset pf1
	mov ah,09
	int 21h
	ret
	
	clear endp
	
	open proc		;open file function
	mov ah,3dh  
	mov al,0
	int 21h 
	mov handle,ax 
	jc open_error 
	jmp rt
	
open_error:
	mov dx,offset operr
	mov ah,09
	int 21h
	
rt:	ret
	open endp
	
	close proc			;close a file
	mov ah,3eh
	mov bx,handle
	int 21h
	jc close_error
	jmp rt1
	
close_error:
	mov dx,offset clerr
	mov ah,09
	int 21h
	
rt1:	ret
	close endp

	
	read proc		;reading a file
	mov ah,3fh
	mov bx,handle
	mov cx,256
	
	int 21h
	jc read_error
	cmp ax,cx
	jl ee
	jmp ee
	
	
read_error:	
	
	mov dx,offset reerr
	mov ah,09
	int 21h
	
	
ee:	ret
	read endp
	
	setbg proc   	;set background pg(451)
	
	mov ah,0
	mov al,06h
	int 10h
	
	mov ah,0bh
	mov bh,01h
	mov bl,0ah
	int 10h
	
	mov bl,0
	mov bh,2
	int 10h
	
	ret
	setbg endp
	
	
	
	val proc     ;function to intialize the Matrix
	mov bx,0
	xor si,si
	xor ax,ax
	xor cx,cx
	
	mov cl,16
	xor di,di
	mov di,offset buff
one1:
	mov al,[di]
	cmp al,23h
	jne tt
	mov al,0dbh
tt:	inc di
	mov arr[bx][si],al
	inc si
	cmp si,cx
	jne one1
	add cl,16
	dec si
	dec cl
	inc bx
	cmp bx,16
	jne one1
	mov bx,1
	mov si,10h
	
	mov arr[bx][si],1
	
	ret
	val endp
	
	
	dis proc			;function to display the Matrix
	xor bx,bx
	xor si,si
	xor cx,cx
	
	mov cx,16
	
	mov dl,10
	mov ah,02
	int 21h
	
	mov dl,13
	mov ah,02
	int 21h

one:
	mov al,arr[bx][si]
	push cx
	cmp bx,15
	je incbx
	jmp notbx
incbx: inc bx
notbx:	inc bx
	mov cx,0001
	mov ah,09h
	int 10h
	mov dl,al
	mov ah,02
	int 21h
	dec bx
	inc si
	pop cx
	loop one
	add cx,16
	dec si
	dec cx
	mov dl,10
	mov ah,02
	int 21h
	mov dl,13
	mov ah,02
	int 21h
	inc bx
	cmp bx,17
	
	jne one		
	ret
	
	dis endp
	
	path proc    ;pathfinder
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor dx,dx
	xor si,si
	xor di,di
	
	mov x,1
	mov y,10h
	
	
	
nemo:
	mov ah,0
	int 16h
	
	xor al,al
	cmp ah,48h
	je up
	cmp ah,50h
	je down
	cmp ah,4bh
	je left1
	cmp ah,4dh
	je right1
	mov dx,offset inkey
	mov ah,09
	int 21h
	mov dx,offset prsag
	mov ah,09
	int 21h
	jmp nemo
	left1:jmp left
	

up:	
	mov bx,x
	mov si,y
	mov arr[bx][si],' '
	sub si,14
	dec bx
	cmp arr[bx][si],0dbh
	je im1
	cmp arr[bx][si],'X'
	je done2
	mov arr[bx][si],1
	mov x,bx
	mov y,si
	call putdis
	jmp nemo
right1:jmp right
done2:jmp don
down:
	mov bx,x
	mov si,y
	mov arr[bx][si],' '
	add si,14
	inc bx
	cmp arr[bx][si],0dbh
	je im1
	cmp arr[bx][si],'X'
	mov arr[bx][si],1
	je don
	mov arr[bx][si],1
	mov x,bx
	mov y,si
	call putdis
	jmp nemo
don:jmp done1
im1: jmp im
left:
	mov bx,x
	mov si,y
	mov arr[bx][si],' '
	dec si
	cmp arr[bx][si],0dbh
	je im
	cmp arr[bx][si],'X'
	je done1
	mov arr[bx][si],1
	mov x,bx
	mov y,si
	call putdis
	jmp nemo
	
	

right:
	mov bx,x
	mov si,y
	mov arr[bx][si],' '
	inc si
	cmp arr[bx][si],0dbh
	je im
	cmp arr[bx][si],'X'
	je done1
	mov arr[bx][si],1
	mov x,bx
	mov y,si
	call putdis
	jmp nemo
	start1: jmp start
	
	
im:	call clear
	mov bx,x
	mov si,y
	mov arr[bx][si],1
	call dis
	mov cl,count
	inc cl
	mov count,cl
	mov dx,offset uwrong
	mov ah,09
	int 21h
	mov dl,cl
	add dl,30h
	mov ah,02
	int 21h
	cmp count,3
	je game_over
	jmp nemo
	
	
done1:
	mov arr[bx][si],1
	call putdis
	mov dx,offset done
	mov ah,09
	int 21h
	
	mov dx,offset fname1
	call open
	mov dx,offset buff
	call read
	call close
	mov cl,lel
	cmp lel,1
	je exit
	inc cl
	mov lel,cl
	mov dx,offset nextlel
	mov ah,09
	int 21h
	xor cx,cx
	mov count,cl
	mov ah,01
	int 21h
	cmp al,79h
	
	je start1
	jmp exit
	
game_over:
	mov dx,offset gameover
	mov ah,09
	int 21h	
	
exit:
	ret
	path endp
	
	putdis proc		;function of put the value
	call clear
	call dis

	ret
	putdis endp
	
	
end main