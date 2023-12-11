#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>


Func Task111()
        ;ConsoleWrite("HI")

        ; Open the file for reading and store the handle to a variable.
        Local $hFileOpen = FileOpen("map.txt", $FO_READ)
        If $hFileOpen = -1 Then
                MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
                Return False
        EndIf

        ; Read the contents of the file using the handle returned by FileOpen.
        Local $sFileRead = FileRead($hFileOpen)

        ; Close the handle returned by FileOpen.
        FileClose($hFileOpen)

        Dim $lines = StringSplit($sFileRead, @CRLF, $STR_ENTIRESPLIT)
        Dim $colCounts[StringLen($lines[1])]
        Dim $rowCounts[$lines[0]]

        ; Expand array
        For $i = 1 To $lines[0]
            For $j = 1 to StringLen($lines[$i])
                $ss = StringMid($lines[$i], $j, 1)
                If ($ss <> ".") Then
                    $colCounts[$j-1] = $colCounts[$j-1] + 1
                    $rowCounts[$i-1] = $rowCounts[$i-1] + 1
                EndIf
            Next
        Next
        $newWidth = UBound($colCounts)
		$newHeight = $Lines[0]
        For $i = 1 To UBound($colCounts)
            If $colCounts[$i-1] = '' Then
                $newWidth = $newWidth + 1
            EndIf
        Next
        For $i = 1 To UBound($rowCounts)
            If $rowCounts[$i-1] = '' Then
                $newHeight = $newHeight + 1
            EndIf
        Next
        Dim $gal[$newHeight][$newWidth]
        $galCount = 0
        $y = 0
        For $i = 1 To $lines[0]
            $x = 0
            If $rowCounts[$i-1] = '' Then
                For $j = 1 to StringLen($lines[$i])
                    $gal[$y][$x] = "."
                    $x = $x + 1
                Next
                $y = $y + 1
            EndIf
            $x = 0
            For $j = 1 to StringLen($lines[$i])
                $ss = StringMid($lines[$i], $j, 1)
                If $colCounts[$j-1] = '' Then
                    $gal[$y][$x] = "."
                    $x = $x + 1
                EndIf
                $gal[$y][$x] = $ss
                If $ss = "#" Then
                    $galCount = $galCount + 1
                EndIf
                $x = $x + 1
            Next
            $y = $y + 1
        Next
        $totPaths = 0
        For $i = 1 To $galCount-1
            $totPaths = $totPaths + $i
        Next
        ConsoleWrite("Galaxies: " & $galCount & @CRLF)
        ConsoleWrite("Paths: " & $totPaths & @CRLF)
        Dim $paths[$totPaths]
        $totSum = 0
        $currentPath = 0
        For $y1 = 0 To $newHeight-1
            For $x1 = 0 To $newWidth-1
                If $gal[$y1][$x1] = "#" Then
                    For $y2 = $y1 To $newHeight-1
					    For $x2 = 0 To $newWidth-1
                            If $gal[$y2][$x2] = "#" and (($y2 > $y1) or ($x2 > $x1)) Then
							    $pSize = Abs($y2 - $y1) + Abs($x2 - $x1)
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

EndFunc   ;==>Example

Task111()
