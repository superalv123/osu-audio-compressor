$parentFolder = "C:\Users\YOUR USERNAME HERE\AppData\Local\osu!\Songs"
# Get only the top-level directories and loop through them
Get-ChildItem -Path $parentFolder -Directory | ForEach-Object {
    # The current folder object is represented by the $_ variable inside the loop
    $folder = $_.FullName
    Write-Host "Processing folder: $($folder)"
    Get-ChildItem -Path $folder -Filter "*.wav" -File | ForEach-Object {
        $audio = $_.FullName
        Write-Host "Processing : $audio"
        $temp = [System.IO.Path]::ChangeExtension($audio, ".ogg")
        ffmpeg -hide_banner -loglevel error -y -i "$audio" -c:a libvorbis -q:a 3 "$temp"
        if ($LASTEXITCODE -eq 0 -and (Test-Path $temp)) {
            Remove-Item "$audio"
        }
        else {
            Write-Host "  Conversion failed. Original kept."
            Remove-Item "$temp" -ErrorAction SilentlyContinue
        }
    }
}
