pragma solidity ^0.6.0;
// SPDX-License-Identifier: UNLICENSED

import "./supp_contracts/Crowdsale.sol";
import "./supp_contracts/CappedCrowdsale.sol";
import "./supp_contracts/TimedCrowdsale.sol";
import "./supp_contracts/WhitelistCrowdsale.sol";
import "./supp_contracts/RefundableCrowdsale.sol";
import "./supp_contracts/RefundablePostDeliveryCrowdsale.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract DappTokenCrowdsale is Pausable, Crowdsale, CappedCrowdsale, TimedCrowdsale, WhitelistCrowdsale, RefundablePostDeliveryCrowdsale{

    // Tracking contributions by an investor
    uint public investorMinCap = 1440000000000000000; // $500 in wei
    mapping(address=>uint) public contributions;

    // Crowdsale Stages
    enum CrowdsaleStage { PrivateSale, PreSale, PublicSale}
    CrowdsaleStage public stage = CrowdsaleStage.PrivateSale;

    // Crowdsale week stages
    enum CrowdsaleWeekStage {Week1, Week2, Week3, Week4}
    CrowdsaleWeekStage public weekStage = CrowdsaleWeekStage.Week1;

    address _owner;
    uint openingTime1;
    uint closingTime1;

    // Token Distribution Percentage
    uint256 public reserve = 30;
    uint256 public interestPayout = 20;
    uint256 public teamMembersHR = 10;
    uint256 public companyGeneralFund = 13;
    uint256 public bountiesAirdrops = 2;
    uint256 public tokenSalePercentage = 25;
    
    constructor(
        uint256 _rate,    // rate in TKNbits. No of tokens for 1 ether
        address payable _wallet,
        IERC20 _token1,
        uint256 _cap,
        uint256 _openingTime, 
        uint256 _closingTime,
        uint256 _goal
    )
        Crowdsale(_rate, _wallet, _token1)
        CappedCrowdsale(_cap)
        TimedCrowdsale(_openingTime, _closingTime)
        RefundableCrowdsale(_goal)
        public
    {
        require(_goal <= _cap);
        _owner = msg.sender;
        openingTime1 = _openingTime;
        closingTime1 = _closingTime;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    // Gives back a particular beneficiary's contribution
    function getUserContribution(address _beneficiary) public view returns(uint256) {
        return contributions[_beneficiary];
    }

    // Updating the Crowdsale stages and rates according to Time
    function seeCrowdsaleStage() internal {
        uint time = 1 days * 24 hours * 60 minutes * 60 seconds;  // a Day's time in seconds;
        if(block.timestamp >= openingTime1 && block.timestamp < (openingTime1 + 15 * time)){
            stage = CrowdsaleStage.PrivateSale;
        } else if(block.timestamp >= (openingTime1 + 15 * time) && block.timestamp < (openingTime1 + 30 * time)){
            stage = CrowdsaleStage.PreSale;
        } else if (block.timestamp >= (openingTime1 + 30 * time) && block.timestamp <= closingTime1) {
            stage = CrowdsaleStage.PublicSale;
            if(block.timestamp >= (openingTime1 + 30 * time) && block.timestamp < (openingTime1 + 37 * time)){
                weekStage = CrowdsaleWeekStage.Week1;
            } else if(block.timestamp >= (openingTime1 + 37 * time) && block.timestamp < (openingTime1 + 45 * time)){
                weekStage = CrowdsaleWeekStage.Week2;
            } else if(block.timestamp >= (openingTime1 + 45 * time) && block.timestamp < (openingTime1 + 52 * time)){
                weekStage = CrowdsaleWeekStage.Week3;
            } else if(block.timestamp >= (openingTime1 + 52 * time) && block.timestamp <= closingTime1){
                weekStage = CrowdsaleWeekStage.Week4;
            }
        }
        
        uint initialRate = _rate; //_rate accessed from Crowdsale
        if(stage == CrowdsaleStage.PrivateSale) {
            _rate = initialRate - (initialRate * 25)/100;                           // 25% discount to be given
        }else if(stage == CrowdsaleStage.PreSale) {
            _rate = initialRate - (initialRate * 20)/100;                           // 20% discount to be given
        }else if(stage == CrowdsaleStage.PublicSale) {
            if(weekStage == CrowdsaleWeekStage.Week1){
                _rate = initialRate - (initialRate * 15)/100;                       // 15% discount to be given
            } else if (weekStage == CrowdsaleWeekStage.Week2){
                _rate = initialRate - (initialRate * 10)/100;                       // 10% discount to be given
            } else if (weekStage == CrowdsaleWeekStage.Week3) {
                _rate = initialRate - (initialRate * 5)/100;                        // 5% discount to be given
            } else if (weekStage == CrowdsaleWeekStage.Week4) {
                _rate = initialRate;                                                // 0% discount to be given
            }
        }
    }


    // Keeping track and updating beneficiary's contributions and ensuring that they are above $500
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal override(Crowdsale, CappedCrowdsale, TimedCrowdsale, WhitelistCrowdsale) {
        seeCrowdsaleStage(); // Calling this to check the Crowdsale stage to update _rate.
        super._preValidatePurchase(beneficiary, weiAmount);
        uint256 existingContribution = contributions[beneficiary];
        uint256 newContribution = existingContribution.add(weiAmount);
        require(newContribution >= investorMinCap);  // ensuring the total contribution made is greater than the minimum contribution required of the investor to make
        contributions[beneficiary] = newContribution;
    }
    
    function _forwardFunds() internal override(Crowdsale, RefundablePostDeliveryCrowdsale) {
        super._forwardFunds();
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount) internal override(Crowdsale, RefundablePostDeliveryCrowdsale) {
        super._processPurchase(beneficiary, tokenAmount);
    }

    // Function to stop the crowdsale
    function stopCrowdsale() public onlyOwner{
        require(msg.sender == _owner, "You are not the owner");
        selfdestruct(msg.sender);
    }

    // Function to pause the crowdsale
    function pauseCrowdsale() public onlyOwner whenNotPaused{
        super._pause();
    }

    // Function to unpause the crowdsale
    function unpauseCrowdsale() public onlyOwner whenPaused{
        super._unpause();
    }

    // Function to whitelist a beneficiary
    function whitelistBeneficiary(address beneficiary) public onlyOwner {
        addWhitelisted(beneficiary);
    }

    // Function to remove whitelisted beneficiary
    function remveWhitelistedBeneficiary(address beneficiary) public onlyOwner {
        removeWhitelisted(beneficiary);
    }

}