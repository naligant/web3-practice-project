// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NFT is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public mintPrice = 0.01 ether;
    string private baseTokenURI;
    uint private _tokenIdCounter;

    constructor(
        string memory name,
        string memory symbol,
        string memory _baseURI
    ) ERC721(name, symbol) Ownable(msg.sender) {
        baseTokenURI = _baseURI;
    }

    function mint(uint256 quantity) public payable {
        require(_tokenIdCounter + quantity <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= quantity * mintPrice, "Insufficient payment");

        for (uint256 i = 0; i < quantity; i++) {
            _tokenIdCounter++;
            _safeMint(msg.sender, _tokenIdCounter);
        }
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter;
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseTokenURI = _baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
