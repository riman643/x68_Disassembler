    ORG    $1000
START:                  ; first instruction of program

*Figure out...
*how to print assembly location/data in memory
*how to print the size
*how to do the exceptions
*how to use variables


* Put program code here
        MOVE.L      #$0247000B, D7       *Given
        MOVE.L      D7, D0
    
        MOVE.L      #$00000000, D1      *Place to put the given EA
        MOVE.L      #$00000000, D2      *Place to put temp binary
        MOVEA.L     #$00000000, A0      *Counter
        
        MOVEA.L     #$00000000, A2
        MOVEA.L     #$00000000, A3
        MOVEA.L     #$00000000, A4
        ASL.L       #4, D0              *Shifts bits so if D2 contains $12345678 now contains $23456780
    
    
ProperPlace                             *Used to put each number in its proper place in D1
        ROL.L       #4, D0
        MOVE.B      D0, D1              *Move Most significant Nibble to D1
        MOVE.B      #$0, D0             *Clears and ensures the number being analyzed is always single digit
    
        JSR         BinaryTable         *Converts each number to binary
    
    
    
*Tells where to move the binary number   
FirstNum CMP.W       #$0, A0
        BNE         SecNum
        MOVEA.W      D2, A2
        BRA         ContEA
        
SecNum  CMP.W       #$1, A0
        BNE         ThirdNum
        MOVEA.W      D2, A3
        BRA         ContEA
        
ThirdNum MOVEA.W      D2, A4
        BRA         ContEA
       
        
        
ContEA
        CMP.B       #0, (A0)+           *Increase counter
        CMP.W       #3, A0              *Keeps counter of how many numbers have been analyzed so far
        BNE         ProperPlace
        BRA         Finish
    
    
    
    
BinaryTable
BZero   CMP.B       #$0, D1
        BNE         BOne
        MOVE.W      #$0000, D2
        RTS
        
BOne    CMP.B       #$1, D1
        BNE         BTwo
        MOVE.W      #$0001, D2
        RTS

BTwo    CMP.B       #$2, D1
        BNE         BThree
        MOVE.W      #$0010, D2
        RTS

BThree  CMP.B       #$3, D1
        BNE         BFour
        MOVE.W      #$0011, D2
        RTS

BFour   CMP.B       #$4, D1
        BNE         BFive
        MOVE.W      #$0100, D2
        RTS

BFive   CMP.B       #$5, D1
        BNE         BSix
        MOVE.W      #$0101, D2
        RTS

BSix    CMP.B       #$6, D1
        BNE         BSeven
        MOVE.W      #$0110, D2
        RTS

BSeven  MOVE.W      #$0111, D2
        RTS


        
    

Finish    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~