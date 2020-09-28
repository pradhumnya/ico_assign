const DappToken = artifacts.require('DappToken')
const DappTokenCrowdsale = artifacts.require('DappTokenCrowdsale')
const RefundVault = artifacts.require('./RefundEscrow');

require("dotenv").config({ path: "../.env" })
const { web3 } = require("@openzeppelin/test-helpers/src/setup");
const chai = require("./setupchai.js");
const BN = web3.utils.BN;
const expect = chai.expect;


contract("DappTokenCrowdsale Test", async (accounts) => {

    const [deployerAccount, wallet, investor1, investor2] = accounts;
    this.investorMinCap = 1440000000000000000;

    // ICO Distribution Percentage
    this.reserve = 30;
    this.interestPayout = 20;
    this.teamMembersHR = 10;
    this.companyGeneralFund = 13;
    this.bountiesAirdrops = 2;
    this.tokenSalePercentage = 25;

    // Crowdsale Config
    this._rate = 370370; // No. of tokens that can be bought with 1 ether (Given price: $0.001 per token)
    this._cap = web3.utils.toWei("36584", "ether");   // Total amount to be raised in the ICO (Given $12,500,000)


    it("all tokens should be in the DappTokenCrowdsale smart contract by default", async() => {
        let instance = await DappToken.deployed();
        this.crowdsale = await DappTokenCrowdsale.deployed();
        let balanceOfTokenSaleSmartContract = await instance.balanceOf(this.crowdsale.address);
        return expect(balanceOfTokenSaleSmartContract).to.be.a.bignumber.equal(new BN(12500000000)); // Amount of tokenSale tokens transferred to the crowdsale checked
    })

    it('has the correct hard cap', async() => {
        this.crowdsale = await DappTokenCrowdsale.deployed();
        let cap = await this.crowdsale.cap();
        return expect(cap).to.be.a.bignumber.equal(new BN(this._cap))  // Expected cap is the amount of ethers to be raised(12.5 million as given in PS)
    })

    describe('timed crowdsale', function() {
        it('is open', async function() {
          this.crowdsale = await DappTokenCrowdsale.deployed();
          const isClosed = await this.crowdsale.hasClosed();
          expect(isClosed).to.be.false;
        });
      });

    describe('whitelisted crowdsale', function() {
        it('rejects contributions from non-whitelisted beneficiaries', async function() {
            this.crowdsale = await DappTokenCrowdsale.deployed();
          const notWhitelisted = deployerAccount;
          expect(this.crowdsale.buyTokens(notWhitelisted, { value: web3.utils.toWei("1", "ether"), from: notWhitelisted })).to.eventually.be.rejected;
        });
      });

    
    describe('when the contribution is less than the minimum cap', () => {
        it('rejects the transaction', async() => {
            this.crowdsale = await DappTokenCrowdsale.deployed();
            const value = this.investorMinCap - 100;
            await this.crowdsale.whitelistBeneficiary(investor1);
            await this.crowdsale.whitelistBeneficiary(investor2);
            return expect(this.crowdsale.buyTokens(investor2, {value: value, from: investor2})).to.be.rejected;
        });

    })

    describe('Crowdsale stages', () => {
        it('starts with private sale', async() => {
            const stage = await this.crowdsale.stage();
            return expect(stage).to.be.a.bignumber.equal(new BN(this.privateSaleStage))
        });

        it('starts at the opening(deployed) rate', async() => {
            const rate = await this.crowdsale.rate();
            return expect(rate).to.be.a.bignumber.equal(new BN(this._rate))
        })
    })

    describe('Token Distribution', () => {
        it('tracks the distribution correctly', async () => {
            const tokenSalePercentage = await this.crowdsale.tokenSalePercentage();
            expect(tokenSalePercentage).to.be.a.bignumber.equal(new BN(this.tokenSalePercentage), 'has correct tokenSalePercentage');
            const interestPayout = await this.crowdsale.interestPayout();
            expect(interestPayout).to.be.a.bignumber.equal(new BN(this.interestPayout), 'has correct interestPayout Percentage');
            const reserve = await this.crowdsale.reserve();
            expect(reserve).to.be.a.bignumber.equal(new BN(this.reserve), 'has correct reserve Percentage');
            const teamMembersHR = await this.crowdsale.teamMembersHR();
            expect(teamMembersHR).to.be.a.bignumber.equal(new BN(this.teamMembersHR), 'has correct teamMembersHR Percentage');
            const companyGeneralFund = await this.crowdsale.companyGeneralFund();
            expect(companyGeneralFund).to.be.a.bignumber.equal(new BN(this.companyGeneralFund), 'has correct companyGeneralFund Percentage');
            const bountiesAirdrops = await this.crowdsale.bountiesAirdrops();
            expect(bountiesAirdrops).to.be.a.bignumber.equal(new BN(this.bountiesAirdrops), 'has correct bounties/Airdrops Percentage');
        })
    })

})