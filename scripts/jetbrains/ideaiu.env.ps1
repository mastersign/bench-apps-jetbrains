$ideaDir = App-Dir "JetBrains.IdeaIU"
$propertiesFile = "$ideaDir\bin\idea.properties"
$homeDir = Get-ConfigValue "HomeDir"
$ideaConfigPath = "$homeDir\.IdeaIU\config"
$ideaSystemPath = "$homeDir\.IdeaIU\system"

$utf8 = New-Object System.Text.UTF8Encoding($false)

Write-Host "Updating $propertiesFile ..."
$propertiesContent = ""
if (Test-Path $propertiesFile)
{
    $propertiesContent = [IO.File]::ReadAllText($propertiesFile, $utf8)
}

function SetConfigProperty($text, $name, $value)
{
    $escName = [regex]::Escape($name)
    $p = New-Object System.Text.RegularExpressions.Regex ("^\s*#?\s*${escName}=.*$", "Multiline")
    if ($p.IsMatch($text))
    {
        return $p.Replace($text, "$name=$value")
    }
    else
    {
        return $text.TrimEnd() + [Environment]::NewLine + "$name=$value" + [Environment]::NewLine
    }
}

$propertiesContent = SetConfigProperty $propertiesContent "idea.config.path" $ideaConfigPath.Replace("\", "/")
$propertiesContent = SetConfigProperty $propertiesContent "idea.system.path" $ideaSystemPath.Replace("\", "/")

[IO.File]::WriteAllText($propertiesFile, $propertiesContent, $utf8)
