org 100h 
   .data
Entry db "Enter The Amount Of Paid Money or Enter '0' if you want to leave: $"    
entr db "You can use the parking now"
temm db 0
cost db 0 

wrongEntrymessage db "Not Specified value $"

Expirymessage db "Expired... $ "    
greenmessage db "No pending amount, You can take left and use the free lane! Thank you for using our service!! $"
redmessage db "You have used the parking more that the given stipulated time. Take right and kindly pay the specified amount in the exit lane booth... You have availed an additional of $"
thank db " minutes Thank you for using our service!! $" 
RES  DB 10 DUP ('$')
.code

mov ax,@data
mov ds, ax ;load @data in data segement
                         

Userinput:
                                                                                                           
lea dx,Entry
mov ah,09h
int 21h

mov dl,10 ;intialize by 10
mov bl,0  ;intialize by 0

scanNum:

      mov ah, 01h
      int 21h

      cmp al, 13   ; Terminates Loop if "ENTER KEY"
      je  Return

      mov ah, 0  
      sub al, 48   ; ASCII

      mov cl, al
      mov al, bl   ; bl contains the previous value

      mul dl       ; multiply the previous value with 10

      add al, cl   ; previous * 10 + new value
      mov bl, al

      jmp scanNum

Return:

mov ax,0

cmp bl, 1                   
jne if5pounds                 
lea si,temm 
mov [si],30
call print
jmp endif





if5pounds:
cmp bl, 5
jne if10pounds
lea si,temm 
mov [si],100
call print
jmp endif
 

if10pounds:
cmp bl, 0Ah
jne wrongentry
lea si,temm 
mov [si],250
call print
jmp endif


endif:

;Newline                    
mov dx,13
mov ah,2
int 21h  
mov dx,10
mov ah,2
int 21h

;wait function
;mov ah,86h
;int 15h

;types Expired When Time is Finished   
mov di,0
cmp cx,di
je exp

 ;When cae is removed from the parking with green indicator
   
mov di,2
cmp cx,di
je green 
 
 ;When cae is removed from the parking with red indicator
mov di,1
cmp cx,di
je red


jmp final
 

exp:
lea dx,Expirymessage
mov ah,09h
int 21h

jmp Final   

green:
lea dx,greenmessage
mov ah,09h
int 21h 

jmp Final 

red:
lea dx,redmessage
mov ah,09h
int 21h   
sub [si],bl   
mov bl,[si]    
mov cost,bl
      ;-----------
  mov bh,0    
MOV AX,BX;load the value of bl into ax 
    LEA SI,RES
    CALL HEX2DEC
    LEA DX,RES
    MOV AH,9
    INT 21H         

lea dx,thank
mov ah,09h
int 21h
 jmp Final

wrongentry:
cmp bl,0h
je END

;Newline                    
mov dx,13
mov ah,2
int 21h  
mov dx,10
mov ah,2
int 21h

lea dx,wrongEntrymessage
mov ah,09h
int 21h


Final:

;Newline                    
mov dx,13
mov ah,2
int 21h  
mov dx,10
mov ah,2
int 21h
call Userinput

END:
hlt
    
    
    
    
proc print  
mov ah,0
mov al,13h
int 10h

mov ah,0ch;
mov al,4;colour
mov cx,10
mov dx,50
int 10h
       
mov bl,[si]
fl:
mov al,10
 int 10h
 push ax
 mov ah, 01h
   int 16h
   jnz process_input1
 mod1:
pop ax
inc cx
dec bl
jnz fl  

mov bl,[si]
sl:
mov al,10
int 10h 
 push ax
 mov ah, 01h
   int 16h
   jnz process_input2
 mod2:
pop ax
inc dx
dec bl
jnz sl

mov bl,[si]
tl:
mov al,10
int 10h  
 push ax
 mov ah, 01h
   int 16h
   jnz process_input3
 mod3:
pop ax
dec cx
dec bl
jnz tl
       

mov bl,[si]
ff: 
mov ah,0ch
mov al,4
int 10h
 push ax
 mov ah, 01h
   int 16h
   jnz process_input4
 mod4:
pop ax 
push dx
mov dx,0  
mov dl,7h
mov ah,2
int 21h 
pop dx
dec dx
dec bl
jnz ff  
mov cx,0
ret  
process_input1:
    ; Read the key from the input buffer
    mov ah, 00h
    int 16h
    
    ; Check if the key is the Enter key
    cmp al, 0Dh ; Check if AH contains  (Enter key)
    je end_program
    jmp mod1
process_input2:
    ; Read the key from the input buffer
    mov ah, 00h
    int 16h
    
    ; Check if the key is the Enter key
    cmp al, 0Dh ; Check if AH contains (Enter key)
    je end_program
    jmp mod2
process_input3:
    ; Read the key from the input buffer
    mov ah, 00h
    int 16h
    
    ; Check if the key is the Enter key
    cmp al, 0Dh ; Check if AH contains (Enter key)
    je end_program
    jmp mod3 
process_input4:
    ; Read the key from the input buffer
    mov ah, 00h
    int 16h
    
    ; Check if the key is the Enter key
    cmp al, 0Dh ; Check if AH contains Carriage Return (Enter key)
    je end_program2
    jmp mod4

end_program: 
pop ax 
mov cx,2
ret  
end_program2:    
pop ax 
mov cx,1
ret
print endp    


HEX2DEC PROC NEAR
    MOV CX,0
    MOV BX,10
   
LOOP1: MOV DX,0
       DIV BX
       ADD DL,30H
       PUSH DX
       INC CX
       CMP AX,9
       JG LOOP1
     
       ADD AL,30H
       MOV [SI],AL

LOOP2: POP AX
       INC SI
       MOV [SI],AL
       LOOP LOOP2
       RET
HEX2DEC ENDP 