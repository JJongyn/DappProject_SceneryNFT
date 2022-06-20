// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintSceneryToken.sol";

contract SaleSceneryToken {
    MintSceneryToken public mintSceneryTokenAddress;

    constructor (address _mintSceneryTokenAddress) {
        mintSceneryTokenAddress = MintSceneryToken(_mintSceneryTokenAddress);
    }

    mapping(uint256 => uint256) public sceneryTokenPrices;
    uint256[] public onSaleSceneryTokenArray; 


    function setForSaleSceneryToken(uint256 _sceneryTokenId, uint256 _price) public{
        address sceneryTokenOwner = mintSceneryTokenAddress.ownerOf(_sceneryTokenId);

        require(sceneryTokenOwner == msg.sender, "Caller is not Scenery token owner.");
        require(_price > 0, "Price is not zero or lower.");
        require(sceneryTokenPrices[_sceneryTokenId]==0, "already on sale.");
        require(mintSceneryTokenAddress.isApprovedForAll(sceneryTokenOwner, address(this)),"Scenery token owner did not approve token.");

        sceneryTokenPrices[_sceneryTokenId] = _price;
        onSaleSceneryTokenArray.push(_sceneryTokenId);
    }

    function purchaseSceneryToken(uint256 _sceneryTokenId) public payable {
        uint256 price = sceneryTokenPrices[_sceneryTokenId];
        address sceneryTokenOwner = mintSceneryTokenAddress.ownerOf(_sceneryTokenId);

        require(price > 0, "Scenery token not sale.");
        require(price <= msg.value, "caller sent lower than price.");
        require(sceneryTokenOwner != msg.sender, "Caller is scenery token owner");

        payable(sceneryTokenOwner).transfer(msg.value);
        mintSceneryTokenAddress.safeTransferFrom(sceneryTokenOwner, msg.sender, _sceneryTokenId);

        sceneryTokenPrices[_sceneryTokenId] = 0;

        for(uint256 i = 0; i < onSaleSceneryTokenArray.length; i++){
            if(sceneryTokenPrices[onSaleSceneryTokenArray[i]] == 0){
                onSaleSceneryTokenArray[i] = onSaleSceneryTokenArray[onSaleSceneryTokenArray.length - 1];
                onSaleSceneryTokenArray.pop();
            }
        }
    }

    function getOnSaleSceneryTokenArrayLength() view public returns (uint256) {
        return onSaleSceneryTokenArray.length;
    }
}