$ContainerBase = ':1803'

docker build                                    `
    -t "$env:IMAGE_NAME"                        `
    --build-arg "BASE_IMAGE_VER=$ContainerBase" `
    windows
