// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./SubBookToken.sol";

contract BookContract is
    Initializable,
    UUPSUpgradeable,
    ERC721Upgradeable,
    ERC721URIStorageUpgradeable,
    OwnableUpgradeable
{
    // todo functionn to return nextTokenId
    uint256 private nextTokenId  ;
    // Map Store if book is Divided Into Token
    //Book TOKEN Id - bool
    mapping(uint256 => bool) private mapBookDivided;
   

    // addrres of Contract erc1155
    SubBookToken private  subBookTokenContract ;
  
  
    mapping(address =>  uint256[] ) private bookIpOwnedByUser;

       
 

    function initialize() public initializer {
     //   _disableInitializers();
        __ERC721_init("Bilgamesh", "BLS");
        __ERC721URIStorage_init();
        __Ownable_init();
        __UUPSUpgradeable_init();
      nextTokenId   =0;
    }

    function setsubBookTokenAddress( address _subBookTokenContract ) external onlyOwner  {
          
    subBookTokenContract = SubBookToken(_subBookTokenContract);
    }

     function addBook(
        address owner, 
        string memory tokenURI 
    ) external {
        uint256 tokenId = nextTokenId;
        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);
        bookIpOwnedByUser[owner].push(tokenId);
        nextTokenId++;
    }

     function divideBook(  address caller, uint256 bookTokenId) external returns (address) {
        // check if token exists
        require(_exists(bookTokenId), "Token does not exist");
        // check if the sender is the owner
        require(
            caller== ownerOf(bookTokenId),
            "Only the owner can divide the book"
        );
        // check if book already divide
        require(!mapBookDivided[bookTokenId], "Book has already been divided");

       

        subBookTokenContract.mint(caller,bookTokenId)  ;
	

        // add to map divided true
        mapBookDivided[bookTokenId] = true;
    
   
    }


  
    function _burn(uint256 id)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        // todo update this code
        super._burn(id);
    }

    function tokenURI(uint256 id)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(id);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}
}



