// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract JoblyRewards {
    IERC20 public leafFlowToken;
    address public owner;
    uint256 public rewardRate = 50 * 1e18; // 50 LeafFlow tokens per task
    uint256 public stakingAPR = 10; // 10% annual return

    struct StakeInfo {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => StakeInfo) public stakes;

    event TaskReward(address indexed user, uint256 amount);
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(address _leafFlowToken) {
        leafFlowToken = IERC20(_leafFlowToken);
        owner = msg.sender;
    }

    function rewardContributor(address user) external onlyOwner {
        require(leafFlowToken.transfer(user, rewardRate), "Transfer failed");
        emit TaskReward(user, rewardRate);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Stake > 0");
        require(leafFlowToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        StakeInfo storage stakeData = stakes[msg.sender];
        stakeData.amount += amount;
        stakeData.timestamp = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        StakeInfo storage stakeData = stakes[msg.sender];
        require(stakeData.amount > 0, "Nothing staked");

        uint256 timeStaked = block.timestamp - stakeData.timestamp;
        uint256 reward = (stakeData.amount * stakingAPR * timeStaked) / (365 days * 100);

        uint256 total = stakeData.amount + reward;
        stakeData.amount = 0;

        require(leafFlowToken.transfer(msg.sender, total), "Transfer failed");
        emit Unstaked(msg.sender, total, reward);
    }

    function setRewardRate(uint256 newRate) external onlyOwner {
        rewardRate = newRate;
    }

    function setAPR(uint256 newAPR) external onlyOwner {
        stakingAPR = newAPR;
    }
}
