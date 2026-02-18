Write-Host "Installation des dependances..."
npm install | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de l'installation" ; exit 1 }

Write-Host "Build de l'application..."
npm run build | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors du build" ; exit 1 }

Write-Host "Execution des tests..."
npm run test | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "... ECHEC !" ; exit 1 }

Write-Host "... SUCCES !"
