                 ORG     $1000
                 
start
*******************************************
        MOVE.B (A0), D2
        MOVE.L (A3)+, -(A4)
        
        MOVE.W      D0,(A5)
        SUB.L       D4,D2       *invalid opcode

        MOVE.B      D3,(A4)
        MOVE.L      D2,(A3)
        CMP.B       D1, D2

        NOT.B       D1
        NOT.W       D5
        NOT.L       D2
        NOT.B       (A1)
        NOT.W       (A5)+
        NOT.L       -(A3)
        

*******************************************


beginning   
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

loading               
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
               LEA         BchgMess,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister
code0001       
               MOVE.L      #$1, D3
               LEA         MoveBM,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister
code0010       
               MOVE.L      #$2, D3
               LEA         MoveLM,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister
code0011       
               MOVE.L      #$3, D3
               LEA         MoveWM,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister

code0100       BRA         FourCheck
               
code0101       BRA         NotApplicable

code0110       
               MOVE.L      #$6, D3
               LEA         BcsMess,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister
               
code0111       BRA         NotApplicable
code1000       BRA         NotApplicable
code1001       BRA         NotApplicable
code1010       BRA         NotApplicable

code1011       
               MOVE.L      #$B, D3
               LEA         CmpMess,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister

code1100       
               MOVE.L      #$C, D3
               LEA         AndMess,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister

code1101       
               MOVE.L      #$D, D3
               LEA         AddMess,A1
               MOVE.B      #14,D0
               TRAP        #15
               BRA         dRegister
               
code1110       BRA         NotApplicable
code1111       BRA         NotApplicable

NotApplicable   
               LEA         NA,A1
               MOVE.B      #14,D0
               TRAP        #15
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
               BEQ     RTSVal
               
               CMP.B   #$06,D0
               BEQ     NOTVal
               
RTSVaL
               CLR.L   D0

               MOVE.W  D2,D0
               LSL.W   #8,D0
               MOVE.B  #shift,D1
               LSR.W   D1,D0
               CMP.B   #$07,D0
               BNE     Error
               
               CLR.L   D0
               MOVE.W  D2,D0
               MOVE.B  #shift,D1
               LSL.W   D1,D0
               MOVE.B  #shift,D1
               LSR.W   D1,D0
               CMP.B   #$05,D0
               BNE     Error
                
               LEA         RtsMess,A1
               MOVE.B      #14,D0
               TRAP        #15

               ADDA.L      #$2, A6
               BRA         loading

NOTVal
               LEA         NotMess,A1
               MOVE.B      #14,D0
               TRAP        #15
               
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
*DESTINATION REGISTER NUMBER
dRegister
                LEA     dr_table,A0
                CLR.L   D0
                MOVE.W  (A6),D2
                MOVE.W  D2,D0
                MOVE.B  #drShift,D1
                LSL.W   D1,D0
                MOVE.B  #shift2,D1
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
dMode           LEA     dm_table,A0
                CLR.L   D0
                MOVE.W  D2,D0
                MOVE.B  #dmShift,D1
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
                BRA     sMode
dmode010
                MOVE.W  #%010,D6
                BRA     sMode
dmode011
                MOVE.W  #%011,D6
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
                BRA     sMode
                
*******************************************************************************************           
sMode           LEA     sm_table,A0
                CLR.L   D0
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
                MOVE.B  #shift2,D1
                LSL.W   D1,D0
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

printingSize
                CMP.B       #$D, D3                 *Go here to print size if ADD
                BEQ         printingSizeOpmode
                CMP.B       #$C, D3                 *Go here to print size if AND
                BEQ         printingSizeOpmode
                CMP.B       #$B, D3                 *Go here to print size if CMP
                BEQ         printingSizeOpmode
                CMP.L       #$46, D3                *Go here to print size if NOT
                BEQ         printingSizeOpmode
                BRA         printingSource

printingSource
                CMP.B       #$4, D3
                BEQ         printingSourceAll
                BRA         printingSourceAll
                
printingDestination
                CMP.L       #$46,D3
                BEQ         increment

                LEA         SpaceM, A1          *Prints ", "
                MOVE.B      #14, D0
                TRAP        #15
                BRA         printingDestinationAll
increment
                ADDA.L      #$2,A6
                BRA         loading


**********************************************************************************************
printingSizeOpmode
ByteSomeDn  *Dn is destination
                CMP.B       #$0, D6
                BNE         WordSomeDn
                LEA         BSize, A1                  *Prints .B
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      #$0, D6
                BRA         printingSource
                
WordSomeDn
                CMP.B       #$1, D6
                BNE         LongSomeDn
                LEA         WSize, A1                  *Prints .W
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      #$0, D6
                BRA         printingSource
                
LongSomeDn
                CMP.B       #$2, D6
                BNE         ByteDnSome
                LEA         LSize, A1                  *Prints .L
                MOVE.B      #14, D0
                TRAP        #15
                MOVE.L      #$0, D6
                BRA         printingSource
                
ByteDnSome  *Dn is source
                CMP.B       #$4, D6
                BNE         WordDnSome
                LEA         BSize, A1                  *Prints .B
                MOVE.B      #14, D0
                TRAP        #15
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
                MOVE.L      #$0, D6
                EXG.L       D6, D5
                EXG.L       D7, D4
                BRA         printingSource

******PUT ERROR IF DOESN"T MATCH FOR ANY*****
SizeError
                BRA         printingSource

**********************************************************************************************
printingSourceAll
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
                BNE         printAnSource               *
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
                CMP.B       #$7, D5                     *
                BNE         printERRORSource            *
                CMP.B       #$0, D4
                BNE         printAbsoluteLongSource     *
                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15
                
*                MOVE.L      D4, SourceReg              *Print the (xxx).W
*                MOVE.L      SourceReg,D1                
*                MOVE.B      #3,D0
*                TRAP        #15
                ADDA.L      #$4, A6
                BRA         printingDestination
                
printAbsoluteLongSource 
                CMP.B       #$1, D4
                BNE         printDirectDataSource       *
                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15

*                MOVE.L      D4, SourceReg              *Print the (xxx).L
*                MOVE.L      SourceReg,D1                
*                MOVE.B      #3,D0
*                TRAP        #15
                ADDA.L      #$8, A6
                BRA         printingDestination

printDirectDataSource
                CMP.B       #$4, D4
                BNE         printDirectDataSource       *
                LEA         MessImmediate, A1           *Prints #$
                MOVE.B      #14, D0
                TRAP        #15

*                MOVE.L      D4, SourceReg              *Print the #<data>
*                MOVE.L      SourceReg,D1                
*                MOVE.B      #3,D0
*                TRAP        #15
                BRA         printingDestination

printERRORSource      
*                CMP.B       #$1, D5                     *
*                BNE         printAnSource               *
*                LEA         MessAn, A1                  *Prints A *
*                MOVE.B      #14, D0
*                TRAP        #15
*                MOVE.L      D4, SourceReg               *Print Source Mode Number by first set variable
*                MOVE.L      SourceReg,D1                *Print variable
*                MOVE.B      #3,D0
*                TRAP        #15
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
                BNE         printAnDestin               *
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
                CMP.B       #$7, D6                     *
                BNE         printERRORDestin            *
                CMP.B       #$0, D7
                BNE         printAbsoluteLongDestin     *
                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15
                
*                MOVE.L      D4, DestinReg              *Print the (xxx).W
*                MOVE.L      DestinReg,D1                
*                MOVE.B      #3,D0
*                TRAP        #15
                ADDA.L      #$4, A6
                BRA         loading
                
printAbsoluteLongDestin 
                CMP.B       #$1, D7
                BNE         printDirectDataDestin       *
                LEA         MessDollar, A1              *Prints $
                MOVE.B      #14, D0
                TRAP        #15

*                MOVE.L      D4, DestinReg              *Print the (xxx).L
*                MOVE.L      DestinReg,D1                
*                MOVE.B      #3,D0
*                TRAP        #15
                ADDA.L      #$8, A6
                BRA         loading

printDirectDataDestin
                CMP.B       #$4, D7
                BNE         printDirectDataDestin       *
                LEA         MessImmediate, A1           *Prints #$
                MOVE.B      #14, D0
                TRAP        #15

*                MOVE.L      D4, DestinReg              *Print the #<data>
*                MOVE.L      DestinReg,D1                
*                MOVE.B      #3,D0
*                TRAP        #15
                BRA         loading

printERRORDestin      
*                CMP.B       #$1, D5                     *
*                BNE         printAnDestin               *
*                LEA         MessAn, A1                  *Prints A *
*                MOVE.B      #14, D0
*                TRAP        #15
*                MOVE.L      D4, DestinReg               *Print Destin Mode Number by first set variable
*                MOVE.L      DestinReg,D1                *Print variable
*                MOVE.B      #3,D0
*                TRAP        #15
                BRA         loading
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
NA      DC.B    CR,LF,'DATA $WXYZ',0






Invalid DC.B    'Invalid Input',CR,LF,0
OrderEr DC.B    'STARTING Address must be less than ENDING Address',CR,LF,0
Done    DC.B    CR,LF,'Processing Completed',CR,LF,0
AgainM  DC.B    'Do you want to disassemble again? (Y/N): ',0

FourCheckMess DC.B 'This Command starts with a four',CR,LF,0
BchgMess DC.B   'BCHG',CR,LF,0

MoveBM DC.B     CR,LF,'MOVE.B ',0
MoveLM DC.B     CR,LF,'MOVE.L ',0
MoveWM DC.B     CR,LF,'MOVE.W ',0

BcsMess DC.B    CR,LF,'BCS',0
CmpMess DC.B    CR,LF,'CMP',0
AndMess DC.B    CR,LF,'AND',0
AddMess DC.B    CR,LF,'ADD',0

NotMess DC.B    CR,LF,'NOT',0
NotBM DC.B      CR,LF,'NOT.B ',0
NotWM DC.B      CR,LF,'NOT.W ',0
NotLM DC.B      CR,LF,'NOT.L ',0

MovemMess DC.B  CR,LF,'MOVEM',0
JsrMess DC.B    CR,LF,'JSR',0
RtsMess DC.B    CR,LF,'RTS',0
ErrMess DC.B    'Not a valid Command',CR,LF,0
EndMess DC.B    CR,LF,CR,LF,'End of Script',CR,LF,0



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

SourceReg   DC.L    1
DestinReg   DC.L    1

        
    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~
