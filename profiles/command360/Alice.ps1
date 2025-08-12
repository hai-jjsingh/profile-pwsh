# Check if the enum exists, if it doesn"t, create it.
# need the zzzz otherwise it will not reconize the device type
if (!("RepoType" -as [Type])) {
	Add-Type -TypeDefinition @"
    public enum RepoType {
		zzzzz,
		dev,
		c360,
        frontend,
        haitools,
		manager,
		personal,
    }
"@
}

function Get-RepoLocation([RepoType]$repoName) {
    # 
	$devDirectory = "C:\dev"
	$rootDirectory = Join-Path $devDirectory "command360"

    $endingFolder = "";
    $finalFolder = ""

    switch ($repoName) {
        "c360" { 
            $finalFolder = $rootDirectory
        }
        "dev" { 
            $finalFolder = $devDirectory
        }
        "frontend" { 
            $endingFolder = "Sites\main"
        }
        "haitools" { 
            $endingFolder = "Tools\HaiTools\HaiTools"
        }
        "manager" { $endingFolder = "Manager" }
		"personal" { 
            $endingFolder = "Powershell\Personal"
        }
    }

    if ($finalFolder -ne "") {
        return $finalFolder
    }

    if (-not $endingFolder) {
        return ""
    }

    # if ($env:UseLegacyCodeBase -eq $true) {
    #     $rootDirectory = $env:CineMassiveCodeRoot
    # }

    # if ($env:UseLegacyCodeBase -eq $true) {
    #     $endingFolder = "CineNet.$endingFolder"
    # }
	
    $finalDestination = Join-Path $rootDirectory $endingFolder
    return $finalDestination
}

function Move-ToRepo() {
	param(
		[RepoType]$repoName
    )

	$finalDestination = Get-RepoLocation $repoName
	
	Write-Host "cd $finalDestination"	-ForegroundColor Magenta

	if(Test-Path $finalDestination) {
		Set-Location -Path $finalDestination
	}
}

Set-Alias .. cd..
Set-Alias cd2 Move-ToRepo