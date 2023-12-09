[int]$totSum = 0
foreach($line in Get-Content input.txt) {
    [System.Collections.ArrayList]$fields = @(@())
    [System.Collections.ArrayList]$newRow = $line.Split(" ")
    $fields.Add($newRow)
    $hasNonZero = $false
    do {
      $hasNonZero = $false
      $firstVal = $true
      $prevVal = 0;
      $newRow = @()
      forEach ($val in $fields[$fields.Count-1]) {
        if ($firstVal) {
          $firstVal = $false
        } else {
          $diff = $val - $prevVal
          $newRow.Add($diff)
          if ($diff -ne 0) {
            $hasNonZero = $true
          }
        }
        $prevVal = $val
      }
      $fields.Add($newRow)
    } while ($hasNonZero)
    $fields[$fields.Count-1].Add(0)
    for ($i = $fields.Count-1; $i -gt 0; $i--) {
      $thisLast = [convert]::ToInt32($fields[$i][$fields[$i].Count-1])
      $prevLast = [convert]::ToInt32($fields[$i-1][$fields[$i-1].Count-1])
      $sum = $prevLast + $thisLast
      $fields[$i-1].Add([string]($sum))
      if ($i -eq 1) {
        $totSum += $sum
      }
    }
}
Write-Output "Sum: $($totSum)"
