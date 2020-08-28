# Aliases
function vim { mvim -v $args }
function vi {
  if ($args.count) {
    $args=@("--remote-tab-silent" ) + $args
  }
  mvim $args
}

# Readline
$PSReadLineOptions = @{
  Colors = @{
    Command = "`e[1;30m"
      ContinuationPrompt = "`e[0;30m"
      Default = "`e[0;30m"
      Keyword = "`e[0;30m"
      Number = "`e[0;30m"
      Operator = "`e[0;30m"
      Parameter = "`e[0;30m"
      Selection = "`e[0;30m"
      Variable = "`e[0;30m"
      Type = "`e[0;30m"
      Member = "`e[30m"
      Comment = "`e[38;5;250m"
      Emphasis = "`e[96m"
      Error = "`e[91m"
      String = "`e[36m"
  }
}

Set-PSReadLineOption @PSReadLineOptions
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Posh git
Import-Module posh-git
function promptPath() {
  return "`e[1;30m[`e[0m{0}`e[1;30m]`e[0m" -f $(Split-Path -Path "$pwd" -Leaf)
}
$GitPromptSettings.BeforeStatus = "`e[1;30m[`e[0m"
$GitPromptSettings.DelimStatus  = "`e[1;30m|`e[0m"
$GitPromptSettings.AfterStatus  = "`e[1;30m]`e[0m"
$GitPromptSettings.BranchColor.ForegroundColor = "`e[0;30m"
$GitPromptSettings.DefaultPromptPath = '$(promptPath)'
