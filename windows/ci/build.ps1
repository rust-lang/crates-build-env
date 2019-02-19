$ErrorActionPreference = "Stop"

$ContainerBase = '@sha256:c06b4bfaf634215ea194e6005450740f3a230b27c510cf8facab1e9c678f3a99'

docker build                                    `
    -t "$env:PUSH_IMAGE"                        `
    --build-arg "BASE_IMAGE_VER=$ContainerBase" `
    windows
