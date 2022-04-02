// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721 {
    uint256[] private _allTokens;

    // Mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    // Mapping of owner to list of all owner token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // See ERC721.sol for virtual function
    // This is the one that is overrriding
    function _mint(address to, uint256 tokenId) internal override(ERC721) {
      super._mint(to, tokenId);
      /**
        2 things!
        A. Add tokent to the owner
        B. All tokens to our totalSupply - to allTokens
       */

      _addTokensToTotalSupply(tokenId);
    }

    function _addTokensToTotalSupply(uint256 tokenId) private {
      _allTokens.push(tokenId);
    }

    function totalSupply() public view returns (uint256) {
      return _allTokens.length;
    }
}