// File: `./migrations/1_deploy_filieratoken.js`

var Filieratoken = artifacts.require("Filieratoken");

module.exports = function (deployer) {
  deployer.deploy(Filieratoken);
}