Set-PSReadlineOption -EditMode vi
Set-Alias -Name la -Value ls
Set-Alias -Name less -Value "${env:ProgramFiles}\Git\usr\bin\less.exe"
Set-Alias -Name which -Value Get-Command

$j_timer = New-Object System.Diagnostics.Stopwatch

Set-PSReadLineKeyHandler -Key d -ViMode Insert -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("d")
    $j_timer.Restart()
}

Set-PSReadLineKeyHandler -Key f -ViMode Insert -ScriptBlock {
    if (!$j_timer.IsRunning -or $j_timer.ElapsedMilliseconds -gt 1000) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("f")
    } 
    else {
        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        if ($line[-1] -eq 'd') {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor-1, 1)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor-1)
            [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
        }
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("f")
        }
    }
}