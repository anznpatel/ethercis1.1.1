# Docker container for EtherCIS
This is a docker container for <a href="https://github.com/ethercis/ethercis" target="_blank">EtherCIS</a>, an open source openEHR server. It supports the latest summer edition, EtherCIS v1.1.1

## Build Status

<img src="https://anpether.visualstudio.com/_apis/public/build/definitions/01417fa5-d121-448e-acdd-e6a1c302632e/1/badge"/>

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
*Prerequisites: To create a secure cluster you pass your SSH public key during deployment*

Click the button below to deploy this application on Azure.

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)
</hr>
<img width=500 src="https://github.com/anznpatel/ethercis1.1.1/raw/master/images/deployment.gif">

### Next steps
1. Go to 'Manage Resources' in your Azure Portal and click on the new resource group you created
2. Click on the master-vm and select 'Network Interfaces' 
  * Dissociate the IP by clicking on the ... in the right corner
  * Disable NSG settings

## API

* EtherCIS uses a RESTful API similar to the <a href="https://code4health.org/platform/open_interfaces_apis/ehrscape/ehrscape_api_reference" target="_blank">Ehrscape API.</a>
* The Docker image contains no data upon startup. Data can be imported into the application and Postgres database using the various queries described in the Ehrscape API.

## Notes

* EtherCIS is still in active development. If you encounter any issues please use the <a href="https://github.com/ethercis/ethercis/issues" target="_blank">EtherCIS issue tracker.</a>
* For more information please refer to the official <a href="https://github.com/ethercis/ethercis/tree/master/doc" target="_blank">EtherCIS documentation.</a>

## License

* The EtherCIS platform is licensed under the Apache License. A copy of the license can be found in the <a href="https://github.com/anznpatel/docker-ethercis/tree/master/application/ethercis-1.1.1" target="_blank">EtherCIS subfolder.</a>
* All other code is licensed under the MIT ©
