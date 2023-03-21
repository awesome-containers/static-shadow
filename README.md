# Statically linked Shadow Utils

Statically linked [Shadow] container image with [Bash]

> 4,3M (1,1M bash)

```bash
ghcr.io/awesome-containers/static-shadow:latest
ghcr.io/awesome-containers/static-shadow:4.13

docker.io/awesomecontainers/static-shadow:latest
docker.io/awesomecontainers/static-shadow:4.13
```

Slim statically linked [Shadow] container image with [Bash] stripped and
packaged with [UPX]

> 2,3M (578K bash)

```bash
ghcr.io/awesome-containers/static-shadow:latest-slim
ghcr.io/awesome-containers/static-shadow:4.13-slim

docker.io/awesomecontainers/static-shadow:latest-slim
docker.io/awesomecontainers/static-shadow:4.13-slim
```

[Shadow]: https://github.com/shadow-maint/shadow
[Bash]: https://github.com/awesome-containers/static-bash
[UPX]: https://upx.github.io/

<!--
```bash
image="localhost/${PWD##*/}"

podman build -t "$image:latest" .
podman build -t "$image:latest-slim" -f Containerfile-slim \
  --build-arg STATIC_SHADOW_IMAGE="$image" \
  --build-arg STATIC_SHADOW_VERSION=latest --no-cache .

echo "$image:latest"
podman inspect "$image:latest" | jq '.[].Size' | numfmt --to=iec
echo "$image:latest-slim"
podman inspect "$image:latest-slim" | jq '.[].Size' | numfmt --to=iec

```
-->
