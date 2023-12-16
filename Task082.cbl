IDENTIFICATION DIVISION.
PROGRAM-ID. TASK082.

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
01 WS-Track.
   05 WS-Path OCCURS 6 TIMES INDEXED BY TrackId.
      10 WS-GhostLoc    PIC X(3).
      10 WS-GhostCnt    PIC 99999 VALUE 0.
01 WS-MyRow.
   03 WS-RowVal      PIC X(2000) VALUE SPACES.
01 WS-EOF            PIC A(1) VALUE 'N'.
01 WS-TotPaths       PIC 99 VALUE 6.
01 WS-EndCount       PIC 99.
01 WS-DirIndex       PIC 999999999999 VALUE 1.
01 WS-CountSteps     PIC 999999999999999 VALUE 0.
01 WS-StepSize       PIC 999999999999999 VALUE 0.
01 WS-DivResult      PIC 999999999999 VALUE 0.
01 WS-DivRem         PIC 999999999999 VALUE 0.

 
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
                            IF WS-Loc(RowId)(3:1) = 'A'
                                MOVE WS-Loc(RowId) TO WS-GhostLoc(TrackId)
                                SET TrackId UP BY 1
                            END-IF
                            SET RowId UP BY 1
                        END-IF
                    END-IF
            END-READ
        END-PERFORM.
    CLOSE FILE1.

    DISPLAY "BEG: " WS-GhostLoc(1) "   " WS-GhostLoc(2) "   " WS-GhostLoc(3) "   " WS-GhostLoc(4) "   " WS-GhostLoc(5) "   " WS-GhostLoc(6)
    PERFORM FindLoc UNTIL WS-EndCount = WS-TotPaths.
    DISPLAY "END: " WS-GhostLoc(1) "   " WS-GhostLoc(2) "   " WS-GhostLoc(3) "   " WS-GhostLoc(4) "   " WS-GhostLoc(5) "   " WS-GhostLoc(6)
    DISPLAY "     " WS-GhostCnt(1) " " WS-GhostCnt(2) " " WS-GhostCnt(3) " " WS-GhostCnt(4) " " WS-GhostCnt(5) " " WS-GhostCnt(6)
    SET WS-EndCount TO 0.
    MOVE WS-StepSize TO WS-CountSteps
    PERFORM FindDiv UNTIL WS-EndCount = WS-TotPaths.
    DISPLAY "Total Steps: " WS-CountSteps.

    STOP RUN.

FindLoc.
    IF WS-Steps(WS-DirIndex:1) = ' '
        SET WS-DirIndex TO 1
    END-IF.
    SET TrackId TO 1.
    SET WS-EndCount TO 0.
    PERFORM WITH TEST AFTER UNTIL TrackId > WS-TotPaths
        IF NOT WS-GhostLoc(TrackId)(3:1) = 'Z'
            SET RowId TO 1
            SEARCH WS-Row VARYING RowId
                AT END
                    DISPLAY 'NOT FOUND!!'
                    SET WS-EndCount TO WS-TotPaths
                    SET TrackId TO WS-TotPaths
                WHEN WS-Loc(RowId) = WS-GhostLoc(TrackId)
                    IF WS-Steps(WS-DirIndex:1) = 'L'
                        MOVE WS-LeftLoc(RowId) TO WS-GhostLoc(TrackId)
                    ELSE
                        MOVE WS-RightLoc(RowId) TO WS-GhostLoc(TrackId)
                    END-IF
                    SET WS-GhostCnt(TrackId) UP BY 1
            END-SEARCH
        END-IF
        IF WS-GhostLoc(TrackId)(3:1) = 'Z'
            SET WS-EndCount UP BY 1
            IF WS-StepSize = 0 OR WS-GhostCnt(TrackId) > WS-StepSize
                MOVE WS-GhostCnt(TrackId) TO WS-StepSize
            END-IF
        END-IF
        SET TrackId UP BY 1
    END-PERFORM.
    SET WS-DirIndex UP BY 1.

FindDiv.
    SET TrackId TO 1.
    SET WS-EndCount TO 0.
    PERFORM WITH TEST AFTER UNTIL TrackId > WS-TotPaths
        DIVIDE WS-CountSteps BY WS-GhostCnt(TrackId) GIVING WS-DivResult REMAINDER WS-DivRem
        IF WS-DivRem = 0
            SET WS-EndCount UP BY 1
        END-IF
        SET TrackId UP BY 1
    END-PERFORM.
    IF WS-EndCount < WS-TotPaths
        SET WS-CountSteps UP BY WS-StepSize
    END-IF.
