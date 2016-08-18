%work test
    path('..', path);
    path('../../csi-code/test-data/localization-tests--in-room', path);
    path('../../csi-code/test-data/line-of-sight-localization-tests--in-room', path);
    % Paths for the csitool functions provided
    path('../../../linux-80211n-csitool-supplementary/matlab', path);
	path('../../../linux-80211n-csitool-supplementary/matlab/sample_data', path);
    path('../../../matlab2', path);
    path('tmp', path);

    
    csi_trace = read_bf_file('los-test-tall-bookshelf.dat');
    csi_entry = csi_trace{10};
    csi = get_scaled_csi(csi_entry);
    %ph=unwrap(angle(csi));
    
    antenna_distance=0.1;
    frequency = 5.785 * 10^9;
    sub_freq_delta = (40 * 10^6) / 30;   
    
    packet_one_phase_matrix = unwrap(angle(csi), pi, 2);
    sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
   
    smoothed_sanitized_csi = smooth_csi(sanitized_csi);
    % Run SpotFi's AoA-ToF MUSIC algorithm on the smoothed and sanitized CSI matrix
   
    %[aoa_packet_data{1}, tof_packet_data{1}] = spt(...
     %       smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta);
spt;
 