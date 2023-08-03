param(
	[string]$apiKey="", 
	[string]$certIdentifier="",
	[string]$certIdType="subject",
	[string]$certStore="LocalMachine",
	[string]$nugetServer="https://www.nuget.org/api/v2/package",
	[string]$timeServer="http://timestamp.comodoca.com?td=sha256"
)

# ~~~[Introduce]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Write-Host "                                                        "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "IdentityServer3.AccesstokenValidation NuGet Publish Tool"
Write-Host "Developed by Hans Dickel (RecursiveGeek)                "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "                                                        "
Write-Host "? This tool publishes the NuGet packages.               "
Write-Host

# ~~~[Functions]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Function PublishNuGet
{
    param ([string]$project, [string]$rootFolder)

	Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    Write-Host "~~ Publish: $project ~~"

	$prodLocations=@("Release","prd")
	foreach ($prodBits in $prodLocations)
	{
		Try
		{
			$searchFile = $rootFolder + "\" + $project + "\bin\" + $prodBits + "\*.nupkg"
			Write-Host "Searching: $searchFile"
			$newestPackage = Get-ChildItem "$searchFile" -File -ErrorAction Stop | Sort-Object LastAccessTime -Descending | Select-Object -First 1
			if ($newestPackage)
			{
				Write-Host "Found: $newestPackage"
				break
			}
		}
		Catch [System.Exception]
		{
			$newestPackage = $null
		}
	}

    if ($newestPackage)
    {
		# NuGet 5.3.1 and earlier that supports signing defaults to "CurrentUser" for the store location
		if ($certIdType.ToLower() -eq "subject")
		{
			nuget sign "$newestPackage" -CertificateStoreLocation $certStore -CertificateSubjectName $certIdentifier -Timestamper $timeServer
		}
		else
		{
			nuget sign "$newestPackage" -CertificateStoreLocation $certStore -CertificateFingerprint $certIdentifier -Timestamper $timeServer
		}
		
		try
		{
			nuget push "$newestPackage" -Source $nugetServer -ApiKey $apiKey
		}
		catch 
		{
			Write-Host "!! Issue encountered pushing NuGet package: $newestPackage"
			Write-Host "!! NuGet Server: $nugetServer"
			Write-Host "Issue: $_"
		}

    }
    else
    {
        Write-Host ":( Unable to find a package to deploy"
    } 
}

# ~~~[Main Body]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if ($apiKey.Length -eq 0)
{
	$apiKey = Read-Host -Prompt 'Enter your NuGet Api Key'
}
else
{
	Write-Host "(NuGet ApiKey passed via command-line)"
}

if ($apiKey.Length -eq 0)
{
	Write-Host ":( ApiKey not specified.  Discontinuing."
	exit 1
}

if ($certIdentifier.Length -eq 0)
{
	$certIdentifier = Read-Host -Prompt "Enter your NuGet Certificate Identifier ($certIdType)"
}
else
{
	Write-Host "(NuGet Certificate '$certIdType' passed via command-line)"
}

if ($certIdentifier.Length -eq 0)
{
	Write-Host ":( Certified Identifer not specified.  Discontinuing."
	exit 1
}

$startupFolder = Get-Location
$scriptFolder = $PSScriptRoot

Write-Host "Script Startup Folder: $startupFolder"
Write-Host "This Script Folder: $scriptFolder"

PublishNuGet "IdentityServer3.AccessTokenValidation" $scriptFolder

exit 0
# ~End~