$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$buildRoot = Join-Path $projectRoot 'build\sim'
$waveOutput = Join-Path $buildRoot 'wave.vcd'
$vivadoBin = 'C:\AMDDesignTools\2026.1\Vivado\bin'
$compiler = Join-Path $vivadoBin 'xvlog.bat'
$elaborator = Join-Path $vivadoBin 'xelab.bat'
$simulator = Join-Path $vivadoBin 'xsim.bat'
$runRoot = Join-Path $buildRoot ('run-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $runRoot -Force | Out-Null
if (Test-Path -LiteralPath $waveOutput) { Remove-Item -LiteralPath $waveOutput }
$sources = @((Join-Path $projectRoot 'src\decoder3x8.v'), (Join-Path $projectRoot 'sim\tb_decoder3x8.sv'))
Push-Location -LiteralPath $runRoot
try {
    & $compiler --sv @sources *> compile.log
    if ($LASTEXITCODE -ne 0) { Get-Content compile.log; throw 'Compile failed.' }
    & $elaborator tb_decoder3x8 --debug typical --snapshot decoder3x8_sim *> elaborate.log
    if ($LASTEXITCODE -ne 0) { Get-Content elaborate.log; throw 'Elaboration failed.' }
    & $simulator decoder3x8_sim --runall *> simulation.log
    $simExit = $LASTEXITCODE
    Get-Content simulation.log
    if ($simExit -ne 0) { throw 'Simulation failed.' }
    if (-not (Select-String -LiteralPath simulation.log -SimpleMatch 'LAB1_PASS decoder3x8 cases=8' -Quiet)) { throw 'The testbench did not report all 8 cases passing.' }
    if (-not (Test-Path -LiteralPath 'wave.vcd')) { throw 'No VCD was generated.' }
    Copy-Item -LiteralPath 'wave.vcd' -Destination $waveOutput
    Write-Host 'SIMULATED: LAB1_PASS decoder3x8 cases=8'
    Write-Host "Waveform: $waveOutput"
    Write-Host "Logs: $runRoot"
} finally { Pop-Location }
