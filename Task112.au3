#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>


Func Task112()
        Local $hFileOpen = FileOpen("map.txt", $FO_READ)
        If $hFileOpen = -1 Then
            ConsoleWrite("An error occurred when reading the file.")
            Return False
        EndIf
        Local $sFileRead = FileRead($hFileOpen)
        FileClose($hFileOpen)

        Dim $lines = StringSplit($sFileRead, @CRLF, $STR_ENTIRESPLIT)
        Dim $colCounts[StringLen($lines[1])]
        Dim $rowCounts[$lines[0]]
        Dim $gal[$lines[0]][UBound($colCounts)]
        $galCount = 0

        ; Expand array
        For $i = 1 To $lines[0]
            For $j = 1 to StringLen($lines[$i])
                $ss = StringMid($lines[$i], $j, 1)
                If ($ss <> ".") Then
                    $colCounts[$j-1] = $colCounts[$j-1] + 1
                    $rowCounts[$i-1] = $rowCounts[$i-1] + 1
                EndIf
                $gal[$i-1][$j-1] = $ss
                If $ss = "#" Then
                    $galCount = $galCount + 1
                EndIf
            Next
        Next
        $totPaths = 0
        For $i = 1 To $galCount-1
            $totPaths = $totPaths + $i
        Next
        ConsoleWrite("Galaxies: " & $galCount & @CRLF)
        ConsoleWrite("Paths: " & $totPaths & @CRLF)
        Dim $paths[$totPaths]
        $jump = 1000000
        $totSum = 0
        $currentPath = 0
        $yJump1 = 0
        For $y1 = 0 To $lines[0]-1
            If $rowCounts[$y1] = '' Then
                $yJump1 = $yJump1 + ($jump-1)
            EndIf
            $xJump1 = 0
            For $x1 = 0 To UBound($colCounts)-1
                If $colCounts[$x1] = '' Then
                    $xJump1 = $xJump1 + ($jump-1)
                EndIf
                If $gal[$y1][$x1] = "#" Then
                    $yJump2 = $yJump1
                    For $y2 = $y1 To $lines[0]-1
                        If $y2 > $y1 and $rowCounts[$y2] = '' Then
                            $yJump2 = $yJump2 + ($jump-1)
                        EndIf
                        $xJump2 = 0
                        For $x2 = 0 To UBound($colCounts)-1
                            If $colCounts[$x2] = '' Then
                                $xJump2 = $xJump2 + ($jump-1)
                            EndIf
                            If $gal[$y2][$x2] = "#" and (($y2 > $y1) or ($x2 > $x1)) Then
                                $pSize = Abs(($y2 + $yJump2) - ($y1 + $yJump1)) + Abs(($x2 + $xJump2) - ($x1 + $xJump1))
                                ;ConsoleWrite("  Size: " & $pSize & @CRLF)
                                $paths[$currentPath] = $pSize
                                $totSum = $totSum + $pSize
                                $currentPath = $currentPath + 1
                            EndIf
                        Next
                    Next
                EndIf
            Next
        Next
        ConsoleWrite("Sum: " & $totSum & @CRLF)

EndFunc

Task112()
