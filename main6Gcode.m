% Define Environment
rng(222)
usageOfCollectedData = true;

% Increase the number of users to 10
numUsers = 10;  % Updated number of users
numBeams = 8;

% Define user priorities for 10 users (customize as needed)
userPriorities = [0.8; 0.6; 0.4; 0.7; 0.5; 0.9; 0.3; 0.8; 0.7; 0.6];  % Example user priorities (higher is better)

% Define user spectrum requirements for 10 users (customize as needed)
userRequirements = [0.6; 0.8; 0.5; 0.7; 0.4; 0.9; 0.3; 0.7; 0.6; 0.8];  % Example user spectrum requirements

% Ensure that the lengths of these arrays match the number of users (10).

% Calculate availableResources (customize as needed)
availableResources = 1.5;  % Adjust as needed

% Call the allocateResources function to allocate resources
allocationMatrix = allocateResources(numUsers, numBeams, availableResources, userPriorities, userRequirements);

% Display the allocation matrix
disp("Resource Allocation Matrix:");
disp(allocationMatrix);

% Define the higher frequency (e.g., terahertz)
higherFrequency = 300e12; % 300 terahertz (adjust as needed)

% Update frequency-dependent parameters (e.g., wavelength)
speedOfLight = 299792458; % Speed of light in meters per second
wavelength = speedOfLight / higherFrequency;

% Compute Reference Signal Received Power (RSRP) average for each base station beam and sort in clockwise order
avgRsrpMatTrain = rsrpMatTrain / 4; % prm.NRepeatSameLoc=4;
avgRsrpMatTrain = 100 * avgRsrpMatTrain ./ max(avgRsrpMatTrain, [], "all");

% Angle rotation matrix: update beam numbers (nBeams > 4)
txBeamAng = [-55, 3, 96, 188];
rotAngleMat = [
    0   85  170 105
    85  0   85  170
    170 85  0   85
    105 170 85  0
];
rotAngleMat = 100 * rotAngleMat ./ max(rotAngleMat, [], "all");

% Start training environment creation using collected data
envTrain = BeamSelectEnv(locationMat, avgRsrpMatTrain, rotAngleMat, position);

% Create Agent
obsInfo = getObservationInfo(envTrain);
actInfo = getActionInfo(envTrain);
agent = rlDQNAgent(obsInfo,actInfo);

criticNetwork = getModel(getCritic(agent));
analyzeNetwork(criticNetwork);
figure;
plot(criticNetwork);
title('Deep Learning Network Analyzer Architecture');

% Define agent options and training options
opt = rlQAgentOptions('SampleTime', 0.7);
opt.DiscountFactor = 0.95;
opt.EpsilonGreedyExploration.Epsilon = 0.99;

myActorOpts = rlOptimizerOptions('LearnRate', 0.2, 'GradientThresholdMethod', 'absolute-value');
myActorOpts.GradientThreshold = 20;
myAgentOpt = rlACAgentOptions("ActorOptimizerOptions", myActorOpts);

agent.AgentOptions.CriticOptimizerOptions.LearnRate = 1e-4;
agent.AgentOptions.EpsilonGreedyExploration.EpsilonDecay = 1e-5;

trainOpts = rlTrainingOptions(...
    'MaxEpisodes', 700, ...
    'MaxStepsPerEpisode', 200, ...
    'StopTrainingCriteria', 'AverageSteps', ...
    'StopTrainingValue', 700, ...
    'Plots', 'training-progress');

startTraining = true;
if startTraining
    trainingStats = train(agent, envTrain, trainOpts);
else
    load("four.mat"); % Load pre-trained model if available
end

% Simulate Trained Agent
locationMat = locationMatTest(1:4:end, :);

% Sorting location in clockwise order
secLen = size(locationMat, 1) / 4;
[~, b1] = sort(locationMat(1:secLen, 2));
[~, b2] = sort(locationMat(secLen + 1:2 * secLen, 1));
[~, b3] = sort(locationMat(2 * secLen + 1:3 * secLen, 2), "descend");
[~, b4] = sort(locationMat(3 * secLen + 1:4 * secLen, 1), "descend");
idx = [b1; secLen + b2; 2 * secLen + b3; 3 * secLen + b4];

locationMat = locationMat(idx, :);

% Calculating Average RSRP
avgRsrpMatTest = rsrpMatTest / 4;  % 4 = prm.NRepeatSameLoc;
avgRsrpMatTest = 150 * avgRsrpMatTest ./ max(avgRsrpMatTest, [], "all");
avgRsrpMatTest = avgRsrpMatTest(:, :, idx);
avgRsrpMatTest = mean(avgRsrpMatTest, 1);

% Creating 5G test environment
environementTest = BeamSelectEnv(locationMat, avgRsrpMatTest, rotAngleMat, position);

% Plot the test environment
plot(environementTest);
legend({'base station (gNB)', 'channel scatterers', 'selected beam'});
title('Improved Simulation of 6G Environment with Beamforming and RL Agent');

% Simulate the trained agent in the test environment
sim(environementTest, agent, rlSimulationOptions("MaxSteps", 100));

% Showcase Agent Accuracy and Maximum RSRP
maxPossibleRsrp = sum(max(squeeze(avgRsrpMatTest)));
rsrpSim = environementTest.EpisodeRsrp;
disp("Agent RSRP/Maximum RSRP = " + rsrpSim / maxPossibleRsrp * 100 + "%");

% Plot histograms and location path coordinates
figure;
histogram(avgRsrpMatTrain);
title('RSRP Average Mean for Training Agent Accuracy (Training Data)');

figure;
histogram(avgRsrpMatTest);
title('RSRP Average Mean for Testing Agent Accuracy (Test Data)');

figure;
bubblechart(locationMatTest(:, 1), locationMatTest(:, 2), locationMatTest(:, 3));
title('Location Path Coordinates for UE to Follow');

x = maxPossibleRsrp;
disp('x=');
disp(x);
disp('x is the Maximum Possible RSRP');
