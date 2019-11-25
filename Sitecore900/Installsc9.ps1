#Ensure that SIF 1.2.1 is the version that is active in the PowerShell session
Import-Module SitecoreInstallFramework -Force -RequiredVersion 1.2.1

#define parameters 
$InstallDirectory = "E:\websites"
# The Prefix that will be used on SOLR, Website and Database instances.
#"Site.PhysicalPath": "[joinpath(parameter('InstallDirectory'), parameter('SiteName'))]", in other 4 files
$prefix = "sc9test21" 
$PSScriptRoot = "E:\ResourceFiles\Sitecore900"
$XConnectCollectionService = "$prefix.xconnect" 
$sitecoreSiteName = "$prefix.local" 
$SolrUrl = "https://localhost:8983/solr" 
$SolrRoot = "E:\solr-6.6.2\" 
$SolrService = "solr-6.6.2" 
$SqlServer = "DESKTOP-EKGEB6G\SQLSERVER2016SP2" 
$SqlAdminUser = "sa" 
$SqlAdminPassword="password123$" 

#$solrParams = @{     
#    Path = "$PSScriptRoot\sitecore-solr.json"     
#    SolrUrl = $SolrUrl     
#    SolrRoot = $SolrRoot     
#    SolrService = $SolrService     
#    CorePrefix = $prefix 
#} 

#Install-SitecoreConfiguration @solrParams 
 
#install client certificate for xconnect 
$certParams = @{     
    Path = "$PSScriptRoot\xconnect-createcert.json"     
    CertificateName = "$prefix.xconnect_client"
	#RootCertFileName = "SIF121Root"
    } 
    
Install-SitecoreConfiguration @certParams -Verbose 
 
#install solr cores for xdb 
$solrParams = 
@{     
    Path = "$PSScriptRoot\xconnect-solr.json"     
    SolrUrl = $SolrUrl     
    SolrRoot = $SolrRoot     
    SolrService = $SolrService     
    CorePrefix = $prefix 
} 
Install-SitecoreConfiguration @solrParams -Verbose 
 
#deploy xconnect instance 
$xconnectParams = @{     
    Path = "$PSScriptRoot\xconnect-xp0.json"     
    Package = "$PSScriptRoot\Sitecore 9.0.0 rev. 171002 (OnPrem)_xp0xconnect.scwdp.zip"     
    LicenseFile = "$PSScriptRoot\license.xml"     
    Sitename = $XConnectCollectionService     
    XConnectCert = $certParams.CertificateName     
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser     
    SqlAdminPassword = $SqlAdminPassword     
    SolrCorePrefix = $prefix     
    SolrURL = $SolrUrl      
    } 

Install-SitecoreConfiguration @xconnectParams -Verbose 
 
#install solr cores for sitecore $solrParams = 
$solrParams = @{     
    Path = "$PSScriptRoot\sitecore-solr.json"     
    SolrUrl = $SolrUrl     
    SolrRoot = $SolrRoot     
    SolrService = $SolrService     
    CorePrefix = $prefix 
} 

Install-SitecoreConfiguration @solrParams 
 
#install sitecore instance 
$xconnectHostName = "$prefix.xconnect" 
$sitecoreParams = 
@{     
    Path = "$PSScriptRoot\sitecore-XP0.json"     
    Package = "$PSScriptRoot\Sitecore 9.0.0 rev. 171002 (OnPrem)_single.scwdp.zip"  
    LicenseFile = "$PSScriptRoot\license.xml"     
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser     
    SqlAdminPassword = $SqlAdminPassword     
    SolrCorePrefix = $prefix  
    SolrUrl = $SolrUrl     
    XConnectCert = $certParams.CertificateName     
    Sitename = $sitecoreSiteName         
    XConnectCollectionService = "https://$XConnectCollectionService"    
} 
Install-SitecoreConfiguration @sitecoreParams 