# Change Working Directory
Set-Location $PSScriptRoot

$Env:HF_HOME = "huggingface"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
$Env:PIP_NO_CACHE_DIR = 1
function InstallFail {
    Write-Output "安装失败。"
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
    Write-Output "正在创建虚拟环境..."
    python -m venv venv
    Check "创建虚拟环境失败，请检查 python 是否安装完毕以及 python 版本是否为64位版本的python 3.10、或python的目录是否在环境变量PATH内。"
}

.\venv\Scripts\activate
Check "激活虚拟环境失败。"

pip install -e audiocraft/.

Write-Output "安装程序所需依赖 (已进行国内加速，若在国外或无法使用加速源请换用 install.ps1 脚本)"
$install_torch = Read-Host "是否需要安装 Torch+xformers? 1为2.0.1稳定版+cu118xformers稳定版,2为2.1开发版+cu121+xformers开发版(无法加速)。 [1/2/n] (默认为 1)"
if ($install_torch -ieq "1" -or $install_torch -eq ""){
    pip install torchaudio==2.1.0+cu118 torch==2.1.0+cu118 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html -i https://mirror.baidu.com/pypi/simple
    Check "torch 安装失败，请删除 venv 文件夹后重新运行。"
    pip install -U -I --pre --no-deps xformers -i https://mirror.baidu.com/pypi/simple
    Check "xformers 安装失败。"
}elseif ($install_torch -ieq "2") {
    pip install -U --pre torch==2.1.0+cu121 torchaudio==2.1.0+cu121 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html -i https://mirror.baidu.com/pypi/simple
    Check "torch 安装失败，请删除 venv 文件夹后重新运行。"
    pip install -U -I --pre --no-deps xformers -i https://mirror.baidu.com/pypi/simple
    Check "xformers 安装失败。"
}

pip install --upgrade -r requirements_cn.txt -i https://mirror.baidu.com/pypi/simple
Check "其他依赖安装失败。"

pip install --upgrade flashy>=0.0.1 -i https://pypi.org/simple
Check "其他依赖安装失败。"

Write-Output "安装完毕"
Read-Host | Out-Null ;
