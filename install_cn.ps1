# Change Working Directory
Set-Location $PSScriptRoot

$Env:HF_HOME = "huggingface"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = 1
$Env:PIP_NO_CACHE_DIR = 1
function InstallFail {
    Write-Output "��װʧ�ܡ�"
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
    Write-Output "���ڴ������⻷��..."
    python -m venv venv
    Check "�������⻷��ʧ�ܣ����� python �Ƿ�װ����Լ� python �汾�Ƿ�Ϊ64λ�汾��python 3.10����python��Ŀ¼�Ƿ��ڻ�������PATH�ڡ�"
}

.\venv\Scripts\activate
Check "�������⻷��ʧ�ܡ�"

pip install -e audiocraft/.

Write-Output "��װ������������ (�ѽ��й��ڼ��٣����ڹ�����޷�ʹ�ü���Դ�뻻�� install.ps1 �ű�)"
$install_torch = Read-Host "�Ƿ���Ҫ��װ Torch+xformers? 1Ϊ2.0.1�ȶ���+cu118xformers�ȶ���,2Ϊ2.1������+cu121+xformers������(�޷�����)�� [1/2/n] (Ĭ��Ϊ 1)"
if ($install_torch -ieq "1" -or $install_torch -eq ""){
    pip install torchaudio==2.1.0+cu118 torch==2.1.0+cu118 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html -i https://mirror.baidu.com/pypi/simple
    Check "torch ��װʧ�ܣ���ɾ�� venv �ļ��к��������С�"
    pip install -U -I --pre --no-deps xformers -i https://mirror.baidu.com/pypi/simple
    Check "xformers ��װʧ�ܡ�"
}elseif ($install_torch -ieq "2") {
    pip install -U --pre torch==2.1.0+cu121 torchaudio==2.1.0+cu121 -f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html -i https://mirror.baidu.com/pypi/simple
    Check "torch ��װʧ�ܣ���ɾ�� venv �ļ��к��������С�"
    pip install -U -I --pre --no-deps xformers -i https://mirror.baidu.com/pypi/simple
    Check "xformers ��װʧ�ܡ�"
}

pip install --upgrade -r requirements_cn.txt -i https://mirror.baidu.com/pypi/simple
Check "����������װʧ�ܡ�"

pip install --upgrade flashy>=0.0.1 -i https://pypi.org/simple
Check "����������װʧ�ܡ�"

Write-Output "��װ���"
Read-Host | Out-Null ;
