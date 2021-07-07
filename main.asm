; project last version  
INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 5000
.DATA
; write file 
temp dword ?
outfile	dword ?  
filewrite	BYTE "lastboar.txt",0
string byte 90 dup(0)
; write file solved  
temp1 dword ?
outfile1	dword ?  
filewrite1	BYTE "solved.txt",0
string1 byte 90 dup(0)

; edit data type 

captionW BYTE "info",0
warningMsg BYTE "the solution was correct "
warningMsg2 BYTE "the solution was incorrect "
space byte " ", 0
count dword 0
count2 dword 0
const_size dword 9
count_correct byte 0
count_incorrect byte 0
count_correct_completely byte 0
col_user Byte ? 
row_user  Byte ?
value_user Byte 0
string_user1 Byte "Enter the column number : ",0
string_user2  Byte "Enter the row number : ",0
string_user3  Byte "Enter the value number to edit sodoko board : ",0
board byte 0,0,0,0,0,0,0,0,0
		byte 0,0,0,0,0,0,0,0,0
		byte 0,0,0,0,0,0,0,0,0	  
		byte 0,0,0,0,0,0,0,0,0
		byte 0,0,0,0,0,0,0,0,0
		byte 0,0,0,0,0,0,0,0,0
		byte 0,0,0,0,0,0,0,0,0
		byte 0,0,0,0,0,0,0,0,0
		byte 0,0,0,0,0,0,0,0,0


solved_board  byte 0,0,0,0,0,0,0,0,0
				byte 0,0,0,0,0,0,0,0,0
				byte 0,0,0,0,0,0,0,0,0	  
				byte 0,0,0,0,0,0,0,0,0
				byte 0,0,0,0,0,0,0,0,0
				byte 0,0,0,0,0,0,0,0,0
				byte 0,0,0,0,0,0,0,0,0
				byte 0,0,0,0,0,0,0,0,0
				byte 0,0,0,0,0,0,0,0,0

; select mode , start game data type 

take_un byte 'Enter user name :',0
take_ln byte 'Enter level number ( 1 , 2 , 3)',0
take_iln byte 'Enter inner level number ( 1 , 2 , 3 )',0
choice_list byte 'Enter your choice :',0
cl1 byte ' 1-) Print correct board ',0
cl2 byte ' 2-) Clear the board ',0
cl3 byte ' 3-) Edit cell ',0
cl4 byte ' 4-) Save and exit',0

user_name byte  ?

choice dword ?

; data file 

buffer BYTE BUFFER_SIZE DUP(?)
filename BYTE "diff_1_2.txt"
fileHandle HANDLE ?
tmp dword 0 

file_solved byte "diff_1_1_solved.txt"
fHandle HANDLE ?
bfr BYTE BUFFER_SIZE DUP(?)
tmpp dword 0 

; read file last board 

;start game 
new_string byte "1- new game : " , 0 
cont_string byte "2- continue last game : " , 0 
val byte ?

; file solved write 
filewr byte "lastboar.txt"
fh HANDLE ?
bffr BYTE BUFFER_SIZE DUP(?)
tmmp dword 0 

; file solved read 

filewrit byte "solved.txt"
fhl HANDLE ?
buffr BYTE BUFFER_SIZE DUP(?)
ttmp dword 0 

;report 

str1 byte "User Name : ",0

str2 byte "Scored Right : ",0
rightscore dword 5
str3 byte "Scored Wrong : ",0
wrongscore dword 4
str4 byte "Complete Successful Sudoku : ",0
srting_succ byte "Complete Successful Sudoku ",0

.code
main PROC

call start_game
	exit
main ENDP



;______________________________
read_file PROC 
	
	
	
		; Open the file for input.

		mov edx ,offset filename
		call OpenInputFile
		mov fileHandle,eax
		; Check for errors.
		
		cmp eax,INVALID_HANDLE_VALUE ; error opening file?
		jne file_ok ; no: skip
		mWrite <"Cannot open file",0dh,0ah>
		jmp quit ; and quit
		
		file_ok:
		; Read the file into a buffer.
		mov edx,OFFSET buffer
		mov ecx,BUFFER_SIZE
		call ReadFromFile
		jnc check_buffer_size ; error reading?
		mWrite "Error reading file. " ; yes: show error message
		call WriteWindowsMsg
		jmp close_file
		
		check_buffer_size:
		cmp eax,BUFFER_SIZE ; buffer large enough?
		jb buf_size_ok ; yes
		mWrite <"Error: Buffer too small for the file",0dh,0ah>
		jmp quit ; and quit
		
		buf_size_ok:
		mov buffer[eax],0 ; insert null terminator
	
		
		; Display the buffer.
		mov edi , offset board
		mov edx,OFFSET buffer ; display the buffer
		mov ebx,0
		mov ecx,9
		mov esi , 0

		l1:
        mov tmp,ecx
		mov ecx,9
		l2:
		mov al,[edx+esi]
		
		sub al , "0"
		mov  [edi+ebx],al
		inc ebx
		inc esi
		LOOP l2
		mov ecx , 2
		L5:
		mov al,[edx+esi]
		inc esi
		loop L5
		mov ecx,tmp
		LOOP l1
		close_file:
		mov eax,fileHandle
		call CloseFile
		quit:

	RET 
read_file ENDP


;_______________________________

read_file_last_solved_board PROC 
	
		; Open the file for input.

		mov edx ,offset filewrit
		call OpenInputFile
		mov fhl,eax
		; Check for errors.
		
		cmp eax,INVALID_HANDLE_VALUE ; error opening file?
		jne file_ok ; no: skip
		mWrite <"Cannot open file",0dh,0ah>
		jmp quit ; and quit
		
		file_ok:
		; Read the file into a buffer.
		mov edx,OFFSET buffr
		mov ecx,BUFFER_SIZE
		call ReadFromFile
		jnc check_buffer_size ; error reading?
		mWrite "Error reading file. " ; yes: show error message
		call WriteWindowsMsg
		jmp close_file
		
		check_buffer_size:
		cmp eax,BUFFER_SIZE ; buffer large enough?
		jb buf_size_ok ; yes
		mWrite <"Error: Buffer too small for the file",0dh,0ah>
		jmp quit ; and quit
		
		buf_size_ok:
		mov buffr[eax],0 ; insert null terminator
	
		
		; Display the buffer.
		mov edi , offset solved_board
		mov edx,OFFSET buffr ; display the buffer
		mov ebx,0
		mov ecx,9
		mov esi , 0

		l1:
        mov ttmp,ecx
		mov ecx,9
		l2:
		mov al,[edx+esi]
		
		sub al , "0"
		mov  [edi+ebx],al
		inc ebx
		inc esi
		LOOP l2
		mov al,[edx+esi]
		inc esi
		mov ecx,ttmp
		LOOP l1
		close_file:
		mov eax,fhl
		call CloseFile
		quit:

	RET 
read_file_last_solved_board ENDP
;__________________________________

read_file_last_board PROC 
	
		; Open the file for input.

		mov edx ,offset filewrite
		call OpenInputFile
		mov fhl,eax
		; Check for errors.
		
		cmp eax,INVALID_HANDLE_VALUE ; error opening file?
		jne file_ok ; no: skip
		mWrite <"Cannot open file",0dh,0ah>
		jmp quit ; and quit
		
		file_ok:
		; Read the file into a buffer.
		mov edx,OFFSET bffr
		mov ecx,BUFFER_SIZE
		call ReadFromFile
		jnc check_buffer_size ; error reading?
		mWrite "Error reading file. " ; yes: show error message
		call WriteWindowsMsg
		jmp close_file
		
		check_buffer_size:
		cmp eax,BUFFER_SIZE ; buffer large enough?
		jb buf_size_ok ; yes
		mWrite <"Error: Buffer too small for the file",0dh,0ah>
		jmp quit ; and quit
		
		buf_size_ok:
		mov bffr[eax],0 ; insert null terminator
	
		
		; Display the buffer.
		mov edi , offset board
		mov edx,OFFSET bffr ; display the buffer
		mov ebx,0
		mov ecx,9
		mov esi , 0

		l1:
        mov tmmp,ecx
		mov ecx,9
		l2:
		mov al,[edx+esi]
		
		sub al , "0"
		mov  [edi+ebx],al
		inc ebx
		inc esi
		LOOP l2
		mov al,[edx+esi]
		inc esi
		mov ecx,tmmp
		LOOP l1
		close_file:
		mov eax,fh
		call CloseFile
		quit:

	RET 
read_file_last_board ENDP
;_________________________________
read_file_solved PROC 
	
	
	
		; Open the file for input.

		mov edx ,offset file_solved
		call OpenInputFile
		mov fHandle,eax
		; Check for errors.
		
		cmp eax,INVALID_HANDLE_VALUE ; error opening file?
		jne file_ok ; no: skip
		mWrite <"Cannot open file",0dh,0ah>
		jmp quit ; and quit
		
		file_ok:
		; Read the file into a buffer.
		mov edx,OFFSET bfr
		mov ecx,BUFFER_SIZE
		call ReadFromFile
		jnc check_buffer_size ; error reading?
		mWrite "Error reading file. " ; yes: show error message
		call WriteWindowsMsg
		jmp close_file
		
		check_buffer_size:
		cmp eax,BUFFER_SIZE ; buffer large enough?
		jb buf_size_ok ; yes
		mWrite <"Error: Buffer too small for the file",0dh,0ah>
		jmp quit ; and quit
		
		buf_size_ok:
		mov bfr[eax],0 ; insert null terminator
	
		
		; Display the buffer.
		mov edi , offset solved_board
		mov edx,OFFSET bfr ; display the buffer
		mov ebx,0
		mov ecx,9
		mov esi , 0

		l1:
        mov tmpp,ecx
		mov ecx,9
		l2:
		mov al,[edx+esi]
		
		sub al , "0"
		mov  [edi+ebx],al
		inc ebx
		inc esi
		LOOP l2
		mov ecx , 2
		L5:
		mov al,[edx+esi]
		inc esi
		loop L5
		mov ecx,tmpp
		LOOP l1
		close_file:
		mov eax,fHandle
		call CloseFile
		quit:

	RET 
read_file_solved ENDP
;_______________________________________________

write proc 

call integer_to_string 
	lea edx, filewrite
  call CreateOutputFile
  mov outfile, eax
   
  mov eax, outfile  
  lea edx, string 
  mov ecx, 90
  call WriteToFile

  mov eax, outfile
  call CloseFile

ret 
write endp

integer_to_string proc 
    mov esi , offset board 
    mov edi , offset string 
   mov ecx , 9
   mov edx , 0 
   mov ebx , 0
   L1:
        mov temp , ecx 
        mov ecx , 9
        L2:
            mov eax , [esi+ ebx]
            add eax , "0"
            mov [edi+ edx] , eax 
            inc edx 
            inc ebx
        loop L2 
        mov ecx , temp
        mov byte ptr [edi + edx ] , 10
      
        inc edx
   loop L1
   ret
integer_to_string endp

;______________________________

write_file_solved proc 

call integer_to_string_2 
	lea edx, filewrite1
  call CreateOutputFile
  mov outfile1, eax
   
  mov eax, outfile1  
  lea edx, string1 
  mov ecx, 90
  call WriteToFile

  mov eax, outfile1
  call CloseFile

ret 
write_file_solved endp

integer_to_string_2 proc 
    mov esi , offset solved_board 
    mov edi , offset string1
   mov ecx , 9
   mov edx , 0 
   mov ebx , 0
   L1:
        mov temp1 , ecx 
        mov ecx , 9
        L2:
            mov eax , [esi+ ebx]
            add eax , "0"
            mov [edi+ edx] , eax 
            inc edx 
            inc ebx
        loop L2 
        mov ecx , temp1
        mov byte ptr [edi + edx ] , 10
      
        inc edx
   loop L1
   ret
integer_to_string_2 endp

;______________________________
 insert PROC 
	
	; to print enter column number 
	mov EDX , OFFSET string_user1
	CALL writestring

	; read column for board

	call readint 
	mov col_user , al 


	; to print enter row number
	mov EDX , OFFSET string_user2
	CALL writestring

	; read row  for board

	call readint 
	mov row_user , al 


	; to print enter value number
	mov EDX , OFFSET string_user3
	CALL writestring

	; read value for board 
	
	call readint 
	mov value_user , al 
	
	
	; access index in array solved  board 
	mov edx , OFFSET solved_board  
	sub row_user , 1
	mov al , row_user 
	mov bl , 9 
	mul bl 
	movzx  eax , ax 
	add edx , eax 
	sub col_user , 1
	movzx esi ,  col_user
	mov bl ,byte ptr [edx + esi ]   

	
	; in a value of index from board
	
	cmp bl , value_user
	je play
	; call proc finish sodoko

	inc count_incorrect
	
	invoke MessageBoxA ,null , ADDR warningMsg2, ADDR captionW,
MB_OK + MB_ICONSTOP
	call report
		exit
	play:
	inc count_correct
	; edit in board 
	mov ebx , OFFSET board  
	add ebx , eax 
	movzx esi ,  col_user
	mov al , value_user
	mov byte ptr [ebx + esi ]  ,al
	
	
	; check fill 
mov edx , OFFSET board 	
mov ecx , 9
IO:
	mov esi , 0
	mov ebx , ecx 
	mov ecx , 9
	I:
	
	movzx eax ,byte ptr [edx + esi]
	cmp eax , 0
	je go 
	add esi , 1 
	loop I 
	mov ecx , ebx
	add edx , 9
loop IO 
inc count_correct_completely
mov edx , offset srting_succ
call crlf
call writestring
call crlf 	
call crlf 	
	go:
	call print_board
	invoke MessageBoxA ,null , ADDR warningMsg, ADDR captionW,
MB_OK + MB_ICONINFORMATION
	

quit:

	ret
insert ENDP


;______________________________

	MessageBoxA PROTO,
	hWnd:DWORD, ; handle to window (can be null)
	lpText:PTR BYTE, ; string, inside of box	
	lpCaption:PTR BYTE, ; string, dialog box title
	uType:DWORD ; contents and behavior
	
;______________________________

print_board PROC
mov edx , OFFSET board 	
mov ecx , 9
IO:
	mov esi , 0
	mov ebx , ecx 
	mov ecx , 9
	I:
	
	movzx eax ,byte ptr [edx + esi]
	call writedec
	mov eax , edx 
	mov edx ,offset space 
	call writestring 
	mov edx , eax 
	add esi , 1 
	loop I 
	mov ecx , ebx
	add edx , 9
	call crlf
loop IO 
	RET 
print_board ENDP

;______________________________

print_solved_board PROC
mov edx , OFFSET solved_board 	
mov ecx , 9
IO:
	mov esi , 0
	mov ebx , ecx 
	mov ecx , 9
	I:
	movzx eax ,byte ptr [edx + esi]
	call writedec
	mov eax , edx 
	mov edx ,offset space 
	call writestring 
	mov edx , eax 
	add esi , 1 
	loop I 
	mov ecx , ebx
	add edx , 9
	call crlf
loop IO 
	RET 
print_solved_board ENDP

;______________________________

start_game PROC

mov edx , offset new_string 
call writestring 
call crlf 
mov edx , offset cont_string 
call writestring 

call readdec 
mov val , al

mov edx,offset take_un
mov ecx, lengthof take_un
call writestring
call crlf

mov edx,offset user_name
call readstring
mov edx,offset user_name
call crlf

mov edx, offset take_ln
mov ecx ,lengthof take_ln
call writestring
call crlf
call readint 
add al , "0"
mov filename[5] ,al 
mov file_solved[5] ,al
mov edx, offset take_iln
mov ecx ,lengthof take_iln
call writestring
call crlf
call readint 
; edit in file name for load file 
add al ,"0"
mov filename[7] , al   
mov file_solved[7] ,al

cmp val , 2 
je po 
; edit in file name for load file 
call read_file
call read_file_solved
call print_board
jmp w

po:

call read_file_last_solved_board
call read_file_last_board
call print_board

w:
call select_option
	RET 
start_game ENDP


;______________________________

select_option PROC 
	
mov edx , offset choice_list
mov ecx , lengthof choice_list
call writestring
call crlf

mov edx , offset cl1
mov ecx , lengthof cl1
call writestring
call crlf

mov edx , offset cl2
mov ecx , lengthof cl2
call writestring
call crlf

mov edx , offset cl3
mov ecx , lengthof cl3
call writestring
call crlf

mov edx , offset cl4
mov ecx , lengthof cl4
call writestring
call crlf

call readint 
mov choice,eax

cmp choice , 1
je finish 


cmp choice , 2 
je clear 

cmp choice , 3
je edit 

cmp choice , 4 
je save 


finish:
call print_solved_board
jmp quit

clear:
; load file again and print board
mov fileHandle , 0
mov tmp , 0
mov ecx, BUFFER_SIZE
mov ebx , 0
L45:
mov buffer[ebx] , 0
inc bl 
loop L45 
call read_file
call print_board
call select_option 
jmp quit

edit:
call insert

call select_option
jmp quit

save:
; write in user file 
		call write
		call write_file_solved
		call report 
	
quit:

	RET 
select_option ENDP	

report PROC

call crlf

mov edx,offset str2
call writestring

mov al,count_correct 
call writedec

call crlf

mov edx,offset str3
call writestring

mov al,count_incorrect
call writedec
call crlf
mov edx,offset str4
call writestring

mov al,count_correct_completely
call writedec
call crlf

ret
report ENDP


END main