                 ORG     $1000
                 
start  
        LEA         Welcome, A1         *Outputs the Welcome
        MOVE.B      #14, D0
        TRAP        #15
      
        LEA         Instructions,A1          *Display Instructions for input Message
        MOVE.B      #14,D0
        Trap        #15 

StartAddress
        LEA         StartM, A1          *Outputs the StartM
        MOVE.B      #14, D0
        TRAP        #15

        MOVEA.L     #$00000000, A1
        MOVE.B      #2, D0              *Takes in input
        TRAP        #15
        CLR.L       D4
        MOVE.L      #$00000000, D2
        JSR         Table               *Goes to table where each character from input will be moved to D2
        
        CMP.B       #$0, D4             *See if there is an error input
        BNE         Error               *Go here if there is an error input
        
        
        BTST.L      #0, D2              *Check to see if address is odd
        BEQ         EVENS
        BNE         ODDS
OddS
        LEA         OddEr, A1           *Outputs the error OddEr message for odd
        MOVE.B      #14, D0
        TRAP        #15
        BRA         Error
        
EvenS
        MOVE.L      D2, A6              *Puts the results of input into address register A6
***********************************************************************************************
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
        
        
        BTST.L      #0, D2              *Check to see if address is odd
        BEQ         EVENE
        BNE         ODDE
OddE
        LEA         OddEr, A1           *Outputs the error OddEr message for odd
        MOVE.B      #14, D0
        TRAP        #15
        BRA         Error
        
EvenE
        MOVE.L      D2, A5              *Puts the results of input into address register A5


CompareAddresses
        CMP.L       A6, A5              *A5 must be greater than A6
        BLT         OrderError          *If A6 is greater than or equal to A5, then error
        BRA         loading       *Go to ComputeOpcode step
        
OrderError
        MOVE.L      #$00000000, D2      *Clears data
        MOVEA.L     #$00000000, A6
        MOVEA.L     #$00000000, A5
        MOVE.L      #$00000000, D3
        
        LEA         OrderEr, A1         *Outputs the OrderEr message
        MOVE.B      #14, D0
        TRAP        #15
        BRA         Error               *Go to Error to restart and reask the input and output

Match
        ADD.B       #$1, D5             *Count number of characters in input
        CMP.B       #$1, (A1)+          *Increases A1 to compare the next character taken from input
********************************************************************************************
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

********************************************************************************************
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
********************************************************************************************** 
stack           EQU      $A000   
shift           EQU     12                   * Shift 12 bits 
shift2          EQU     13              *second step in shifting to isolate 3 bits
sizeBit2        EQU     14
drShift         EQU     4               *first step in shifting to find destination register
dmShift         EQU     7               *first step in shifting to find destination mode
smShift         EQU     10              *shift number to isolate source mode
counter         EQU     $0000

loading         
                CMP.W   #$14,counter
                BGT     ClearScreen0
                
                CMP.W   #$14,counter
                BEQ     ClearScreen
                
                ADD.W   #$0001,counter
                MOVE.W  counter,D0
                CLR.B   SizeOfCurrent
                MOVE.B  #$0, SizeOfCurrent
                CLR.L   D3
                CLR.L   D4
                CLR.L   D5
                CLR.L   D6
                CLR.L   D7
                
                CMPA.L      A5,A6               *Compares Starting Address to Ending Address
                BGT         Fin                 *If greater than then branch to Fin subroutine

                LEA     stack,SP        *Load the SP
                LEA     jmp_table,A0    *Index into the table
                CLR.L   D0              *Zero it
                MOVE.W  (A6),D2
                MOVE.W  D2,D0     *We'll play with it here
                MOVE.B  #shift,D1       *Shift 12 bits to the right  
                LSR.W   D1,D0           *Move the bits

* Consider the next instruction. Why do we have to multiply the index 
* by 6? How many bytes does a single jump table entry require?
               MOVEM.L     A0/A1/D0, -(SP)
               LEA         PrintEnter,A1                  *Print Enter next line
               MOVE.B      #14,D0
               Trap        #15
               
               MOVE.B      #$2, AddressSize             *Sets address as long 
               JSR         PrintingAddresses            *Go here to print address
               
               LEA         BigSpace,A1                  *Print BigSpace
               MOVE.B      #14,D0
               Trap        #15
               
               MOVEM.L     (SP)+, A0/A1/D0
               
               MULU        #6,D0       *Form offset     
               JSR         0(A0,D0)   *Jump indirect with index
*The following subroutines will get filled in as you decode the instructions . For *now, just exit gracefully.      $$$$$$$$$$$ DECIDING WHAT COMMAND

jmp_table      JMP         code0000
               JMP         code0001
               JMP         code0010
               JMP         code0011
               JMP         code0100
               JMP         code0101
               JMP         code0110
               JMP         code0111
               JMP         code1000
               JMP         code1001
               JMP         code1010
               JMP         code1011
               JMP         code1100
               JMP         code1101
               JMP         code1110
               JMP         code1111
               
code0000       
               MOVE.L      #$0, D3
               
               CLR.L   D0            
               MOVE.W  (A6),D2
               MOVE.W  D2,D0    
               MOVE.B  #4,D1
               LSL.W   D1,D0
               
               MOVE.B  #shift,D1
               LSR.W   D1,D0
               CMP.B   #$08,D0
               BEQ     dataBCHG
               
               MOVE.W  D2,D0
               MOVE.B  #7,D1
               LSL.W   D1,D0
               MOVE.B  #shift2,D1
               LSR.W   D1,D0
               CMP.B   #%101,D0
               BNE     NotApplicable
               
               MOVE.W  #%000,D5     *making sure source is directed as Dn mode
               BRA     dRegister

dataBCHG       MOVE.L      #$08,D3
               MOVE.W      #%111,D5
               MOVE.W      #$4,D4
               BRA         dRegister
               
code0001       
               MOVE.L      #$1, D3
               
               MOVE.B      #$1,DataSize
               BRA         dRegister
code0010       
               MOVE.L      #$2, D3
              
               MOVE.B      #$2,DataSize
               BRA         dRegister
code0011       
               MOVE.L      #$3, D3
               
               MOVE.B      #$3,DataSize
               BRA         dRegister

code0100       BRA         FourCheck
               
code0101       BRA         NotApplicable

code0110       
               CLR.L       D0
               MOVE.W      (A6),D2
               MOVE.W      D2,D0
               LSL.W       #4,D0
               MOVE.B      #shift,D1
               LSR.W       D1,D0
               CMP.B       #$05,D0
               BNE         NotApplicable

               
               MOVE.W      D2,D0
               LSL.W       #8,D0
               LSR.W       #8,D0
               CMP.W       #$80,D0
               BGE         BCS8Bit
               BRA         BCS16Bit
               
               
code0111       BRA         NotApplicable
code1000       BRA         NotApplicable
code1001       BRA         NotApplicable
code1010       BRA         NotApplicable

code1011       
               MOVE.L      #$B, D3
              
               BRA         dRegister

code1100       
               MOVE.L      #$C, D3
             
               BRA         dRegister

code1101       
               MOVE.L      #$D, D3
               
               BRA         dRegister
               
code1110       BRA         NotApplicable
code1111       BRA         NotApplicable

NotApplicable   
               LEA         NA,A1
               MOVE.B      #14,D0
               TRAP        #15
               
               MOVE.L      A6,A3
               MOVE.W     (A6),A4
               MOVE.W      A4,A6               
               JSR         PrintingAddresses            *Go here to print address
               MOVEM.L     (SP)+, A6
               MOVE.L      A3,A6

               BRA         increment

*******************************************************************************************
FourCheck
               CLR.L   D0
               MOVE.W  (A6),D2
               MOVE.W  D2,D0
               LSL.W   #4,D0
               MOVE.B  #shift,D1
               LSR.W   D1,D0
               
               CMP.B   #$0E,D0
               BEQ     RTSorJSRVal
               
               CMP.B   #$06,D0
               BEQ     NOTVal
               
               CMP.B   #$08,D0
               BEQ     MOVEMVal
               CMP.B   #$0C,D0
               BEQ     MOVEMVal
               BRA     NotApplicable

               
RTSorJSRVal
               CLR.L   D0
               MOVE.W  D2,D0
               LSL.W   #8,D0
               MOVE.B  #shift,D1
               LSR.W   D1,D0
               CMP.B   #$07,D0
               BNE     JSRVal
               
               CLR.L   D0
               MOVE.W  D2,D0
               MOVE.B  #shift,D1
               LSL.W   D1,D0
               MOVE.B  #shift,D1
               LSR.W   D1,D0
               CMP.B   #$05,D0
               BNE     NotApplicable
               
               MOVE.L      #$4E75,D3
               LEA         RtsMess,A1
               MOVE.B      #14,D0
               TRAP        #15 

               ADDA.L      #$2, A6
               BRA         loading
JSRVal
               CLR.L   D0
               MOVE.W  (A6),D2
               MOVE.W  D2,D0
               LSL.W   #8,D0
               MOVE.B  #sizeBit2,D1
               LSR.W   D1,D0
               CMP.B   #$2,D0
               BNE     NotApplicable

               
               MOVE.L  #$4E,D3
               BRA     sMode
               

NOTVal         
               CLR.L   D0
               MOVE.W  (A6),D2
               MOVE.W  D2,D0
               LSL.W   #8,D0
               MOVE.B  #sizeBit2,D1
               LSR.W   D1,D0
               MOVE.B  D0,D6
               
               MOVE.L  #$46,D3
               BRA     sMode

******************************************************************************************* 
BCS8Bit
                MOVE.L  #$658, D3
                CMP.W   #$FF,D0
                BEQ     BCS32Bit
                
                ADD.L   #2,D0
                MOVE.L  A6,D1
                ADD.L   D1,D0
                SUB.L   #$100,D0
                MOVE.L  D0,D1
                
                MOVE.W  #%111,D5
                MOVE.W  #$1,D4
                BRA     StartPrintingEverything
               

BCS16Bit
                MOVE.L  #$6516, D3
                CMP.W   #$80,D0
                BGT     NotApplicable
                
                MOVEA.L A6,A3
                ADDA.L  #$2,A3
                MOVE.W  (A3),D0
                
                ADD.L   #2,D0
                MOVE.L  A6,D1
                ADD.L   D1,D0

                MOVE.L  D0,D1
                
                MOVE.W  #%111,D5
                MOVE.W  #$1,D4
                BRA     StartPrintingEverything

BCS32Bit
                MOVE.L  #$6532, D3
                CMP.W   #$FF,D0
                BNE     NotApplicable
                
                MOVEA.L A6,A3
                ADDA.L  #$2,A3
                MOVE.L  (A3),D0
                
                ADD.L   #2,D0
                MOVE.L  A6,D1
                ADD.L   D1,D0
                
                MOVE.L  D0,D1
                
                MOVE.W  #%111,D5
                MOVE.W  #$1,D4
                BRA     StartPrintingEverything

******************************************************************************************
MOVEMVal       
               MOVE.B      D0,D3
        
               LEA         MovemMess,A1
               MOVE.B      #14,D0
               TRAP        #15
               
               JMP         MOVEMAssign
MOVEMAssign      
               MOVEA.L     A6,A3
               ADDA.W      #$0002,A3
               MOVE.W      (A3),D6
               MOVE.L      #$FFFFFFFF,D7
               
               MOVE.B      D2,D0
               MOVE.B      #$04,D1
               LSR.W       D1,D0
               MOVE.B      D0,D5
               
               LSL.W       #4,D0
               MOVE.B      D2,D1
               SUB.W       D0,D1
               MOVE.B      D1,D4
MOVEMSizeW
               CMP.B       #$0C,D5
               BGE         MOVEMSizeL
               
               LEA         WSize,A1
               MOVE.B      #14,D0
               TRAP        #15
               SUB.B       #$08,D5
               MULU        #2,D5
               
               JMP         MOVEMShift
MOVEMSizeL
               LEA         LSize,A1
               MOVE.B      #14,D0
               TRAP        #15
               SUB.B       #$0C,D5
               MULU        #2,D5
               
               JMP         MOVEMShift
MOVEMShift
               CMP.B       #$07,D4
               BGT         MOVEMShift01
               JMP         MOVEMSource             
MOVEMShift01               
               SUB.B       #$08,D4
               ADD.B       #$01,D5
               JMP         MOVEMSource    
MOVEMSource
               CMP.B       #$08,D3
               BEQ         MOVEMTable
               CMP.B       #$04,D5
               BGT         MOVEMAddressMove
MOVEMPSource               
               JMP         printingSource
MOVEMAddressMove
               ADDA.L      #$0002,A6
               BRA         MOVEMPSource
MOVEMCheck     
               CMP.B       #$08,D3
               BEQ         MOVEMListFirst
               CMP.B       #$0C,D3
               BEQ         MOVEMTable
******************************************************************************************
MOVEMTable
FirstNib
               CMP.B       #$04,D5
               BEQ         MOVEMSwapList
               
               MOVE.L      D6,D2
               DIVU        #4096,D2
               MOVE.W      D2,D1
               SUB.W       D1,D2
               DIVU        #4096,D2
               DIVU        #4096,D2
PA7
               CMP.B       #$08,D1
               BLT         PA6
               LEA         An7, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$08,D1
               CMP.B       #$00,D1
               BNE         PA7Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA7Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PA6
PA6
               CMP.B       #$04,D1
               BLT         PA5
               LEA         An6, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$04,D1
               CMP.B       #$00,D1
               BNE         PA6Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA6Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PA5
PA5
               CMP.B       #$02,D1
               BLT         PA4
               LEA         An5, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$02,D1
               CMP.B       #$00,D1
               BNE         PA5Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA5Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PA4    
PA4
               CMP.B       #$01,D1
               BLT         SecondNib
               LEA         An4, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$01,D1
               CMP.B       #$00,D1
               BNE         PA4Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA4Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         SecondNib
SecondNib
               MOVE.W      D2,D1
               SUB.W       D1,D2
               DIVU        #4096,D2
               DIVU        #4096,D2
PA3
               CMP.B       #$08,D1
               BLT         PA2
               LEA         An3, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$08,D1
               CMP.B       #$00,D1
               BNE         PA3Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA3Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PA2
PA2
               CMP.B       #$04,D1
               BLT         PA1
               LEA         An2, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$04,D1
               CMP.B       #$00,D1
               BNE         PA2Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA2Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PA1
PA1
               CMP.B       #$02,D1
               BLT         PA0
               LEA         An1, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$02,D1
               CMP.B       #$00,D1
               BNE         PA1Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA1Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PA0    
PA0
               CMP.B       #$01,D1
               BLT         ThirdNib
               LEA         An0, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$01,D1
               CMP.B       #$00,D1
               BNE         PA0Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PA0Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         ThirdNib
ThirdNib
               MOVE.W      D2,D1
               SUB.W       D1,D2
               DIVU        #4096,D2
               DIVU        #4096,D2
PD7
               CMP.B       #$08,D1
               BLT         PD6
               LEA         Dn7, A1                 
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$08,D1
               CMP.B       #$00,D1
               BNE         PD7Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD7Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PD6
PD6
               CMP.B       #$04,D1
               BLT         PD5
               LEA         Dn6, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$04,D1
               CMP.B       #$00,D1
               BNE         PD6Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD6Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PD5
PD5
               CMP.B       #$02,D1
               BLT         PD4
               LEA         Dn5, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$02,D1
               CMP.B       #$00,D1
               BNE         PD5Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD5Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PD4    
PD4
               CMP.B       #$01,D1
               BLT         FourthNib
               LEA         Dn4, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$01,D1
               CMP.B       #$00,D1
               BNE         PD4Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD4Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         FourthNib
FourthNib
               MOVE.W      D2,D1
               SUB.W       D1,D2
PD3
               CMP.B       #$08,D1
               BLT         PD2
               LEA         Dn3, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$08,D1
               CMP.B       #$00,D1
               BNE         PD3Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD3Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PD2
PD2
               CMP.B       #$04,D1
               BLT         PD1
               LEA         Dn2, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$04,D1
               CMP.B       #$00,D1
               BNE         PD2Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD2Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PD1
PD1
               CMP.B       #$02,D1
               BLT         PD0
               LEA         Dn1, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$02,D1
               CMP.B       #$00,D1
               BNE         PD1Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD1Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         PD0    
PD0
               CMP.B       #$01,D1
               BLT         FinTable
               LEA         Dn0, A1         
               MOVE.B      #14, D0
               TRAP        #15
               SUBI        #$01,D1
               CMP.B       #$00,D1
               BNE         PD0Fin
               CMP.L       #$0000,D2
               BEQ         FinTable
PD0Fin
               LEA         MessBackSlash, A1         
               MOVE.B      #14, D0
               TRAP        #15
               BRA         FinTable
******************************************************************************************* 
FinTable       
               ADDA.L      #$0002,A6
               CMP.B       #$08,D3
               BEQ         printingDestination
               CMP.B       #$04,D5
               BGT         loading
               ADDA.L      #$0002,A6
               JMP         loading         
MOVEMListFirst
               MOVE.L      D7,D2
               MOVE.L      D6,D1
               MOVE.L      D5,D6
               MOVE.L      D4,D7
               MOVE.L      D1,D5
               MOVE.L      D2,D4
               CLR.L       D1
               CLR.L       D2
               BRA         printingDestinationAll
******************************************************************************************* 
MOVEMSwapList  
               CMPA.W      #$0001,A4
               BEQ         MOVEMSwap2
               CMPA.W      #$0002,A4
               BEQ         MOVEMSwap3
               CMPA.W      #$0003,A4
               BEQ         MOVEMSwap4
               CMPA.W      #$0004,A4
               BEQ         MOVEMSwap5
MOVEMSwap1     
               MOVEA.L     #$0000,A4          
               MOVE.W      D6,D2
               DIVU        #4096,D2
               MOVE.W      D2,D1
               ADDA.W      #$0001,A4
               JMP         MOVEMSwapTable
MOVEMSwap2
               MOVE.B      D1,D0
               DIVU        #4096,D2
               DIVU        #4096,D2
               MOVE.W      D2,D1
               ADDA.W      #$0001,A4
               JMP         MOVEMSwapTable
MOVEMSwap3
               MULU        #16,D1
               ADD.B       D1,D0
               DIVU        #4096,D2
               DIVU        #4096,D2
               MOVE.W      D2,D1
               ADDA.W      #$0001,A4
               JMP         MOVEMSwapTable
MOVEMSwap4
               MULU        #256,D1
               ADD.W       D1,D0
               DIVU        #4096,D2
               DIVU        #4096,D2
               MOVE.W      D2,D1
               ADDA.W      #$0001,A4
               JMP         MOVEMSwapTable

MOVEMSwap5
               MULU        #4096,D1
               ADD.W       D1,D0
               MOVE.L      D0,D6
               MOVEA.L     #$0000,A4
               CLR.L       D0
               CLR.L       D1
               CLR.L       D2
               MOVE.L      D6,D2
               DIVU        #4096,D2
               MOVE.W      D2,D1
               SUB.W       D1,D2
               DIVU        #4096,D2
               DIVU        #4096,D2
               JMP         PA7               
MOVEMSwapTable
ZeroSwap
               CMP.B       #$00,D1
               BEQ         MOVEMSwapList
OneSwap        
               CMP.B       #$01,D1
               BNE         TwoSwap
               SUB.W       D1,D2
               MOVE.B      #$08,D1
               JMP         MOVEMSwapList
TwoSwap        
               CMP.B       #$02,D1
               BNE         ThreeSwap
               SUB.W       D1,D2
               MOVE.B      #$04,D1
               JMP         MOVEMSwapList
ThreeSwap        
               CMP.B       #$03,D1
               BNE         FourSwap
               SUB.W       D1,D2
               MOVE.B      #$0C,D1
               JMP         MOVEMSwapList
FourSwap        
               CMP.B       #$04,D1
               BNE         FiveSwap
               SUB.W       D1,D2
               MOVE.B      #$02,D1
               JMP         MOVEMSwapList
FiveSwap        
               CMP.B       #$05,D1
               BNE         SixSwap
               SUB.W       D1,D2
               MOVE.B      #$0A,D1
               JMP         MOVEMSwapList
SixSwap        
               CMP.B       #$06,D1
               BNE         SevenSwap
               SUB.W       D1,D2
               JMP         MOVEMSwapList
SevenSwap        
               CMP.B       #$07,D1
               BNE         EightSwap
               SUB.W       D1,D2
               MOVE.B      #$0E,D1
               JMP         MOVEMSwapList
EightSwap        
               CMP.B       #$08,D1
               BNE         NineSwap
               SUB.W       D1,D2
               MOVE.B      #$01,D1
               JMP         MOVEMSwapList
NineSwap
               CMP.B       #$09,D1
               BNE         ASwap
               SUB.W       D1,D2
               JMP         MOVEMSwapList
ASwap        
               CMP.B       #$0A,D1
               BNE         BSwap
               SUB.W       D1,D2
               MOVE.B      #$05,D1
               JMP         MOVEMSwapList
BSwap        
               CMP.B       #$0B,D1
               BNE         CSwap
               SUB.W       D1,D2
               MOVE.B      #$0D,D1
               JMP         MOVEMSwapList
CSwap        
               CMP.B       #$0C,D1
               BNE         DSwap
               SUB.W       D1,D2
               MOVE.B      #$03,D1
               JMP         MOVEMSwapList
DSwap        
               CMP.B       #$0D,D1
               BNE         ESwap
               SUB.W       D1,D2
               MOVE.B      #$0B,D1
               JMP         MOVEMSwapList
ESwap        
               CMP.B       #$0E,D1
               BNE         FSwap
               SUB.W       D1,D2
               MOVE.B      #$07,D1
               JMP         MOVEMSwapList
FSwap
               CMP.B       #$0F,D1
               BNE         MOVEMSwapList
               SUB.W       D1,D2
               JMP         MOVEMSwapList                         
*******************************************************************************************         
*DESTINATION REGISTER NUMBER
dRegister
                LEA     dr_table,A0
                CLR.L   D0
                MOVE.W  D2,D0
                
                CMP.L   #$0, D3         *if instruction is BCHG, need to rearrange
                BEQ     BCHGdRegister   *to identify right dRegister
                CMP.L   #$08, D3
                BEQ     BCHGdRegister


                MOVE.W  D2,D0
                MOVE.B  #drShift,D1
                LSL.W   D1,D0
                MOVE.B  #shift2,D1
                LSR.W   D1,D0
                
                MULU    #6,D0
                JSR     0(A0,D0) 
BCHGdRegister
                MOVE.B  #shift2,D1
                LSL.W   D1,D0
                LSR.W   D1,D0
                
                MULU    #6,D0
                JSR     0(A0,D0)
                 
dr_table        JMP     dregister000                
                JMP     dregister001
                JMP     dregister010
                JMP     dregister011
                JMP     dregister100
                JMP     dregister101
                JMP     dregister110
                JMP     dregister111   
   
dregister000     
                MOVE.B  #$0,D7
                BRA     dMode
dregister001     
                MOVE.B  #$1,D7
                BRA     dMode
dregister010    
                MOVE.B  #$2,D7
                BRA     dMode
dregister011    
                MOVE.B  #$3,D7
                BRA     dMode
dregister100    
                MOVE.B  #$4,D7
                BRA     dMode
dregister101     
                MOVE.B  #$5,D7
                BRA     dMode
dregister110     
                MOVE.B  #$6,D7
                BRA     dMode
dregister111     
                MOVE.B  #$7,D7
                BRA     dMode
*******************************************************************************************   
dMode           
                LEA     dm_table,A0
                CLR.L   D0
                MOVE.W  D2,D0

                CMP.L   #$0, D3         *if instruction is BCHG, need to rearrange
                BEQ     BCHGdMode       *to identify right dRegister
                CMP.L   #$08, D3
                BEQ     BCHGdMode

                MOVE.B  #dmShift,D1
                LSL.W   D1,D0
                MOVE.B  #shift2,D1
                LSR.W   D1,D0
                
                MULU    #6,D0
                JSR     0(A0,D0)

BCHGdMode
                MOVE.W  D2,D0
                MOVE.B  #smShift,D1
                LSL.W   D1,D0
                MOVE.B  #shift2,D1
                LSR.W   D1,D0
                
                MULU    #6,D0
                JSR     0(A0,D0)
                
dm_table              
                JMP     dmode000                
                JMP     dmode001
                JMP     dmode010
                JMP     dmode011
                JMP     dmode100
                JMP     dmode101
                JMP     dmode110
                JMP     dmode111   
                
dmode000         
                MOVE.W  #%000,D6
                BRA     sMode
dmode001
                MOVE.W  #%001,D6
                CMP.L   #$1,D3
                BEQ     NotApplicable
                CMP.L   #$2,D3
                BEQ     NotApplicable
                CMP.L   #$3,D3
                BEQ     NotApplicable

                BRA     sMode
dmode010
                MOVE.W  #%010,D6
                BRA     sMode
dmode011
                MOVE.W  #%011,D6
                CMP.L   #$D,D3
                BEQ     NotApplicable
                BRA     sMode
dmode100
                MOVE.W  #%100,D6
                BRA     sMode
dmode101
                MOVE.W  #%101,D6
                BRA     sMode
dmode110
                MOVE.W  #%110,D6
                BRA     sMode
dmode111                
                MOVE.W  #%111,D6
                CMP.L   #$D,D3
                BEQ     NotApplicable
                BRA     sMode
                
*******************************************************************************************           
sMode           LEA     sm_table,A0
                CLR.L   D0

                CMP.L   #$0, D3         *if instruction is BCHG, need to rearrange
                BEQ     sRegister       *to identify right dRegister
                CMP.L   #$08, D3
                BEQ     sRegister

                MOVE.W  D2,D0
                MOVE.B  #smShift,D1
                LSL.W   D1,D0
                MOVE.B  #shift2,D1
                LSR.W   D1,D0
                
                MULU    #6,D0
                JSR     0(A0,D0)
                
sm_table              
                JMP     smode000                
                JMP     smode001
                JMP     smode010
                JMP     smode011
                JMP     smode100
                JMP     smode101
                JMP     smode110
                JMP     smode111
                
smode000         
                MOVE.W  #%000,D5
                BRA     sRegister
smode001
                MOVE.W  #%001,D5
                BRA     sRegister
smode010
                MOVE.W  #%010,D5
                BRA     sRegister
smode011
                MOVE.W  #%011,D5
                BRA     sRegister
smode100
                MOVE.W  #%100,D5
                BRA     sRegister
smode101
                MOVE.W  #%101,D5
                BRA     sRegister
smode110
                MOVE.W  #%110,D5
                BRA     sRegister
smode111                
                MOVE.W  #%111,D5
                BRA     sRegister
                
********************************************************************************************** 
sRegister           
                LEA     sr_table,A0
                CLR.L   D0
                MOVE.W  D2,D0

                CMP.L   #$0, D3         *if instruction is BCHG, can skip to sRegister
                BEQ     BCHGsRegister
                CMP.L   #$08, D3
                BEQ     StartPrintingEverything

                MOVE.B  #shift2,D1
                LSL.W   D1,D0
                LSR.W   D1,D0
                
                MULU    #6,D0
                JSR     0(A0,D0)

BCHGsRegister
                MOVE.B  #drShift,D1
                LSL.W   D1,D0
                MOVE.B  #shift2,D1
                LSR.W   D1,D0
                
                MULU    #6,D0
                JSR     0(A0,D0)

sr_table              
                JMP     sregister000                
                JMP     sregister001
                JMP     sregister010
                JMP     sregister011
                JMP     sregister100
                JMP     sregister101
                JMP     sregister110
                JMP     sregister111

sregister000       
                MOVE.W  #$0,D4
                BRA     StartPrintingEverything
sregister001
                MOVE.W  #$1,D4
                BRA     StartPrintingEverything
sregister010
                MOVE.W  #$2,D4
                BRA     StartPrintingEverything
sregister011
                MOVE.W  #$3,D4
                BRA     StartPrintingEverything
sregister100
                MOVE.W  #$4,D4
                BRA     StartPrintingEverything
sregister101
                MOVE.W  #$5,D4
                BRA     StartPrintingEverything
sregister110
                MOVE.W  #$6,D4
                BRA     StartPrintingEverything
sregister111
                MOVE.W  #$7,D4
                BRA     StartPrintingEverything

**********************************************************************************************
StartPrintingEverything
printingInstruction
isBCHG
                CMP.L       #$0,D3
                BNE         isBCHGd
                LEA         BchgMess,A1
                JSR         print
                BRA         printingSize

isBCHGd
                CMP.L       #$08,D3
                BNE         isMOVEB
                LEA         BchgMess,A1
                JSR         print
                BRA         printingSize
                
isMOVEB
                CMP.L       #$1,D3
                BNE         isMOVEL
                LEA         MoveBM,A1
                JSR         print
                BRA         printingSize   
isMOVEL
                CMP.L       #$2,D3
                BNE         isMOVEW
                LEA         MoveLM,A1
                JSR         print
                BRA         printingSize
isMOVEW
                CMP.L       #$3,D3
                BNE         isJSR
                LEA         MoveWM,A1
                JSR         print
                BRA         printingSize
isJSR
                CMP.L       #$4E,D3
                BNE         isNOT
                LEA         JsrMess,A1
                JSR         print
                BRA         printingSize 
isNOT           
                CMP.L       #$46,D3
                BNE         isBCS8Bit
                LEA         NotMess,A1
                JSR         print
                BRA         printingSize
isBCS8Bit           
                CMP.L       #$658,D3
                BNE         isBCS16Bit
                LEA         BcsMess,A1
                JSR         print
                BRA         printingSize
isBCS16Bit           
                CMP.L       #$6516,D3
                BNE         isCMP
                LEA         BcsMess,A1
                JSR         print
                BRA         printingSize
isCMP          
                CMP.L       #$B,D3
                BNE         isAND
                LEA         CmpMess,A1
                JSR         print
                BRA         printingSize
isAND           
                CMP.L       #$C,D3
                BNE         isADD
                LEA         AndMess,A1
                JSR         print
                BRA         printingSize
isADD           
                CMP.L       #$D,D3
                BNE         isRTS
                LEA         AddMess,A1
                JSR         print
                BRA         printingSize
isRTS
                CMP.L       #$4E75,D3
                BNE         NotApplicable 
                LEA         RtsMess,A1
                JSR         print
                BRA         printingSize
printingSize
                CMP.B       #$D, D3                 *Go here to print size if ADD
                BEQ         printingSizeOpmode
                CMP.B       #$C, D3                 *Go here to print size if AND
                BEQ         printingSizeOpmode
                CMP.B       #$B, D3                 *Go here to print size if CMP
                BEQ         printingSizeOpmode
                CMP.L       #$46, D3                *Go here to print size if NOT
                BEQ         printingSizeOpmode
                CMP.L       #$0, D3
                BEQ         checkingBCHGsize
                CMP.L       #$08, D3
                BEQ         checkingBCHGsize
                BRA         printingSource
                
printingDestination
                CMP.L       #$46,D3                 *Skips if NOT
                BEQ         increment
                CMP.L       #$4E,D3                 *Skips if JSR
                BEQ         increment

                LEA         SpaceM, A1          *Prints ", "
                MOVE.B      #14, D0
                TRAP        #15
                
                CMP.L       #$FFFFFFFF,D7           *Checks for MOVEM
                BEQ         MOVEMCheck
               
                BRA         printingDestinationAll
increment
                ADDA.L      #$2,A6
GoBackToLoadAnother
                BRA         loading
**********************************************************************************************
ClearScreen0
                MOVE.L      #$0000,counter
                JMP         loading
ClearScreen
                MOVE.L      #$0000,counter
ClearScreen1
                LEA         Enter, A1           *Enter Message
                MOVE.B      #14, D0
                TRAP        #15

                MOVEA.L     #$00000000, A1
                MOVE.B      #2, D0              *Takes in input
                TRAP        #15
ClearScreen2
                CMP.W       #$0020,counter
                BGE         loading
                
                LEA         PrintEnter,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                ADD.W       #$01,counter
                MOVE.W      counter,D0
                JMP         ClearScreen2
**********************************************************************************************
checkingBCHGsize
                CMP.W       #%000,D6
                BEQ         printingLong
                BRA         printingByte

printingSizeOpmode
ByteSomeDn  *Dn is destination
                CMP.B       #$0, D6
                BNE         WordSomeDn
printingByte
                LEA         BSize, A1                  *Prints .B
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.B      #$1,DataSize

                CMP.L       #$0, D3
                BEQ         printingSource
                CMP.L       #$08, D3
                BEQ         printingSource

                MOVE.L      #$0, D6
                BRA         printingSource
                
WordSomeDn
                CMP.B       #$1, D6
                BNE         LongSomeDn
                LEA         WSize, A1                  *Prints .W
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.B      #$3,DataSize

                MOVE.L      #$0, D6
                BRA         printingSource
                
LongSomeDn
                CMP.B       #$2, D6
                BNE         ByteDnSome
printingLong
                LEA         LSize, A1                  *Prints .L
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.B      #$2,DataSize

                CMP.L       #$0, D3
                BEQ         printingSource
                CMP.L       #$08, D3
                BEQ         printingSource

                MOVE.L      #$0, D6
                BRA         printingSource
                
ByteDnSome  *Dn is source
                CMP.B       #$4, D6
                BNE         WordDnSome
                LEA         BSize, A1                  *Prints .B
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.B      #$1,DataSize
                
                MOVE.L      #$0, D6                    *Makes it print Dn as source correctly
                EXG.L       D6, D5
                EXG.L       D7, D4
                BRA         printingSource

WordDnSome
                CMP.B       #$5, D6
                BNE         LongDnSome
                LEA         WSize, A1                  *Prints .W
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.B      #$3,DataSize

                MOVE.L      #$0, D6
                EXG.L       D6, D5
                EXG.L       D7, D4
                BRA         printingSource

LongDnSome
                CMP.B       #$6, D6
                BNE         SizeError
                LEA         LSize, A1                  *Prints .L
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.B      #$1,DataSize

                MOVE.L      #$0, D6
                EXG.L       D6, D5
                EXG.L       D7, D4
                BRA         printingSource

******PUT ERROR IF DOESN"T MATCH FOR ANY*****
SizeError
                LEA         SmallSpace, A1                  *Prints spaces
                MOVE.B      #14, D0
                TRAP        #15
                BRA         printingSource

**********************************************************************************************
printingSource
printDnSource   
                CMP.B       #$0, D5
                BNE         printAnSource
                LEA         MessDn, A1                  *Prints D
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D4, SourceReg               *Print Source Mode Number by first set variable
                MOVE.L      SourceReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                BRA         printingDestination

printAnSource   
                CMP.B       #$1, D5                     
                BNE         printBracketAnSource        
                LEA         MessAn, A1                  *Prints A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D4, SourceReg               *Print Source Mode Number by first set variable
                MOVE.L      SourceReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                BRA         printingDestination
                
printBracketAnSource
                CMP.B       #$2, D5
                BNE         printBracketAnPlusSource
                LEA         MessBracAn, A1              *Prints (A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D4, SourceReg               *Print Source Mode Number by first set variable
                MOVE.L      SourceReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                LEA         MessBracClose, A1           *Prints )
                MOVE.B      #14, D0
                TRAP        #15
                BRA         printingDestination
                
printBracketAnPlusSource
                CMP.B       #$3, D5
                BNE         printBracketAnMinusSource
                LEA         MessBracAn, A1              *Prints (A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D4, SourceReg               *Print Source Mode Number by first set variable
                MOVE.L      SourceReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                LEA         MessBracCloseAdd, A1        *Prints )+
                MOVE.B      #14, D0
                TRAP        #15
                BRA         printingDestination

printBracketAnMinusSource
                CMP.B       #$4, D5
                BNE         printAbsoluteWordSource     *

                LEA         MessBracOpenSub, A1         *Prints -(A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D4, SourceReg               *Print Source Mode Number by first set variable
                MOVE.L      SourceReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                LEA         MessBracClose, A1           *Prints )
                MOVE.B      #14, D0
                TRAP        #15
                BRA         printingDestination
    
printAbsoluteWordSource   
                CMP.B       #$7, D5                    
                BNE         printERRORSource
                CMP.B       #$2, D4
                BEQ         printERRORSource
                CMP.B       #$3, D4
                BEQ         printERRORSource           
                CMP.B       #$0, D4
                BNE         printAbsoluteLongSource    

                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15
                                                         *Print the (xxx).W
                *ADDA.L      #$2, A6                      *Moves to the word address
                MOVE.B      #$1, AddressSize             *Sets address size as word
                MOVEM.L     A6, -(SP)
                MOVEA.L     (A6),A6
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                ADDA.L      #$2, A6
                                                         *Do in the destination if needed (assumes will indent)
                BRA         printingDestination
                
printAbsoluteLongSource 
                CMP.B       #$1, D4
                BNE         printDirectDataSource       
                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15
                
                CMP.L       #658,D3
                BEQ         printingTarget
                CMP.L       #$6516,D3
                BEQ         printingTarget
                CMP.L       #$6532,D3
                BEQ         printingTarget

                                                         *Print the (xxx).L
                ADDA.L      #$2, A6                      *Moves to the long address
                BRA         printingLongAddress
                
printingTarget  
                MOVE.B      #$2, AddressSize
                MOVEA.L     A6,A3
                MOVEA.L     D1,A6
                
                MOVEM.L     A6, -(SP)

                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                MOVEA.L     A3, A6
                CMP.L       #$6516,D3
                BEQ         increment16Bit
                CMP.L       #$6532,D3
                BEQ         increment32Bit
                ADDA.L      #$2, A6 
                BRA         loading
                
increment16Bit               
                ADDA.L      #$4, A6 
                BRA         loading
increment32Bit
                ADDA.L      #$6, A6
                BRA         loading


printingLongAddress
                MOVE.B      #$2, AddressSize             *Sets address size as long
                MOVEM.L     A6, -(SP)
                MOVEA.L     (A6), A6
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                
                ADDA.L      #$2, A6                      *Also +2 in the destination if needed (assumes will indent)
                
                BRA         printingDestination

printDirectDataSource
                CMP.B       #$4, D4
                BNE         printERRORSource
                LEA         MessImmediate, A1           *Prints #$
                MOVE.B      #14, D0
                TRAP        #15

                CMP.B       #$1,DataSize
                BEQ         printDirectDataSourceByte
                CMP.B       #$3,DataSize
                BEQ         printDirectDataSourceWord
                CMP.B       #$2,DataSize
                BEQ         printDirectDataSourceLong
                BRA         printERRORSource

 
                *COMPARE SIZE if size is .B set AddressSize to 0 and go to subroutine
                *COMPARE SIZE if size is .W set AddressSize to 1 and go to subroutine
                *COMPARE SIZE if size is .L set AddressSize to 2 and go to subroutine

printDirectDataSourceByte
                *ADDA.L      #$2, A6                      *Moves to the byte address
                MOVE.B      #$0, AddressSize             *Sets address size as byte
                MOVEM.L     A6, -(SP)
                MOVEA.L     (A6), A6
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                ADDA.L      #$2, A6
                BRA         printingDestination


printDirectDataSourceWord
                *ADDA.L      #$2, A6                      *Moves to the word address
                MOVE.B      #$1, AddressSize             *Sets address size as word
                MOVEM.L     A6, -(SP)
                MOVEA.L     (A6), A6
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                ADDA.L      #$2, A6
                BRA         printingDestination

printBCHGdirectDataSourceLong
                MOVEA.W     (A6),A6
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                                     
                BRA         printingDestination

printDirectDataSourceLong
                                                         *Print the (xxx).L
                ADDA.L      #$2, A6                      *Moves to the long address
                MOVE.B      #$2, AddressSize             *Sets address size as long
                MOVEM.L     A6, -(SP)
                CMP.B       #$08,D3
                BEQ         printBCHGdirectDataSourceLong

                MOVEA.L     (A6), A6
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                ADDA.L      #$2, A6                      *Also +2 in the destination if needed (assumes will indent)
                BRA         printingDestination

printERRORSource      
                LEA         PlainERRORM,A1          *Display Error Message
                MOVE.B      #14, D0
                TRAP        #15
                                                
                CMP.B       #$05,D5
                BLT         printingDestination
                
                ADDA.L      #$0002,A6
                BRA         printingDestination
                
**********************************************************************************************
printingDestinationAll
printDnDestin   
                CMP.B       #$0, D6
                BNE         printAnDestin
                LEA         MessDn, A1                  *Prints D
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D7, DestinReg               *Print Destin Mode Number by first set variable
                MOVE.L      DestinReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                ADDA.L      #$2, A6
                BRA         loading

printAnDestin   
                CMP.B       #$1, D6                     
                BNE         printBracketAnDestin        
                LEA         MessAn, A1                  *Prints A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D7, DestinReg               *Print Destin Mode Number by first set variable
                MOVE.L      DestinReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                ADDA.L      #$2, A6
                BRA         loading
                
printBracketAnDestin
                CMP.B       #$2, D6
                BNE         printBracketAnPlusDestin
                LEA         MessBracAn, A1              *Prints (A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D7, DestinReg               *Print Destin Mode Number by first set variable
                MOVE.L      DestinReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                LEA         MessBracClose, A1           *Prints )
                MOVE.B      #14, D0
                TRAP        #15
                ADDA.L      #$2, A6
                BRA         loading
                
printBracketAnPlusDestin
                CMP.B       #$3, D6
                BNE         printBracketAnMinusDestin
                LEA         MessBracAn, A1              *Prints (A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D7, DestinReg               *Print Destin Mode Number by first set variable
                MOVE.L      DestinReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                LEA         MessBracCloseAdd, A1        *Prints )+
                MOVE.B      #14, D0
                TRAP        #15
                ADDA.L      #$2, A6
                BRA         loading

printBracketAnMinusDestin
                CMP.B       #$4, D6
                BNE         printAbsoluteWordDestin     *
                LEA         MessBracOpenSub, A1         *Prints -(A
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      D7, DestinReg               *Print Destin Mode Number by first set variable
                MOVE.L      DestinReg,D1                *Print variable
                MOVE.B      #3,D0
                TRAP        #15
                LEA         MessBracClose, A1           *Prints )
                MOVE.B      #14, D0
                TRAP        #15
                ADDA.L      #$2, A6
                BRA         loading
                
                
printAbsoluteWordDestin   
                CMP.B       #$7, D6                     
                BNE         printERRORDestin            
                CMP.B       #$0, D7
                BNE         printAbsoluteLongDestin     
                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15
                                                         *Print the (xxx).W
                *ADDA.L      #$2, A6                      *Moves to the word address
                MOVE.B      #$1, AddressSize             *Sets address size as word
                MOVEM.L     A6, -(SP)
                MOVEA.L     (A6), A6
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                ADDA.L      #$2, A6
                                                         *Do in the destination if needed (assumes will indent)
                BRA         increment
                
printAbsoluteLongDestin 
                CMP.B       #$1, D7
                BNE         printDirectDataDestin       
                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15
                                                         *Print the (xxx).L
                ADDA.L      #$2, A6                      *Moves to the long address
                MOVE.B      #$2, AddressSize             *Sets address size as long
                MOVEM.L     A6, -(SP)
                MOVEA.L     (A6), A6
                
                JSR         PrintingAddresses            *Go here to print address
                MOVEM.L     (SP)+, A6
                ADDA.L      #$2, A6                      *Also +2 in the destination if needed (assumes will indent)
                
                BRA         increment

printDirectDataDestin
                CMP.B       #$4, D7
                BNE         printERRORDestin       *
                LEA         MessImmediate, A1           *Prints #$
                MOVE.B      #14, D0
                TRAP        #15

*                MOVE.L      D4, DestinReg              *Print the #<data>
*                MOVE.L      DestinReg,D1                
*                MOVE.B      #3,D0
*                TRAP        #15
                BRA         loading

printERRORDestin      
                LEA         PlainERRORM,A1          *Display Error Message
                MOVE.B      #14, D0
                TRAP        #15
                
                CMP.B       #$05,D6
                BLT         loading
                
                ADDA.L      #$0004,A6
                BRA         loading
                

**********************************************************************************************
PrintingAddresses
        MOVEM.L D0/D2/D3/D4, -(SP)
        CLR.L   D0
        CLR.L   D2                      D2 is counter
        CLR.L   D3                      Place to put address
        CLR.L   D4                      Temp place to put part of address
        
        MOVE.L  A6, D3
        BRA WordOrLong
        
GoBytePrint
        MOVE.B  #$6, D2
        ROL.L   #8, D3
        ROL.L   #8, D3
        ROL.L   #8, D3
        BRA     NextValue
        
WordOrLong
        CMP.B   #$0, AddressSize        0 for print byte
        BEQ     GoBytePrint
        CMP.B   #$2, AddressSize        1 for print word   2 for print long
        BEQ     NextValue
        MOVE.B  #$4, D2
        ROL.L   #8, D3
        ROL.L   #8, D3
        BRA     NextValue
        
NextValue
        ROL.L   #4,D3
        MOVE.B  D3,D4
        ASL.B   #4,D4
        CMP.B   #8,D2
        BEQ     DonePrintingData
        BRA     printing_register_data
    
printing_register_data
Hex0print
        CMP.B   #$00,D4
        BNE     Hex1print   
        LEA     Hex0, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue        
Hex1print
        CMP.B   #$10,D4
        BNE     Hex2print   
        LEA     Hex1, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex2print
        CMP.B   #$20,D4
        BNE     Hex3print   
        LEA     Hex2, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex3print
        CMP.B   #$30,D4
        BNE     Hex4print   
        LEA     Hex3, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex4print
        CMP.B   #$40,D4
        BNE     Hex5print   
        LEA     Hex4, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex5print
        CMP.B   #$50,D4
        BNE     Hex6print   
        LEA     Hex5, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex6print
        CMP.B   #$60,D4
        BNE     Hex7print   
        LEA     Hex6, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex7print
        CMP.B   #$70,D4
        BNE     Hex8print   
        LEA     Hex7, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex8print
        CMP.B   #$80,D4
        BNE     Hex9print   
        LEA     Hex8, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
Hex9print
        CMP.B   #$90,D4
        BNE     HexAprint   
        LEA     Hex9, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
HexAprint
        CMP.B   #$A0,D4
        BNE     HexBprint   
        LEA     HexA, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
HexBprint
        CMP.B   #$B0,D4
        BNE     HexCprint   
        LEA     HexB, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
HexCprint
        CMP.B   #$C0,D4
        BNE     HexDprint   
        LEA     HexC, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
HexDprint
        CMP.B   #$D0,D4
        BNE     HexEprint   
        LEA     HexD, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
HexEprint
        CMP.B   #$E0,D4
        BNE     HexFprint   
        LEA     HexE, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
HexFprint
        CMP.B   #$F0,D4
        BNE     ErrorAddress   
        LEA     HexF, A1         
        JSR     print
        ADD.B   #1,D2
        BRA     NextValue
HexError  
        LEA     Hex0, A1         
        JSR     print
        ADD.B   #1,D2
print
        MOVE.B  #14, D0
        TRAP    #15
        RTS
    
DonePrintingData
        MOVE.B  1, AddressSize
        MOVEM.L (SP)+, D0/D2/D3/D4
        RTS
        
**********************************************************************************************
Fin
        LEA         EndMess,A1          *Display Message
        MOVE.B      #14,D0
        Trap        #15
        BRA         DoAgain             *Branch to DoAgain
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
        MOVEA.L     #$00000000, A5      *Clear ending address
        MOVE.L      #$00000000, D2      *Clear
        MOVE.L      #$00000000, D3      *Clear note saying input finished properly
        MOVE.L      #$00000000, D4      *Clear
        MOVE.L      #$00000000, D5      *Clear
        CLR.L       D6
        CLR.L       D7
        BRA         StartAddress
        
No      CMP.W       #$4E00, (A1)          *If equal N, then end
        BNE         AgainEr
        BRA         End
        
AgainEr MOVEA.L     #$00000000, A1      *If invalid, then clear input and ask again
        LEA         Invalid, A1         *Outputs the Invalid
        MOVE.B      #14, D0
        TRAP        #15
        BRA         DoAgain             *Asks again
**********************************************************************************************    



End    SIMHALT             ; halt simulator


* Put variables and constants here
CR      EQU     $0D
LF      EQU     $0A
Welcome DC.B    'Welcome to 68k Disassembler',CR,LF,0
StartM  DC.B    CR,LF,'Enter a STARTING address: ',0
EndM    DC.B    CR,LF,'Enter an ENDING address: ',0
NA      DC.B    'DATA      $',0
Enter   DC.B    CR,LF,'Press Enter to clear screen: ',0



PrintEnter   DC.B    CR,LF,'',0
NewLine      DC.B    ' ',CR,LF,0

Invalid DC.B    'Invalid Input',CR,LF,0
OrderEr DC.B    'STARTING Address must be less than ENDING Address',CR,LF,0
Done    DC.B    CR,LF,'Processing Completed',CR,LF,0
AgainM  DC.B    'Do you want to disassemble again? (Y/N): ',0

FourCheckMess DC.B 'This Command starts with a four',CR,LF,0
BchgMess DC.B   'BCHG',0

PlainERRORM DC.B   'ERROR',0

MoveBM DC.B     'MOVE.B    ',0
MoveLM DC.B     'MOVE.L    ',0
MoveWM DC.B     'MOVE.W    ',0

BcsMess DC.B    'BCS       ',0
CmpMess DC.B    'CMP',0
AndMess DC.B    'AND',0
AddMess DC.B    'ADD',0

NotMess DC.B    'NOT',0
NotBM DC.B      'NOT.B    ',0
NotWM DC.B      'NOT.W    ',0
NotLM DC.B      'NOT.L    ',0

MovemMess DC.B  'MOVEM',0
JsrMess DC.B    'JSR      ',0
RtsMess DC.B    'RTS',0
ErrMess DC.B    'Not a valid Command',CR,LF,0
EndMess DC.B    CR,LF,CR,LF,'End of Script',CR,LF,0


BigSpace DC.B   '       ',0
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
MessBackSlash  DC.B    '/',0

SourceReg   DC.L    1
DestinReg   DC.L    1


Hex0    DC.B   '0',0
Hex1    DC.B   '1',0
Hex2    DC.B   '2',0
Hex3    DC.B   '3',0
Hex4    DC.B   '4',0
Hex5    DC.B   '5',0
Hex6    DC.B   '6',0
Hex7    DC.B   '7',0
Hex8    DC.B   '8',0
Hex9    DC.B   '9',0
HexA    DC.B   'A',0
HexB    DC.B   'B',0
HexC    DC.B   'C',0
HexD    DC.B   'D',0
HexE    DC.B   'E',0
HexF    DC.B   'F',0

An7     DC.B   'A7',0
An6     DC.B   'A6',0
An5     DC.B   'A5',0
An4     DC.B   'A4',0
An3     DC.B   'A3',0
An2     DC.B   'A2',0
An1     DC.B   'A1',0
An0     DC.B   'A0',0

Dn7     DC.B   'D7',0
Dn6     DC.B   'D6',0
Dn5     DC.B   'D5',0
Dn4     DC.B   'D4',0
Dn3     DC.B   'D3',0
Dn2     DC.B   'D2',0
Dn1     DC.B   'D1',0
Dn0     DC.B   'D0',0


SmallSpace DC.B '      ',0
OddEr   DC.B    'STARTING and ENDING Address must not be odd',CR,LF,0

ErrorAddress   DC.B   CR,LF,'Error',0
AddressSize     DC.B    1
SizeOfCurrent   DC.B    0
DataSize        DC.B    0


Instructions DC.B    CR,LF,'Instructions for inputting STARTING and ENDING Addresses:',CR,LF
        DC.B    '  Addresses must not be odd.',CR,LF
        DC.B    '  Addresses must be in hexadecimal.',CR,LF
        DC.B    '  Addresses must contain at least one character.',CR,LF
        DC.B    '  Addresses must be less than or equal to 8 characters long.',CR,LF
        DC.B    '  STARTING Address must be less than or equal to ENDING Address.',CR,LF,CR,LF,0   
 
    SIMHALT             ; halt simulator

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
