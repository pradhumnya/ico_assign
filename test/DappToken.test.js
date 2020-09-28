const DappToken = artifacts.require('DappToken')

require("dotenv").config({ path: "../.env" })

const chai = require("./setupchai.js");
const BN = web3.utils.BN;
const expect = chai.expect;

contract('DappToken', async(accounts) => {

    let addr = await web3.eth.getAccounts();
    const [deployerAccount, recepient, ac1, ac2, ac3, ac4, ac5] = accounts;
    this._reserveAddress = ac1;
    this._interestPayoutAddress = ac2;
    this._teamMembersHRAddress  = ac3;
    this._companyGeneralFundAddress = ac4;
    this._bountiesAirdropsAddress = ac5;

    beforeEach(async () => {
        this.token = await DappToken.new(this._reserveAddress, this._interestPayoutAddress, this._teamMembersHRAddress, this._companyGeneralFundAddress,this._bountiesAirdropsAddress)
    })

    it('all tokens should be in my account', async() => {
        let instance = this.Token;
        let totalSupply = await instance.totalSupply();
        return expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(totalSupply)  //eventually takes care of awaiting for the promise to be fulfilled
    })
    it("is not possible to send more tokens than available in total", async () => {
        let instance = this.token;
        let balanceOfDeployer = await instance.balanceOf(deployerAccount)
        expect(instance.transfer(recepient, new BN(balanceOfDeployer+1))).to.eventually.be.rejected
        return expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(balanceOfDeployer)
    })
})