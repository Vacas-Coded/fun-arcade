// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20Balance {
    function balanceOf(address) external view returns (uint256);
}

/// @title FUN Arcade: hold $FUN to play Pump & Flap on Robinhood Chain testnet.
/// @notice A run is opened on-chain with play(); the wallet must hold at least `minHold` FUN.
///         More FUN = more lives per run (max 5). Scores are submitted once per run.
///         The best score of each UTC day is the "Champion of the day". No owner, no admin keys.
contract FunArcade {
    IERC20Balance public immutable fun;
    uint256 public immutable minHold;
    uint256 public constant LIVES_STEP = 250_000e18; // +1 life per 250k FUN held, on top of the first
    uint8 public constant MAX_LIVES = 5;
    uint256 public constant RUN_WINDOW = 1 hours;

    struct Run {
        address player;
        uint64 startedAt;
        uint8 lives;
        bool scored;
        uint32 score;
    }

    Run[] public runs;
    mapping(address => uint32) public bestScore;
    mapping(address => uint32) public runsPlayed;
    mapping(uint256 => address) public championOf; // day => player
    mapping(uint256 => uint32) public championScore; // day => score

    event RunStarted(uint256 indexed runId, address indexed player, uint8 lives, uint256 funBalance);
    event ScoreSubmitted(uint256 indexed runId, address indexed player, uint32 score, uint256 indexed day);
    event NewChampion(uint256 indexed day, address indexed player, uint32 score);

    error NotEnoughFun(uint256 balance, uint256 required);
    error NotYourRun();
    error AlreadyScored();
    error RunExpired();

    constructor(address fun_, uint256 minHold_) {
        fun = IERC20Balance(fun_);
        minHold = minHold_;
    }

    function livesFor(address player) public view returns (uint8) {
        uint256 bal = fun.balanceOf(player);
        if (bal < minHold) return 0;
        uint256 extra = (bal - minHold) / LIVES_STEP;
        return uint8(extra + 1 >= MAX_LIVES ? MAX_LIVES : extra + 1);
    }

    function play() external returns (uint256 runId) {
        uint8 lives = livesFor(msg.sender);
        if (lives == 0) revert NotEnoughFun(fun.balanceOf(msg.sender), minHold);
        runId = runs.length;
        runs.push(Run(msg.sender, uint64(block.timestamp), lives, false, 0));
        runsPlayed[msg.sender] += 1;
        emit RunStarted(runId, msg.sender, lives, fun.balanceOf(msg.sender));
    }

    function submitScore(uint256 runId, uint32 score) external {
        Run storage r = runs[runId];
        if (r.player != msg.sender) revert NotYourRun();
        if (r.scored) revert AlreadyScored();
        if (block.timestamp > r.startedAt + RUN_WINDOW) revert RunExpired();
        r.scored = true;
        r.score = score;
        if (score > bestScore[msg.sender]) bestScore[msg.sender] = score;
        uint256 day = block.timestamp / 1 days;
        emit ScoreSubmitted(runId, msg.sender, score, day);
        if (score > championScore[day]) {
            championScore[day] = score;
            championOf[day] = msg.sender;
            emit NewChampion(day, msg.sender, score);
        }
    }

    function totalRuns() external view returns (uint256) {
        return runs.length;
    }

    function today() external view returns (uint256 day, address champion, uint32 score) {
        day = block.timestamp / 1 days;
        return (day, championOf[day], championScore[day]);
    }
}
