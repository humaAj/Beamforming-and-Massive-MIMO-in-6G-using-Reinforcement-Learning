# Beamforming and Massive MIMO in 6G Using Reinforcement Learning

## MS Thesis Research

**Author:** Huma Ajmal
**Degree:** MS Computer Science

### Research Area

**Artificial Intelligence | Deep Reinforcement Learning | 6G | Massive MIMO | Beamforming | Beam Selection | Wireless Communications**

---

## Overview

This repository presents my Master's research on applying **Deep Reinforcement Learning (DRL)** to beam selection in next-generation 6G wireless communication systems.

The research investigates how a **Deep Q-Network (DQN)** can be used to intelligently select beams in a Massive MIMO-based communication environment, with the aim of improving beam-selection performance while reducing the overhead associated with conventional beam sweeping.

The work focuses on the challenges of beam misalignment and beam management that can occur in high-frequency wireless communication systems.

---

## Research Problem

In millimeter-wave and future 6G communication systems, beamforming is important for establishing reliable communication between a base station and user equipment.

However, beam misalignment can result in:

* Reduced received signal strength
* Increased beam-sweeping overhead
* Higher latency
* Increased energy consumption
* Inefficient beam selection

This research investigates whether a reinforcement learning agent can learn to make better beam-selection decisions based on information available from the wireless environment.

---

## Proposed Approach

The proposed framework uses a **Deep Q-Network (DQN)** to learn beam-selection decisions.

The general workflow is:

```text
User Location / Wireless Environment
                ↓
       RSRP and Beam Information
                ↓
        Environment Creation
                ↓
       State / Observation
                ↓
            DQN Agent
                ↓
         Beam Selection
                ↓
       Reward / Penalty
                ↓
        Agent Training
                ↓
     Learned Beam-Selection Policy
                ↓
       Performance Evaluation
```

The reinforcement learning environment uses user location information, beam angles, and RSRP-related information to train the agent.

---

## System Configuration

The experimental environment considers a 6G communication system with:

* Massive MIMO
* 16 transmission beam sets
* Multiple mobile users
* User location information
* Beam-angle information
* RSRP-based performance evaluation

The thesis experiments use **10 mobile users**, with receiver positions generated across the considered simulation environment.

---

## Deep Q-Network

The DQN agent learns a policy for selecting an appropriate beam from the available beam set.

The learning process includes:

1. Initializing the communication environment
2. Defining observation and action spaces
3. Initializing the DQN
4. Selecting actions using an exploration strategy
5. Interacting with the environment
6. Receiving rewards
7. Storing experiences in the replay buffer
8. Training the Q-network
9. Updating the target network
10. Repeating the process until the learned policy is sufficiently optimized

The implementation uses experience replay and an epsilon-greedy exploration strategy.

---

## Training Configuration

The main experimental configuration includes:

| Parameter                 | Configuration |
| ------------------------- | ------------: |
| Training episodes         |           700 |
| Time steps per episode    |           200 |
| Validation/test positions |           200 |
| Beam sets                 |            16 |
| Discount factor (γ)       |          0.99 |
| Mini-batch size           |            64 |
| Replay buffer size        |        10,000 |
| Sample time               |           0.8 |
| Epsilon decay             |      1 × 10⁻⁵ |
| Target smoothing          |      1 × 10⁻³ |

The experiments were implemented using **MATLAB** and the MATLAB Reinforcement Learning Toolbox.

---

## Algorithms Compared

The DQN-based approach was evaluated against several alternative approaches, including:

* Deep Q-Network (DQN)
* K-Nearest Neighbors (KNN)
* Random Forest
* Neural Network
* Random beam selection
* Statistical-information-based beam selection

The comparison was designed to evaluate the effectiveness of intelligent beam selection using different machine learning and baseline approaches.

---

## Evaluation Metrics

The research evaluates beam-selection performance using:

### RSRP

Received Reference Signal Power is used to evaluate the received signal strength associated with beam selection.

### Spectral Efficiency

Spectral efficiency is used to evaluate how effectively the available communication spectrum is utilized.

### Energy Efficiency

Energy efficiency evaluates communication performance in relation to energy consumption.

### Throughput

Throughput is used to evaluate the effective data transmission performance of the communication system.

---

## Key Findings

The experiments indicate that the reinforcement-learning-based approach can effectively learn beam-selection decisions in the simulated 6G environment.

The trained DQN agent was able to select beams corresponding to high signal-strength conditions and demonstrated competitive performance against the evaluated machine learning and baseline approaches.

Under the experimental conditions reported in the thesis, beams with more than **90% of the maximum signal strength** were consistently selected by the optimized agent.

The research also evaluates improvements in RSRP, energy efficiency, spectral efficiency, and throughput.

> **Important:** The reported results are specific to the simulation environment and experimental configuration used in this research and should not be interpreted as universal performance guarantees.

---

## Research Contributions

The research investigates an AI-based approach to beam management in 6G systems by combining:

* Massive MIMO
* Beamforming
* Machine Learning
* Deep Reinforcement Learning
* Deep Q-Networks
* Beam-selection optimization

The work provides a foundation for further investigation of **AI-enabled wireless communication systems and intelligent beam management in 6G networks**.

---

## Tools & Technologies

* MATLAB
* MATLAB Reinforcement Learning Toolbox
* Deep Q-Network (DQN)
* Deep Reinforcement Learning
* Machine Learning
* Massive MIMO
* Beamforming
* 6G Wireless Communications

---

## Repository Status

This repository is intended to document my MS research and provide a high-level overview of the methodology, experimental framework, and selected results.

Some implementation details, datasets, and research materials may not be publicly available because related research is currently not published.

---

## Future Research Directions

Potential directions for extending this research include:

* Reinforcement learning for dynamic beam management
* AI-based wireless resource allocation
* Multi-agent reinforcement learning for wireless networks
* AI-enabled millimeter-wave and sub-THz communications
* AI for Non-Terrestrial Networks (NTN)
* Satellite-assisted wireless communication
* Edge AI for wireless systems
* Intelligent and autonomous 6G networks
* Hardware/FPGA implementation of lightweight AI models

---


