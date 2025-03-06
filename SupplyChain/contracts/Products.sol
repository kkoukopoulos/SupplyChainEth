// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "./Types.sol";

contract Products {
    Types.Product[] internal products;
    mapping(string => Types.Product) internal product;
    mapping(address => string[]) internal userProducts;

    event NewProduct(
        string name,
        string manufacturerName,
        string productId
    );

    event ProductOwnershipTransfer(
        string name,
        string manufacturerName,
        string productId,
        string buyerName,
        string sellerName
    );

    function getUserProducts() internal view returns (Types.Product[] memory) {
        string[] memory ids = userProducts[msg.sender];
        Types.Product[] memory products_ = new Types.Product[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            products_[i] = product[ids[i]];
        }
        return products_;
    }


    function addProduct(Types.Product memory product_) internal {
        products.push(product_);
        product[product_.productId] = product_;
        userProducts[msg.sender].push(product_.productId);

        emit NewProduct(
            product_.name,
            product_.manufacturerName,
            product_.productId
        );
    }

    function sell(address buyerId, address sellerId, string memory productId_, Types.UserDetails memory buyer, Types.UserDetails memory seller) internal {
        Types.Product memory product_ = product[productId_];
        userProducts[buyerId].push(productId_);
        userProducts[sellerId].pop();

        emit ProductOwnershipTransfer(
            product_.name,
            product_.manufacturerName,
            product_.productId,
            buyer.name,
            seller.name
        );
    }
}