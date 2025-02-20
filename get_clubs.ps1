Function DecodeHTML {
    param (
        [System.Array]$clubNames
    )
    
    return $clubNames | ForEach-Object { [System.Web.HttpUtility]::HtmlDecode($_) }
}

Add-Type -AssemblyName System.Web

$url = "https://www.myams.org/clubs/club-directory/"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing

$htmlContent = $response.Content

$regexPattern = '(?<=<div class="el-title uk-h4 uk-margin-top uk-margin-remove-bottom">)([\s\S]*?)(?=</div>)'
$match = [regex]::Matches($htmlContent, $regexPattern)
$clubNames = $match | ForEach-Object { $_.Value.Trim() }

# Decode HTML entities
$decodedClubNames = DecodeHTML -clubNames $clubNames

$outputFilePath = ".\clubs.txt"

$decodedClubNames | Set-Content -Path $outputFilePath

Write-Output "Extracted club names:"
$decodedClubNames
