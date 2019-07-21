foreach ($var in "DOCKER_USERNAME", "DOCKER_PASSWORD") {
    if (-not (Test-Path "env:$var")) {
        echo "Environment variable \"$var\" not set"
        exit 22
    }
}

Write-Host "Publishing to hub.docker.com/$env:DOCKER_USERNAME"
docker login --username "$env:DOCKER_USERNAME" --password "$env:DOCKER_PASSWORD"
docker tag "$env:IMAGE_NAME" "$env:DOCKER_USERNAME/$env:IMAGE_NAME"
docker push "$env:DOCKER_USERNAME/$env:IMAGE_NAME"
