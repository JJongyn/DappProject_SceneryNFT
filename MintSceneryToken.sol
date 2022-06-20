// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintSceneryToken is ERC721Enumerable {
    constructor() ERC721("scenery", "JY") {}

    mapping(uint256 => uint256) public sceneryTypes;

    function mintSceneryToken() public {
        uint256 sceneryTokenId = totalSupply() + 1; // 현재 token id = 3이면 다음 NFT의 token id = 4 ...
        
        uint256 sceneryType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, sceneryTokenId))) % 5 + 1; // random
        
        sceneryTypes[sceneryTokenId] = sceneryType;

        _mint(msg.sender, sceneryTokenId);
    }
}