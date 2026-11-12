# FUN Arcade · Pump & Flap

**Play:** https://vacas-coded.github.io/fun-arcade/

A flappy-style arcade game on **Robinhood Chain testnet** where you need **$FUN** to play.
Dodge the red rug candles, grab green pumps (+3) and become the champion of the day, recorded on-chain.

## How it works
- **Hold to play:** your wallet needs at least **10,000 $FUN** to open an on-chain run. Tokens are never spent; you only have to hold them.
- **More FUN = more lives:** +1 life for every 250,000 FUN held, up to 5 lives.
- **On-chain runs:** `play()` opens a run, and `submitScore(runId, score)` records it once, within 1 hour.
- **Daily champion:** the best score of each UTC day is stored on-chain (`championOf(day)`).
- **Practice mode:** play without a wallet. Practice scores are not recorded.

## Features
- **4-step onboarding (free):** connect wallet, add Robinhood testnet in one tap, claim free test ETH at the official faucet, buy 10k $FUN. Each step ticks green when done. Mobile users without a wallet get deep links to open the arcade inside MetaMask, Coinbase Wallet, OKX or Trust.
- **Crown countdown:** time left until today's champion is locked, and practice scores show where they would rank.
- **Buy $FUN in-game:** one tap buys straight from the $FUN bonding curve on vibe/vibe (0.0002 / 0.0005 / 0.001 ETH).
- **Holder perks:** holders of 10k+ FUN get the green Holder skin. Holders of 250k+ get the 💎 Diamond skin and start every run with a shield.
- **💎 Shield pickups:** a shield absorbs one hit.
- **🔥 Streaks:** +5 bonus every 10 candles in a row without getting hit.
- **Share your score on X** after every run.
- Synth sounds (with mute) and haptics on mobile. Physics at a fixed 60 Hz, so it plays the same on 60 Hz and 120 Hz screens.
- Live arcade stats: on-chain runs, players, champion of the day and all-time top 10.

## Contracts (Robinhood Chain testnet, chainId 46630)
| | Address |
|---|---|
| $FUN (vibe/vibe launch #2461) | `0x7Cc4e096dd2309203A2102B34EEe6550722EF386` |
| FunArcade | `0x9a1e51d31eF5CF7AaF90f7D4F9D43f6cc4D08B7C` |

Get $FUN: https://testnet.vibevibe.fun/token/0x7Cc4e096dd2309203A2102B34EEe6550722EF386

The source of `FunArcade` is in [`contracts/FunArcade.sol`](contracts/FunArcade.sol). It has no owner and no admin keys.

## Stack
A single static `index.html` (canvas + ethers v6) and a Solidity 0.8.24 contract. Vibe-coded.

## Roadmap
- Once $FUN graduates and becomes transferable: pay-per-run mode, with the entry fee going to a daily prize pot for the champion and a share burned.
- More games in the arcade: snake-style "Degen Snake" and "Rug Runner".

Testnet only. Test tokens have no monetary value.
