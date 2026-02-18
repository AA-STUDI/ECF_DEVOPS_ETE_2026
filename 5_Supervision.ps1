cd AT3_Supervision
.\deploy.ps1
Write-Host "NOTE : les pods deployes avant les outils de supervision doivent etre redmarres pour etre visibles par ceux-ci."
Write-Host "Exemple pour l'application Spring Boot de l'activite type 2 :"
Write-Host "kubectl rollout restart deployment/infoline-hello-world"
cd ..