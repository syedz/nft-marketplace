// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
    MINTING Function

    1. NFT to point to an address
    2. Keep track of the token IDs
    3. Keep track of token owner addresses to token IDs
    4. Keep track of how many tokens an owner address has
    5. Create an event that emits a transfer log - contract address, where it is being minted to, the ID
  */
contract ERC721 {
  event Transfer(
    address indexed from, 
    address indexed to, 
    uint256 indexed tokenId
  );

  // Mapping in solidity creates a hash table of key pair values

  // Mapping from id to the owner
  mapping(uint => address) private _tokenOwner;

  // Mapping from owner to number of owned tokens
  mapping(address => uint) private _OwnedTokensCount;

  /// @notice Count all NFTs assigned to an owner
  /// @dev NFTs assigned to the zero address are considered invalid, and this
  ///  function throws for queries about the zero address.
  /// @param _owner An address for whom to query the balance
  /// @return The number of NFTs owned by `_owner`, possibly zero
  function balanceOf(address _owner) public view returns (uint256) {
    require(_owner != address(0), 'Owner query for non-existent token');
    return _OwnedTokensCount[_owner];
  }

  /// @notice Find the owner of an NFT
  /// @dev NFTs assigned to zero address are considered invalid, and queries
  ///  about them do throw.
  /// @param _tokenId The identifier for an NFT
  /// @return The address of the owner of the NFT
  function ownerOf(uint256 _tokenId) external view returns (address) {
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), 'Owner query for non-existent token');
    return owner;
  }

  function _exists(uint256 tokenId) internal view returns(bool) {
    // setting the address of the NFT owner to check the mapping
    // of the address from tokenOwner at the tokenId
    address owner = _tokenOwner[tokenId];
    // return truthiness that address is NOT zero
    return owner != address(0);
  }

  // See ERCERC721Enumerable721.sol for override function
  // This is the one that will be overwritten (virtual)
  function _mint(address to, uint256 tokenId) internal virtual {
    // requires that the address isn't zero
    require(to != address(0), 'ERC721: Minting to the zero address');
    // requires that the token does not already exist
    require(!_exists(tokenId), 'ERC721: Token already minted');
    // we are adding a new address with a token ID for minting
    _tokenOwner[tokenId] = to;
    // keeping track of each address that is minting and adding one
    _OwnedTokensCount[to] += 1;

    emit Transfer(address(0), to, tokenId);
  }
}