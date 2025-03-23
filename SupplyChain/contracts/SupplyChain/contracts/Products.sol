// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.29;

import "./Types.sol";
import "./Users.sol";

contract Products {
    Types.Product[] internal products;
    mapping(string => Types.Product) internal product;
    mapping(string => address[]) internal productOwnerHistory;
    mapping(address => string[]) internal userProducts;

    event NewProduct(
        string name,
        string manufacturerName,
        string productId,
        address[] ownerHistory
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
        productOwnerHistory[product_.productId].push(msg.sender);

        emit NewProduct(
            product_.name,
            product_.manufacturerName,
            product_.productId,
            product_.ownerHistory
        );
    }

    function getProductOwnerHistory(string memory productId_) internal view returns (Types.User[] memory) {
        address[] memory owners = productOwnerHistory[productId_];
        Types.User[] memory history;
        for (uint256 i = 0; i < owners.length; i++) {
            //history[i] = getUserDetails(owners[i]);
        }
        return history;
    }

    function sell(address buyerId, address sellerId, string memory productId_, Types.User memory buyer, Types.User memory seller) internal {
        Types.Product memory product_ = product[productId_];

        // get seller product list
        string[] storage sellerProducts = userProducts[sellerId];

        // get product index
        uint256 productIndex = sellerProducts.length;
        for (uint256 i = 0; i < sellerProducts.length; i++) {
            if (keccak256(bytes(sellerProducts[i])) == keccak256(bytes(productId_))) {
                productIndex = i;
                break;
            }
        }
        require(productIndex < sellerProducts.length, "Product not found in seller's inventory");

        // swap with last element
        if (productIndex < sellerProducts.length - 1) {
            sellerProducts[productIndex] = sellerProducts[sellerProducts.length - 1];
        }
        // and pop from seller product list
        sellerProducts.pop();

        // push to buyer product list
        userProducts[buyerId].push(productId_);

        // push to product ownership history
        productOwnerHistory[productId_].push(buyerId);

        emit ProductOwnershipTransfer(
            product_.name,
            product_.manufacturerName,
            product_.productId,
            buyer.name,
            seller.name
        );
    }
}