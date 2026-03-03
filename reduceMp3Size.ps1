$parentFolder = "C:\Users\YOUR USERNAME HERE\AppData\Local\osu!\Songs"
# Get only the top-level directories and loop through them
Get-ChildItem -Path $parentFolder -Directory | ForEach-Object {
    # The current folder object is represented by the $_ variable inside the loop
    $folder = $_.FullName
    Write-Host "Processing folder: $($folder)"
    Get-ChildItem -Path $folder -Filter "*.mp3" -File | ForEach-Object {
        $audio = $_.FullName
        Write-Host "Processing : $audio"
        $temp  = "$folder\output.mp3"
        ffmpeg -hide_banner -loglevel error -y -i "$audio" -c:a libmp3lame -b:a 128k "$temp"
        if ($LASTEXITCODE -eq 0 -and (Test-Path $temp) -and ((Get-Item $temp).Length -gt 0)) {
            Move-Item -Force "$temp" "$audio"
        }
        else {
            Write-Host "MP3 conversion failed. Original kept."
            Remove-Item "$temp" -ErrorAction SilentlyContinue
        }
    }
    Write-Host "Done with mp3"
}
