# ico_assign

This ICO/STO plans to raise USD 12.5 million in ETH The fundraise must only be available for whitelisted investors. The ICO will run over multiple rounds for 2 months, with a minimum of $500 per investor. The price of the underlying X token is pegged to USD, with varying bonus structures across various rounds. The ICO smart contract shall release the X ERC20 token immediately after the purchase by each investor, calculated at the various bonus structures that may be applicable during the multiple rounds of the ICO. All ETH raised in the ICO must be immediately made available in each respective crypto wallet as specified by the client without any delays, and the contract shall not hold any funds. At the client's discretion, the fundraise must lend itself to be paused, or stopped at any time.

Total number of tokens :   50,000,000,000 
Tokens division :  	 	 						
Reserve Wallet: 30% (20 billion)
Interest Payout Wallet: 20% (10 billion)
Team Members HR Wallet: 10% (5 billion) 
Company General Fund Wallet: 13% (6.5 billion) 
Bounties/Airdrops Wallet: 2% (1 billion)
Token Sale Wallet: 25% (12.5 billion) 

Token Price :   	$0.001 
Private sale Duration :  15 days
PreSale Duration : 15 Days
CrowdSale : 30 Days
SoftCap :    $5,000,000 
Bonus :  	Private Sale 25%
            Pre-Sale 20%
            CrowdSale 
                15% 1st week, 
                10% 2nd week, 
                5% 3rd week, 
                0% 4th week 
				


Features of the ICO contract:
    Token smart contract 
    Crowdsale smart contract 
    Whitelisitng for investors - Owner of the contract can whitelist people
    Bonus Structure - Implemented as per the problem statement
    Crowdsale timeline Structure - Implemented as per the problem statement
    
Could not set dynamic ETH/USD price conversion with the help of Oracles. So the price set are static. Rest all the things mentioned above are implemented.

ICO contract is DappTokenCrowdsale.sol.

If the below error pops: 
          "CompileError: InternalCompilerError: Compiled contract not found.
          Compilation failed. See above."
delete the build folder or use "rm build" in the terminal to remove all files and compile again.
I haven't been able to pinpoint the exact cause of it throwing this error but it happens when the refundable contracts are started to compile.

You can also deploy it on infura.
