param (
    [string]$SolutionPath
)

function Get-ProjectReferences {
    param($ProjectPath)

    $references = @()

    if (Test-Path $ProjectPath) {
        [xml]$xml = Get-Content $ProjectPath
        $refs = $xml.Project.ItemGroup.ProjectReference
        foreach ($ref in $refs) {
            $include = $ref.Include
            if ($include) {
                $refPath = Join-Path (Split-Path $ProjectPath) $include
                $refFull = Resolve-Path $refPath -ErrorAction SilentlyContinue
                if ($refFull) {
                    $references += $refFull.Path
                }
            }
        }
    }

    return $references
}

function TopoSort {
    param($graph)

    $visited = @{}
    $result = @()

    function Visit($node) {
        if ($visited[$node] -eq $true) { return }
        $visited[$node] = $true

        foreach ($dep in $graph[$node]) {
            Visit $dep
        }

        $result += $node
    }

    # Fix: clone the keys to prevent modification during iteration
    $nodes = @($graph.Keys)
    foreach ($node in $nodes) {
        Visit $node
    }

    return $result
}

# --- MAIN ---

if (-not (Test-Path $SolutionPath)) {
    Write-Host "❌ Solution file not found: $SolutionPath"
    exit 1
}

$projects = @{}
$slnDir = Split-Path $SolutionPath -Parent

# Step 1: Extract project paths from the .sln file
Get-Content $SolutionPath | ForEach-Object {
    if ($_ -match '^Project\(".*"\) = ".*", "(.*)", ".*"$') {
        $projRelPath = $matches[1]
        if ($projRelPath -like "*.csproj" -or $projRelPath -like "*.vbproj" -or $projRelPath -like "*.vcxproj") {
            $projFullPath = Resolve-Path (Join-Path $slnDir $projRelPath) -ErrorAction SilentlyContinue
            if ($projFullPath) {
                $projects[$projFullPath.Path] = @()
            }
        }
    }
}

# Step 2: Build dependency graph
foreach ($proj in $projects.Keys) {
    $projects[$proj] = Get-ProjectReferences -ProjectPath $proj | Where-Object { $projects.ContainsKey($_) }
}

# Step 3: Topological sort
$buildOrder = TopoSort -graph $projects

# Step 4: Output
Write-Host "`n📦 Project Build Order:`n"
$buildOrder | ForEach-Object { Write-Host ("- " + (Split-Path $_ -Leaf)) }
