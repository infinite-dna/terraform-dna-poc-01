# Download JDK
$url = "https://download.oracle.com/otn-pub/java/jdk/16.0.2%2B7/d4a915d82b4c4fbb9bde534da945d746/jdk-16.0.2_windows-x64_bin.exe"
$outputFile = "jdk-16.0.2_windows-x64_bin.exe"
Invoke-WebRequest -Uri $url -OutFile $outputFile

# Install JDK silently
Start-Process -FilePath $outputFile -ArgumentList "/s" -Wait

# Set Environment Variables
$jdkPath = "C:\Program Files\Java\jdk-16.0.2"  # Adjust the path accordingly
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "Machine")
[Environment]::SetEnvironmentVariable("Path", "$($env:Path);$jdkPath\bin", "Machine")

# Verify Installation
java -version
 
