$ErrorActionPreference = "Stop"

# Build the image
./windows/ci/build.ps1

foreach ($var in "DOCKER_USERNAME", "DOCKER_PASSWORD") {
    if (-not (Test-Path "env:$var")) {
        echo "Environment variable \"$var\" not set"
        exit 22
    }
}

# Log in to dockerhub
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Env:DOCKER_PASSWORD)).Trim() `
    | docker login --username "$Env:DOCKER_USERNAME" --password-stdin

docker push "$env:PUSH_IMAGE"
