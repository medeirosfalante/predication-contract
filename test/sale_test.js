const Prediction = artifacts.require('Prediction')
const PredictionsContract = artifacts.require('PredictionsContract')
const PredictionStaker = artifacts.require('PredictionStaker')
const PredictionReferral = artifacts.require('PredictionReferral')


contract('PopBet predication', async (accounts) => {
  it('initialize project', async () => {
    let category = await Category.deployed()
    try {
      await Prediction.initialize(accounts[2],10,10,)
    } catch (e) {
      assert.isNull(e)
      console.log(e)
    }
  })


})
