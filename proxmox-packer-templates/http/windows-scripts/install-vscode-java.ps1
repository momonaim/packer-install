$ErrorActionPreference = "Stop"

Write-Host "Installing VS Code..."
# Install VS Code using winget
winget install --id Microsoft.VisualStudioCode -e --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -ne 0) {
    Write-Host "winget installation failed, trying direct download..."
    # Fallback: Download and install directly
    $vsCodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
    $vsCodeInstaller = "$env:TEMP\VSCodeSetup.exe"
    Invoke-WebRequest -Uri $vsCodeUrl -OutFile $vsCodeInstaller
    & $vsCodeInstaller /verysilent /norestart /dir="C:\Program Files\Microsoft VS Code"
    Remove-Item $vsCodeInstaller
}

Write-Host "Installing Java (OpenJDK)..."
# Install Java using winget
winget install --id EclipseAdoptium.Temurin.21 -e --silent --accept-source-agreements --accept-package-agreements
if ($LASTEXITCODE -ne 0) {
    Write-Host "winget installation failed, trying direct download..."
    # Fallback: Download and install OpenJDK directly
    $javaUrl = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_windows_hotspot_21.0.3_9.msi"
    $javaInstaller = "$env:TEMP\OpenJDK21.msi"
    Invoke-WebRequest -Uri $javaUrl -OutFile $javaInstaller
    Start-Process msiexec.exe -ArgumentList "/i $javaInstaller /quiet /norestart" -Wait
    Remove-Item $javaInstaller
}

Write-Host "Installation completed successfully!"
