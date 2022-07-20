const Prediction = artifacts.require('Prediction')
const PredictionsContract = artifacts.require('PredictionsContract')
const PredictionStaker = artifacts.require('PredictionStaker')
const PredictionReferral = artifacts.require('PredictionReferral')

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(Prediction, {
    from: accounts[0],
  })

  await deployer.deploy(PredictionStaker, {
    from: accounts[0],
  })
  await deployer.deploy(PredictionReferral, {
    from: accounts[0],
  })
  await deployer.deploy(PredictionsContract, {
    from: accounts[0],
  })
}
