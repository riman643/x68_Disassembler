    ORG    $1000
START:                  ; first instruction of program
        * Test commands starting at address $00009000
        CMP.W       D0, D1
        MOVE.W      D0, D1
        MOVEM.W     D0, -(SP)

* Put program code here
*Starting/Ending Address stored in A6 and A7

        LEA         Welcome, A1         *Outputs the Welcome
        MOVE.B      #14, D0
        TRAP        #15





************ASK FOR STARTING AND ENDING ADDRESS****************
StartAddress
        LEA         StartM, A1          *Outputs the StartM
        MOVE.B      #14, D0
        TRAP        #15

        MOVEA.L     #$00000000, A1
        MOVE.B      #2, D0              *Takes in input
        TRAP        #15
        MOVE.L      #$00000000, D2
        JSR         Table               *Goes to table where each character from input will be moved to D2
        
        CMP.B       #$0, D4             *See if there is an error input
        BNE         Error               *Go here if there is an error input
        
        MOVE.L      D2, A6              *Puts the results of input into address register A6

EndAddress
        MOVE.L      #$00000000, D5
        MOVE.L      #$00000001, D3      *Notes that starting address computed successfully
        LEA         EndM, A1            *Outputs the EndM
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVEA.L     #$00000000, A1
        MOVE.B      #2, D0              *Takes in output
        TRAP        #15
        MOVE.L      #$00000000, D2
        JSR         Table               *Goes to table where each character from input will be moved to D2
        
        CMP.B       #$0, D4             *See if there is an error input
        BNE         Error               *Go here if there is an error input
        
        MOVE.L      D2, A7              *Puts the results of input into address register A7
        
CompareAddresses
        CMP.L       A6, A7              *A7 must be greater than A6
        BLT         OrderError          *If A6 is greater than or equal to A7, then error
        BRA         ComputeOpcode       *Go to ComputeOpcode step
        
OrderError
        MOVE.L      #$00000000, D2      *Clears data
        MOVEA.L     #$00000000, A6
        MOVEA.L     #$00000000, A7
        MOVE.L      #$00000000, D3
        
        LEA         OrderEr, A1         *Outputs the OrderEr message
        MOVE.B      #14, D0
        TRAP        #15
        BRA         Error               *Go to Error to restart and reask the input and output





********COMPUTING OPCODE**********
ComputeOpcode
        CMPA.L      A7,A6               *Compares Starting Address to Ending Address
        BGT         Fin                 *If greater than then branch to Fin subroutine
        
        MOVE.L      #$00000000,D7       *Reset Register 7
        MOVE.L      #$00000000,D6       *Reset Register 6
        MOVE.W      (A6),D7             *Move Word data from starting address to register 7
        DIVU        #4096,D7            *Isolates Most Significant Nibble
        MOVE.B      D7,D6               *Move Most significant Nibble to D6
        
        CMP.B       #$00,D6             *Compares Zero to Most Significant Nibble
        BEQ         BchgVal             *If equal send to BchgVal Subroutine
        
        
        CMP.B       #$01,D6             *Compares One to Most Significant Nibble
        BEQ         MoveVal             *If equal send to MoveVal Subroutine
        CMP.B       #$02,D6             *Compares Two to Most Significant Nibble
        BEQ         MoveVal             *If equal send to MoveVal Subroutine
        CMP.B       #$03,D6             *Compares Three to Most Significant Nibble
        BEQ         MoveVal             *If equal send to MoveVal Subroutine
        
        CMP.B       #$06,D6             *Compares Six to Most Significant Nibble
        BEQ         BcsVal              *If equal send to BcsVal Subroutine
        
        CMP.B       #$0B,D6             *Compares B to Most Signficant Nibble
        BEQ         CmpVal              *If equal send to CmpVal Subroutine
        
        CMP.B       #$0C,D6             *Compares C to Most Significant Nibble
        BEQ         AndVal              *If equal send to AndVal Subroutine
        
        CMP.B       #$0D,D6             *Compares D to Most Significant Nibble
        BEQ         AddVal              *If equal send to AddVal Subroutine
        
        CMP.B       #$04,D6             *Compares Four to Most significant Nibble
        BEQ         FourCheck           *If equal send to FourCheck    
        
        BRA         ErrorM               *Branch back to ComputeOpcode
        
BchgVal
        LEA         BchgMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
MoveVal
        LEA         MoveMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
BcsVal
        LEA         BcsMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
CmpVal
        LEA         CmpMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        JSR         ComputeEA           *Go to compute EA (for other op-code, may need to compute size first)
        JSR         ComputeSize
        *JSR         PrintSizeEA         *May need to print everything all at once, after done processing? Don't know yet
        BRA         ComputeOpcode
        
        
AndVal
        LEA         AndMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
AddVal
        LEA         AddMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode

NotVal
        LEA         NotMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
MovemVal
        LEA         MovemMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
RtsVal
        LEA         RtsMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
JsrVal
        LEA         JsrMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode
        
FourCheck
        MOVE.L      #$00000000,D7       *Reset D7
        MOVE.L      #$00000000,D6       *Reset D6
        MOVE.W      (A6),D7             *Move Word data from starting address to register 7
        DIVU        #256,D7             *Isolates Most Significant Nibble
        MOVE.B      D7,D6               *Move Second significant Nibble to D6
        
        CMP.B       #$46,D6             *Compares Six to Second Significant Nibble
        BEQ         NotVal              *If equal send to NotVal Subroutine
        
        CMP.B       #$4E,D6             *Compares E to to Second Significant Nibble
        BEQ         ECheck              *If equal send to ECheck Subroutine

        BRA         MovemVal            *If not 6 or E send to MovemVal
        
ECheck
        MOVE.L      #$00000000,D7       *Reset D7
        MOVE.L      #$00000000,D6       *Reset D6
        MOVE.W      (A6),D7             *Move Word data from starting address to register 7
        DIVU        #16,D7              *Isolates Most Third Significant Nibble
        MOVE.W      D7,D6               *Move Third significant Nibble to D6
        
        CMP.W       #$04E7,D6           *Compares 7 to Second Significant Nibble
        BEQ         RtsVal              *If equal send to RtsVal Subroutine
        
        CMP.W       #$04E7,D6
        BGT         JsrVal              *If greater than send to JsrVal Subroutine
        
        CMP.W       #$04E4,D6           *Compares 4 to Second Significant Nibble
        BLT         MovemVal            *If less than send to MovemVal Subroutine
        
        BRA         ErrorM              *Branch to error if it does not fit any
        
ErrorM
        LEA         ErrMess,A1          *Displapy Error Message
        MOVE.B      #14,D0              
        Trap        #15
        ADDA.W      #$02,A6             *Increase Address by 2 bytes
        BRA         ComputeOpcode       *Branch back to ComputeOpcode

Fin
        BRA         RestartAgain        *Branch to RestartAgain

Match
        ADD.B       #$1, D5             *Count number of characters in input
        CMP.B       #$1, (A1)+          *Increases A1 to compare the next character taken from input






***********PROCESSING USER INPUT WITH STARTING/END ADDRESS*************
*Testing for characters 0-9 and A-F
Table
Zero    CMP.B       #$30, (A1)
        BNE         One
        ASL.L       #4, D2              *Shifts bits so if D2 contains $12345678 now contains $23456780
        ADD.B       #$0, D2             *Adds the appropriate number to D2
        BRA         Match

One     CMP.B       #$31, (A1)
        BNE         Two
        ASL.L       #4, D2
        ADD.B       #$1, D2
        BRA         Match

Two     CMP.B       #$32, (A1)
        BNE         Three
        ASL.L       #4, D2
        ADD.B       #$2, D2
        BRA         Match


Three   CMP.B       #$33, (A1)
        BNE         Four
        ASL.L       #4, D2
        ADD.B       #$3, D2
        BRA         Match

Four    CMP.B       #$34, (A1)
        BNE         Five
        ASL.L       #4, D2
        ADD.B       #$4, D2
        BRA         Match

Five    CMP.B       #$35, (A1)
        BNE         Six
        ASL.L       #4, D2
        ADD.B       #$5, D2
        BRA         Match

Six     CMP.B       #$36, (A1)
        BNE         Seven
        ASL.L       #4, D2
        ADD.B       #$6, D2
        BRA         Match

Seven   CMP.B       #$37, (A1)
        BNE         Eight
        ASL.L       #4, D2
        ADD.B       #$7, D2
        BRA         Match

Eight   CMP.B       #$38, (A1)
        BNE         Nine
        ASL.L       #4, D2
        ADD.B       #$8, D2
        BRA         Match

Nine    CMP.B       #$39, (A1)
        BNE         KeyA
        ASL.L       #4, D2
        ADD.B       #$9, D2
        BRA         Match

KeyA    CMP.B       #$41, (A1)
        BNE         KeyB
        ASL.L       #4, D2
        ADD.B       #$A, D2
        BRA         Match

KeyB    CMP.B       #$42, (A1)
        BNE         KeyC
        ASL.L       #4, D2
        ADD.B       #$B, D2
        BRA         Match

KeyC    CMP.B       #$43, (A1)
        BNE         KeyD
        ASL.L       #4, D2
        ADD.B       #$C, D2
        BRA         Match

KeyD    CMP.B       #$44, (A1)
        BNE         KeyE
        ASL.L       #4, D2
        ADD.B       #$D, D2
        BRA         Match
        
KeyE    CMP.B       #$45, (A1)
        BNE         KeyF
        ASL.L       #4, D2
        ADD.B       #$E, D2
        BRA         Match

KeyF    CMP.B       #$46, (A1)
        BNE         Key00
        ASL.L       #4, D2
        ADD.B       #$F, D2
        BRA         Match

Key00   CMP.B       #$9, D5             *Compare counter, make sure input is 8 characters or less
        BGE         TableErr            *If counter is greater than or equal to 9, go to TableErr
        CMP.B       #$0, D5             *Compare counter, make sure input is 1 character or more
        BEQ         TableErr            *If counter is equal to 0, go to TableErr
        CMP.B       #$0, (A1)           *00 means enter, so stop and return when program sees this
        BNE         TableErr
        RTS
        
TableErr
        MOVE.L      #$00000001, D4      *Mark that input error
        RTS        

*Invalid character, restart and reask for new address
Error
        MOVE.L      #$00000000, D2      *Clear temp place to put characters when going through input
        MOVEA.L     #$00000000, A1      *Clear input
        MOVE.L      #$00000000, D4      *Mark as input error
        MOVE.L      #$00000000, D5      *Count number of input characters
        
        LEA         Invalid, A1         *Outputs the Invalid
        MOVE.B      #14, D0
        TRAP        #15
        
        CMP.B       #$00000001, D3      *If starting address is already good, repeat asking new end address
        BNE         RestartForStart
        BRA         EndAddress

RestartForStart
        BRA         StartAddress
        




********COMPUTE Size*********        
ComputeSize
        *Add stuff here for processing
        *Add stuff here to repeat again
        *Add stuff here when done processing
        RTS




        
********COMPUTE EA*********        
ComputeEA
        *Add stuff here for processing
        *Add stuff here to repeat again
        *Add stuff here when done processing
        RTS
       


       
       
       
********ASK FOR RESTARTING*********
RestartAgain
        LEA         Done, A1            *Outputs the Done message
        MOVE.B      #14, D0
        TRAP        #15

DoAgain
        LEA         AgainM, A1         *Outputs the AgainM message
        MOVE.B      #14, D0
        TRAP        #15

        MOVEA.L     #$00000000, A1
        MOVE.B      #2, D0              *Takes in input (Y/N)
        TRAP        #15
        
Yes     CMP.W       #$5900, (A1)          *If equal Y, then reset everything and start at begining
        BNE         No
        MOVEA.L     #$00000000, A1      *Clear input
        MOVEA.L     #$00000000, A6      *Clear starting address
        MOVEA.L     #$00000000, A7      *Clear ending address
        MOVE.L      #$00000000, D2      *Clear
        MOVE.L      #$00000000, D3      *Clear note saying input finished properly
        MOVE.L      #$00000000, D4      *Clear
        MOVE.L      #$00000000, D5      *Clear
        BRA         StartAddress
        
No      CMP.W       #$4E00, (A1)          *If equal N, then end
        BNE         AgainEr
        BRA         End
        
AgainEr MOVEA.L     #$00000000, A1      *If invalid, then clear input and ask again
        LEA         Invalid, A1         *Outputs the Invalid
        MOVE.B      #14, D0
        TRAP        #15
        BRA         DoAgain             *Asks again
    
    
    
    
    
End    SIMHALT             ; halt simulator


* Put variables and constants here
CR      EQU     $0D
LF      EQU     $0A
Welcome DC.B    'Welcome to 68k Disassembler',CR,LF,0
StartM  DC.B    CR,LF,'Enter a STARTING address: ',0
EndM    DC.B    CR,LF,'Enter an ENDING address: ',0
Invalid DC.B    'Invalid Input',CR,LF,0
OrderEr DC.B    'STARTING Address must be less than ENDING Address',CR,LF,0
Done    DC.B    CR,LF,CR,LF,'Processing Completed',CR,LF,0
AgainM  DC.B    'Do you want to disassemble again? (Y/N): ',0

FourCheckMess DC.B 'This Command starts with a four',CR,LF,0
BchgMess DC.B   'BCHG Validate Subroutine.',CR,LF,0
MoveMess DC.B   'MOVE Validate Subroutine.',CR,LF,0
BcsMess DC.B    'BCS Validate Subroutine.',CR,LF,0
CmpMess DC.B    'CMP',0
AndMess DC.B    'AND Validate Subroutine.',CR,LF,0
AddMess DC.B    'ADD Validate Subroutine.',CR,LF,0
NotMess DC.B    'NOT Validate Subroutine.',CR,LF,0
MovemMess DC.B  'MOVEM Validate Subroutine.',CR,LF,0
JsrMess DC.B    'JSR Validate Subroutine.',CR,LF,0
RtsMess DC.B    'RTS Validate Subroutine.',CR,LF,0
ErrMess DC.B    'Not a valid Command',CR,LF,0
EndMess DC.B    'End of Script',CR,LF,0

BSize   DC.B    '.B    ',0
WSize   DC.B    '.W    ',0
LSize   DC.B    '.L    ',0
SpaceM   DC.B   ', ',0

MessDn  DC.B    'D',0
MessAn  DC.B    'A',0
MessBracAn DC.B    '(A',0
MessBracClose DC.B    ')',0
MessBracCloseAdd DC.B    ')+',0
MessBracOpenSub DC.B    '-(A',0
MessDollar  DC.B    '$',0
MessImmediate  DC.B    '#$',0

        
    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~
