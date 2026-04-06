$filePath = "C:\Users\artem\OneDrive\Desktop\XXXiii\frontend\src\app\globals.css"

$lines = Get-Content -Path $filePath

$fixedLines = @()

foreach ($line in $lines) {
    $trimmed = $line.Trim()
    
    if ($trimmed -match '^\s*[a-z-]+\s*\{;?\s*$') {
        $fixedLine = $trimmed -replace ';\s*$', ''
        $fixedLines += $fixedLine
        continue
    }
    
    if ($trimmed -eq "" -or $trimmed -eq "}" -or $trimmed -eq "{") {
        $fixedLines += $line
        continue
    }
    
    if ($trimmed -match '^@') {
        $fixedLines += $line
        continue
    }
    
    if ($trimmed -match '^\*|^\.|^#|^:|^-') {
        $fixedLines += $line
        continue
    }
    
    if ($trimmed -match ':.+[^;]$') {
        $fixedLines += $line + ";"
    } else {
        $fixedLines += $line
    }
}

$fixedContent = $fixedLines -join "`n"
Set-Content -Path $filePath -Value $fixedContent -NoNewline

Write-Host "CSS file fixed successfully!"