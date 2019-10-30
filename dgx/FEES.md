# DGX Token contract
* Mainnet contract address: [0x4f3afec4e5a3f2a6a1a411def7d7dfe50ee057bf](https://etherscan.io/address/0x4f3afec4e5a3f2a6a1a411def7d7dfe50ee057bf#code)
* Decimals: 9
* Symbol: DGX
* Name: Digix Gold Token
* Standards supported: ERC-20 and ERC-677([link](https://github.com/ethereum/EIPs/issues/677))

# Demurage fees
### Overview
* Demurrage fees can be turned off globally, exempting demurrage for all accounts. Since launch in March 2018, global demurrage has been turned off
as a promotional offer to encourage DGX usage. This fee will be turned on in the future at the discretion of Digix
* Demurrage fees can also be turned off for specific contracts/accounts

### When is it deducted from an account A?
* Before A recasts his DGX to a physical gold bar
* Before A sends some DGX to another account
* Before A receives some DGX from another account
* Quarterly, a script will be run to deduct demurrage fees from all the accounts.

### How is it calculated?
* There are 2 global variables `demurrage_base` (default to 10000000) and `demurrage_rate` (default to 165)
* Every account A has a value of `last_demurrage_payment_timestamp` (in seconds), which is initialized to be the current time when A first receives any DGXs
* When a demurrage deduction occurs at `current_time`:
  * We calculate how many whole days have passed since the `last_demurrage_payment_timestamp`:
    ```
    days_elapsed = (current_time - last_demurrage_payment_timestamp) / ONE_DAY_DURATION_IN_SECONDS
    ```
  * The demurrage fees will be calculated as such:
    ```
    demurrage_fees = days_elapsed * user_balance * demurrage_rate / demurrage_base
    ```
  * We advance the `last_demurrage_payment_timestamp` by exactly `days_elapsed`:
    ```
    last_demurrage_payment_timestamp += days_elapsed * ONE_DAY_DURATION_IN_SECONDS
    ```
    As such, the new `last_demurrage_payment_timestamp` is not necessarily the current timestamp.
    * For example: if A's `last_demurrage_payment_timestamp` is 27 hours ago, then we will deduct A's demurrage for 1 day, and update his `last_demurrage_timestamp` to be 27 - 24 = 3 hours ago

### Demurrage Calculator contract
* This contract can be used by interested third-parties to calculate the demurrage on DGX: [link to etherscan](https://etherscan.io/address/0xcd76744cd377707279cd500e40a08d707147c871#readContract)
```
function calculateDemurrage(uint256 _initial_balance, uint256 _days_elapsed)
           public
           view
           returns (uint256 _demurrage_fees, bool _no_demurrage_fees)
```
  * In the above function, the `_demurrage_fees` is the demurrage fees for a DGX balance of `_initial_balance` over a period of `_days_elapsed` days, if demurrage is turned on.
  * `_no_demurrage_fees` is true if global demurrage fees is currently turned off.

### Demurrage and `balanceOf` of the DGX Token contract
* The value returned by calling `balanceOf` of the DGX Token contract always takes into account the demurrage fees up until the current time, as if demurrage has just been deducted.

# Transfer fees
### Overview
* Transfer fees can be turned off globally, for all accounts
* Transfer fees can also be turned off for specific contracts/accounts
* There is a minimum transfer amount (default to 0.001DGX)
* A DGX transfer takes roughly 170000~220000 gas

### How is it calculated and deducted
* There are 2 global variables `transfer_fees_base` (default to 10000) and `transfer_fees_rate` (default to 13)
* Transfer fees is calculated as such:
  ```
  transfer_fees = transfer_amount * transfer_fees_rate / transfer_fees_base
  ```
* When A transfers `X` DGXs to B, A's balance will be deducted `X` and B's balance will increase `X - transfer_fees`. `transfer_fees` will go to `transfer_fee_collector`'s balance.

# Token Config contract
All the configurations related to the DGX token (such as the `demurrage_fees_base`, `demurrage_fees_rate`, `transfer_fees_base`, `transfer_fees_rate`,...) can be read from this contract: [link to etherscan](https://etherscan.io/address/0xbb246ee3fa95b88b3b55a796346313738c6e0150#readContract)
DG
