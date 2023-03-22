pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract SubBookToken is
    Initializable,
    UUPSUpgradeable,
    ERC1155Upgradeable,
    OwnableUpgradeable
{
    // number of token of erc 1155
    uint256 private constant TOKENS_PER_BOOK = 5;

    function initialize() public initializer {
        __ERC1155_init("https://mytoken.com/token/{id}.json");
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function mint(address owner, uint256 bookIpToken) external {
        _mint(owner, bookIpToken, TOKENS_PER_BOOK, "");
    }

    // todo upgrade this code..
    // on mangment buy and sell token
    function safeTransfer(
        address from,
        address to,
        uint256 bookIpToken,
        uint256 amount,
        bytes memory data
    ) public {
        require(
            balanceOf(from, bookIpToken) >= amount,
            "SubBookToken: insufficient balance"
        );
        safeTransferFrom(from, to, bookIpToken, amount, data);
    }

    function sendRewards(
        address payable[] memory investors,
        uint256 bookIpToken,
        address payable broker
    ) external payable onlyOwner {
        // from the value should send 5% to the broker
        // then divide rest  of value to owners

        // take 5% to broker
        uint256 value = msg.value;
        uint256 percentOf5 = (value * 5) / 100;
        uint256 rewardToDistribute = value - percentOf5;
        (bool sent, bytes memory data) = broker.call{value: percentOf5}("");
        require(sent, "Failed to send Ether");
        for (uint256 i = 0; i < investors.length; i++) {
            uint256 reward = (rewardToDistribute *
                balanceOf(investors[i], bookIpToken)) / TOKENS_PER_BOOK;

            (bool sent, bytes memory data) = investors[i].call{value: reward}("");
            require(sent, "Failed to send Ether");
        }
    }

    function _authorizeUpgrade(address _newImplementation)
        internal
        override
        onlyOwner
    {}
}
