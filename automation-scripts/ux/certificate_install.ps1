# Copy certificates from storage to C:\Temp folder
$source = "\\azndnapocstorageaccount.file.core.windows.net\dnaprereqsSharedna_certificates.zip"
$destination = "C:\Temp"
Invoke-WebRequest -Uri $source -OutFile "$destination\dna_certificates.zip"

# Unzip dna_certificates
Expand-Archive -Path "$destination\dna_certificates.zip" -DestinationPath $destination

# Import Binding PFX certificate to Windows certificate store
$bindingCertificatePath = "$destination\on-prod-dna-poc-7-21.pfx"
$bindingCertificatePassword = "osi"
Import-PfxCertificate -FilePath $bindingCertificatePath -CertStoreLocation Cert:\LocalMachine\My -Password (ConvertTo-SecureString -String $bindingCertificatePassword -AsPlainText -Force) -Exportable

# Import Encrypting PFX certificate to Windows certificate store
$encryptingCertificatePath = "$destination\dna-poc-encryption.pfx"
$encryptingCertificatePassword = "osi"
Import-PfxCertificate -FilePath $encryptingCertificatePath -CertStoreLocation Cert:\LocalMachine\My -Password (ConvertTo-SecureString -String $encryptingCertificatePassword -AsPlainText -Force) -Exportable

# Import Signing PFX certificate to Windows certificate store
$signingCertificatePath = "$destination\dna-poc-signature.pfx"
$signingCertificatePassword = "osi"
Import-PfxCertificate -FilePath $signingCertificatePath -CertStoreLocation Cert:\LocalMachine\My -Password (ConvertTo-SecureString -String $signingCertificatePassword -AsPlainText -Force) -Exportable

# Import Signing PFX certificate to Windows Trusted People certificate store
Import-PfxCertificate -FilePath $signingCertificatePath -CertStoreLocation Cert:\LocalMachine\TrustedPeople -Password (ConvertTo-SecureString -String $signingCertificatePassword -AsPlainText -Force) -Exportable

# Import Trusted Root Certificate Authority to Windows Trusted Root store
$trustedRootCertificatePath = "$destination\oracle_ca.cer"
Import-Certificate -FilePath $trustedRootCertificatePath -CertStoreLocation Cert:\LocalMachine\Root
