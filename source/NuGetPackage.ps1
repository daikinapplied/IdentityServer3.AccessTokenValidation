# ~~~[Introduce]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Write-Host "                                                        "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "DotNetLib NuGet Package Tool                            "
Write-Host "Developed by Hans Dickel (RecursiveGeek)                "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "                                                        "
Write-Host "? Create .NET Framework NuGet packages.                 "
Write-Host "                                                        "
Write-Host

# ~~~[Globals]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$prodLocations = @("Release","prd")

# ~~~[Functions]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Function BuildNuGet
{
	param (
		[string]$project,
		[string]$nugetPackage,
		[string]$rootFolder
	)

	Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	Set-Location "$rootFolder\$project"
	Write-Host "~~ Build: $project ~~"
	Write-Host

	$prodBits = ""
	foreach ($prodBits in $prodLocations)
	{
		try
		{
			$searchFile = "bin\$prodBits\$project.dll"
			Write-Host "Searching: $searchFile"
			$dllFile = Get-Item $searchFile
			if ($dllFile)
			{
				Write-Host "Found: $($dllFile.FullName)"
				$versionInfo = $dllFile.VersionInfo
				break
			}
		}
		catch [System.Exception]
		{
			$versionInfo = $null
		}
	}

	if ($versionInfo)
	{
		$version = $versionInfo.FileMajorPart.ToString() + "." + $versionInfo.FileMinorPart.ToString() + "." + $versionInfo.FileBuildPart.ToString()
		if ( $versionInfo.FilePrivatePart.ToString() -ne "0" ) 
		{ 
		   $version = $version + "." + $versionInfo.FilePrivatePart.ToString()
		}
	
		nuget pack $project.nuspec -Version $version -Prop Configuration=Release
		Move-Item "$nugetPackage.$version.nupkg" "bin\$prodBits\" -Force
		Set-Location "$rootFolder"
		Write-Host
	}
	else
	{
		Set-Location "$rootFolder"
		Write-Host ":( Unable to find a package to deploy"
		exit 1
	}
}

# ~~~[Main Body]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~ .NET Framework NuGet packaging (.NET Standard and .NET Core projects can build this automatically in Visual Studio 2017/2019) ~~
BuildNuGet "IdentityServer3.AccessTokenValidation" "Daikin.IdentityServer3.AccessTokenValidation" $PSScriptRoot

exit 0
# ~End~