Set-Location $PSScriptRoot
.\venv\Scripts\activate
Set-Location .\audiocraft

$Env:HF_HOME = "../huggingface"
$Env:XFORMERS_FORCE_DISABLE_TRITON = "1"

python.exe app_batched.py $args