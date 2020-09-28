# ico_assign

Features of the ICO contract:
    Token smart contract 
    Crowdsale smart contract 
    Whitelisitng for investors - Owner of the contract can whitelist people
    Bonus Structure - Implemented as per the problem statement
    Crowdsale timeline Structure - Implemented as per the problem statement
    
Could not set dynamic ETH/USD price conversion with the help of Oracles. So the price set are static.
Also could not make a function to restart the crowdsale completely. Rest all the things mentioned in the problem statement are implemented.

ICO contract is DappTokenCrowdsale.sol.

If the below error pops: 
          "CompileError: InternalCompilerError: Compiled contract not found.
          Compilation failed. See above."
delete the build folder or use "rm build" in the terminal to remove all files and compile again.
I haven't been able to pinpoint the exact cause of it throwing this error but it happens when the refundable contracts are started to compile.

You can also deploy it on infura.
