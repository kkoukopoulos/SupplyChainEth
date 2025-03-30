// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "./Types.sol";

contract Products {
    Types.Product[] internal products;
    mapping(string => Types.Product) internal product;
    mapping(address => string[]) internal userProducts;
    mapping(string => address[]) public ownerHistory;

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

    function productOwnerHistory(Types.Product memory product_) internal returns (Types.User[] memory) {

    }

    function addProduct(Types.Product memory product_) internal {
        products.push(product_);
        product[product_.productId] = product_;
        userProducts[msg.sender].push(product_.productId);
        ownerHistory[product_.productId].push(msg.sender);

        emit NewProduct(
            product_.name,
            product_.manufacturerName,
            product_.productId
        );
    }

    function sell(address buyerId, address sellerId, string memory productId_, Types.User memory buyer, Types.User memory seller) internal {
        Types.Product memory product_ = product[productId_];
        string[] storage sellerProducts = userProducts[sellerId];
        // find product index
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
        // remove from seller
        sellerProducts.pop();
        // add to buyer
        userProducts[buyerId].push(productId_);
        // record buyer to product owner history
        ownerHistory[productId_].push(buyerId);

        emit ProductOwnershipTransfer(
            product_.name,
            product_.manufacturerName,
            product_.productId,
            buyer.name,
            seller.name
        );
    }
}