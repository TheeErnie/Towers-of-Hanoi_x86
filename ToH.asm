;////////////////////////////////////////;
;//   CSC 314 - ASSEMBLY LANGUAGE      //;
;//   FINAL PROJECT: TOWERS OF HANOI   //;
;//   AUTHOR: THEE_ERNIE               //;
;////////////////////////////////////////;

%include "/usr/local/share/csc314/asm_io.inc"
segment .string

segment .data

   hide_c db "tput civis", 0
   show_c db "tput cnorm", 0

   toh00 db 27, "[1;38;5;123m   _____________ ", 10, 0
   toh01 db 27, "[1;38;5;117m  |_____   _____|                                  ___", 10, 0
   toh02 db 27, "[1;38;5;111m        | |                                       /   |", 10, 0
   toh03 db 27, "[1;38;5;105m        | | ___ _        __ ___ _ __  ___     ___ | |_", 10, 0
   toh04 db 27, "[1;38;5;99m        | |/ _ \ \  __  / // _ \ `_ \/ __|   / _ \|  _|", 10, 0
   toh05 db 27, "[1;38;5;93m        | | ( ) | \/  \/ /|  __/ | \/\__ \  | (_) | |", 10, 0
   toh06 db 27, "[1;38;5;93m  _     |_|\___/ \__/\__/  \___|_|   |___/   \___/|_|", 10, 0
   toh07 db 27, "[1;38;5;93m | |    | |                    _", 10, 0
   toh08 db 27, "[1;38;5;92m | |    | |                   (_)", 10, 0
   toh09 db 27, "[1;38;5;92m | |____| | ____   _ __   ___  _", 10, 0
   toh10 db 27, "[1;38;5;98m |  ____  |/ _  | | `_ \ / _ \| |", 10, 0
   toh11 db 27, "[1;38;5;104m | |    | | (_| | | | | | (_) | |", 10, 0
   toh12 db 27, "[1;38;5;110m |_|    |_|\___,_\|_| |_|\___/|_|", 10, 0

   rules db 10, "   The object of this game is to move all the rings from the first", 10, "   peg to the third. Seems easy right? Here's the catch, bigger", 10, "   rings can't be placed on smaller ones, and you can only move", 10, "   one ring at a time. You will be prompted which peg to grab the", 10, "   top ring from, then which peg you want to place it on.", 10, "   Good luck!", 10, 10, " Enter 0 to start: ", 27, "[0m", 0
   proceed db " Enter 0 to continue: ", 0

   ;//strings for rings/board spaces
   r0 db 27, "[1;90m          ||          ", 27, "[0m", 0
   r1 db "         ", 27, "[1;44;34m====", 27, "[0m         ", 0
   r2 db "       ", 27, "[1;42;32m========", 27, "[0m       ", 0
   r3 db "     ", 27, "[1;43;33m============", 27, "[0m     ", 0
   r4 db "   ", 27, "[1;41;31m================", 27, "[0m   ", 0
   r5 db " ", 27, "[1;45;35m====================", 27, "[0m ", 0



   tbborder db " +------------------------------------------------------------------+", 10, 0
   sborder db " |", 0


   ;//set of arrays for board
   arr0 dd 1, 9, 9
   arr1 dd 2, 9, 9
   arr2 dd 3, 9, 9
   arr3 dd 4, 9, 9
   arr4 dd 5, 9, 9

   ;//number of moves used
   moves dd 0;


   ;//strings for winner message
   sleeper db "sleep 0.5", 0
   winner0 db "                                           _", 10, 0
   winner1 db "__            __ _                        | |", 10, 0
   winner2 db "\ \    __    / /(_)_ __  _ __   ___ _ __  | |",10, 0
   winner3 db " \ \  /  \  / /  _| `_ \| `_ \ / _ \ `_ \ |_|", 10, 0
   winner4 db "  \ \/ /\ \/ /  | | | | | | | |  __/ | \/  _ ", 10, 0
   winner5 db "   \__/  \__/   |_|_| |_|_| |_|\___|_|    (_)", 27, "[0m", 10, 0
   winner10 db 27, "[38;5;9m", 0
   winner20 db 27, "[38;5;220m", 0
   winner30 db 27, "[38;5;56m", 0
   winner40 db 27, "[38;5;21m", 0
   winner50 db 27, "[38;5;126m", 0


   from_prompt db " Rung to move from (1-3): ", 0
   to_prompt db " Rung to move to (1-3): ", 0
   user_quit db " User has ended game...", 10, 0
   bad_input db " User input invalid. Please try again", 10, 0
   usermoves0 db "  Moves: ", 0
   usermoves1 db " ", 0
   usermoves2 db "                            Fewest Possible Moves: 31  ", 0
   red_string db 27, "[1;38;5;124m", 0
   green_string db 27, "[1;38;5;46m", 0
   clear_formatting db 27, "[0m", 0

   clear db "clear", 0

segment .bss
segment .text
   global asm_main
   extern system
asm_main:
   push ebp
   mov ebp, esp
   ;======  ASM MAIN CODE STARTS HERE  =======

   push clear
   call system
   add esp, 4
   push hide_c
   call system
   add esp, 4

   mov eax, toh00
   call print_string
   mov eax, toh01
   call print_string
   mov eax, toh02
   call print_string
   mov eax, toh03
   call print_string
   mov eax, toh04
   call print_string
   mov eax, toh05
   call print_string
   mov eax, toh06
   call print_string
   mov eax, toh07
   call print_string
   mov eax, toh08
   call print_string
   mov eax, toh09
   call print_string
   mov eax, toh10
   call print_string
   mov eax, toh11
   call print_string
   mov eax, toh12
   call print_string
   call print_nl
   call print_nl
   call print_nl
   mov eax, proceed
   call print_string
   call read_int
   push clear
   call system

   mov eax, rules
   call print_string
   call read_int
   push clear
   call system
   call print_board

   ;//===============================================//;
   ;//================   GAME LOOP   ================//;
   ;//===============================================//;

   top_game_loop:
      ;//user prompt, input, & checking
      mov eax, from_prompt   ;//prompt for & get ui
      call print_string
      call read_int
      cmp eax, 0
      je ugameend            ;//user ended game
      jl bad_user_input      ;//ui out of range
      cmp eax, 3
      jg bad_user_input      ;//ui out of range
      mov ebx, eax           ;//store ui
      dec ebx                ;//edit ui for program use (its a feature not a bug)
      mov eax, to_prompt     ;//prompt for & get 2nd ui
      call print_string
      call read_int
      cmp eax, 0
      je ugameend            ;//user ended game
      jl bad_user_input      ;//ui out of range
      cmp eax, 3
      jg bad_user_input      ;//ui out or range
      mov ecx, eax           ;//store ui
      dec ecx                ;//edit ui for program use (its a feature not a bug)
      cmp ebx, ecx
      je bad_user_input      ;//moving to self
      ;//user input finished
      ;//call for move
      push ecx
      push ebx
      call move
      add esp, 8

      push clear
      call system
      ;//print board
      call print_board

      ;//check if player has won
      call win
      cmp eax, 1
      jne top_game_loop
      call win_screen
      jmp gameend

      bad_user_input:
      mov eax, bad_input
      call print_string
   jmp top_game_loop
   ugameend:
      mov eax, user_quit
      call print_string
   gameend:

   push show_c
   call system
   add esp, 4

   ;======   ASM MAIN CODE ENDS HERE   =======
   mov eax, 0
   mov esp, ebp
   pop ebp
   ret

;//==================================================================//;
;//==================================================================//;
;//==========================   FUNCTIONS   =========================//;
;//==================================================================//;
;//==================================================================//;


move: ;//takes in "to" and "from" coloumns and moves if appropriate
   push ebp
   mov ebp, esp

   ;//from ebp+8
   ;//to ebp+12
   mov ebx, DWORD[ebp + 8]   ;//from column (l-r)
   mov ecx, DWORD[ebp + 12]  ;//to   column (l-r)

   ;//checking if moving to self
      cmp ebx, ecx
      je endmove

   ;//find rows for move
   push ebx
   call find_top_filled
   add esp, 4
   cmp eax, 111
   je endmove
   mov edi, eax              ;//from row (t-b)

   push ecx
   call find_top_open
   add esp, 4
   cmp eax, 111
   je endmove
   mov esi, eax              ;//to row (t-b)

   ;//summary:
   ;////ebx - column number of from ring
   ;////edi - row (array) of from   ring
   ;////***from c++ version: from ring = board[edi][ebx]
   ;////ecx - column number of to ring
   ;////esi - row (array) of empty space for to ring
   ;////***from c++ version: to ring = board[esi][ecx]
   ;////
   ;////board[edi][ebx] -> board[esi][ecx]

   ;//checking for bad move
      push ecx
      call find_top_filled
      add esp, 4
      cmp eax, 111
      je empty
      push DWORD[eax + ecx * 4]
      jmp notempty
      empty:
      push r0
      notempty:
      push DWORD[edi + ebx * 4]
      call check_move
      add esp, 8
      cmp eax, 2
      je endmove
   ;//mov is now sure to be good
   ;//carry out move

      mov edx, DWORD[edi + ebx * 4]
      mov DWORD[edi + ebx * 4], 9
      mov DWORD[esi + ecx * 4], edx
      inc DWORD[moves]
   endmove:

   mov esp, ebp
   pop ebp
   ret

check_move: ;//checks if move is legal (if not putting big ring on little ring)
            ;//use numbers to check this time
            ;//returns 0 in eax if bad
            ;//returns 1 in eax if good
   push ebp
   mov ebp, esp

   ;//from # - ebp+8
   ;//to # - ebp_12

   mov edx, DWORD[ebp + 8]
   cmp edx, DWORD[ebp + 12]
   jge bad
   mov eax, 1
   jmp notbad
   bad:
   mov eax, 2
   notbad:

   mov esp, ebp
   pop ebp
   ret

win: ;//returns 1 if winning condition is met
   push ebp
   mov ebp, esp

   cmp DWORD[arr0 + 8], 1
   jne no
   cmp DWORD[arr1 + 8], 2
   jne no
   cmp DWORD[arr2 + 8], 3
   jne no
   cmp DWORD[arr3 + 8], 4
   jne no
   cmp DWORD[arr4 + 8], 5
   jne no
   mov eax, 1
   jmp endwin
   no:
   mov eax, 2
   endwin:

   mov esp, ebp
   pop ebp
   ret

find_top_open: ;//returns number of lowest list w/ space open at input column
   push ebp
   mov ebp, esp

   ;//ebp+8 = column that is being searched
   mov esi, DWORD[ebp + 8]

   cmp DWORD[arr0 + esi * 4], 9
   jne badbad
   lea eax, arr0
   cmp DWORD[arr1 + esi * 4], 9
   jne end_fto
   lea eax, arr1
   cmp DWORD[arr2 + esi * 4], 9
   jne end_fto
   lea eax, arr2
   cmp DWORD[arr3 + esi * 4], 9
   jne end_fto
   lea eax, arr3
   cmp DWORD[arr4 + esi * 4], 9
   jne end_fto
   lea eax, arr4
   jmp end_fto

   badbad:
   mov eax, 111
   end_fto:

   mov esp, ebp
   pop ebp
   ret

find_top_filled:   ;//returns highest list w/ spot taken at input column
                   ;//if no ring in rung, return 111
   push ebp
   mov ebp, esp

   mov edx, DWORD[ebp + 8]

   cmp DWORD[arr0 + edx * 4], 9
   je nxtcmp4
   lea eax, arr0
   jmp end_ftf
   nxtcmp4:
   cmp DWORD[arr1 + edx * 4], 9
   je nxtcmp5
   lea eax, arr1
   jmp end_ftf
   nxtcmp5:
   cmp DWORD[arr2 + edx * 4], 9
   je nxtcmp6
   lea eax, arr2
   jmp end_ftf
   nxtcmp6:
   cmp DWORD[arr3 + edx * 4], 9
   je nxtcmp7
   lea eax, arr3
   jmp end_ftf
   nxtcmp7:
   cmp DWORD[arr4 + edx * 4], 9
   je nxtcmp8
   lea eax, arr4
   jmp end_ftf
   nxtcmp8:
   mov eax, 111

   end_ftf:

   mov esp, ebp
   pop ebp
   ret

print_space: ;//prints space based on number input
   push ebp
   mov ebp, esp

   cmp DWORD[ebp + 8], 9
   jne nextif0
   mov eax, r0
   call print_string
   jmp eif0
   nextif0:
   cmp DWORD[ebp + 8], 1
   jne nextif1
   mov eax, r1
   call print_string
   jmp eif0
   nextif1:
   cmp DWORD[ebp + 8], 2
   jne nextif2
   mov eax, r2
   call print_string
   jmp eif0
   nextif2:
   cmp DWORD[ebp + 8], 3
   jne nextif3
   mov eax, r3
   call print_string
   jmp eif0
   nextif3:
   cmp DWORD[ebp + 8], 4
   jne nextif4
   mov eax, r4
   call print_string
   jmp eif0
   nextif4:
   cmp DWORD[ebp + 8], 5
   jne eif0
   mov eax, r5
   call print_string
   eif0:

   mov esp, ebp
   pop ebp
   ret

print_board: ;//print out the game board (rings on rungs)
             ;//it's kind of long and would be better optimized
             ;//if I used a better structure for by board but
             ;//this is just v1.0 so it'll have to suffice for now
   push ebp
   mov ebp, esp
   ;//print top border
   mov eax, tbborder
   call print_string
   ;//first row
   mov eax, sborder
   call print_string
   push DWORD[arr0]
   call print_space
   add esp, 4
   push DWORD[arr0 + 4]
   call print_space
   add esp, 4
   push DWORD[arr0 + 8]
   call print_space
   add esp, 4
   mov eax, sborder
   call print_string
   call print_nl
   ;//second row
   mov eax, sborder
   call print_string
   push DWORD[arr1]
   call print_space
   add esp, 4
   push DWORD[arr1 + 4]
   call print_space
   add esp, 4
   push DWORD[arr1 + 8]
   call print_space
   add esp, 4
   mov eax, sborder
   call print_string
   call print_nl
   ;//third row
   mov eax, sborder
   call print_string
   push DWORD[arr2]
   call print_space
   add esp, 4
   push DWORD[arr2 + 4]
   call print_space
   add esp, 4
   push DWORD[arr2 + 8]
   call print_space
   add esp, 4
   mov eax, sborder
   call print_string
   call print_nl
   ;//fourth row
   mov eax, sborder
   call print_string
   push DWORD[arr3]
   call print_space
   add esp, 4
   push DWORD[arr3 + 4]
   call print_space
   add esp, 4
   push DWORD[arr3 + 8]
   call print_space
   add esp, 4
   mov eax, sborder
   call print_string
   call print_nl
   ;//fifth row
   mov eax, sborder
   call print_string
   push DWORD[arr4]
   call print_space
   add esp, 4
   push DWORD[arr4 + 4]
   call print_space
   add esp, 4
   push DWORD[arr4 + 8]
   call print_space
   add esp, 4
   mov eax, sborder
   call print_string
   call print_nl
   ;//bottom sub-border
   mov eax, tbborder
   call print_string
   ;//bottom info pane
   mov eax, sborder
   call print_string
   mov eax, usermoves0
   call print_string
   ;//checking if lots of moves to print out red or green num
   cmp DWORD[moves], 31
   jg red
   mov eax, green_string
   call print_string
   jmp notred
   red:
   mov eax, red_string
   call print_string
   notred:
   mov eax, DWORD[moves]
   call print_int
   mov eax, clear_formatting
   call print_string
   ;//checking if need buffer space to keep even borders
   cmp DWORD[moves], 9
   jg skip
   mov eax, usermoves1
   call print_string
   skip:
   mov eax, usermoves2
   call print_string
   mov eax, sborder
   call print_string
   call print_nl
   mov eax, tbborder
   call print_string

   mov esp, ebp
   pop ebp
   ret

win_screen: ;//displays win screen that flashes "winner!" in different colors
   push sleeper
   call system
   call system
   add esp, 4
   push clear
   call system
   add esp, 4

   mov esi, 0
   mov edi, 0
   twin:
      cmp esi, 0
      je c0
      cmp esi, 1
      je c1
      cmp esi, 2
      je c2
      cmp esi, 3
      je c3
      cmp esi, 4
      je c4
      c0:
      mov eax, winner10
      jmp cend
      c1:
      mov eax, winner20
      jmp cend
      c2:
      mov eax, winner30
      jmp cend
      c3:
      mov eax, winner40
      jmp cend
      c4:
      mov eax, winner50
      jmp cend
      cend:
      call print_string
      mov eax, winner0
      call print_string
      mov eax, winner1
      call print_string
      mov eax, winner2
      call print_string
      mov eax, winner3
      call print_string
      mov eax, winner4
      call print_string
      mov eax, winner5
      call print_string
      push sleeper
      call system
      add esp, 4
      push clear
      call system
      add esp, 4

   inc esi
   cmp esi, 4
   jle twin
   inc edi
   mov esi, 0
   cmp edi, 2
   jle twin

   ret

;//hey! its the end of my code! did you like looking at it? I hope it wasn't too messy, I know it's not all that pretty
