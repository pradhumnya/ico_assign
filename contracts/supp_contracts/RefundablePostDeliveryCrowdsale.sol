pragma solidity ^0.6.0;
// SPDX-License-Identifier: UNLICENSED

import "./RefundableCrowdsale.sol";
import "./PostDeliveryCrowdsale.sol";


/**
 * @title RefundablePostDeliveryCrowdsale
 * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
 * once the crowdsale has closed and the goal met, preventing refunds to be issued
 * to token holders.
 */
abstract contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale, PostDeliveryCrowdsale {
    function withdrawTokens(address beneficiary) public override{
        require(finalized(), "RefundablePostDeliveryCrowdsale: not finalized");
        require(goalReached(), "RefundablePostDeliveryCrowdsale: goal not reached");

        super.withdrawTokens(beneficiary);
    }

    function _forwardFunds() internal override(Crowdsale, RefundableCrowdsale) virtual{
        super._forwardFunds();
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount) internal override(Crowdsale, PostDeliveryCrowdsale) virtual{
        super._processPurchase(beneficiary, tokenAmount);
    }
}