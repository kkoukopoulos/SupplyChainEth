// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import "./Types.sol";
import "./Users.sol";

contract Products {
    Types.Product[] public products;
    mapping(address => string[]) public userProducts;
    mapping(address => Types.User) public userAddress;
    mapping(string => Types.ProductHistory[]) public productHistory;

    event NewProduct(
        string name,
        string manufacturerName,
        string barcode,
        string manufacturedTime
    );

    event ProductOwnershipTransfer(
        string name,
        string manufacturerName,
        string barcode,
        string buyerName,
        string sellerName,
        uint256 transferTime
    );

    modifier onlyManufacturer() {
        require(Types.UserRole(userAddress[msg.sender].role) == Types.UserRole.Manufacturer, "Only manufacturer can add products.");
        _;
    }

    function addProduct(string memory _name, string memory _manufacturerName, string memory _barcode, string memory _manufacturedTime) public onlyManufacturer {
        products.push(Types.Product(_name, _manufacturerName, _barcode, _manufacturedTime));
        Types.Product memory _product = products[products.length-1];
        // record sender to product history
        productHistory[_product.barcode].push(Types.ProductHistory({owner: msg.sender, timestamp: block.timestamp}));

        emit NewProduct(
            _product.name,
            _product.manufacturerName,
            _product.barcode,
            _product.manufacturedTime
        );
    }

    function sell(address buyerId, string memory _barcode) public {
        Types.Product memory _product = products[_barcode];
        string[] storage sellerProducts = userProducts[msg.sender];
        // find product index
        uint256 productIndex = sellerProducts.length;
        for (uint256 i = 0; i < sellerProducts.length; i++) {
            if (keccak256(bytes(sellerProducts[i])) == keccak256(bytes(_barcode))) {
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
        userProducts[buyerId].push(_barcode);
        // record buyer to product owner history
        productHistory[_barcode].push(Types.ProductOwnerHistory({
            owner: buyerId,
            timestamp: block.timestamp
        }));

        emit ProductOwnershipTransfer(
            _product.name,
            _product.manufacturerName,
            _product.barcode,
            buyer.name,
            msg.sender.name,
            block.timestamp
        );
    }
}