param (
    [string]$SolutionPath
)

# Step 1: Get list of all project paths from the .sln
$projectPaths = @()
$slnDir = Split-Path $SolutionPath -Parent

Get-Content $SolutionPath | ForEach-Object {
    if ($_ -match '^\s*Project\(".*"\) = ".*", "(.*\.csproj)",') {
        $projPath = Join-Path $slnDir $matches[1]
        $fullPath = Resolve-Path $projPath -ErrorAction SilentlyContinue
        if ($fullPath) {
            $projectPaths += $fullPath.Path
        }
    }
}

# Step 2: Build dependency graph
$projectMap = @{}
foreach ($proj in $projectPaths) {
    $projectMap[$proj] = @()

    if (Test-Path $proj) {
        [xml]$xml = Get-Content $proj
        $refs = $xml.Project.ItemGroup.ProjectReference
        foreach ($ref in $refs) {
            $refPath = Join-Path (Split-Path $proj) $ref.Include
            $resolved = Resolve-Path $refPath -ErrorAction SilentlyContinue
            if ($resolved) {
                $projectMap[$proj] += $resolved.Path
            }
        }
    }
}

# Step 3: Topological sort
function Sort-Projects {
    param ($graph)

    $visited = @{}
    $result = @()

    function Visit($node) {
        if ($visited[$node]) { return }
        $visited[$node] = $true
        foreach ($dep in $graph[$node]) {
            Visit $dep
        }
        $result += $node
    }

    foreach ($node in $graph.Keys) {
        Visit $node
    }

    return $result
}

$ordered = Sort-Projects -graph $projectMap

# Step 4: Output
Write-Host "`n📦 Build Order:`n"
$ordered | ForEach-Object { Write-Host ("- " + (Split-Path $_ -Leaf)) }
