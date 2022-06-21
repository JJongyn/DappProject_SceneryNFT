# DappProject_SceneryNFT

## 2022.06.22
  * 새로운 smart contract 코드로 변경 -> nft.sol
  * tokenOfOwnerByIndex(address owner, uint256 index)
    - owner의 index token 목록에서 소유한 토큰 ID 반환
  * 판매중인 token list에서 판매 완료 후 제거 방법
    - 판매완료 -> price = 0
    - 판매 리스트 중 price = 0인 token 판별
    - 마지막 index token과 바꾼 후 pop()

## 2022.06.21
  * node.js, web3 연동
    - web3 is not defined -> npm install web3
  * TypeError: react__WEBPACK_IMPORTED_MODULE_1__.useSyncExternalStore is not a function
    - npm i --save react@next react-dom@next
  * node.js, web3 version 호환 문제로 재설치

## 2022.06.20
  * NFT Smart Contract 코드 작성
    - NFT minting, sale 
  * vs code -> remix local 옮기는 명령어
    - remixd -s . --remix-ide https://remix.ethereum.org
  * src/index.js 오류 
    - plugin-ws/package.json에서 main : src/index.js을 index.js으로 변경

