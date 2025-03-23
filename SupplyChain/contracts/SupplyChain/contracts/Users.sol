// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.29;

import "./Types.sol";

contract Users {
    mapping(address => Types.User) internal users;

    event NewUser(
        string name,
        Types.UserRole role
    );

    function getUserDetailsFromId(address id_) internal view returns (Types.User memory) {
        return getUserDetails(id_);
    }

    function getUserDetails(address address_) public view returns (Types.User memory) {
        return users[address_];
    }

    function addUser(Types.User memory user_) internal {
        users[user_.id] = user_;

        emit NewUser(user_.name, user_.role);
    }
}