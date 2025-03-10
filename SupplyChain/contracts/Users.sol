// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "./Types.sol";

contract Users {
    mapping(address => Types.User) internal user;

    event NewUser(
        string name,
        Types.UserRole role
    );

    function getUser(address id_) internal view returns (Types.User memory) {
        return user[id_];
    }

    function addUser(Types.User memory user_) internal {
        user[user_.id] = user_;

        emit NewUser(user_.name, user_.role);
    }
}