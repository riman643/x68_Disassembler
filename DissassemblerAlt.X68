    ORG    $1000
START:                  ; first instruction of program
**************************************************
*                Test Commands                   *
**************************************************  
        MOVE.B      D0,(A5)
        MOVE.W      (A6),D1
        MOVE.L      A3,(A4)
        MOVE.L      -(A5),(A0)+
        ADD.W       D0,(A1)
        ADD.B       -(A4),D4
           

**************************************************
* Welcome Message and Address Input and Storage  *
**************************************************

*Starting/Ending Address stored in A6 and A7
        LEA         Welcome, A1         *Outputs the Welcome
        MOVE.B      #14, D0
        TRAP        #15



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
        BLE         OrderError          *If A6 is greater than or equal to A7, then error
        CLR.L       D0
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




**************************************************
*                  Main Loop                     *
**************************************************
ComputeOpcode
        *Finish Loop If Starting address greater than 
        CMPA.L      A7,A6               *Compares Starting Address to Ending Address
        BGT         Fin                 *If greater than then branch to Fin subroutine
        
        *Check to see if conversions are taking place
        CMP.B       #$01,D0             *Compares 1 to Nibble Counter
        BEQ         NibbleConversion2   *If Nibble Counter is one branch to NibbleConversion2

        CMP.B       #$02,D0             *Compares 1 to Nibble Counter
        BEQ         NibbleConversion3   *If Nibble Counter is one branch to NibbleConversion2
        
        CMP.B       #$03,D0             *Compares 1 to Nibble Counter
        BEQ         NibbleConversion4   *If Nibble Counter is one branch to NibbleConversion2
        
        CMP.B       #$04,D0             *Compares 1 to Nibble Counter
        BEQ         PostConversion      *If Nibble Counter is one branch to NibbleConversion2
        
        *Clear the data registers
        CLR.L       D7                  *Reset D7
        CLR.L       D6                  *Reset D6
        CLR.L       D5                  *Reset D5       
        CLR.L       D4                  *Reset D4
        CLR.L       D3                  *Reset D3
        CLR.L       D2                  *Reset D2
        CLR.L       D1                  *Reset D1
        CLR.L       D0                  *Reset D0
        
        *Isolate First Nibble
        MOVE.W      (A6),D7             *Moves Command at Address to D7             
        DIVU        #4096,D7            *Isolates First Nibble
        MOVE.W      D7,D6               *Move First Nibble to D6
        SUB.W       D6,D7               *Subtract First Nibble from D7
        DIVU        #4096,D7            *Move Remaining Nibbles down the register
        
        *Isolate Second Nibble
        DIVU        #4096,D7            *Isolate Second Nibble
        MOVE.W      D7,D5               *Move Second Nibble to D5
        SUB.W       D5,D7               *Subtract Second Nibble from D7
        DIVU        #4096,D7            *Move Remaining Nibbles down the register
        
        *Isolate Third Nibble
        DIVU        #4096,D7            *Isolate Third Nibble
        MOVE.W      D7,D4               *Move Third Nibble to D4
        SUB.W       D4,D7               *Subtract Third Nibble from D7
        DIVU        #4096,D7            *Move Remaining Nibbles down the register
        
        *Isolate Fourth Nibble
        DIVU        #4096,D7            *Isolate Fourth Nibble
        MOVE.W      D7,D3               *Move Fourth Nibble to De
        SUB.W       D3,D7               *Subtract Third Nibble from D7
        
        *Move Nibbles Up one Register
        MOVE.W      D6,D7               *Move Nibble in D6 to D7
        MOVE.W      D5,D6               *Move Nibble in D5 to D6
        MOVE.W      D4,D5               *Move Nibble in D4 to D5
        MOVE.W      D3,D4               *Move Nibble in D3 to D4
        CLR.L       D3                  *Clear D3

*Convert Each Nibble to Binary
NibbleConversion1
        MOVE.W      D7,D3               *Move Nibble in D7 to D3
        ADDI.W      #$01,D0             *Increment Nibble Conversion Counter
        BRA         NibbleConversion    *Branch to Nibble Conversion

NibbleConversion2
        *Clear and Move Relevant registers
        CLR.L       D7                  *Clear Hex for first Nibble
        MOVE.W      D3,D7               *Move binary from register 3 to register 7
        CLR.L       D3                  *Clear register 3
        MOVE.W      D6,D3               *Move second Nibble to register 3
        
        *Convert Nibble
        ADDI.W      #$01,D0             *Increment Nibble Conversion Counter
        BRA         NibbleConversion    *Branch to Nibble Conversion

NibbleConversion3
        *Clear and Move Relevant registers
        CLR.L       D6                  *Clear Hex for Second Nibble
        MOVE.W      D3,D6               *Move binary from register 3 to register 6
        CLR.L       D3                  *Clear register 3
        MOVE.W      D5,D3               *Move second Nibble to register 3
        
       *Convert Nibble
        ADDI.W      #$01,D0             *Increment Nibble Conversion Counter
        BRA         NibbleConversion    *Branch to Nibble Conversion

NibbleConversion4
        *Clear and Move Relevant Registers
        CLR.L       D5                  *Clear Hex for Third Nibble
        MOVE.W      D3,D5               *Move binary from register 3 to register 5
        CLR.L       D3                  *Clear register 3
        MOVE.W      D4,D3               *Move Fourth Nibble to register 3
        
        *Convert to Nibble
        ADDI.W      #$01,D0             *Increment Nibble Conversion Counter
        BRA         NibbleConversion    *Branch to Nibble Conversion
        
PostConversion
        *Clear and Move Relevant Registers
        CLR.L       D4                  *Clear Register 4
        MOVE.W      D3,D4               *Move binary from register 3 to Register 4
        CLR.L       D3                  *Clear Register 3
        CLR.L       D0                  *Clear Nibble Counter
        
        *Go to BCHG Validator Routine
        CMP.W       #$0000,D7           *Compares Zero to Most Significant Nibble
        BEQ         BchgVal             *If equal send to BchgVal Subroutine
        
        *Go to MOVE Validator Routine
        CMP.W       #$0001,D7           *Compares to Most Significant Nibble
        BEQ         MoveVal             *If equal send to MoveVal Subroutine
        CMP.W       #$0010,D7           *Compares Two to Most Significant Nibble
        BEQ         MoveVal             *If equal send to MoveVal Subroutine
        CMP.W       #$0011,D7           *Compares Three to Most Significant Nibble
        BEQ         MoveVal             *If equal send to MoveVal Subroutine
        
        *Go to BCS Validator Routine
        CMP.W       #$0110,D7           *Compares Six to Most Significant Nibble
        BEQ         BcsVal              *If equal send to BcsVal Subroutine
        
        *Go to CMP Validator Routine
        CMP.W       #$1011,D7           *Compares B to Most Signficant Nibble
        BEQ         CmpVal              *If equal send to CmpVal Subroutine
        
        *Go to AND Validator Routine
        CMP.W       #$1100,D7           *Compares C to Most Significant Nibble
        BEQ         AndVal              *If equal send to AndVal Subroutine
        
        *Go to ADD Validator Routine
        CMP.W       #$1101,D7           *Compares D to Most Significant Nibble
        BEQ         AddVal              *If equal send to AddVal Subroutine
        
        *Go to FourCheck Routine
        CMP.W       #$0100,D7           *Compares Four to Most significant Nibble
        BEQ         FourCheck           *If equal send to FourCheck    
        
        *Go to Error Message
        BRA         ErrorM              *Branch to Error Message
        
FourCheck
        *Go to NOT Validator Routine
        CMP.W       #$0110,D6           *Compares Six to Second Significant Nibble
        BEQ         NotVal              *If equal send to NotVal Subroutine
        
        *Go to ECheck Routine
        CMP.W       #$1110,D6           *Compares E to to Second Significant Nibble
        BEQ         ECheck              *If equal send to ECheck Subroutine
        
        *Go to MOVEM Validator Routine
        BRA         MovemVal            *If not 6 or E send to MovemVal
        
ECheck  
        *Go to RTS Validator Routine      
        CMP.W       #$0111,D5           *Compares 7 to Second Significant Nibble
        BEQ         RtsVal              *If equal send to RtsVal Subroutine
        
        *Go to JSR Validator Routine
        CMP.W       #$0111,D5
        BGT         JsrVal              *If greater than send to JsrVal Subroutine
        
        *Go to MOVEM Validator Routine
        CMP.W       #$0100,D5           *Compares 4 to Second Significant Nibble
        BLT         MovemVal            *If less than send to MovemVal Subroutine
        
        BRA         ErrorM              *Branch to error if it does not fit any
        



**************************************************
*      BCHG Command Validation and Print         *
**************************************************          
BchgVal
        LEA         BchgMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*      MOVE Command Validation and Print         *
**************************************************  
MoveVal 
        *Branch Ahead if table has been used
        CMP.B       #$01,D1
        BEQ         MoveSourceMode
        CMP.B       #$02,D1
        BEQ         MoveSourceReg
        CMP.B       #$03,D1
        BEQ         MoveParenCheck1
        CMP.B       #$04,D1
        BEQ         MoveDestMode
        CMP.B       #$05,D1
        BEQ         MoveDestReg
        CMP.B       #$06,D1
        BEQ         MoveParenCheck2
        CMP.B       #$07,D1
        BEQ         MoveEnd
        
        *Isolate Destination Register
        MOVE.W      D6,D3
        DIVU        #16,D3
        MOVE.W      D3,D2
        SUB.W       D2,D3
        CLR.L       D6
        MOVE.W      D2,D6
        CLR.L       D2
        
        *Isolate Destination Mode
        MOVE.W      D5,D3
        DIVU        #256,D3
        MOVE.W      D3,D2
        SUB.W       D2,D3
        CLR.L       D5
        MOVE.W      D2,D5
        CLR.L       D2
        
        *Isolate Source Mode
        MOVE.W      D4,D3
        DIVU        #4096,D3
        MOVE.W      D3,D2
        SUB.W       D2,D3
        CLR.L       D4
        MOVE.W      D2,D4
        CLR.L       D2
        
       *Isolate Source Register
        DIVU        #4096,D3
        DIVU        #16,D3
        
        *Check For Invalid MOVE Destination Mode
        CMP.W       #$0001,D5
        BEQ         ErrorM
        
        *Prints MOVE
        MOVE.B      #$07,D2
        LEA         MoveMess,A1
        MOVE.B      #14,D0
        TRAP        #15
MoveSize
        *Prints Size
        ADDI.W      #$01,D1
        CMP.W       #$0001,D7
        BEQ         B
        CMP.W       #$0010,D7
        BEQ         L
        CMP.W       #$0011,D7
        BEQ         W
MoveSourceMode
        *PrintsMode
        ADDI.W      #$01,D1
        MOVE.W      D4,D0
        BRA         Mode
MoveSourceReg
        *PrintsRegister
        ADDI.W      #$01,D1
        MOVE.W      D3,D0
        BRA         Reg
MoveParenCheck1
        *PrintClosedParen
        ADDI.W      #$01,D1
        CMP.W       #$0010,D4
        BEQ         CloseParen
        CMP.W       #$0100,D4
        BEQ         CloseParen
        *PrintClosedParen+
        CMP.W       #$0011,D4
        BEQ         CloseParenP
MoveDestMode
        *Add Comma
        MOVE.B      #$14,D0
        LEA         Comma,A1
        MOVE.B      #14,D0
        TRAP        #15
        *Print Destination Mode
        ADDI.W      #$01,D1
        MOVE.W      D5,D0
        BRA         Mode
MoveDestReg
        *Print Destination Register
        ADDI.W      #$01,D1
        MOVE.W      D6,D0
        BRA         Reg
MoveParenCheck2
        *PrintClosedParen
        ADDI.W      #$01,D1
        CMP.W       #$0010,D5
        BEQ         CloseParen
        CMP.W       #$0100,D5
        BEQ         CloseParen
        *PrintClosedParen+
        CMP.W       #$0011,D5
        BEQ         CloseParenP      
MoveEnd
        *NewLine And increase address
        MOVE.B      #$14,D0
        LEA         NewLine,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*       BCS Command Validation and Print         *
**************************************************  
BcsVal
        LEA         BcsMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*       CMP Command Validation and Print         *
**************************************************  
CmpVal
        LEA         CmpMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode





**************************************************
*       AND Command Validation and Print         *
**************************************************  
AndVal
        LEA         AndMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*       ADD Command Validation and Print         *
**************************************************  
AddVal 
        *Branch Ahead if table has been used
        CMP.B       #$01,D1
        BEQ         AddSourceMode
        CMP.B       #$02,D1
        BEQ         AddSourceReg
        CMP.B       #$03,D1
        BEQ         AddParenCheck1
        CMP.B       #$04,D1
        BEQ         AddDestMode
        CMP.B       #$05,D1
        BEQ         AddDestReg
        CMP.B       #$06,D1
        BEQ         AddParenCheck2
        CMP.B       #$07,D1
        BEQ         AddEnd
        
        *Remove and Replace First Nibble
        CLR.L       D7
        MOVE.W      D6,D7
        MOVE.W      D5,D6
        MOVE.W      D4,D5
        CLR.L       D4
        
        *Isolate Destination Register
        MOVE.W      D7,D3
        DIVU        #16,D3
        MOVE.W      D3,D2
        SUB.W       D2,D3
        CLR.L       D7
        MOVE.W      D2,D7
        CLR.L       D2
        
        *Isolate Opmode
        MOVE.W      D6,D3
        DIVU        #256,D3
        MOVE.W      D3,D2
        SUB.W       D2,D3
        CLR.L       D6
        MOVE.W      D2,D6
        CLR.L       D2
        
        *Isolate Source Mode
        MOVE.W      D5,D3
        DIVU        #4096,D3
        MOVE.W      D3,D2
        SUB.W       D2,D3
        CLR.L       D5
        MOVE.W      D2,D5
        CLR.L       D2
        
       *Isolate Source Register
        DIVU        #4096,D3
        DIVU        #16,D3
        MOVE.W      D3,D4
        
        *Move around registers
        MOVE.W      D7,D3
        MOVE.W      D6,D2
        MOVE.W      D2,D7
        MOVE.W      #$0000,D6
        MOVE.W      D5,D2
        MOVE.W      D3,D5
        MOVE.W      D4,D3
        MOVE.W      D2,D4
        CLR.L       D2
        
        
        *Check For Invalid Adds
        
        *Prints Add
        MOVE.B      #$01,D2
        LEA         AddMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        
        *Add Flip Flop
        CMP.W       #$0100,D7
        BEQ         AddSize
        CMP.W       #$0101,D7
        BEQ         AddSize
        CMP.W       #$0110,D7
        BEQ         AddSize
        MOVE.W      D6,D2
        MOVE.W      D5,D1
        MOVE.W      D4,D6
        MOVE.W      D3,D5
        MOVE.W      D2,D4
        MOVE.W      D1,D3
        CLR.L       D2
        CLR.L       D1
        MOVE.L      #$01,D2
AddSize
        *Prints Size
        ADDI.W      #$01,D1
        CMP.W       #$0000,D7
        BEQ         B
        CMP.W       #$0100,D7
        BEQ         B
        CMP.W       #$0001,D7
        BEQ         W
        CMP.W       #$0101,D7
        BEQ         W
        CMP.W       #$0010,D7
        BEQ         W
        CMP.W       #$0110,D7
        BEQ         W
AddSourceMode
        *PrintsMode
        ADDI.W      #$01,D1
        MOVE.W      D6,D0
        BRA         Mode
AddSourceReg
        *PrintsRegister
        ADDI.W      #$01,D1
        MOVE.W      D5,D0
        BRA         Reg
AddParenCheck1
        *PrintClosedParen
        ADDI.W      #$01,D1
        CMP.W       #$0010,D6
        BEQ         CloseParen
        CMP.W       #$0100,D6
        BEQ         CloseParen
        *PrintClosedParen+
        CMP.W       #$0011,D6
        BEQ         CloseParenP
AddDestMode
        *Add Comma
        MOVE.B      #$14,D0
        LEA         Comma,A1
        MOVE.B      #14,D0
        TRAP        #15
        *Print Destination Mode
        ADDI.W      #$01,D1
        MOVE.W      D4,D0
        BRA         Mode
AddDestReg
        *Print Destination Register
        ADDI.W      #$01,D1
        MOVE.W      D3,D0
        BRA         Reg
AddParenCheck2
        *PrintClosedParen
        ADDI.W      #$01,D1
        CMP.W       #$0010,D4
        BEQ         CloseParen
        CMP.W       #$0100,D4
        BEQ         CloseParen
        *PrintClosedParen+
        CMP.W       #$0011,D4
        BEQ         CloseParenP      
AddEnd
        *NewLine And increase address
        MOVE.B      #$14,D0
        LEA         NewLine,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*       NOT Command Validation and Print         *
**************************************************  
NotVal
        LEA         NotMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*     MOVEM Command Validation and Print         *
**************************************************    
MovemVal
        LEA         MovemMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*       RTS Command Validation and Print         *
**************************************************        
RtsVal
        LEA         RtsMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*      MOVE Command Validation and Print         *
**************************************************          
JsrVal
        LEA         JsrMess,A1
        MOVE.B      #14,D0
        TRAP        #15
        ADDA.W      #$02,A6
        BRA         ComputeOpcode




**************************************************
*           Find Current Val Routine             *
**************************************************
ValFind
        CMP         #$01,D2
        BEQ         AddVal
        CMP         #$02,D2
        BEQ         AndVal
        CMP         #$03,D2
        BEQ         BchgVal
        CMP         #$04,D2
        BEQ         BcsVal
        CMP         #$05,D2
        BEQ         CmpVal
        CMP         #$06,D2
        BEQ         JsrVal
        CMP         #$07,D2
        BEQ         MoveVal
        CMP         #$08,D2
        BEQ         MovemVal
        CMP         #$09,D2
        BEQ         NotVal
        CMP         #$0A,D2
        BEQ         RtsVal




**************************************************
*    Identify if nibble needs to be converted    *
**************************************************  
NibbleConversion
        CMP.W       #$0000,D3           *If first Nibble is Zero Skip two NibbleConversion2
        BEQ         ComputeOpcode       *Branch to ComputeOpcode
        CMP.W       #$0001,D3           *If second Nibble is 1 Skip two NibbleConversion2
        BEQ         ComputeOpcode       *Branch to ComputeOpcode
        CMP.W       #$0010,D3           *If Nibble less than hex 0010 convert to binary
        BLT         Hex2Bin             *Branch to Hex2Bin
        



**************************************************
*        Identify what Mode is being used        *
************************************************** 
Mode
        CMP.W       #$0000,D0
        BEQ         Dn
        CMP.W       #$0001,D0
        BEQ         An
        CMP.W       #$0010,D0
        BEQ         Ans
        CMP.W       #$0011,D0
        BEQ         Ansp
        CMP.W       #$0100,D0
        BEQ         Ansm
        CMP.W       #$0111,D0
        BEQ         Immediate




**************************************************
*     Identify what register is being used       *
************************************************** 
Reg
        CMP.W       #$0000,D0
        BEQ         RZero
        CMP.W       #$0001,D0
        BEQ         ROne
        CMP.W       #$0010,D0
        BEQ         RTwo
        CMP.W       #$0011,D0
        BEQ         RThree
        CMP.W       #$0100,D0
        BEQ         RFour
        CMP.W       #$0101,D0
        BEQ         RFive
        CMP.W       #$0110,D0
        BEQ         RSix
        CMP.W       #$0111,D0
        BEQ         RSeven
        
        
        
        
**************************************************
*              Close Parentheses                 *
**************************************************         
CloseParen       
        LEA         Close,A1
        MOVE.B      #14,D0
        TRAP        #15
        BRA         ValFind
CloseParenP
        LEA         Close,A1
        MOVE.B      #14,D0
        TRAP        #15
        LEA         Plus,A1
        MOVE.B      #14,D0
        TRAP        #15
        BRA         ValFind


        

**************************************************
*        Error, End, and Match Routines          *
************************************************** 
ErrorM
        LEA         ErrMess,A1          *Displapy Error Message
        MOVE.B      #14,D0              
        Trap        #15
        ADDA.W      #$02,A6             *Increase Address by 2 bytes
        BRA         ComputeOpcode       *Branch back to ComputeOpcode

Fin
        LEA         EndMess,A1          *Display Message
        MOVE.B      #14,D0
        Trap        #15
        BRA         DoAgain             *Branch to DoAgain

Match
        ADD.B       #$1, D5             *Count number of characters in input
        CMP.B       #$1, (A1)+          *Increases A1 to compare the next character taken from input




**************************************************
*        Convert ASCII to Hexadecimal            *
************************************************** 
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
        CMP.B       #$0, (A1)           *00 means enter, so stop and return when program sees this
        BNE         TableErr
        RTS

TableErr
        MOVE.L      #$00000001, D4      *Mark that input error
        RTS




**************************************************
*       Convert Hexadecimal to Binary            *
**************************************************     
Hex2Bin
ZeroBin
        CMP.B      #00,D3
        BNE        OneBin
        CLR.L      D3
        MOVE.W     #$0000,D3
        BRA        ComputeOpcode
OneBin
        CMP.B      #01,D3
        BNE        TwoBin
        CLR.L      D3
        MOVE.W     #$0001,D3
        BRA        ComputeOpcode
TwoBin
        CMP.B      #$02,D3
        BNE        ThreeBin
        CLR.L      D3
        MOVE.W     #$0010,D3
        BRA        ComputeOpcode
ThreeBin
        CMP.B      #$03,D3
        BNE        FourBin
        CLR.L      D3
        MOVE.W     #$0011,D3
        BRA        ComputeOpcode
FourBin
        CMP.B      #$04,D3
        BNE        FiveBin
        CLR.L      D3
        MOVE.W     #$0100,D3
        BRA        ComputeOpcode
FiveBin
        CMP.B      #$05,D3
        BNE        SixBin
        CLR.L      D3
        MOVE.W     #$0101,D3
        BRA        ComputeOpcode
SixBin
        CMP.B      #$06,D3
        BNE        SevenBin
        CLR.L      D3
        MOVE.W     #$0110,D3
        BRA        ComputeOpcode
SevenBin
        CMP.B      #$07,D3
        BNE        EightBin
        CLR.L      D3
        MOVE.W     #$0111,D3
        BRA        ComputeOpcode
EightBin
        CMP.B      #$08,D3
        BNE        NineBin
        CLR.L      D3
        MOVE.W     #$1000,D3
        BRA        ComputeOpcode
NineBin
        CMP.B      #$09,D3
        BNE        ABin
        CLR.L      D3
        MOVE.W     #$1001,D3
        BRA        ComputeOpcode
ABin
        CMP.B      #$0A,D3
        BNE        BBin
        CLR.L      D3
        MOVE.W     #$1010,D3
        BRA        ComputeOpcode
BBin
        CMP.B      #$0B,D3
        BNE        CBin
        CLR.L      D3
        MOVE.W     #$1011,D3
        BRA        ComputeOpcode
CBin
        CMP.B      #$0C,D3
        BNE        DBin
        CLR.L      D3
        MOVE.W     #$1100,D3
        BRA        ComputeOpcode
DBin
        CMP.B      #$0D,D3
        BNE        EBin
        CLR.L      D3
        MOVE.W     #$1101,D3
        BRA        ComputeOpcode
EBin
        CMP.B      #$0E,D3
        BNE        FBin
        CLR.L      D3
        MOVE.W     #$1110,D3
        BRA        ComputeOpcode
FBin
        CMP.B      #$0F,D3
        BNE        ErrorM
        CLR.L      D3
        MOVE.W     #$1111,D3
        BRA        ComputeOpcode

        


**************************************************
*               Prints Size                      *
************************************************** 
SizeTable
B
        LEA         Byte,A1
        MOVE.B      #14,D0
        TRAP        #15
        BRA         ValFind

W
        LEA         Word,A1
        MOVE.B      #14,D0
        TRAP        #15
        BRA         ValFind
L
        LEA         Long,A1
        MOVE.B      #14,D0
        TRAP        #15
        BRA         ValFind




**************************************************
*          Prints Effective Address              *
************************************************** 
EaTable
Dn
        LEA         DMess,A1
        MOVE.B      #14,D0
        Trap        #15
        
        BRA         ValFind
An
        LEA         AMess,A1
        MOVE.B      #14,D0
        Trap        #15
        
        BRA         ValFind
Ans
        LEA         Open,A1
        MOVE.B      #14,D0
        Trap        #15
        
        LEA         AMess,A1
        MOVE.B      #14,D0
        Trap        #15
        
        BRA         ValFind
Ansp
        LEA         Open,A1
        MOVE.B      #14,D0
        Trap        #15
        
        LEA         AMess,A1
        MOVE.B      #14,D0
        Trap        #15
        
        BRA         ValFind
Ansm
        LEA         Minus,A1
        MOVE.B      #14,D0
        Trap        #15
        
        LEA         Open,A1
        MOVE.B      #14,D0
        Trap        #15
        
        LEA         AMess,A1
        MOVE.B      #14,D0
        Trap        #15
        
        BRA         ValFind
Immediate




**************************************************
*                Prints Register                 *
************************************************** 
RegTable
RZero
        LEA         ZeroMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind
ROne
        LEA         OneMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind
RTwo
        LEA         TwoMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind
RThree
        LEA         ThreeMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind
RFour
        LEA         FourMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind
RFive
        LEA         FiveMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind
RSix
        LEA         SixMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind
RSeven
        LEA         SevMess,A1
        MOVE.B      #14,D0
        Trap        #15
        BRA         ValFind




**************************************************
*  Determines error, Asks for start and restart  *
************************************************** 
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
    
    
    
    
************************************************* 
*        Variables, Constants, and Strings      *
*************************************************              
CR      EQU     $0D
LF      EQU     $0A
*Welcome Message
Welcome DC.B    'Welcome to 68k Disassembler',CR,LF,0
*Start and End Address Prompts
StartM  DC.B    CR,LF,'Enter a STARTING address: ',0
EndM    DC.B    CR,LF,'Enter an ENDING address: ',0
ErrMess DC.B    'Not a valid Command',CR,LF,0
*Invalid Inputs, Order error, and Command Error
Invalid DC.B    'Invalid Input',CR,LF,0
OrderEr DC.B    'STARTING Address must be less than ENDING Address',CR,LF,0
*Done Processing Address and Again Prompt
Done    DC.B    CR,LF,'Processing Completed',CR,LF,0
AgainM  DC.B    'Do you want to disassemble again? (Y/N): ',0
*Command Messages
BchgMess DC.B   'BCHG',0
MoveMess DC.B   'MOVE',0
BcsMess DC.B    'BCS',0
CmpMess DC.B    'CMP',0
AndMess DC.B    'AND',0
AddMess DC.B    'ADD',0
NotMess DC.B    'NOT',0
MovemMess DC.B  'MOVEM',0
JsrMess DC.B    'JSR',0
RtsMess DC.B    'RTS',CR,LF,0
*Size of Command Messages
Byte    DC.B    '.B ',0
Long    DC.B    '.L ',0
Word    DC.B    '.W ',0
*Numbers (0-9), (A-F)
ZeroMess DC.B   '0',0
OneMess DC.B    '1',0
TwoMess DC.B    '2',0
ThreeMess DC.B  '3',0
FourMess DC.B   '4',0
FiveMess DC.B   '5',0
SixMess  DC.B   '6',0
SevMess  DC.B   '7',0
EightMess DC.B  '8',0
NineMess DC.B   '9',0
AMess    DC.B   'A',0
BMess    DC.B   'B',0
CMess    DC.B   'C',0
DMess    DC.B   'D',0
EMess    DC.B   'E',0
FMess    DC.B   'F',0
*Punctuation and Other Chars
Comma   DC.B    ',',0
Open    DC.B    '(',0
Close   DC.B    ')',0
Octo    DC.B    '#',0
Dollar  DC.B    '$',0
Modulo  DC.B    '%',0
Plus    DC.B    '+',0
Minus   DC.B    '-',0
NewLine DC.B    CR,LF,0
*End Of Script Message 
EndMess DC.B    'End of Script',CR,LF,0
        
End     SIMHALT        ; last line of source
        END      START






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
