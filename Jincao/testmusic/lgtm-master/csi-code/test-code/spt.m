%function [estimated_aoas, estimated_tofs] = spt(x, ...
 %       antenna_distance, frequency, sub_freq_delta, data_name)
    x=smoothed_sanitized_csi;
    % If OUTPUT_SUPPRESSED does not exist then initialize all the globals.
    if exist('OUTPUT_SUPPRESSED') == 0
        globals_init()
    end
    %% DEBUG AND OUTPUT VARIABLES-----------------------------------------------------------------%%
    % Debug Variables
    global DEBUG_PATHS
    global DEBUG_PATHS_LIGHT
    
    % Output Variables
    global OUTPUT_AOAS
    global OUTPUT_TOFS
    global OUTPUT_AOA_MUSIC_PEAK_GRAPH
    global OUTPUT_TOF_MUSIC_PEAK_GRAPH
    global OUTPUT_AOA_TOF_MUSIC_PEAK_GRAPH
    global OUTPUT_SELECTIVE_AOA_TOF_MUSIC_PEAK_GRAPH
    global OUTPUT_BINARY_AOA_TOF_MUSIC_PEAK_GRAPH
    global OUTPUT_SUPPRESSED
    global OUTPUT_FIGURES_SUPPRESSED
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data_name = '-';
    
    
    % Data covarivance matrix
    R = x * x'; 
    % Find the eigenvalues and eigenvectors of the covariance matrix
    [eigenvectors, eigenvalue_matrix] = eig(R);
    % Find max eigenvalue for normalization
    max_eigenvalue = -1111;
    for ii = 1:size(eigenvalue_matrix, 1)
        if eigenvalue_matrix(ii, ii) > max_eigenvalue
            max_eigenvalue = eigenvalue_matrix(ii, ii);
        end
    end

    if DEBUG_PATHS && ~OUTPUT_SUPPRESSED
        fprintf('Normalized Eigenvalues of Covariance Matrix\n')
    end
    for ii = 1:size(eigenvalue_matrix, 1)
        eigenvalue_matrix(ii, ii) = eigenvalue_matrix(ii, ii) / max_eigenvalue;
        if DEBUG_PATHS && ~OUTPUT_SUPPRESSED
            % Suppress most print statements...
            if ii > 20
                fprintf('Index: %d, eigenvalue: %f\n', ii, eigenvalue_matrix(ii, ii))
                if ii + 1 <= size(eigenvalue_matrix, 1)
                    fprintf('Decrease Factor %f:\n', ...
                            ((eigenvalue_matrix(ii + 1, ii + 1) / max_eigenvalue) ...
                                / eigenvalue_matrix(ii, ii)))
                end
            end
        end
    end
    
    % Find the largest decrease ratio that occurs between the last 10 elements (largest 10 elements)
    % and is not the first decrease (from the largest eigenvalue to the next largest)
    % Compute the decrease factors between each adjacent pair of elements, except the first decrease
    start_index = size(eigenvalue_matrix, 1) - 2;
    end_index = start_index - 10;
    decrease_ratios = zeros(start_index - end_index + 1, 1);
    k = 1;
    for ii = start_index:-1:end_index
        temp_decrease_ratio = eigenvalue_matrix(ii + 1, ii + 1) / eigenvalue_matrix(ii, ii);
        decrease_ratios(k, 1) = temp_decrease_ratio;
        k = k + 1;
    end
    if DEBUG_PATHS_LIGHT && ~OUTPUT_SUPPRESSED
        fprintf('\n')
    end
    [max_decrease_ratio, max_decrease_ratio_index] = max(decrease_ratios);
    if DEBUG_PATHS && ~OUTPUT_SUPPRESSED
        fprintf('Max Decrease Ratio: %f\n', max_decrease_ratio)
        fprintf('Max Decrease Ratio Index: %d\n', max_decrease_ratio_index)
    end

    index_in_eigenvalues = size(eigenvalue_matrix, 1) - max_decrease_ratio_index;
    num_computed_paths = size(eigenvalue_matrix, 1) - index_in_eigenvalues + 1;
    
    if (DEBUG_PATHS || DEBUG_PATHS_LIGHT) && ~OUTPUT_SUPPRESSED
        fprintf('True number of computed paths: %d\n', num_computed_paths)
        for ii = size(eigenvalue_matrix, 1):-1:end_index
            fprintf('%g, ', eigenvalue_matrix(ii, ii))
        end
        fprintf('\n')
    end
    
    % Estimate noise subspace
    column_indices = 1:(size(eigenvalue_matrix, 1) - num_computed_paths);
    eigenvectors = eigenvectors(:, column_indices); 
    % Peak search
    % Angle in degrees (converts to radians in phase calculations)
    %% TODO: Tuning theta too??
    theta = -90:1:90; 
    % time in milliseconds
    %% TODO: Tuning tau....
    %tau = 0:(1.0 * 10^-9):(50 * 10^-9);
    tau = 0:(100.0 * 10^-9):(3000 * 10^-9);
    Pmusic = zeros(length(theta), length(tau));
    % Angle of Arrival Loop (AoA)
    for ii = 1:length(theta)
        % Time of Flight Loop (ToF)
        for jj = 1:length(tau)
            steering_vector = compute_steering_vector(theta(ii), tau(jj), ...
                    frequency, sub_freq_delta, antenna_distance);
            PP = steering_vector' * (eigenvectors * eigenvectors') * steering_vector;
            Pmusic(ii, jj) = abs(1 /  PP);
        end
    end

    % Convert to decibels
    % ToF loop
    for jj = 1:size(Pmusic, 2)
        % AoA loop
        for ii = 1:size(Pmusic, 1)
            Pmusic(ii, jj) = 10 * log10(Pmusic(ii, jj));
        end
    end

    if OUTPUT_AOA_TOF_MUSIC_PEAK_GRAPH && ~OUTPUT_SUPPRESSED && ~OUTPUT_FIGURES_SUPPRESSED
        % Theta (AoA) & Tau (ToF) 3D Plot
        figure('Name', 'AoA & ToF MUSIC Peaks', 'NumberTitle', 'off')
        mesh(tau, theta, Pmusic)
        xlabel('Time of Flight')
        ylabel('Angle of Arrival in degrees')
        zlabel('Spectrum Peaks')
        title('AoA and ToF Estimation from Modified MUSIC Algorithm')
        grid on
    end

    if (DEBUG_PATHS || OUTPUT_AOA_MUSIC_PEAK_GRAPH) ...
            && ~OUTPUT_SUPPRESSED && ~OUTPUT_FIGURES_SUPPRESSED
        % Theta (AoA)
        figure_name_string = sprintf('%s: Number of Paths: %d', data_name, num_computed_paths);
        figure('Name', figure_name_string, 'NumberTitle', 'off')
        plot(theta, Pmusic(:, 1), '-k')
        xlabel('Angle, \theta')
        ylabel('Spectrum function P(\theta, \tau)  / dB')
        title('AoA Estimation as a function of theta')
        grid on
    end

    binary_peaks_pmusic = imregionalmax(Pmusic);
    
    % Get AoAs that have peaks
    % fprintf('Future estimated aoas\n')
    aoa_indices = linspace(1, size(binary_peaks_pmusic, 1), size(binary_peaks_pmusic, 1));
    aoa_peaks_binary_vector = any(binary_peaks_pmusic, 2);
    estimated_aoas = theta(aoa_peaks_binary_vector);
    
    if OUTPUT_AOAS && ~OUTPUT_SUPPRESSED
        fprintf('Estimated AoAs\n')
        estimated_aoas
    end

    aoa_peak_indices = aoa_indices(aoa_peaks_binary_vector);
    
    % Get ToFs that have peaks
    time_peak_indices = zeros(length(aoa_peak_indices), length(tau));
    % AoA loop (only looping over peaks in AoA found above)
    for ii = 1:length(aoa_peak_indices)
        aoa_index = aoa_peak_indices(ii);
        binary_tof_peaks_vector = binary_peaks_pmusic(aoa_index, :);
        matching_tofs = tau(binary_tof_peaks_vector);
        
        % Pad ToF rows with -1s to have non-jagged matrix
        negative_ones_for_padding = -1 * ones(1, length(tau) - length(matching_tofs));
        time_peak_indices(ii, :) = horzcat(matching_tofs, negative_ones_for_padding);
    end

    
    if OUTPUT_BINARY_AOA_TOF_MUSIC_PEAK_GRAPH && ~OUTPUT_SUPPRESSED && ~OUTPUT_FIGURES_SUPPRESSED
        figure('Name', 'BINARY Peaks over AoA & ToF MUSIC Spectrum', 'NumberTitle', 'off')
        mesh(tau, theta, double(binary_peaks_pmusic))
        xlabel('Time of Flight')
        ylabel('Angle of Arrival in degrees')
        zlabel('Spectrum Peaks')
        title('AoA and ToF Estimation from Modified MUSIC Algorithm')
        grid on
    end

    if OUTPUT_SELECTIVE_AOA_TOF_MUSIC_PEAK_GRAPH && ~OUTPUT_SUPPRESSED && ~OUTPUT_FIGURES_SUPPRESSED
        % Theta (AoA) & Tau (ToF) 3D Plot
        figure('Name', 'Selective AoA & ToF MUSIC Peaks, with only peaked AoAs', 'NumberTitle', 'off')
        mesh(tau, estimated_aoas, Pmusic(aoa_peak_indices, :))
        xlabel('Time of Flight')
        ylabel('Angle of Arrival in degrees')
        zlabel('Spectrum Peaks')
        title('AoA and ToF Estimation from Modified MUSIC Algorithm')
        grid on
    end
    
    if OUTPUT_TOF_MUSIC_PEAK_GRAPH && ~OUTPUT_SUPPRESSED && ~OUTPUT_FIGURES_SUPPRESSED
        % Tau (ToF)
        for ii = 1:1%length(estimated_aoas)
            figure_name_string = sprintf('ToF Estimation as a Function of Tau w/ AoA: %f', ...
                    estimated_aoas(ii));
            figure('Name', figure_name_string, 'NumberTitle', 'off')
            plot(tau, Pmusic(ii, :), '-k')
            xlabel('Time of Flight \tau / degree')
            ylabel('Spectrum function P(\theta, \tau)  / dB')
            title(figure_name_string)
            grid on
        end
    end
    
    % Set return values
    % AoA is now a column vector
    estimated_aoas = transpose(estimated_aoas);
    % ToF is now a length(estimated_aoas) x length(tau) matrix, with -1 padding for unused cells
    estimated_tofs = time_peak_indices;
%end

%% Computes the steering vector for SpotFi. 
% Each steering vector covers 2 antennas on 15 subcarriers each.
% theta           -- the angle of arrival (AoA) in degrees
% tau             -- the time of flight (ToF)
% freq            -- the central frequency of the signal
% sub_freq_delta  -- the frequency difference between subcarrier
% ant_dist        -- the distance between each antenna
% Return:
% steering_vector -- the steering vector evaluated at theta and tau
%
% NOTE: All distance measurements are in meters
function steering_vector = compute_steering_vector(theta, tau, freq, sub_freq_delta, ant_dist)
    steering_vector = zeros(30, 1);
    k = 1;
    base_element = 1;
    for ii = 1:2
        for jj = 1:15
            steering_vector(k, 1) = base_element * omega_tof_phase(tau, sub_freq_delta)^(jj - 1);
            k = k + 1;
        end
        base_element = base_element * phi_aoa_phase(theta, freq, ant_dist);
    end
end

%% Compute the phase shifts across subcarriers as a function of ToF
% tau             -- the time of flight (ToF)
% frequency_delta -- the frequency difference between adjacent subcarriers
% Return:
% time_phase      -- complex exponential representing the phase shift from time of flight
function time_phase = omega_tof_phase(tau, sub_freq_delta)
    time_phase = exp(-1i * 2 * pi * sub_freq_delta * tau);
end

%% Compute the phase shifts across the antennas as a function of AoA
% theta       -- the angle of arrival (AoA) in degrees
% frequency   -- the frequency of the signal being used
% d           -- the spacing between antenna elements
% Return:
% angle_phase -- complex exponential representing the phase shift from angle of arrival
function angle_phase = phi_aoa_phase(theta, frequency, d)
    % Speed of light (in m/s)
    c = 3.0 * 10^8;
    % Convert to radians
    theta = theta / 180 * pi;
    angle_phase = exp(-1i * 2 * pi * d * sin(theta) * (frequency / c));
end

%% Creates the smoothed CSI matrix by rearranging the various csi values in the default CSI matrix.
% csi          -- the regular CSI matrix to use for creating the smoothed CSI matrix
% Return:
% smoothed_csi -- smoothed CSI matrix following the construction put forth in the SpotFi paper.
%                   Each column in the matrix includes data from 2 antennas and 15 subcarriers each.
%                   Has dimension 30x32. 
function smoothed_csi = smooth_csi(csi)
    smoothed_csi = zeros(size(csi, 2), size(csi, 2));
    % Antenna 1 (values go in the upper left quadrant)
    m = 1;
    for ii = 1:1:15
        n = 1;
        for j = ii:1:(ii + 15)
            smoothed_csi(m, n) = csi(1, j); % 1 + sqrt(-1) * j;
            n = n + 1;
        end
        m = m + 1;
    end
    
    % Antenna 2
    % Antenna 2 has its values in the top right and bottom left
    % quadrants, the first for loop handles the bottom left, the second for
    % loop handles the top right
    
    % Bottom left of smoothed csi matrix
    for ii = 1:1:15
        n = 1;
        for j = ii:1:(ii + 15)
            smoothed_csi(m, n) = csi(2, j); % 2 + sqrt(-1) * j;
            n = n + 1;
        end
        m = m + 1;
    end
    
    % Top right of smoothed csi matrix
    m = 1;
    for ii = 1:1:15
        n = 17;
        for j = ii:1:(ii + 15)
            smoothed_csi(m, n) = csi(2, j); %2 + sqrt(-1) * j;
            n = n + 1;
        end
        m = m + 1;
    end
    
    % Antenna 3 (values go in the lower right quadrant)
    for ii = 1:1:15
        n = 17;
        for j = ii:1:(ii + 15)
            smoothed_csi(m, n) = csi(3, j); %3 + sqrt(-1) * j;
            n = n + 1;
        end
        m = m + 1;
    end
end