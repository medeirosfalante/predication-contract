// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import '@openzeppelin/contracts/utils/Context.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

interface IPrediction {
    function claimable(uint256 epoch, address user) external view returns (bool);
    function refundable(uint256 epoch, address user) external view returns (bool);
    function getRound(uint256 epoch) external view returns (bool completed, uint256 totalAmount, uint256 bullAmount, uint256 bearAmount, int256 lockPrice, int256 closePrice);
    function getBet(address userAddress, uint256 epoch) external view returns (uint8 position, uint256 amount, uint256 refereeAmount, uint256 referrerAmount, bool claimed);
    function claimFromProxy(address userAddress, uint256[] calldata epochs) external;
    function betBullFromProxy(address userAddress, uint256 epoch) external payable;
    function betBearFromProxy(address userAddress, uint256 epoch) external payable;
    function claimTreasuryFromProxy(address userAddress) external;
    function claimHostedPartnerTreasuryFromProxy(address userAddress) external;
    function claimReferenceBonusFromProxy(address userAddress) external;
    function hasReferenceBonus(address userAddress) external view returns (bool);
    function hostedPartnerTreasuryAmount(address partnerAddress) external view returns (uint256);
}

//prediction contracts are owned by the PredictionFactory contract
contract PredictionsContract is Ownable {

    mapping(uint => address) private predictions;

    //add events to keep added predictions

    //--------

    modifier isPrediction(uint _id) {
        require(predictions[_id] != address(0), "not prediction");
        _;
    }

    function addPrediction(uint id, address predictionAddress) external onlyOwner {
        require(predictionAddress != address(0), "address 0");
        predictions[id] = predictionAddress;
    }

    function removePrediction(uint id) external onlyOwner {
        predictions[id] = address(0);
    }

    function claim(uint id, uint256[] calldata epochs) external isPrediction(id) {
        IPrediction(predictions[id]).claimFromProxy(msg.sender, epochs);
    }

    function betBull(uint id, uint256 epoch) external payable isPrediction(id) {
        IPrediction(predictions[id]).betBullFromProxy{value:msg.value}(msg.sender, epoch);
    }

    function betBear(uint id, uint256 epoch) external payable isPrediction(id) {
        IPrediction(predictions[id]).betBearFromProxy{value:msg.value}(msg.sender, epoch);
    }

    function claimable(uint id, uint256 epoch, address user) external view isPrediction(id) returns (bool) {
        return IPrediction(predictions[id]).claimable(epoch, user);
    }

    function refundable(uint id, uint256 epoch, address user) external view isPrediction(id) returns (bool) {
        return IPrediction(predictions[id]).refundable(epoch, user);
    }

    function getRound(uint id, uint256 epoch) external view returns (bool completed, uint256 totalAmount, uint256 bullAmount, uint256 bearAmount, int256 lockPrice, int256 closePrice) {
        (completed, totalAmount, bullAmount, bearAmount, lockPrice, closePrice) = IPrediction(predictions[id]).getRound(epoch);
    }

    function getBet(uint id, uint256 epoch, address user) external view isPrediction(id) returns (uint8 position, uint256 amount, uint256 refereeAmount, uint256 referrerAmount, bool claimed) {
        (position, amount, refereeAmount, referrerAmount, claimed) = IPrediction(predictions[id]).getBet(user, epoch);
    }

    function claimTreasury(uint id) external isPrediction(id) {
        IPrediction(predictions[id]).claimTreasuryFromProxy(msg.sender);
    }
    
    function claimHostedPartnerTreasury(uint id) external isPrediction(id) {
        IPrediction(predictions[id]).claimHostedPartnerTreasuryFromProxy(msg.sender);
    }

    function claimReferenceBonus(uint id) external isPrediction(id) {
        IPrediction(predictions[id]).claimReferenceBonusFromProxy(msg.sender);
    }

    function hasReferenceBonus(uint id, address user) external view isPrediction(id) returns (bool) {
        return IPrediction(predictions[id]).hasReferenceBonus(user);
    }

    function hostedPartnerTreasuryAmount(uint id, address partnerAddress) external view returns (uint256) {
        return IPrediction(predictions[id]).hostedPartnerTreasuryAmount(partnerAddress);
    }

}