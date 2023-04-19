start		EQU	$00007000	* ORG and END address


		ORG	start
		
* Put program code here

*Can't have An or #<data> as dest.
*With .B can't have An as source
MOVE.B
    MOVE.B      (A0), D2
    MOVE.B      (A3)+, -(A4)
    MOVE.B      $A234, D5
    MOVE.B      $B2345678, D6
    MOVE.B      #$C2, D7
    
    
MOVE.W
    MOVE.W      A7, D1
    MOVE.W      (A1), D3
    MOVE.W      (A5)+, -(A6)
    MOVE.W      $D567, D2
    MOVE.W      $8E65F432, D4
    MOVE.W      #$9F76, D6


*With .L WARNING possible bug with #<data> going into a Dn with #<data> being less than 5 bits
MOVE.L
    MOVE.L      A0, D0
    MOVE.L      (A2), D7
    MOVE.L      (A6)+, -(A5)
    MOVE.L      $12BB, D3
    MOVE.L      $123456CC, D2
    MOVE.L      #$AAAA1234, D1





*For register to memory: Can't have Dn, An, (An)+, #<data> as dest
*For memory to register: Can't have Dn, An, -(An), #<data> as source
MOVEM.W
    MOVEM.W     A4, -(SP)
    MOVEM.W     A0-A3/D5, -(SP)
    MOVEM.W     D6/A2, -(SP)
    MOVEM.W     D2-D3/A0/D1, -(SP)
    
    MOVEM.W     (SP)+, A4
    MOVEM.W     (SP)+, A0-A3/D5
    MOVEM.W     (SP)+, D6/A2
    MOVEM.W     (SP)+, D2-D3/A0/D1


MOVEM.L
    MOVEM.L     A5, -(SP)
    MOVEM.L     A6-A4/D0, -(SP)
    MOVEM.L     D1/A2, -(SP)
    MOVEM.L     D5-D6/A3/D2, -(SP)
    
    MOVEM.L     (SP)+, A3
    MOVEM.L     (SP)+, A1-A5/D2
    MOVEM.L     (SP)+, D7/A4
    MOVEM.L     (SP)+, D0-D3/A0/D1





*<ea>, Dn  and  Dn, <ea>
*For Source: Can use anything
*For Dest: Can't use Dn, An, #<data>
*For .B can't use An
ADD.B
    ADD.B       D3, D4
    ADD.B       (A0), D5
    ADD.B       (A1)+, D6
    ADD.B       -(A2), D7
    ADD.B       $1234, D0
    ADD.B       $1A34C6B8, D1
    ADD.B       #$1A, D2        *Possible bug?
    
    ADD.B       D0, (A1)
    ADD.B       D1, (A2)+
    ADD.B       D2, -(A3)
    ADD.B       D3, $5641
    ADD.B       D4, $4563ACDE


ADD.W
    ADD.W       D3, D4
    ADD.W       A3, D0
    ADD.W       (A0), D5
    ADD.W       (A1)+, D6
    ADD.W       -(A2), D7
    ADD.W       $1234, D0
    ADD.W       $1A34C6B8, D1
    ADD.W       #$5B34, D2      *Possible bug?
    
    ADD.W       D0, (A1)
    ADD.W       D1, (A2)+
    ADD.W       D2, -(A3)
    ADD.W       D3, $5641
    ADD.W       D4, $4563ACDE
    
    
ADD.L
    ADD.L       D3, D4
    ADD.L       A3, D0
    ADD.L       (A0), D5
    ADD.L       (A1)+, D6
    ADD.L       -(A2), D7
    ADD.L       $1234, D0
    ADD.L       $1A34C6B8, D1
    ADD.L       #$564CF132, D2  *Possible bug?
    
    ADD.L       D0, (A1)
    ADD.L       D1, (A2)+
    ADD.L       D2, -(A3)
    ADD.L       D3, $5641
    ADD.L       D4, $4563ACDE





*<ea>, Dn  and  Dn, <ea>
*For source: Can use all except An
*For dest: Can't use Dn, An, #<data>
AND.B
    AND.B       D3, D4
    AND.B       (A0), D5
    AND.B       (A1)+, D6
    AND.B       -(A2), D7
    AND.B       $1234, D0
    AND.B       $1A34C6B8, D1
    AND.B       #$1A, D2
    
    AND.B       D0, (A1)
    AND.B       D1, (A2)+
    AND.B       D2, -(A3)
    AND.B       D3, $5641
    AND.B       D4, $4563ACDE


AND.W
    AND.W       D3, D4
    AND.W       (A0), D5
    AND.W       (A1)+, D6
    AND.W       -(A2), D7
    AND.W       $1234, D0
    AND.W       $1A34C6B8, D1
    AND.W       #$2B34, D2
    
    AND.W       D0, (A1)
    AND.W       D1, (A2)+
    AND.W       D2, -(A3)
    AND.W       D3, $5641
    AND.W       D4, $4563ACDE
    
    
AND.L
    AND.L       D3, D4
    AND.L       (A0), D5
    AND.L       (A1)+, D6
    AND.L       -(A2), D7
    AND.L       $1234, D0
    AND.L       $1A34C6B8, D1
    AND.L       #$564CF132, D2
    
    AND.L       D0, (A1)
    AND.L       D1, (A2)+
    AND.L       D2, -(A3)
    AND.L       D3, $5641
    AND.L       D4, $4563ACDE



    

*For .B, An can't be used
CMP.B
    CMP.B       D0, D1
    CMP.B       (A3), D3
    CMP.B       (A4)+, D4
    CMP.B       -(A5), D5
    CMP.B       $1234, D6
    CMP.B       $12345678, D7
    CMP.B       #$12, D0
    
   
CMP.W 
    CMP.W       D0, D1
    CMP.W       A2, D2
    CMP.W       (A3), D3
    CMP.W       (A4)+, D4
    CMP.W       -(A5), D5
    CMP.W       $1234, D6
    CMP.W       $12345678, D7
    CMP.W       #$1234, D0
    
    
CMP.L
    CMP.L       D0, D1
    CMP.L       A2, D2
    CMP.L       (A3), D3
    CMP.L       (A4)+, D4
    CMP.L       -(A5), D5
    CMP.L       $1234, D6
    CMP.L       $12345678, D7
    CMP.L       #$12345678, D0
    
    
    
    
    
*Test with RTS
*Assembled code depends on where it is jumping to
*Place randomly in file and jump to random parts in file to see how assembled code changes
*Unsized and no destination    
*Only allows (An), (xxx).W, and (xxx).L
JSR
    JSR         (A0)
    JSR         $1234
    JSR         $12345678
    JSR         JumpHere





JumpHere
*Test with JSR
*Assembled code is always 4E75 or 0100 1110 0111 0101
RTS
    RTS
    
    
    
    

*Only has label of where to jump to
*Place randomly in file to see how displacement changes and code is changed
*Based on displacement
BCS
    BCS         JumpHere1
    
JumpHere1





*Something to do with Bit number?
*Syntax is Dn, <ea> and #<data>, <ea>
*For .B, can use everything except Dn and An and #<data> for source
BCHG.B
    BCHG.B      D0, (A0)
    BCHG.B      D0, (A1)+
    BCHG.B      D0, -(A0)
    BCHG.B      D0, $1234
    BCHG.B      D0, $12345678
    
    BCHG.B      #$12345678, (A1)
    BCHG.B      #$12345678, (A2)+
    BCHG.B      #$12345678, -(A3)
    BCHG.B      #$12345678, $1234
    BCHG.B      #$12345678, $12345678
    
*For .L, can only use Dn
BCHG.L
    BCHG.L      D0, D1
    
    BCHG.L      #$12345678, D0





*Cannot use with An or #<data>
NOT.B
    NOT.B      D0
    NOT.B      (A1)
    NOT.B      (A2)+
    NOT.B      -(A3)
    NOT.B      $1234
    NOT.B      $12345678
    
NOT.W
    NOT.W      D0
    NOT.W      (A1)
    NOT.W      (A2)+
    NOT.W      -(A3)
    NOT.W      $1234
    NOT.W      $12345678
    
NOT.L
    NOT.L      D0
    NOT.L      (A1)
    NOT.L      (A2)+
    NOT.L      -(A3)
    NOT.L      $1234
    NOT.L      $12345678





*Test every combination with .B, .W, .L
*Test for every opcode
*Test switch combination (EX: D0, A1 and switch A1, D0)
*Test in different orders (EX: MOVE.W and then ADD.W and then AND.L etc.)
*Test with InvalidCode placed randomly in file
*Test decimal numbers? Test binary?
Extra
    MOVE.W      D0, D0
    MOVE.W      (A0), (A1)
    
    MOVE.W      $1, D0
    MOVE.W      $01, D0
    MOVE.W      $001, D0
    MOVE.W      $0001, D0

    MOVE.W      $A, D0
    MOVE.W      $F, D0
    MOVE.W      $0, D0
    MOVE.W      $1, D0
    MOVE.W      $12, D0
    MOVE.W      $123, D0
    MOVE.W      $1234, D0
    MOVE.W      $12345, D0
    MOVE.W      $123456, D0
    MOVE.W      $1234567, D0
    MOVE.W      $12345678, D0
    
    MOVE.L      #$A, D0     *Possible bug
    MOVE.L      #$0, D0     *Possible bug
    MOVE.L      #$12, D0    *Possible bug
    MOVE.L      #$123, D0
    MOVE.L      #$1234, D0
    MOVE.L      #$12345, D0
    MOVE.L      #$123456, D0
    MOVE.L      #$1234567, D0
    MOVE.L      #$12345678, D0
    
    



TestInvalidCode
    ADDA.W      D3, A0
    MOVEA.L     D3, A0
    






    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source






















*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~
