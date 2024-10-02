  param
    (
         [Parameter(Mandatory=$true)]
         $loc,
         
         [Parameter(Mandatory=$true)]
         $sub,
         
         [Parameter(Mandatory=$true)]
         $baseName
    )

$rg="rg-$baseName"
$cosmoAccountName="$baseName-cosmosdb"

#create resource group
az group create --name $rg --location $loc --subscription $sub

#create App insights and get key
az group deployment create --name DeployAppInsights --template-uri https://raw.githubusercontent.com/andywahr/microservices-workshop/master/src/azuredeploy-appinsights.json --parameters name=appInsights$baseName regionId=southcentralus --resource-group $rg --subscription $sub
$appInsightsKey=az resource show --resource-group $rg --subscription $sub --resource-type Microsoft.Insights/components --name appInsights$baseName --query "properties.InstrumentationKey"

#create cosmos db account and list keys
az cosmosdb create --subscription $sub --resource-group $rg --name $cosmoAccountName
$cosmosPrimaryKey=az cosmosdb list-keys --resource-group $rg --subscription $sub --name $cosmoAccountName --query primaryMasterKey

#deploy dataloader container image
az appservice plan create --name asp-discovery --resource-group $rg --is-linux --location $loc --sku S1 --number-of-workers 1 --subscription $sub
az webapp create --subscription $sub --resource-group $rg --name $baseName-dataloader --plan asp-discovery -i microservicesdiscovery/travel-dataloader 
az webapp config appsettings set  --resource-group $rg --subscription $sub --name $baseName-dataloader --settings DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey 

#deploy data service container image
az webapp create --subscription $sub --resource-group $rg --name $baseName-data --plan asp-discovery -i microservicesdiscovery/travel-data-service
az webapp config appsettings set  --resource-group $rg --subscription $sub --name $baseName-data --settings DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey 
$dataServiceUri=az webapp show -g $rg -n $baseName-data  --query "hostNames[0]"

#deploy itinerary service container image
az webapp create --subscription $sub --resource-group $rg --name $baseName-itinerary --plan asp-discovery -i microservicesdiscovery/travel-itinerary-service 
az webapp config appsettings set  --resource-group $rg --subscription $sub --name $baseName-itinerary --settings DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey 
$itineraryServiceUri=az webapp show -g $rg -n $baseName-itinerary  --query "hostNames[0]"

#create and deploy app service container
az webapp create --subscription $sub --resource-group $rg --name $baseName-web --plan asp-discovery -i microservicesdiscovery/travel-web 
az webapp config appsettings set  --resource-group $rg --subscription $sub --name $baseName-web --settings DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey DataServiceUrl="https://$dataServiceUri/" ItineraryServiceUrl="https://$itineraryServiceUri/"

#same can be deployed using ACI
#create dataloader ACI
#az container create --subscription $sub --resource-group $rg --name $baseName-dataloader --image microservicesdiscovery/travel-dataloader --dns-name-label $baseName-dataloader --environment-variables DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey --restart-policy OnFailure
#az container attach --subscription $sub --resource-group $rg --name $baseName-dataloader

#create data service ACI
#az container create --subscription $sub --resource-group $rg --name $baseName-data --image microservicesdiscovery/travel-data-service --dns-name-label $baseName-dataservice --environment-variables DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey --restart-policy OnFailure
#$dataServiceUri=az container show -g $rg -n $baseName-data --query "ipAddress.fqdn"

#create itinerary service ACI
#az container create --subscription $sub --resource-group $rg --name $baseName-itinerary --image microservicesdiscovery/travel-itinerary-service --dns-name-label $baseName-itineraryservice --environment-variables DataAccountName=$cosmoAccountName DataAccountPassword=$cosmosPrimaryKey ApplicationInsights__InstrumentationKey=$appInsightsKey --restart-policy OnFailure
#$itineraryServiceUri=az container show -g $rg -n $baseName-itinerary --query "ipAddress.fqdn"
