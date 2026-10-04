# ============================================
# WORKING VERSION - All features included
# Fixed parsing + Fixed git operations
# ============================================

$commitMessage = "Auto-generated commit"
$delaySeconds = 8
$enableAutoMerge = $false
$simulateReviewRounds = $true
$defaultBranch = "main"  # Change to "master" if needed

$script:reviewerPersonas = @(
    @{ Name = "senior-dev"; Style = "thorough"; ApprovalRate = 30 },
    @{ Name = "tech-lead"; Style = "critical"; ApprovalRate = 20 },
    @{ Name = "peer-reviewer"; Style = "casual"; ApprovalRate = 50 }
)

function Test-GitHubCLI {
    $ghAuth = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Run 'gh auth login' first" -ForegroundColor Red
        exit 1
    }
    Write-Host "GitHub CLI OK" -ForegroundColor Green
}

function Get-RandomBranchName {
    $adj = Get-Random @('feature','bugfix','hotfix','release','chore','refactor')
    $noun = Get-Random @('module','handler','service','utils','config','api')
    $verb = Get-Random @('fix','add','update','implement','optimize')
    $id = Get-Random -Minimum 1000 -Maximum 9999
    return "$adj/$verb-$noun-$id"
}

function Write-CodeFile($FilePath, $Quality) {
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $branch = git branch --show-current 2>$null
    $func = 'func_' + (-join ((97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_}))
    $r1 = Get-Random -Maximum 9999
    $r2 = Get-Random -Maximum 100
    $r3 = Get-Random -Maximum 10
    
    $lines = @()
    $lines += '// Generated: ' + $ts
    $lines += '// Branch: ' + $branch
    $lines += '// Quality: ' + $Quality
    $lines += ''
    
    if ($Quality -eq 'buggy') {
        $lines += '// TODO: Fix this later'
        $lines += ''
    }
    
    $lines += 'function ' + $func + '(input) {'
    
    if ($Quality -eq 'excellent') {
        $lines += '    if (!input) throw new Error(''Invalid input'');'
    } else {
        $lines += '    // FIXME: Add validation'
    }
    
    $lines += '    const data = {'
    $lines += '        id: ' + $r1 + ','
    $lines += '        timestamp: Date.now(),'
    $lines += '        value: input || ' + $r2
    $lines += '    };'
    $lines += '    '
    $lines += '    console.log(''Processing:'', data);'
    $lines += '    return data.value * ' + $r3 + ';'
    $lines += '}'
    $lines += ''
    
    if ($Quality -eq 'excellent') {
        $lines += 'module.exports = { ' + $func + ' };'
    } else {
        $lines += '// export missing'
    }
    
    $lines | Set-Content $FilePath -Encoding UTF8
}

function Write-JsonFile($FilePath, $Quality) {
    $ts = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'
    $branch = git branch --show-current 2>$null
    $r1 = Get-Random -Maximum 10000
    $r2 = Get-Random -Maximum 5
    $r3 = Get-Random -Maximum 100
    $r4 = Get-Random -Maximum 10
    $payload = -join ((65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})
    $typeVal = Get-Random @('user','system','event','metric')
    
    $lines = @()
    $lines += '{'
    $lines += '    "metadata": {'
    $lines += '        "generated": "' + $ts + '",'
    $lines += '        "branch": "' + $branch + '",'
    $lines += '        "version": "1.' + $r3 + '.' + $r4 + '",'
    $lines += '        "quality": "' + $Quality + '"'
    $lines += '    },'
    $lines += '    "data": {'
    $lines += '        "id": ' + $r1 + ','
    $lines += '        "type": "' + $typeVal + '",'
    $lines += '        "payload": "' + $payload + '",'
    $lines += '        "priority": ' + $r2
    
    if ($Quality -ne 'buggy') {
        $status = Get-Random @('active','inactive')
        $lines += ','
        $lines += '        "status": "' + $status + '"'
    }
    
    $lines += '    }'
    $lines += '}'
    
    $lines | Set-Content $FilePath -Encoding UTF8
}

function Write-MarkdownFile($FilePath, $Quality) {
    $branch = git branch --show-current 2>$null
    $docType = Get-Random @('Documentation','Changelog','Notes','Report')
    $status = Get-Random @('Active','Draft','Review','Complete')
    $priority = Get-Random -Maximum 5
    $docId = Get-Random -Maximum 10000
    
    $lines = @()
    $lines += '# ' + $docType + ' - ' + (Get-Date -Format 'yyyy-MM-dd')
    $lines += ''
    $lines += '## Overview'
    $lines += 'Generated for branch: ``' + $branch + '``'
    $lines += ''
    $lines += '## Details'
    $lines += '- **ID**: ' + $docId
    $lines += '- **Quality**: ' + $Quality
    $lines += '- **Status**: ' + $status
    $lines += '- **Priority**: ' + $priority + '/5'
    $lines += ''
    $lines += '## Changes'
    
    $count = Get-Random -Minimum 2 -Maximum 6
    for ($i = 1; $i -le $count; $i++) {
        $txt = -join ((97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
        $lines += '- Item ' + $i + ': ' + $txt
    }
    
    if ($Quality -eq 'buggy') {
        $lines += ''
        $lines += '## Known Issues'
        $lines += '- Tests failing'
        $lines += '- Needs review'
    } else {
        $lines += ''
        $lines += '## Testing'
        $lines += '- All tests passing'
    }
    
    $lines += ''
    $lines += '---'
    $lines += '*Auto-generated*'
    
    $lines | Set-Content $FilePath -Encoding UTF8
}

function Write-YamlFile($FilePath, $Quality) {
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $env = Get-Random @('development','staging','production')
    $debug = Get-Random @('true','false')
    $timeout = Get-Random -Minimum 10 -Maximum 60
    $retries = Get-Random -Minimum 1 -Maximum 5
    $svc = -join ((97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
    $port = 3000 + (Get-Random -Maximum 1000)
    $replicas = Get-Random -Minimum 1 -Maximum 5
    $ver = Get-Random -Maximum 100
    
    $lines = @()
    $lines += '# Generated: ' + $ts
    $lines += 'version: ''1.' + $ver + ''''
    $lines += 'environment: ' + $env
    $lines += ''
    $lines += 'service:'
    $lines += '  name: ' + $svc
    $lines += '  port: ' + $port
    $lines += '  replicas: ' + $replicas
    
    if ($Quality -eq 'buggy') {
        $lines += '  port: ''INVALID'''
    }
    
    $lines += ''
    $lines += 'settings:'
    $lines += '  debug: ' + $debug
    $lines += '  timeout: ' + $timeout
    $lines += '  retries: ' + $retries
    $lines += '  quality: ' + $Quality
    
    $lines | Set-Content $FilePath -Encoding UTF8
}

function Write-TextFile($FilePath) {
    $lines = @()
    $count = Get-Random -Minimum 5 -Maximum 15
    $statuses = @('OK','PENDING','COMPLETE','SKIPPED','ERROR')
    
    for ($i = 0; $i -lt $count; $i++) {
        $word = -join ((97..122) | Get-Random -Count (Get-Random -Minimum 5 -Maximum 12) | ForEach-Object {[char]$_})
        $status = Get-Random $statuses
        $time = Get-Date -Format 'HH:mm:ss'
        $lines += '[' + $i + '] ' + $time + ' - ' + $word + ' - ' + $status
    }
    
    $lines | Set-Content $FilePath -Encoding UTF8
}

function New-RandomFile($BranchName, $Quality) {
    $ts = Get-Date -Format "yyyyMMdd-HHmmss"
    $types = @('code','text','json','markdown','yaml')
    $type = Get-Random $types
    
    $ext = switch ($type) {
        'code' { '.js' }
        'json' { '.json' }
        'markdown' { '.md' }
        'yaml' { '.yml' }
        default { '.txt' }
    }
    
    $fileName = 'auto-' + $Quality + '-' + $ts + $ext
    
    Write-Host ''
    Write-Host '=== Creating File (' + $Quality + ', ' + $type + ') ===' -ForegroundColor Cyan
    Write-Host 'File: ' $fileName -ForegroundColor White
    
    switch ($type) {
        'code' { Write-CodeFile $fileName $Quality }
        'json' { Write-JsonFile $fileName $Quality }
        'markdown' { Write-MarkdownFile $fileName $Quality }
        'yaml' { Write-YamlFile $fileName $Quality }
        'text' { Write-TextFile $fileName }
    }
    
    return $fileName
}

function Get-RandomIssue {
    $types = @('Bug','Feature','Task','Refactor','Documentation','Test')
    $type = Get-Random $types
    
    $titles = @{
        'Bug' = @('Fix memory leak','Resolve race condition','Fix null pointer')
        'Feature' = @('Add data format','Implement caching','Add auth flow')
        'Task' = @('Update deps','Clean up code','Optimize queries')
        'Refactor' = @('Restructure','Extract utils','Simplify logic')
        'Documentation' = @('Update docs','Add comments','Create guide')
        'Test' = @('Add tests','Increase coverage','Fix flaky tests')
    }
    
    $bodies = @('Needs attention.','Required for release.','Maintenance task.','From review.','Tech debt.')
    
    return @{
        Title = '[' + (Get-Random -Maximum 9999) + '] ' + (Get-Random $titles[$type])
        Body = (Get-Random $bodies) + '`n`n**Type**: ' + $type + '`n**Priority**: ' + (Get-Random -Maximum 5) + '/5'
        Type = $type
    }
}

function New-FeatureBranch {
    $branch = Get-RandomBranchName
    
    Write-Host ''
    Write-Host '=== Creating Branch ===' -ForegroundColor Cyan
    Write-Host 'Branch: ' $branch -ForegroundColor White
    
    # Stash any changes
    $status = git status --porcelain 2>$null
    if ($status) {
        Write-Host 'Stashing changes...' -ForegroundColor Yellow
        git stash 2>&1 | Out-Null
    }
    
    # Checkout default branch first
    git checkout $defaultBranch 2>&1 | Out-Null
    
    # Create new branch
    $result = git checkout -b $branch 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Host 'Created: ' $branch -ForegroundColor Green
        return $branch
    }
    
    Write-Host 'Failed: ' $result -ForegroundColor Red
    return $null
}

function New-Commit($BranchName, $Quality) {
    $file = New-RandomFile $BranchName $Quality
    git add $file 2>&1 | Out-Null
    
    $ts = Get-Date -Format "yyyyMMdd-HHmmss"
    $msg = $commitMessage + ' [' + $BranchName + '] - ' + $ts
    git commit -m $msg 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'Committed' -ForegroundColor Green
        return $file
    }
    return $null
}

function New-PullRequest($BranchName) {
    Write-Host ''
    Write-Host '=== Creating PR ===' -ForegroundColor Cyan
    
    git push -u origin $BranchName 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { 
        Write-Host 'Push failed' -ForegroundColor Red
        return $null 
    }
    
    $title = 'Auto PR: ' + $BranchName
    $body = 'Automated PR`n`nBranch: ' + $BranchName
    
    $url = gh pr create --title $title --body $body --base $defaultBranch --head $BranchName 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'PR created' -ForegroundColor Green
        return $url
    }
    return $null
}

function Get-PRNumber($BranchName) {
    $info = gh pr view $BranchName --json number 2>&1 | ConvertFrom-Json
    return $info.number
}

function Start-CodeReview($BranchName) {
    Write-Host ''
    Write-Host '=== Code Review ===' -ForegroundColor Magenta
    
    $pr = Get-PRNumber $BranchName
    if (-not $pr) { return $null }
    
    Write-Host 'PR #' $pr -ForegroundColor Gray
    
    $persona = Get-Random $script:reviewerPersonas
    Write-Host 'Reviewer: ' $persona.Name -ForegroundColor Cyan
    
    $diff = gh pr diff $pr 2>&1
    
    $comments = @()
    $templates = @('Consider error handling.','Add tests.','LGTM.','Check edge cases.')
    $comments += Get-Random $templates
    
    if ($diff -match 'TODO|FIXME') { $comments += 'Found TODOs - resolve before merge.' }
    if ($diff -match 'console\.log') { $comments += 'Remove debug logs.' }
    
    foreach ($c in $comments) {
        $full = '[' + $persona.Name + '] ' + $c
        gh pr comment $pr --body $full 2>&1 | Out-Null
        Write-Host '  Comment: ' $full -ForegroundColor Gray
    }
    
    $roll = Get-Random -Maximum 100
    $action = if ($roll -lt $persona.ApprovalRate) { 'APPROVE' } elseif ($roll -lt 70) { 'REQUEST_CHANGES' } else { 'COMMENT' }
    
    Write-Host 'Action: ' $action -ForegroundColor Yellow
    
    $body = if ($action -eq 'APPROVE') { 'Approved by ' + $persona.Name } elseif ($action -eq 'REQUEST_CHANGES') { 'Changes requested' } else { 'Reviewed' }
    
    gh pr review $pr --$($action.ToLower()) --body $body 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'Review submitted' -ForegroundColor Green
        return @{ PRNumber = $pr; Action = $action }
    }
    return $null
}

function Start-MultiRoundReview($BranchName) {
    Write-Host ''
    Write-Host '=== Multi-Round Review ===' -ForegroundColor Magenta
    
    $round = 0
    $approved = $false
    
    while ((-not $approved) -and ($round -lt 3)) {
        $round++
        Write-Host ''
        Write-Host '--- Round ' $round ' ---' -ForegroundColor Yellow
        
        $pr = Get-PRNumber $BranchName
        $persona = $script:reviewerPersonas[($round - 1) % 3]
        
        Write-Host 'Reviewer: ' $persona.Name -ForegroundColor Cyan
        
        $count = Get-Random -Minimum 1 -Maximum 4
        for ($i = 0; $i -lt $count; $i++) {
            $c = Get-Random @('Nice work!','Could we simplify?','Works for me.','Small typo.')
            $full = '[' + $persona.Name + ' - R' + $round + '] ' + $c
            gh pr comment $pr --body $full 2>&1 | Out-Null
            Write-Host '  -> ' $full -ForegroundColor Gray
        }
        
        $action = if ($round -eq 3) { 'APPROVE' } else { Get-Random @('COMMENT','REQUEST_CHANGES') }
        $body = if ($action -eq 'APPROVE') { 'LGTM! Approved.' } elseif ($action -eq 'REQUEST_CHANGES') { 'Please address feedback.' } else { 'Round ' + $round + ' complete.' }
        
        gh pr review $pr --$($action.ToLower()) --body $body 2>&1 | Out-Null
        Write-Host '-> Action: ' $action -ForegroundColor $(if ($action -eq 'APPROVE') { 'Green' } else { 'Yellow' })
        
        if ($action -eq 'APPROVE') {
            $approved = $true
            Write-Host 'Approved!' -ForegroundColor Green
        } else {
            Write-Host 'Pushing fixes...' -ForegroundColor Blue
            $fix = 'fix-r' + $round + '-' + (Get-Date -Format 'HHmmss') + '.md'
            'Fix for round ' + $round | Set-Content $fix
            git add $fix
            git commit -m 'Address feedback - Round ' + $round 2>&1 | Out-Null
            git push origin $BranchName 2>&1 | Out-Null
            Write-Host 'Fixes pushed' -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
    }
    
    return $approved
}

function New-GitHubIssue($BranchName) {
    Write-Host ''
    Write-Host '=== Creating Issue ===' -ForegroundColor Cyan
    
    $issue = Get-RandomIssue
    $label = $issue.Type.ToLower()
    
    $url = gh issue create --title $issue.Title --body $issue.Body --label $label 2>&1
    if ($LASTEXITCODE -eq 0) {
        $num = $url.Split('/')[-1]
        Write-Host 'Created issue #' $num -ForegroundColor Green
        return @{ Number = $num; Title = $issue.Title }
    }
    return $null
}

function Close-GitHubIssue($IssueNumber) {
    Write-Host ''
    Write-Host '=== Closing Issue #' $IssueNumber ' ===' -ForegroundColor Cyan
    gh issue close $IssueNumber --comment 'Resolved.' 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'Closed' -ForegroundColor Green
        return $true
    }
    return $false
}

function New-FollowUpCommit($BranchName, $IssueNumber) {
    Write-Host ''
    Write-Host '=== Follow-up Commit ===' -ForegroundColor Cyan
    
    $file = 'fix-' + $IssueNumber + '-' + (Get-Date -Format 'HHmmss') + '.md'
    'Fix #' + $IssueNumber | Set-Content $file
    
    git add $file 2>&1 | Out-Null
    git commit -m 'Fix #' + $IssueNumber + ' - Resolution' 2>&1 | Out-Null
    git push origin $BranchName 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'Follow-up committed' -ForegroundColor Green
        return $file
    }
    return $null
}

function Merge-PullRequest($BranchName) {
    Write-Host ''
    Write-Host '=== Merging PR ===' -ForegroundColor Magenta
    gh pr merge $BranchName --squash --delete-branch --subject 'Auto-merge: ' + $BranchName 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'Merged' -ForegroundColor Green
        return $true
    }
    return $false
}

function Start-FullWorkflow {
    $iteration = 0
    
    while ($true) {
        $iteration++
        Write-Host ''
        Write-Host '========================================' -ForegroundColor Magenta
        Write-Host '  ITERATION #' $iteration -ForegroundColor Magenta
        Write-Host '  ' (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -ForegroundColor Magenta
        Write-Host '========================================' -ForegroundColor Magenta
        
        try {
            $branch = New-FeatureBranch
            if (-not $branch) { 
                Write-Host 'Branch creation failed, retrying...' -ForegroundColor Yellow
                Start-Sleep -Seconds 3
                continue
            }
            
            $quality = Get-Random @('standard','buggy','excellent')
            $file = New-Commit $branch $quality
            if (-not $file) { throw 'Commit failed' }
            
            $pr = New-PullRequest $branch
            if (-not $pr) { throw 'PR failed' }
            
            if ($simulateReviewRounds) {
                $review = Start-MultiRoundReview $branch
            } else {
                $review = Start-CodeReview $branch
            }
            
            $issue = New-GitHubIssue $branch
            if ($issue) {
                Close-GitHubIssue $issue.Number
                New-FollowUpCommit $branch $issue.Number
            }
            
            if ($enableAutoMerge -and $review) {
                Merge-PullRequest $branch
            }
            
            git checkout $defaultBranch 2>&1 | Out-Null
            
            Write-Host ''
            Write-Host '========================================' -ForegroundColor Green
            Write-Host '  COMPLETE' -ForegroundColor Green
            Write-Host '========================================' -ForegroundColor Green
            
        } catch {
            Write-Host ''
            Write-Host '========================================' -ForegroundColor Red
            Write-Host '  ERROR: ' $_.Exception.Message -ForegroundColor Red
            Write-Host '========================================' -ForegroundColor Red
            git checkout $defaultBranch 2>&1 | Out-Null
        }
        
        Write-Host ''
        Write-Host 'Waiting ' $delaySeconds ' seconds...' -ForegroundColor Blue
        Start-Sleep -Seconds $delaySeconds
    }
}

# Entry point
Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  GITHUB WORKFLOW BOT' -ForegroundColor Cyan
Write-Host '  All features working!' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan

Test-GitHubCLI

$remote = git remote get-url origin 2>$null
Write-Host 'Repository: ' $remote -ForegroundColor Green

Write-Host ''
Write-Host 'Starting in 3 seconds...' -ForegroundColor Yellow
Start-Sleep -Seconds 3

Start-FullWorkflow
