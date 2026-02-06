# Plane Project Setup Script (PowerShell)

Write-Host "Setting up Plane..."

$services = @("", "web", "api", "space", "admin", "live")

foreach ($service in $services) {
    if ($service -eq "") {
        $prefix = "."
    }
    else {
        $prefix = ".\apps\$service"
    }

    $source = "$prefix\.env.example"
    $dest = "$prefix\.env"

    if (Test-Path $source) {
        if (-not (Test-Path $dest)) {
            Copy-Item -Path $source -Destination $dest
            Write-Host "Copied $dest"
        }
        else {
            Write-Host "$dest already exists"
        }
    }
}

# Generate SECRET_KEY
$apiEnvPath = ".\apps\api\.env"
if (Test-Path $apiEnvPath) {
    $content = Get-Content $apiEnvPath
    if ($content -notmatch "SECRET_KEY=") {
        $secretKey = [Guid]::NewGuid().ToString()
        Add-Content -Path $apiEnvPath -Value "SECRET_KEY=""$secretKey"""
        Write-Host "Added SECRET_KEY to apps/api/.env"
    }
}

# Install dependencies
Write-Host "Enabling corepack..."
corepack enable
Write-Host "Installing dependencies..."
pnpm install

Write-Host "Setup complete."
