cd AT2_SpringBoot
.\local_test.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "ECHEC DU TEST LOCAL, DEPLOIEMENT ANNULE" ; cd .. ; exit 1 }
.\deploy.ps1
cd ..