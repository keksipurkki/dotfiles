# Environment
$env:MYVIMRC = "$HOME/Config/vim/vimrc"
$env:VIMINIT = "source $HOME/Config/vim/vimrc"

$env:PATH = "$HOME/.local/bin:$env:PATH"
$env:PATH="$HOME/.local/bin:$env:PATH"
$env:PATH="$HOME/Library/Python/3.7/bin:$env:PATH"
$env:PATH="/usr/local/opt/python/libexec/bin:$env:PATH"
$env:PATH="$HOME/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/:$env:PATH"

$env:NODE_PATH="/usr/local/lib/node_modules"
$env:EDITOR = "mvim -v"

# Aliases
function vim { mvim -v $args }
function vi { mvim --remote-tab-silent $args }

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
