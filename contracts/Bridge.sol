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

    event Lock(address payee, address token, uint256 amount);
    event Claim(address payee, address token, uint256 amount);

    struct UserTokens {
        address token;
        mapping(address => uint256) locked;
    }

    mapping(address => UserTokens[]) public userTokens;

    function getLockedBalance(address _token) public view returns (uint256) {
        return userTokens[msg.sender][_token].locked;
    }

    function deposit(address _token, uint256 _amt) external {
        // update balance of specified token
        u = UserTokens({token: _token});
        u.locked[msg.sender] = u.locked[msg.sender].add(_amt);

        userTokens[msg.sender].push(u);

        IERC20 token = IERC20(_token);
        token.transferFrom(msg.sender, address(this), _amt);

        emit Lock(msg.sender, _token, _amt);
    }

    function claim(uint256 _amt) external {
        // should be called when tokens are locked
    }
}
