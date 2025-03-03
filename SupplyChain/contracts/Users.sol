// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.28;

import "./Types.sol";

contract Users {
    mapping(address => Types.UserDetails) internal users;

    event NewUser(
        string name,
        Types.UserRole role
    );

    function getUserDetails(address id_) internal view returns (Types.UserDetails memory) {
        return users[id_];
    }

    function add(Types.UserDetails memory user) internal {
        users[user.id] = user;

        emit NewUser(user.name, user.role);
    }
}