// SPDX-License-Identifier: UNLICENSED

// TO DO: (1) no backwards transactions, (2) timestamps [new user/product, transaction]

pragma solidity 0.8.28;

import "./Products.sol";
import "./Users.sol";

contract SupplyChain is Users, Products {
    constructor(string memory name_) {
        Types.UserDetails memory manufacturer_ = Types.UserDetails({role: Types.UserRole.Manufacturer, id: msg.sender, name: name_});
        addUser(manufacturer_);
    }

    modifier onlyRole(Types.UserRole role_) {
        require(users[msg.sender].role == role_, "Unauthorized");
        _;
    }

    function getProducts() public view returns (Types.Product[] memory) {
        return getUserProducts();
    }

    function getDetails(address id_) public view returns (Types.UserDetails memory) {
        return getUserDetails(id_);
    }

    function getMyDetails() public view returns (Types.UserDetails memory) {
        return getUserDetails(msg.sender);
    }

    function addNewUser(Types.UserDetails memory user) public onlyRole(Types.UserRole.Manufacturer) {
        addUser(user);
    }

    function addNewProduct(Types.Product memory product_) public onlyRole(Types.UserRole.Manufacturer) {
        addProduct(product_);
    }

    function sellProduct(address buyerId_, address sellerId_, string memory productId_, Types.UserDetails memory buyer_, Types.UserDetails memory seller_) public {
        sell(buyerId_, sellerId_, productId_, buyer_, seller_);
    }
}