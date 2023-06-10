# Change Working Directory
Set-Location $PSScriptRoot

$Env:HF_HOME = "huggingface"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
$Env:PIP_NO_CACHE_DIR = 1
function InstallFail {
    Write-Output "Install failed"
    Read-Host | Out-Null ;
    Exit
}

function Check {
    param (
        $ErrorInfo
    )
    if (!($?)) {
        Write-Output $ErrorInfo
        InstallFail
    }
}

# Check whether Pylauncher is installed
$list = (py --list 2> $null)
if(!$?){
    InstallFail
}

# Check minor version of Python
$requiredMinorVersion = "3\.10"
if(!($list -match $requiredMinorVersion)){
    Check "Python 3.10 is not found. Please install Python 3.10.x later than 3.10.8"
}

# Check micro version of Python
$requiredMicroVersion = "3\.10\.(8|9|([1-7]\d))"
$pyVersion = py -3.10 --version
if(!($pyVersion -match $requiredMicroVersion)){
    Check "Installed Python 3.10 is too old to install layerdivider. Please upgrade your Python 3.10"
}

if (!(Test-Path -Path "venv")) {
    Write-Output "creating venv..."
    python -m venv venv
    Check "create venv failed"
}

.\venv\Scripts\activate
Check "activate venv failed"

Write-Output "Installing requirement"

$install_torch = Read-Host "Need install Torch+xformers? [y/n] (first use/default y)"
if ($install_torch -eq "y" -or $install_torch -eq "Y" -or $install_torch -eq ""){
    pip install torchaudio==2.0.2+cu118 torch==2.0.1+cu118 --extra-index-url https://download.pytorch.org/whl/cu118
    Check "torch install failed，please delete venv dir and rerun"
    pip install -U -I --no-deps xformers==0.0.20
    Check "xformers install failed"
}

pip install --upgrade -r requirements.txt -i https://pypi.org/simple
Check "Install requirement failed"

Write-Output "Install Finished"
Read-Host | Out-Null ;