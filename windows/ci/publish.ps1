$ErrorActionPreference = "Stop"

# Build the image
./windows/ci/build.ps1

# Log in to dockerhub
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Env:DOCKER_PASSWORD)).Trim() `
    | docker login --username "$Env:DOCKER_USERNAME" --password-stdin

docker push "$env:PUSH_IMAGE"
