Function CreateCertificate ($hostName) {
    $certificate = Get-ChildItem -Path Cert:\LocalMachine\My  | Where-Object {$_.Subject -eq "CN=$hostName"}
    if (-Not $certificate) {
        $certificate = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation "cert:\LocalMachine\My"
        $mypwd = ConvertTo-SecureString -String "1234" -Force -AsPlainText
        $certificate | Export-PfxCertificate -FilePath ".\$webSiteName.pfx" -Password $mypwd
        Import-PfxCertificate -FilePath ".\$webSiteName.pfx" -CertStoreLocation Cert:\LocalMachine\Root -Password $mypwd
    }

    $date = Get-Date
    if ($certificate.NotAfter -gt $date) {
        Get-ChildItem -Path Cert:\LocalMachine\Root  | Where-Object {$_.Thumbprint -eq  $certificate.Thumbprint} | Remove-Item -Force
        $certificate | Remove-Item -Force

        $certificate = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation "cert:\LocalMachine\My"
        $mypwd = ConvertTo-SecureString -String "1234" -Force -AsPlainText
        $certificate | Export-PfxCertificate -FilePath ".\$webSiteName.pfx" -Password $mypwd
        Import-PfxCertificate -FilePath ".\$webSiteName.pfx" -CertStoreLocation Cert:\LocalMachine\Root -Password $mypwd
    }
    return Get-Item -Path Cert:\LocalMachine\My  | Where-Object {$_.Subject -eq "CN=$hostName"}
}