$IMAGE = "infoline-hello-world:1.0.0"
$EXPECTED = "Hello World !"
$PORT = 8081
$TIMEOUT = 30

Write-Host "Build en cours..."
docker build -t $IMAGE . | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors du build" ; exit 1 }

Write-Host "Lancement du container..."
docker run -d --name test-app -p ${PORT}:8080 $IMAGE | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors du montage du container" ; exit 1 }

# Attente du container et envoi de la requête
Write-Host "Test de connexion..."
$ready = $false
for ($i = 1; $i -le $TIMEOUT; $i++) {
    try {
        $response = (Invoke-WebRequest -Uri "http://localhost:$PORT/" -UseBasicParsing).Content.Trim()
        $ready = $true
        break
    } catch {
        Start-Sleep -Seconds 1
    }
}

Write-Host "Arret du container..."
docker stop test-app | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de l'arrêt du container" ; exit 1 }
Write-Host "Suppression du container..."
docker rm test-app | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "Erreur lors de la suppression du container" ; exit 1 }

# Résultat final
if (-not $ready) {
    Write-Host "Erreur lors de la connexion au container"
    exit 1
} else {
    Write-Host "Reponse attendue : '$EXPECTED'"
    Write-Host "Reponse obtenue : '$response'"
    if ($response -eq $EXPECTED) {
        Write-Host "...SUCCES !"
    } else {
        Write-Host "...ECHEC !"
        exit 1
    }
}