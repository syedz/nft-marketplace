// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    uint256[] private _allTokens;

    // Mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // Mapping of owner to list of all owner token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
      _registerInteface(bytes4(keccak256('totalSupply(bytes4)')^
      keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    // See ERC721.sol for virtual function
    // This is the one that is overrriding
    function _mint(address to, uint256 tokenId) internal override(ERC721) {
      super._mint(to, tokenId);
      /**
        2 things!
        A. Add tokent to the owner
        B. All tokens to our totalSupply - to allTokens
       */

      _addTokensToAllTokenEnumeration(tokenId);
      _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the _allTokens array and set the position of the tokens index
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
      _allTokensIndex[tokenId] = _allTokens.length;
      _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
      // 1. add address and token ID to the _ownedTokens
      // 2. ownedTokensIndex tokenId set to the address of the ownedTokens position
      // 3. We want to execute the function with minting
      _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
      _ownedTokens[to].push(tokenId);
    }

    // two functions - one that returns tokenByIndex and
    // another one that returns tokenOfOwnerByIndex

    function tokenByIndex(uint256 index) public override view returns(uint256) {
      // make sure that index is not out of bounds of the total supply
      require(index < totalSupply(), 'Global index is out of bounds!');
      return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public override view returns(uint256) {
      require(index < balanceOf(owner), 'Owner index is out of bounds!');
      return _ownedTokens[owner][index];
    }

    // return the total supply of the _alltokens array
    function totalSupply() public override view returns (uint256) {
      return _allTokens.length;
    }
}