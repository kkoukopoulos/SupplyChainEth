// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "./Types.sol";

contract Users {
    mapping(address => Types.User) internal users;

    event NewUser(
        string name,
        Types.UserRole role
    );

    function getUser(address id_) internal view returns (Types.User memory) {
        return users[id_];
    }

    function addUser(Types.User memory user) internal {
        users[user.id] = user;

        emit NewUser(user.name, user.role);
    }
}