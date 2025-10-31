// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC20} from "src/ERC20.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployERC20 is Script {
    string public constant TOKEN_NAME = "Shiva Sai";
    string public constant TOKEN_SYMBOL = "SSB";
    uint256 public constant INITIAL_SUPPLY = 1000 * 10 ** 18;

    function run() external returns (ERC20) {
        vm.startBroadcast();

        ERC20 token = new ERC20(TOKEN_NAME, TOKEN_SYMBOL);
        console.log("ERC20 deployed at:", address(token));
        console.log("Name:", TOKEN_NAME);
        console.log("Symbol:", TOKEN_SYMBOL);

        if (INITIAL_SUPPLY > 0) {
            token.mint(msg.sender, INITIAL_SUPPLY);
            console.log("Minted initial supply:", INITIAL_SUPPLY);
            console.log("Minted to:", msg.sender);
        }

        vm.stopBroadcast();

        console.log("Deployment complete.");
        console.log("Total supply:", token.totalSupply());
        console.log("Owner balance:", token.balanceOf(msg.sender));

        return token;
    }
}
