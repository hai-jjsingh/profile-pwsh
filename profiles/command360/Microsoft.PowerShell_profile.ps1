# 
Import-Module PKI -SkipEditionCheck
[System.Environment]::SetEnvironmentVariable('BuildCineNetDevelopment', "true") | Out-Null;
$env:UseDeveloperServiceForLogin = $true;

# 
$env:computername = "localhost"
$env:LocalWindowsUserName = "jjsingh"
# 
$env:CineMassiveCodeRoot = "C:\dev"
$env:CineMassiveRepoLocation = "$env:CineMassiveCodeRoot\command360"
$env:HaivisionRepoLocation = "$env:CineMassiveCodeRoot\command360"

$env:CineNetInstallLogToConsole = $true
$env:UseDeveloperServiceForLogin = $false;
$env:ASPNETCORE_ENVIRONMENT = "Development"

# For logging in
$env:Authorization = "Bearer undefined"
$env:Content = "application/json"
$env:body = @{username = "haiadmin"; password = "manager" } | ConvertTo-Json
# 
$env:MongoPath = "C:\tools\mongo\bin\mongo.exe"
# 
$env:NunitToConsole = $true
$env:PathToNUnit = "C:\ProgramData\chocolatey\lib\nunit-console-runner\tools\nunit3-console.exe"
$env:BareTailLocation = "C:\ProgramData\chocolatey\bin\baretail.exe"
# 
Import-Module "C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1"

# Grab all tools and have them loaded up
$pathToPowershellBootstrapper = Join-Path $env:CineMassiveRepoLocation "Powershell\Bootstrap.ps1"
. $pathToPowershellBootstrapper

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Alice
$AliceInWonderland = "C:\Users\jjsingh\Documents\PowerShell\Alice.ps1"
if (Test-Path($AliceInWonderland)) {
  Import-Module "$AliceInWonderland"
}

# search with fuzzy logic
Remove-PSReadlineKeyHandler "Ctrl+r"
Set-PSReadlineOption -HistoryNoDuplicates
Import-Module PSFzf -Force | Out-Null

function prompt {
  if ($GitPromptSettings.DefaultPromptEnableTiming) {
      $sw = [System.Diagnostics.Stopwatch]::StartNew()
  }
  $origLastExitCode = $global:LASTEXITCODE

  # Display default prompt prefix if not empty.
  $defaultPromptPrefix = [string]$GitPromptSettings.DefaultPromptPrefix
  if ($defaultPromptPrefix) {
      $expandedDefaultPromptPrefix = $ExecutionContext.SessionState.InvokeCommand.ExpandString($defaultPromptPrefix)
      Write-Prompt $expandedDefaultPromptPrefix
  }

  # Write the abbreviated current path
  $currentPath = $ExecutionContext.SessionState.InvokeCommand.ExpandString($GitPromptSettings.DefaultPromptPath)
  Write-Prompt $currentPath

  # Write the Git status summary information
  Write-VcsStatus

  # If stopped in the debugger, the prompt needs to indicate that in some fashion
  $hasInBreakpoint = [runspace]::DefaultRunspace.Debugger | Get-Member -Name InBreakpoint -MemberType property
  $debugMode = (Test-Path Variable:/PSDebugContext) -or ($hasInBreakpoint -and [runspace]::DefaultRunspace.Debugger.InBreakpoint)
  $promptSuffix = if ($debugMode) { $GitPromptSettings.DefaultPromptDebugSuffix } else { $GitPromptSettings.DefaultPromptSuffix }

  # If user specifies $null or empty string, set to " " to avoid "PS>" unexpectedly being displayed
  if (!$promptSuffix) {
      $promptSuffix = " "
  }

  $expandedPromptSuffix = $ExecutionContext.SessionState.InvokeCommand.ExpandString($promptSuffix)

  # If prompt timing enabled, display elapsed milliseconds
  if ($GitPromptSettings.DefaultPromptEnableTiming) {
      $sw.Stop()
      $elapsed = $sw.ElapsedMilliseconds
      Write-Prompt " ${elapsed}ms"
  }

  $global:LASTEXITCODE = $origLastExitCode
  $expandedPromptSuffix

  Write-Prompt " $(Get-Date -UFormat %T)"
}

# 
# 
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_classic.omp.json" | Invoke-Expression
