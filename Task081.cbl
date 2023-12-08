IDENTIFICATION DIVISION.
PROGRAM-ID. TASK081.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION. 
FILE-CONTROL. 
SELECT FILE1 ASSIGN TO "map.txt"
ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD FILE1.
   01 Row.
      03 RowVal      PIC X(2000).


WORKING-STORAGE SECTION.
01 WS-Dir.
   05 WS-Steps       PIC X(2000) VALUE SPACES.
01 WS-Map.
   05 WS-Row OCCURS 790 TIMES INDEXED BY RowId.
      10 WS-Loc      PIC X(3).
      10 FILLER      PIC X(4).
      10 WS-LeftLoc  PIC X(3).
      10 FILLER      PIC X(2).
      10 WS-RightLoc PIC X(3).
      10 FILLER      PIC X(1).
01 WS-MyRow.
   03 WS-RowVal      PIC X(2000) VALUE SPACES.
01 WS-EOF            PIC A(1) VALUE 'N'.
01 WS-DirIndex       PIC 999999999999 VALUE 1.
01 WS-LastLoc        PIC X(3) VALUE 'ZZZ'.
01 WS-CurrentLoc     PIC X(3) VALUE 'AAA'.
01 WS-CountSteps     PIC 999999999999 VALUE 0.

 
PROCEDURE DIVISION.
MAIN-PROCEDURE.

    OPEN INPUT FILE1.
        PERFORM UNTIL WS-EOF='Y'
            READ FILE1 INTO WS-MyRow
                AT END MOVE 'Y' TO WS-EOF
                NOT AT END
                    IF WS-Dir(1:1) = ' '
                        MOVE WS-MyRow TO WS-Dir
                    ELSE
                        IF WS-MyRow(1:1) NOT = ' '
                            MOVE WS-MyRow TO WS-Row(RowId)
                            SET RowId UP BY 1
                        END-IF
                    END-IF
            END-READ
        END-PERFORM.
    CLOSE FILE1.
    DISPLAY "Going from " WS-CurrentLoc " to " WS-LastLoc.

    PERFORM FindLoc UNTIL WS-CurrentLoc = WS-LastLoc.
    DISPLAY "Total Steps: " WS-CountSteps.

    STOP RUN.

FindLoc.
    IF WS-Steps(WS-DirIndex:1) = ' '
        SET WS-DirIndex TO 1
    END-IF.
    SET RowId TO 1.
    SEARCH WS-Row VARYING RowId
        AT END
            DISPLAY 'NOT FOUND!!'
            MOVE WS-LastLoc TO WS-CurrentLoc
        WHEN WS-Loc(RowId) = WS-CurrentLoc
            IF WS-Steps(WS-DirIndex:1) = 'L'
                MOVE WS-LeftLoc(RowId) TO WS-CurrentLoc
            ELSE
                MOVE WS-RightLoc(RowId) TO WS-CurrentLoc
            END-IF
            SET WS-CountSteps UP BY 1
            SET WS-DirIndex UP BY 1
    END-SEARCH.
