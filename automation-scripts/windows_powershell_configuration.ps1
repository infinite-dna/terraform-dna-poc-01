# Set the execution policy to RemoteSigned for the current user
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or, set the execution policy to RemoteSigned for the local machine (requires admin)
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine

# Check if the profile exists
Test-Path $PROFILE

# Create the profile if it does not exist
New-Item -Path $PROFILE -Type File -Force

# Open the profile in notepad to edit
notepad $PROFILE
