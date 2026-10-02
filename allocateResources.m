function allocationMatrix = allocateResources(numUsers, numBeams, availableResources, userPriorities, userRequirements)
    allocationMatrix = zeros(numUsers, numBeams);
    
    % Sort users based on priorities (higher priority first)
    [~, sortedUserIndices] = sort(userPriorities, 'descend');
    
    % Loop through users and allocate resources
    for i = 1:numUsers
        userIndex = sortedUserIndices(i);
        
        % Calculate the share of available resources for the user based on requirements
        userShare = userRequirements(userIndex) / sum(userRequirements(sortedUserIndices(1:i)));
        
        % Implement your dynamic resource allocation logic here
        % For this example, we allocate resources equally among the beams
        allocationMatrix(userIndex, :) = userShare * (availableResources / numBeams);
    end
end
