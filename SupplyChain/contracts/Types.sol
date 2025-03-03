// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.28;

library Types {
    enum UserRole {
        Manufacturer,
        Supplier,
        Vendor,
        Customer
    }
    
    struct UserDetails {
        UserRole role;
        address id;
        string name;
    }

    struct Product {
        string name;
        string productId;
        string manufacturerName;
        address manufacturer;
    }
}