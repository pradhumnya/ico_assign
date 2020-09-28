pragma solidity ^0.6.0;
// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Pausable.sol";

contract DappToken is ERC20Pausable {
    // Token Distribution amount
    uint256 reserveTokens             = 15000000000;
    uint256 interestPayoutTokens      = 10000000000;
    uint256 teamMembersHRTokens       =  5000000000;
    uint256 companyGeneralFundTokens  =  6500000000;
    uint256 bountiesAirdropsTokens    =  1000000000;
    uint256 tokenSaleTokens           = 12500000000;

    constructor (
        address _reserveAddress, 
        address _interestPayoutAddress,
        address _teamMembersHRAddress,
        address _companyGeneralFundAddress,
        address _bountiesAirdropsAddress
    ) public ERC20("X Token", "X")
    {   // Alloting tokens to the different parties stated.
        _mint(msg.sender, tokenSaleTokens); 
        _mint(_reserveAddress, reserveTokens);
        _mint(_interestPayoutAddress, interestPayoutTokens);
        _mint(_teamMembersHRAddress, teamMembersHRTokens);
        _mint(_companyGeneralFundAddress, companyGeneralFundTokens);
        _mint(_bountiesAirdropsAddress, bountiesAirdropsTokens);

        _setupDecimals(0);
    }
    
}