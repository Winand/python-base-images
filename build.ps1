param (
    [string]$tag,
    [switch]$push
)
if ($tag -match '(?<name>.+):(?<ver>[\d.]+)-(?<libc>\w+)') {
    $name = $Matches.name
    $ver = $Matches.ver
    $libc = $Matches.libc
} else {
    throw "$tag does not match 'NAME:VERSION-LIBC'"
}

$dockerfile="$name-$libc.Dockerfile"
docker buildx build --build-arg PYTHON_VERSION=$ver -t $tag `
                    $(if ($push) {'--push'}) -f $dockerfile .
