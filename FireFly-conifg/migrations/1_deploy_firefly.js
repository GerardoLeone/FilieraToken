// File: `./migrations/1_deploy_fireflycontract.js`

var firefly = artifacts.require("Firefly");

module.exports = function (deployer) {
  // Pass 42 to the contract as the first constructor parameter
  deployer.deploy(firefly);
}