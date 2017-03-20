# Docker container for EtherCIS
This is a docker container for <a href="https://github.com/ethercis/ethercis" target="_blank">EtherCIS</a>, an open source openEHR server. It supports the latest summer edition, EtherCIS v1.1.1

## Build Status

<img src="https://aethercis.visualstudio.com/_apis/public/build/definitions/2029b45d-6729-4066-afa6-6eb91653e010/1/badge"/>

## Setup locally

1. Install the latest version of <a href="https://www.docker.com" target="_blank">Docker</a>. Docker Compose version 2 is required.
2. Clone the repository.
3. Open a terminal in the directory where you cloned the repo.
4. Run `docker-compose up`.
5. Once the startup process completes your terminal should display a message saying

   ``` 
   INFO - com.ethercis.vehr.Launcher.start(140) | Server listening at:http://{container-ip}:8080/ 
   ```
6. Find the ip of your Docker environment:
  * If you are using Docker toolbox this tends to be `192.168.99.100`.
  * If you are using a native Docker installation it will be `localhost`.
7. You can now connect to the RESTful API via ``` {docker-ip}:8080/{rest-query} ```

## Deployment
*Prerequisites: To create a secure cluster you need to pass your SSH public key during deployment*

Click the button below to deploy this application on Azure.

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)
</hr>
<img width=500 src="https://github.com/anznpatel/ethercis1.1.1/raw/master/images/deployment.gif">

### Next steps
1. Go to 'Manage Resources' in your Azure Portal and click on the new resource group you created
2. Fork this repo and edit the **docker-compose.env.production.yml** file, replace the letters "aethercis" to your username that you set during deployment
3. Click on the **containerservice-resource_group_name** and select 'Releases' 
  * Get started via Github
  * Authenticate your Github account and select the forked repo from your Github account
  * Define the VSTS project name and account name and select 'create'
  * Wait for the Continous Deployment pipeline to succeed
4. Visit **visualstudio.com** and locate the account you created, open the project related to that account
5. Click on the 'Build and Release' button, wait for the build to be successful
6. Select the 'Releases' tab and double click on 'Release-1' - the project will automatically deploy in the **Dev** environment
7. Select the **Deploy** button and deploy to the Production environment

## API

* To test whether the deployment was successful you can perform the following REST API call via command line. Don't forget to change the URL to that of your deployment.
   ``` 
   curl -X POST -H "Auth-Token: {{Auth-Token}}" -H "Cache-Control: no-cache" -H "Postman-Token: f4190d7a-12ea-6fdb-5b73-09206aa8639c" -d '' "http://aethercisagents.westus.cloudapp.azure.com:80/rest/v1/session?username=guest&password=guest" 
   ```
* EtherCIS uses a RESTful API similar to the <a href="https://code4health.org/platform/open_interfaces_apis/ehrscape/ehrscape_api_reference" target="_blank">Ehrscape API.</a>
* The Docker image contains no data upon startup. Data can be imported into the application and Postgres database using the various queries described in the Ehrscape API.

## Notes

* EtherCIS is still in active development. If you encounter any issues please use the <a href="https://github.com/ethercis/ethercis/issues" target="_blank">EtherCIS issue tracker.</a>
* For more information please refer to the official <a href="https://github.com/ethercis/ethercis/tree/master/doc" target="_blank">EtherCIS documentation.</a>

## License

* The EtherCIS platform is licensed under the Apache License. A copy of the license can be found in the <a href="https://github.com/anznpatel/docker-ethercis/tree/master/application/ethercis-1.1.1" target="_blank">EtherCIS subfolder.</a>
* All other code is licensed under the MIT ©
