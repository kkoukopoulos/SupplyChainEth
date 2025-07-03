// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import "./Types.sol";

contract Users {
    uint public userCount = 0;
    mapping (uint => Types.User) public users;

    event NewUser(
        uint id,
        string name,
        Types.UserRole role
    );

    function addUser(string memory _name, Types.UserRole _role) public {
        userCount += 1;
        users[userCount] = Types.User(userCount, _name, _role);
        emit NewUser(userCount, _name, _role);
    }
}