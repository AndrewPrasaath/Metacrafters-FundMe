//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

//Error Codes
error FundMe__NotOwner();

/**@title A contract for funding
 * @author Andrew Prasaath
 * @notice This contract is to demo a sample funding contract
 */
contract FundMe {
    //State Variables
    address private immutable i_owner;
    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmtFunded;

    //Modifier
    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Sender is not owner");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    //what if someone sends this contract without calling fund
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        //1e18 == 1 * 10 ** 18 == 1000000000000000000
        //console.log("%s funding %s ETH", msg.sender, msg.value);
        s_funders.push(msg.sender);
        s_addressToAmtFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        address[] memory funders = s_funders;
        //mapping can't be in memory, sorry!
        for (uint256 funderIndex; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_addressToAmtFunded[funder] = 0;
        }
        // reseting address
        s_funders = new address[](0);

        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Call failed");
    }

    // view/pure functions
    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 funder) public view returns (address) {
        return s_funders[funder];
    }

    function getAddressToAmtFunded(
        address funder
    ) public view returns (uint256) {
        return s_addressToAmtFunded[funder];
    }
}
