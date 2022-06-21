# DappProject_SceneryNFT

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

