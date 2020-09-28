const DappToken = artifacts.require("./DappToken.sol");
const DappTokenCrowdsale = artifacts.require("./DappTokenCrowdsale.sol")
require("dotenv").config({ path: "../.env" })
// const time = require('../node_modules/@openzeppelin/test-helpers/src/time')
const duration = {
    seconds: function (val) { return val; },
    minutes: function (val) { return val * this.seconds('60'); },
    hours: function (val) { return val * this.minutes('60'); },
    days: function (val) { return val * this.hours('24'); },
    weeks: function (val) { return val * this.days('7'); },
    years: function (val) { return val * this.days('365'); },
  };



module.exports = async function(deployer) {
    let addr = await web3.eth.getAccounts();

    // Addresses of the wallets of the different parties among whom the tokens are to be distributed. 
    const _reserveAddress = addr[4];
    const _interestPayoutAddress = addr[5];
    const _teamMembersHRAddress  = addr[6];
    const _companyGeneralFundAddress = addr[7];
    const _bountiesAirdropsAddress = addr[8];

    await deployer.deploy(DappToken, _reserveAddress, _interestPayoutAddress, _teamMembersHRAddress, _companyGeneralFundAddress, _bountiesAirdropsAddress);
    let instance = await DappToken.deployed();

    const latestTime = (new Date).getTime();
    const _rate = 370370; // No. of tokens that can be bought with 1 ether (Given price: $0.001 per token)
    const _wallet = addr[0];
    const _token = instance.address;
    const _openingTime = latestTime + duration.minutes(1);
    const _closingTime = _openingTime + duration.weeks(8);
    const _cap = web3.utils.toWei("36584", "ether");   // Total amount to be raised in the ICO (Given $12,500,000)
    const _goal = web3.utils.toWei("13743", "ether"); // Softcap of the ICO. (Given $5,000,000, converted to ether and then wei)

    await deployer.deploy(DappTokenCrowdsale, _rate, _wallet, _token, _cap, _openingTime, _closingTime, _goal); 
    // rate(in wei) and cap, goal to be made dynamic here
    
    await instance.transfer(DappTokenCrowdsale.address, 12500000000);  // Transfers tokens from tokenSaleTokens to DappTokenCrowdsale
};
