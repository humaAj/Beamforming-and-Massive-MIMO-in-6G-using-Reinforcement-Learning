classdef BeamSelectEnv < rl.env.MATLABEnvironment
    % BeamSelectEnv Beam Selection Environment
    %
    % Customizing a reinforcement learning environment created for Beam
    % Selection for a fixed number of four transmit beams 
    %
    %%%%%%%%%%

    properties
        % reward weights
        RsrpWeight = 0.9
        AngleRotationWeight = 0.1

        % Episode of Reference Signal Received Power (RSRP) 
        EpisodeRsrp = 0
    end

    properties (Access = private)
        % 200x3 (NDiffLocTrain or NDiffLocTest x 3)
        LocationMat
        LocationMatScaled
        % 4x4x200 (row User equipemenet( UE) beam, column RX beam)
        RsrpMapping
        % Normalization of rotation matrix, row for last action, column for next step action
        RotAngleMat
        Pos

        % Figure 
        Figure
        % Last action
        LastAction = 1
        % Current step count
        StepCount = 0
        LocationIdx = 1
        BeamPlotLength = 5

        NumMaxLocation
    end

    properties (Constant)
        NumAction = 4
        TxBeamAng = [-66,11,99,199];
    end

    methods
        function this = BeamSelectEnv(locationMat, rsrpMapping, rotAngleMat, position)

            % Create action specifications
            actionInfo = rlFiniteSetSpec(1:4);
            % Create observation specifications
            observationInfo = [rlNumericSpec([1 2]) actionInfo];
            this = this@rl.env.MATLABEnvironment(observationInfo, actionInfo);

            % Normalizing receiver locations
            this.LocationMatScaled = rescale(locationMat, 0, 1);

            % Saving data
            this.LocationMat = locationMat;
            this.RsrpMapping = rsrpMapping;
            this.RotAngleMat = rotAngleMat;
            this.Pos = position;
            this.NumMaxLocation = size(this.LocationMat, 1);
        end

        function [observation, reward, isDone, loggedSignals] = step(this, action)
            % Simulation of the environment with the given action for one step.

            if iscell(action)
                action = action{1};
            end

            % Calculating rsrp for current action
            rsrpMap = this.RsrpMapping(:,:,this.LocationIdx);
            rsrp = rsrpMap(action);

            % is-done signal means: it is always false, and there is no
            % early termination condition.
            isDone = false;

            % Compute reward
            % Angle rotation (not to be counted if in 1st step)
            angleRotation = 0;
            if this.StepCount > 0
                angleRotation = this.RotAngleMat(this.LastAction, action);
            end

            % Losing signal penalty
            reward = this.RsrpWeight * rsrp - angleRotation * this.AngleRotationWeight;

            % Computing next observation
            if this.LocationIdx < this.NumMaxLocation
                this.LocationIdx = this.LocationIdx + 1;
            else
                this.LocationIdx = 1;
            end
            nextLocation = getCoordinate(this.LocationMatScaled, this.LocationIdx);
            observation = {nextLocation, action};
            this.LastAction = action;
            this.StepCount = this.StepCount + 1;

            loggedSignals.rsrp = rsrp;
            loggedSignals.RsrpReward = this.RsrpWeight * rsrp;
            loggedSignals.AnglePenalty = angleRotation * this.AngleRotationWeight;

            this.EpisodeRsrp = this.EpisodeRsrp + rsrp;
            % Use notifyEnvUpdated to signal that there is an update (for visualization)
            notifyEnvUpdated(this);
        end

        function initialObservation = reset(this)
            % Resetting environment
            % Method is called at the beginning of each episode.

            % Select random starting receiver location
            this.LocationIdx = randi(this.NumMaxLocation);
            initialLocation = getCoordinate(this.LocationMatScaled, this.LocationIdx);
            initialAction = usample(this.ActionInfo);
            initialObservation = [{initialLocation}, initialAction];
            this.LastAction = initialAction{1};
            this.StepCount = 0;

            this.EpisodeRsrp = 0;
            % Use notifyEnvUpdated to signal the update for visualization
            notifyEnvUpdated(this);
        end

        function plot(this)
            % Visualization
            this.Figure = figure;
            xlabel('X (meter)')
            ylabel('Y (meter)')
            xlim([0 12])
            ylim([0 12])
            rectangle("Position",[2 2 6 6])
            coordinate = getCoordinate(this.LocationMat, this.LocationIdx);
            hold on
            scatter(this.Pos.posTX(1), this.Pos.posTX(2), 'b^', 'filled');
            scatter(this.Pos.ScatPos(1,:), this.Pos.ScatPos(2,:), 100, [0.929 0.694 0.125], 'g^', 'filled');
            angle = this.TxBeamAng(this.LastAction);
            x2 = this.Pos.posTX(1) + (this.BeamPlotLength * cosd(angle));
            y2 = this.Pos.posTX(2) + (this.BeamPlotLength * sind(angle));
            line([this.Pos.posTX(1) x2], [this.Pos.posTX(2) y2])
            hold off
            a = rectangle('Position', [coordinate(1:2), 0.4, 0.4], 'Curvature', [1, 1], 'FaceColor', 'magenta');

            envUpdatedCallback(this);
        end
    end

    methods (Access = protected)
        function envUpdatedCallback(this)
            % Update visualization every time we update the environment 
            % (notifyEnvUpdated calls this)

            if ~isempty(this.Figure) && isvalid(this.Figure)
                ha = gca(this.Figure);
                coordinate = getCoordinate(this.LocationMat, this.LocationIdx);
                ha.Children(1).Position(1:2) = coordinate(1:2);

                angle = this.TxBeamAng(this.LastAction);
                x2 = this.Pos.posTX(1) + (this.BeamPlotLength * cosd(angle));
                y2 = this.Pos.posTX(2) + (this.BeamPlotLength * sind(angle));
                ha.Children(2).XData = [this.Pos.posTX(1) x2];
                ha.Children(2).YData = [this.Pos.posTX(2) y2];
                drawnow
            end
        end
    end
end

% usage of Local function
function coordinate = getCoordinate(location, idx)
    coordinate = location(idx, 1:2);
end
