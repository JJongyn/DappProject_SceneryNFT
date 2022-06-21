// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract MintNftToken is ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("_name", "_symbol") {}

    mapping(uint => string ) public tokenURIs;

    function tokenURI(uint _tokenId) override public view returns (string memory){
        return tokenURIs[_tokenId];
    }

    function mintNFT(string memory _tokenURI) public returns (uint256){
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        tokenURIs[tokenId] = _tokenURI;
        _mint(msg.sender, tokenId);

        return tokenId;

    }

    struct NftTokenData {
        uint256 nftTokenId;
        string nftTokenURI;
        uint price;
    }

    // Owner가 보유한 nft의 수 
    function getNftTokens(address _nftTokenOwner) view public returns (NftTokenData[] memory) {
        uint256 balanceLength = balanceOf(_nftTokenOwner);

        // require(balanceLength != 0, "Owner did not have token.");

        for(int i = 0; i < balanceLength; i++){
            uint256 nftTokenId = tokenOfOwnerByIndex(_nftTokenOwner, i);
            string memory nftTokenURI = tokenURI(nftTokenId);
            uint tokenPrice = getNftTokenPrice(nftTokenId);
            NftTokenData[i] = NftTokenData(nftTokenId, nftTokenURI, tokenPrice);
        }

        return NftTokenData;
    }

    // 판매 등록
    mapping(uint256 => uint256) public nftTokenPrices; // 판매 상태 확인
    uint256[] public onSaleNftTokenArray;

    function setSaleNftToken(uint256 _tokenId, uint256 _price) public {
        address nftTokenOwner = ownerOf(_tokenId);
        require(msg.sender == nftTokenOwner, "Caller is not token owner.");
        require(_price > 0, "Price is zero or lower");
        require(nftTokenPrices[_tokenId] == 0, "token is already on sale.");
        require(isApprovedForAll(nftTokenOwner, address(this)), "nft token owner did not approve token.");

        nftTokenPrices[_tokenId] = _price;
        onSaleNftTokenArray.push(_tokenId);
    }

    // 판매 리스트 확인
    function getSaleNftTokens() public view returns (NftTokenData[] memory ){
        uint[] memory onSaleNftToken = getSaleNftToken();

        NftTokenData[] memory onSaleNftTokens = new NftTokenData[](onSaleNftToken.length);

        for(int i = 0; i < onSaleNftToken.length; i++){
            uint256 tokenId = onSaleNftToken[i];
            uint tokenPrice = getNftTokenPrice(tokenId);
            onSaleNftTokens[i] = NftTokenData(tokenId, tokenURI(tokenId), tokenPrice);
        }
        return onSaleNftTokens;
    }

    function getSaleNftToken() view public returns (uint[] memory){
        return onSaleNftTokenArray;
    }

    function getNftTokenPrice(uint256 _tokenId) view public returns (uint256){
        return nftTokenPrices[_tokenId];
    }

    // 구매

    function buyNftToken(uint256 _tokenId) public payable{
        uint256 price = nftTokenPrices[_tokenId];
        address tokenOwner = ownerOf(_tokenId);

        require(msg.sender != tokenOwner, "Caller in Nft token owner.");
        require(price > 0, "price is zero or lower.");
        require(price <= msg.value, "Caller sent lower than price.");
        require(isApprovedForAll(tokenOwner, address(this)), "nft token owner did not approve token.");

        payable(tokenOwner).transfer(msg.value); // token owner에게 token 값 전달
        IERC721(address(this)).safeTransferFrom(tokenOwner, msg.sender, _tokenId); // tokenId를 구매자에게 전달

        // 판매 리스트에서 제거
        removeToken(_tokenId);
    }

    function removeToken(uint256 _tokenId) private {
        nftTokenPrices[_tokenId] = 0;

        for(uint256 i = 0; i < onSaleNftTokenArray.length; i++){
            if(nftTokenPrices[onSaleNftTokenArray[i]] == 0){
                onSaleNftTokenArray[i] = onSaleNftTokenArray[onSaleNftTokenArray.length - 1];
                onSaleNftTokenArray.pop();
            }
        }
    }
}