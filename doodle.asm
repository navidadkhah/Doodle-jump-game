DATA segment para 'DATA'
    
	Window_width DW 140h       ; the width of the window is 320 pixels
	Window_height DW 0c8h      ; the height of the window is 200 pixels
	Window_bound DW 6h          ; for checking the layer of the screen
	
	Points DB 0                 ; Player Points
	round DB 1                 ; Player Points
	show_points_in_menu DB 0    ; show points in game over page
	Hight_points DB 0           ; show the highest point in game over page 
	
	Text_potints DB '0','$'
	Text_game_over_title DB 'GAME OVER','$'
	Text_game_over_score DB 'your score is : 0', '$'
	Text_game_over_hight_score DB 'High score is : 0', '$'
	Text_restart DB 'Press R to play game', '$'
   
	time DB 0
	game_active DB 1            ; if the game is active, value is 1
   
    Ball_x DW 0A0h
    Ball_y DW 0Ah
    Ball_size DW 09h
	Ball_velocity_x DW 05h
	Ball_velocity_y DW 04h
	
	Paddle_x DW 0AFh
	Paddle_y DW 0AFh
	Paddle_width DW 1fh
	Paddle_Height DW 05h
	Paddle_velocity DW 0Ah
	
	broken_paddle_x DW 06Fh
	broken_paddle_y DW 06Fh
	
	insects_x DW 080h
	insects_y DW 080h
	insects_size DW 04h
	insects_show DB 3
	
	upside DB 0
	downside DB 1
	
	up_hight DW 30h

DATA ends

CODE segment para 'CODE'

    main proc far
    ASSUME CS:CODE,DS:DATA    ;assume as code,data and stack segments the respective registers
	PUSH DS                              ;push to the stack the DS segment
	SUB AX,AX                            ;clean the AX register
	PUSH AX                              ;push AX to the stack
	MOV AX,DATA                          ;save on the AX register the contents of the DATA segment
	MOV DS,AX                            ;save on the DS segment the contents of AX
	POP AX                               ;release the top item from the stack to the AX register
	POP AX         
        
       	call Clear_screen
      
        check_time:
		
		    cmp game_active, 00h
		    je  show_game_over	
			
            mov ah,2ch
            int 21h
            cmp dl, time
            je check_time
            mov time, dl
			
			call Clear_screen
			
			call Moving_ball
            call DRAW_BALL
			
			
			;call Moving_paddle
			;call Draw_paddle
			
			
			call Draw_paddle
			
			call Draw_broken_paddle
			  
	        call DRAW_UI      ; interface
			
			call Draw_Insects
			
			
			mov AL, insects_show
			cmp round, AL
			je update_insects
			jmp not_updating
			
			update_insects:
			  
			  add insects_show, 3
			  call updating_insects
			  
			not_updating:
			
			  
			  
            jmp check_time  

			show_game_over:
				call DRAW_GAME_OVER
				jmp check_time
    
    main endp 
	
	Moving_paddle proc NEAR
	
	
		MOV AH, 01h
		INT 16h
		jz here
	
		mov AH,00h
		int 16h
	
		cmp AL, 6Bh
		je paddle_right
	
		cmp AL, 6Ah
		je paddle_left
		
	paddle_right:
		mov AX, Paddle_velocity
		add Paddle_x, AX
		
		mov AX, Window_width
		sub AX, Window_bound
		SUB AX, Paddle_width
		cmp Paddle_x, AX
		JG fixi
		jmp here
		
		fixi:
			mov Paddle_x, AX
			jmp here
			
		
	
	paddle_left:
		mov AX, Paddle_velocity
		SUB Paddle_x, AX
		
		mov AX, Window_bound
		cmp Paddle_x, AX
		JL  fix
		jmp here
		
		fix:
			mov Paddle_x, AX
			jmp here
		
		
	here:
	
	RET
 	
	Moving_paddle ENDP
	
	Draw_paddle proc NEAR
	
			
		MOV CX,Paddle_x                  ;set the initial column (X)
		MOV DX,Paddle_y                  ;set the initial line (Y)
		
		DRAW_PADDLE_HORIZONTAL:
			MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,0Fh 					 ;choose white as color
			MOV BH,00h 					 ;set the page number 
			INT 10h    					 ;execute the configuration
			
			INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - Paddle_x > Paddle_width (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,Paddle_x
			CMP AX,Paddle_width
			JNG DRAW_PADDLE_HORIZONTAL
			
			MOV CX,Paddle_x 		     ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
			
			MOV AX,DX             		 ;DX - Paddle_y > Paddle_Height(Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,Paddle_y
			CMP AX,Paddle_Height
			JNG DRAW_PADDLE_HORIZONTAL
		
		RET
	
	Draw_paddle ENDP
	
	Draw_broken_paddle proc NEAR
	
			
		MOV CX,broken_paddle_x                  ;set the initial column (X)
		MOV DX,broken_paddle_y                  ;set the initial line (Y)
		
		DRAW_PADDLE_HORIZONTAL1:
			MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,03h 					 ;choose white as color
			MOV BH,00h 					 ;set the page number 
			INT 10h    					 ;execute the configuration
			
			INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - Paddle_x > Paddle_width (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,broken_paddle_x
			CMP AX,Paddle_width
			JNG DRAW_PADDLE_HORIZONTAL1
			
			MOV CX,broken_paddle_x 		     ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
			
			MOV AX,DX             		 ;DX - Paddle_y > Paddle_Height(Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,broken_paddle_y
			CMP AX,Paddle_Height
			JNG DRAW_PADDLE_HORIZONTAL1
			
		
		RET
	
	Draw_broken_paddle ENDP
	
	Draw_Insects proc NEAR
	
		MOV CX,insects_x                    ;set the initial column (X)
		MOV DX,insects_y                    ;set the initial line (Y)
		
		DRAW_insects_HORIZONTAL:
			MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,04h 					 ;choose red as color
			MOV BH,00h 					 ;set the page number 
			INT 10h    					 ;execute the configuration
			
			INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,insects_x
			CMP AX,insects_size
			JNG DRAW_insects_HORIZONTAL
			
			MOV CX,insects_x 				 ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
			
			MOV AX,DX             		 ;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,insects_y
			CMP AX,insects_size
			JNG DRAW_insects_HORIZONTAL
			
			
			;;;;;;;;;;;;;;;
			
			mov AX, Ball_x
			add AX, Ball_size
			cmp AX, insects_x
			JNG check_collision1              ; if there is no collision go to check_collision
			
			mov AX, insects_x
			add AX, insects_size
			cmp Ball_x, AX
			jnl check_collision1              ; if there is no collision go to check_collision
			
			mov AX, Ball_y
			add AX,Ball_size
			cmp AX, insects_y
			JNG check_collision1              ; if there is no collision go to check_collision
			
			mov AX, insects_y
			add AX, insects_size
			cmp Ball_y, AX
			jnl check_collision1               ; if there is no collision go to check_collision
			
			;dec points
			;dec show_points_in_menu
			;call Update_points
			
			;call updating_insects
			
			
			resetting_ball_insects:
				MOV Ball_y, 0Ah
				MOV Ball_x, 0A0h
				mov Points,00h
			    call Update_points
				MOV game_active, 00h
				RET
			
			
			check_collision1:
			
			
		
		RET
	
	Draw_Insects ENDP
	
	updating_insects proc NEAR
	
			mov ah,2ch
            int 21h      
			
			add insects_x, dx                ; add dl to Paddle_x for generate randome hex with 21h interrupt
			add insects_y, dx                ; add dl to Paddle_x for generate randome hex with 21h interrupt		
	
	        RET
	updating_insects ENDP
	
	Moving_ball proc NEAR 
	
	    MOV AH, 01h
		INT 16h                     ; check if user pressed any keys
		jz not_pressed
	
		mov AH,00h
		int 16h                     ; user pressed one of the keys
	
		cmp AL, 6Bh
		je ball_right               ; if the pressed key is 'k', go to right
		
		cmp AL, 4Bh
		je ball_right               ; if the pressed key is 'K', go to right
	
		cmp AL, 6Ah
		je ball_left                ; if the pressed key is 'j', go to left
		
		cmp AL, 4Ah
		je ball_left                ; if the pressed key is 'J', go to left
		
		jmp not_pressed             ; if none of keys pressed, go to label
		
	ball_right:
	
		mov AX, Ball_velocity_x
		add Ball_x, AX              ; add velocity to Ball_x
		
		mov AX, Window_width        ;
		sub AX, Window_bound        ; mov Window_width to AX and sub Window_bound and SUB BALL_SIZE
		SUB AX, Ball_size           ; from it and compare it to BALL_X and if its greater than right side goto label
		cmp Ball_x, AX
		JG fix_right_width
		jmp not_pressed
		
		fix_right_width:
			mov Ball_x, AX          ; MOV ax to BALL_X
			jmp not_pressed
			
	ball_left:
	
		mov AX, Ball_velocity_x
		SUB Ball_x, AX              ; SUB velocity to Ball_x
		
		mov AX, Window_bound        ;
		cmp Ball_x, AX              ; mov Window_width to AX 
		JL  fix_left_width          ; and compare it to BALL_X 
		jmp not_pressed             ; and if its less then left side goto label
		
		fix_left_width:
			mov Ball_x, AX          ; MOV ax to BALL_X
			jmp not_pressed
			
	not_pressed:
	
			
				cmp downside, 01h
				je go_to_down
				
				go_to_up:
				
				   mov AX, up_hight
				  
				   cmp Ball_y, AX
				   Jl neg_velocity_y1
				   jmp a
				 
				   neg_velocity_y1:
				    neg Ball_velocity_y
					MOV downside,01h
					MOV upside, 00h
					RET	
					
				   a:	
				     cmp Ball_y, 25h
					 Jl zero
					 
				     mov AX, Ball_velocity_y
			         add Ball_y, AX	
					 jmp b
					 
				     zero:
						mov AX, 02h
						add Ball_y, AX
					ret						
					b:
				 
				go_to_down:
						mov AX, Ball_velocity_y
			            add Ball_y, AX					 ; add velocity to vertical
			
						mov DX, Window_height
						SUB DX, Ball_size
						SUB DX, Window_bound             ; check if the ball is greater than 320px and its overflow from bottum of the screen
						CMP Ball_y, DX
						JG resetting_ball
				
					
				
	
		    
			;mov AX, Ball_velocity_y
			;add Ball_y, AX					 ; add velocity to vertical
			
			;CMP Ball_y, 00h
			;JL neg_velocity_y                ; check if the ball is less than 00h and its overflow from top of the screen
			
			;mov AX, Window_height
			;SUB AX, Ball_size
			;SUB AX, Window_bound             ; check if the ball is greater than 320px and its overflow from bottum of the screen
			;CMP Ball_y, AX
			;JG resetting_ball
			
			; check if the ball is colliding with the Paddle_Height
			; Ball_x + Ball_size > Paddle_x && BALL_X < Paddle_x + Paddle_width 
			; && Ball_y + Ball_size > Paddle_y && Ball_y < Paddle_y + Paddle_Height
 			
			mov AX, Ball_x
			add AX, Ball_size
			cmp AX, Paddle_x
			JNG check_collision              ; if there is no collision go to check_collision
			
			mov AX, Paddle_x
			add AX, Paddle_width
			cmp Ball_x, AX
			jnl check_collision              ; if there is no collision go to check_collision
			
			mov AX, Ball_y
			add AX,Ball_size
			cmp AX, Paddle_y
			JNG check_collision              ; if there is no collision go to check_collision
			
			mov AX, Paddle_y
			add AX, Paddle_Height
			cmp Ball_y, AX
			jnl check_collision              ; if there is no collision go to check_collision
			
			NEG Ball_velocity_y
			
		
			call randome
			
        	INC Points
			INC show_points_in_menu
			inc round
			MOV downside, 00h
			MOV upside, 01h
			
			
			MOV AL,Hight_points
			cmp Points, AL 
			JGE change_high_point
			jmp noting_changed
			
			change_high_point:
				
				MOV AL, Points
				MOV Hight_points,AL
			
			noting_changed:
			
			call Update_points
			
		    
			RET
			
			check_collision:
			   
			   RET
			
			neg_velocity_x:
				NEG Ball_velocity_x         ; this label for negativing Ball_velocity_x 
				RET
			neg_velocity_y:
				NEG Ball_velocity_y         ; this label for negativing Ball_velocity_y
				MOV downside, 01h
				MOV upside, 00h
				RET
				
			resetting_ball:
				MOV Ball_y, 0Ah
				MOV Ball_x, 0A0h
				mov Points,00h
			    call Update_points
				MOV game_active, 00h
				RET
				
			
	Moving_ball ENDP
	
	randome proc NEAR
	
			call delay
	
			mov ah,2ch
            int 21h      
			
			add Paddle_x, dl                ; add dl to Paddle_x for generate randome hex with 21h interrupt
			add Paddle_y,01h                ; add dl to Paddle_y for generate randome hex with 21h interrupt
			
			mov ah,2ch
            int 21h   
			
			add broken_paddle_x, dl                ; add dl to Paddle_x for generate randome hex with 21h interrupt
			add broken_paddle_y,dl                ; add dl to Paddle_y for generate randome hex with 21h interrupt
			
			
		call delay
		
						
		RET
		
	randome ENDP
	
	delay proc                          
		mov cx,1
		start_delay:
			cmp cx, 30000
			je end_delay
			inc cx                        ; this proc for delay to the game for using random
			jmp start_delay
		end_delay:
			RET
	delay endp
	
	DRAW_UI proc NEAR
			
			MOV AH, 02h				
			MOV BH, 00h				; set the position of the Text_potints
			MOV DH, 01h
			MOV DL, 9dh
			INT 10h
			
			MOV AH, 09h
			LEA DX, Text_potints
			INT 21h
	
	
			RET
	DRAW_UI ENDP
	
	Update_points proc NEAR
	
		xor AX, AX
		mov AL, Points
		
		add AL, 30h                      ; add 30h for convert to ascii
		mov [Text_potints], AL           ; updating the Text_potints variable 
		
	
		RET
	Update_points ENDP
	
	DRAW_GAME_OVER proc NEAR
	
		call Clear_screen
		
		MOV AH, 02h				
		MOV BH, 00h				; set the position of the Text_game_over_title
		MOV DH, 04h
		MOV DL, 04h
		INT 10h
		
		MOV AH, 09h
		LEA DX, Text_game_over_title
		INT 21h
		
		call show_points 
		
		MOV AH, 02h				
		MOV BH, 00h				; set the position of the Text_game_over_score
		MOV DH, 06h
		MOV DL, 04h
		INT 10h
		
		MOV AH, 09h
		LEA DX, Text_game_over_score
		INT 21h
		
		MOV AH, 02h				
		MOV BH, 00h				; set the position of the Text_game_over_hight_score
		MOV DH, 08h
		MOV DL, 04h
		INT 10h
		
		MOV AH, 09h
		LEA DX, Text_game_over_hight_score
		INT 21h
		
		
		MOV AH, 02h				
		MOV BH, 00h				; set the position of the Text_restart
		MOV DH, 10h
		MOV DL, 04h
		INT 10h
		
		MOV AH, 09h
		LEA DX, Text_restart
		INT 21h
	
	
		; wait until press any key
		MOV AH, 00h
		INT 16h
		
		cmp AL,'r'
		je Restart_game
		cmp AL, 'R'                ; if user press 'r' or 'R' then the game has been reset
		je Restart_game
		RET
		
		Restart_game:
			MOV show_points_in_menu, 00h
			MOV game_active, 01h                  ; activate this variable
			RET
	
	DRAW_GAME_OVER ENDP
	
	show_points proc NEAR
	
		mov AL, show_points_in_menu
		add AL,30h                                    ; updating the Text_game_over_score with show_points_in_menu
		MOV [Text_game_over_score+16], AL
		
		
		mov AL, Hight_points
		add AL,30h                                    ; updating the Text_game_over_hight_score with Hight_points
		MOV [Text_game_over_hight_score+16], AL
		
		RET
	show_points ENDP
	
	Clear_screen proc NEAR
			mov ah, 0	 ;
            mov al,13h   ; config the graphic mode
            int 10h      ;
			
			mov ah, 0bh   ;
            mov bh, 00h   ;  
			mov bl, 00h   ;    clear the screen 
			int 10h       ;
			
			RET
	Clear_screen ENDP
    
    DRAW_BALL PROC NEAR                  
		
		MOV CX,BALL_X                    ;set the initial column (X)
		MOV DX,BALL_Y                    ;set the initial line (Y)
		
		DRAW_BALL_HORIZONTAL:
			MOV AH,0Ch                   ;set the configuration to writing a pixel
			MOV AL,0Fh 					 ;choose white as color
			MOV BH,00h 					 ;set the page number 
			INT 10h    					 ;execute the configuration
			
			INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,BALL_X
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
			
			MOV CX,BALL_X 				 ;the CX register goes back to the initial column
			INC DX       				 ;we advance one line
			
			MOV AX,DX             		 ;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
			SUB AX,BALL_Y
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
			
			call FIX_BALL
		
		RET
	DRAW_BALL ENDP
	
	FIX_BALL    PROC    
   	
		MOV CX,BALL_X                
		MOV DX,BALL_Y               
		MOV AH,0CH                   
		MOV AL,0 					
		MOV BH,00H 					
		INT 10H 
	
		MOV CX,BALL_X      
		INC CX
		MOV DX,BALL_Y               
		MOV AH,0CH                   
		MOV AL,0 					
		MOV BH,00H 					
		INT 10H  
	
		MOV CX,BALL_X      	
		MOV DX,BALL_Y
		INC DX	
		MOV AH,0CH                   
		MOV AL,0 					
		MOV BH,00H 					
		INT 10H  
	
		MOV CX,BALL_X                
		MOV DX,BALL_Y                    	
		ADD DX,BALL_SIZE
		MOV AH,0CH                   
		MOV AL,0 					
		MOV BH,00H 					 
		INT 10H
	
		MOV CX,BALL_X    
		INC CX
		MOV DX,BALL_Y                    	
		ADD DX,BALL_SIZE
		MOV AH,0CH                   
		MOV AL,0 					
		MOV BH,00H 					 
		INT 10H
	
		MOV CX,BALL_X    
		MOV DX,BALL_Y                    	
		ADD DX,BALL_SIZE
		DEC DX
		MOV AH,0CH                   
		MOV AL,0 					
		MOV BH,00H 					 
		INT 10H
	
		MOV CX,BALL_X                 
		ADD CX,BALL_SIZE
		MOV DX,BALL_Y                  
		MOV AH,0CH                  
		MOV AL,0 					
		MOV BH,00H 					
		INT 10H  

		MOV CX,BALL_X                 
		ADD CX,BALL_SIZE
		DEC CX
		MOV DX,BALL_Y                  
		MOV AH,0CH                  
		MOV AL,0 					
		MOV BH,00H 					
		INT 10H   	
	
		MOV CX,BALL_X                 
		ADD CX,BALL_SIZE
		MOV DX,BALL_Y 
		INC DX
		MOV AH,0CH                  
		MOV AL,0 					
		MOV BH,00H 					
		INT 10H   	
	
		MOV CX,BALL_X                    
		MOV DX,BALL_Y                    
		ADD CX,BALL_SIZE
		ADD DX,BALL_SIZE	
		MOV AH,0CH                   
		MOV AL,0				 
		MOV BH,00H 					
		INT 10H  
	
		MOV CX,BALL_X                    
		MOV DX,BALL_Y                    
		ADD CX,BALL_SIZE
		ADD DX,BALL_SIZE	
		DEC CX
		MOV AH,0CH                   
		MOV AL,0				 
		MOV BH,00H 					
		INT 10H  

		MOV CX,BALL_X                    
		MOV DX,BALL_Y                    
		ADD CX,BALL_SIZE
		ADD DX,BALL_SIZE	
		DEC DX
		MOV AH,0CH                   
		MOV AL,0				 
		MOV BH,00H 					
		INT 10H 
      
		RET    
	FIX_BALL    ENDP
    
CODE ends
end main