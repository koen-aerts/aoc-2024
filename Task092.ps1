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
    $fields[$fields.Count-1].Insert(0, 0)
    for ($i = $fields.Count-1; $i -gt 0; $i--) {
      $thisFirst = [convert]::ToInt32($fields[$i][0])
      $prevFirst = [convert]::ToInt32($fields[$i-1][0])
      $diff = $prevFirst - $thisFirst
      $fields[$i-1].Insert(0, [string]($diff))
      if ($i -eq 1) {
        $totSum += $diff
      }
    }
}
Write-Output "Sum: $($totSum)"
