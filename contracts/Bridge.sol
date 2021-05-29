//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/**
 * @title Bridge
 * @notice Base bridge contract, locks the funds and mints the equivalent (1:1 ratio)
 * amount of tokens on another chain.
 */

contract Bridge {
    using Address for address payable;
    using SafeMath for uint256;

    event Lock(address indexed payee, uint256 amount);
    event Mint(address indexed payee, uint256 amount);

    // new mappings
    mapping(address => uint256) public locked;

    IERC20 public UND;

    constructor(address _undAddress) {
        UND = IERC20(_undAddress);
    }

    // real code
    function deposit(uint256 _amt) external {
        locked[msg.sender] = locked[msg.sender].add(_amt);
        UND.transferFrom(msg.sender, address(this), _amt);
        emit Lock(msg.sender, _amt);
    }

    function claim(uint256 _amt) external {
        // should be called when tokens are locked
    }
}
