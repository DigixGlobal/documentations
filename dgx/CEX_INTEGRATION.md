# Integration of DGX into centralized exchanges

### Overview
There are two non-typical behaviours of DGX tokens that a Centralized Exchange will have to deal with:
1. Transfer fees: 0.13% of DGXs is deducted when DGX tokens are transferred from one address to another
2. Demurrage fees (which is only turned on `DEMURRAGE_START_DATE`): DGX balance of the exchange wallet will decay over time at the rate of 0.00165% a day (hence, ~0.6% a year).

More details about the DGX fees can be found at this [doc](FEES.md)

###### Contract for reading DGX fees configurations
* Details about the DGX fees (whether demurrage is turned on, the rate of demurrage and transfer fees) can be read at this contract: https://etherscan.io/address/0xbb246ee3fa95b88b3b55a796346313738c6e0150#readContract

### Bare minimum DGX integration from now to `DEMURRAGE_START_DATE`:
Since there is no demurrage fees until `DEMURRAGE_START_DATE`, centralized exchanges only need to deal with transfer fees:
* Assume that the user deposits into a personalized wallet, before the DGXs is swept to the exchange's wallet, there will be two DGX transfers which will take ~0.26%.
* For example, if a user deposits 100DGX, only 99.87DGX will go into their deposit address, out of which only 99.74DGX will go into the exchange's wallet.
* Suggestion: the exchange might want to tell the users that there is an addtional 0.26% fees when depositing DGXs and a 0.13% fees when withdrawing DGXs.
* Suggestion: the exchange should include a note to roughly explain this extra fees, and link it to a post from Digix that explains the fees.


### Extra integration needed after `DEMURRAGE_START_DATE` when demurrage is turned on:
* Since the DGX balance of the exchange wallet will decay 0.00165% a day, the exchange should deduct the users' DGX balances by 0.00165% a day as well, in order to remain solvent
* Suggested implementation:
  * The exchange should have an additional variable `lastDGXDemurrageDeduction` for every user, which could be initialized when the user deposits the first DGXs
  * Whenever there is a scenario that needs an updated DGX balance of the user, a function should be called to:
    * Calculate how many days have passed since `lastDGXDemurrageDeduction`
    * Deduct the demurrage fees from the user's DGX balance. There are multiple options an exchange could use to calculate this demurrage fees:
      * Use the `DgxDemurrageCalculator` contract (at [link](https://etherscan.io/address/0xcd76744cd377707279cd500e40a08d707147c871#readContract)) to calculate the demurrage using the current demurrage rate on the blockchain. The documentation for this contract can be found [here](https://gist.github.com/mrenoon/2582fba7b4d457d80f7d37520aabbc08)
      * Use a REST API provided by Digix that will take a `numberOfDays` and `initialBalance` and return the demurrage fees.
      * Since the demurrage rate is not likely going to change very often, the exchange could just use the rate of 0.00165% a day to calculate the demurrage. Digix will inform the exchange when this rate is about to change.
    * Update the `lastDGXDemurrageDeduction`
    * The exchange is encouraged to replicate the same demurrage deduction logic that is already described in [here](https://gist.github.com/mrenoon/2582fba7b4d457d80f7d37520aabbc08)
  * The scenarios where a user's DGX balance should be updated might include:
    * When the user logs in (either throug UI or API)
    * Right before the user makes a DGX order
    * Right before the user's balance is updated after their DGX order is filled.
  * The exchange should have a note near the user's DGX balance that briefly say that DGX balance decays overtime, and link it to a Digix post that explains it.
* Since the user's DGX balance will decay over time, a sell order of the whole DGX balance would become "insolvent" on the next day. Our suggestion to solve this problem is:
  * When placing new DGX sell orders, disallow the user to use more than 99.7% of their DGX balance in open orders. This ensures that the DGXs remaining are enough to pay for demurrage for 6 months.
  * To prevent a case where a sell order of 99.7% of the user's DGX balance remains open for more than 6 months and hence become "insolvent" (since the user balance is less than the amount on the order), a periodic script should be run at least monthly to:
    * Loop through all the users that have DGXs
    * For each user, if the DGXs in the user wallet (and are not on any open orders) are not enough to pay for at least 1 month of demurrage, cancel the open DGX orders.
  * The exchange should inform the users of these behaviors and link it to a Digix post that explains these behaviours.
