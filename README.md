---
page_type: sample
languages:
- java
- terraform
---

# Azure Spring Cloud scenario
This repo is the result of completing the training [azure-spring-cloud-training](https://github.com/microsoft/azure-spring-cloud-training). The purpose of this repo is having a working environment in Azure Spring Cloud to demonstrate its capabilities.

Hystrix-Turbine also deployed to get hystrix dashboard.

## How to deploy
This environment is deployed in two steps:
* Deploy Azure Spring Cloud infrastructure: There is a terraform script in terraform folder.
* Deploy Java applications: deployapps.sh script builds and deploy the java applications using azure cli.
## What is deployed
* Azure Spring Cloud service with following apps:
    * [simple-microservice](https://github.com/microsoft/azure-spring-cloud-training/tree/master/02-build-a-simple-spring-boot-microservice)
    * [spring-cloud-microservice](https://github.com/microsoft/azure-spring-cloud-training/tree/master/05-build-a-spring-boot-microservice-using-spring-cloud-features)
    * [city-service](https://github.com/microsoft/azure-spring-cloud-training/tree/master/06-build-a-reactive-spring-boot-microservice-using-cosmosdb)
    * [weather-service](https://github.com/microsoft/azure-spring-cloud-training/tree/master/07-build-a-spring-boot-microservice-using-mysql)
    * [gateway](https://github.com/microsoft/azure-spring-cloud-training/tree/master/08-build-a-spring-cloud-gateway)
    * [all-cities-weather-service](https://github.com/microsoft/azure-spring-cloud-training/tree/master/12-making-microservices-talk-to-each-other)
    * [hystrix-turbine](https://docs.microsoft.com/en-us/azure/spring-cloud/tutorial-circuit-breaker#using-public-endpoints)

* Application Insights linked to Azure Spring Cloud Service.
* CosmosDb service binded to app 
* MySQL database binded to app
* Configuration linked to git repository

## How to test
See [azure-spring-cloud-training](https://github.com/microsoft/azure-spring-cloud-training) for each of the scenarios.
## How to clean-up resources
You can clean-up the resources by executing:
```bash
terraform destroy
```
This should be executed in folder _terraform_

## Requirements
Terraform, Azure cli and Java 8/11 or above.

---

## Legal Notices

Microsoft and any contributors grant you a license to the Microsoft documentation and other content
in this repository under the [Creative Commons Attribution 4.0 International Public License](https://creativecommons.org/licenses/by/4.0/legalcode),
see the [LICENSE](LICENSE) file, and grant you a license to any code in the repository under the [MIT License](https://opensource.org/licenses/MIT), see the
[LICENSE-CODE](LICENSE-CODE) file.

Microsoft, Windows, Microsoft Azure and/or other Microsoft products and services referenced in the documentation
may be either trademarks or registered trademarks of Microsoft in the United States and/or other countries.
The licenses for this project do not grant you rights to use any Microsoft names, logos, or trademarks.
Microsoft's general trademark guidelines can be found at http://go.microsoft.com/fwlink/?LinkID=254653.

Privacy information can be found at https://privacy.microsoft.com/en-us/

Microsoft and any contributors reserve all other rights, whether under their respective copyrights, patents,
or trademarks, whether by implication, estoppel or otherwise.
