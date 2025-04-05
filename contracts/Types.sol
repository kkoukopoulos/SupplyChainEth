// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

library Types {
    enum UserRole {
        Manufacturer,
        Supplier,
        Vendor,
        Customer
    }
    
    struct User {
        UserRole role;
        address id;
        string name;
    }

    struct Product {
        string name;
        string productId;
        string manufacturerName;
        address manufacturer;
        uint256 manufacturedTime;
    }

    struct ProductOwnerHistory {
        address owner;
        uint256 timestamp;
    }
}