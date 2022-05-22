function plot_BER(step_size_max, BER_data, channel_type)
    % plot
    BER_for_plot = BER_data(:, 3:2:end);
    figure()
    plot(0.01 : 0.01 : step_size_max, BER_for_plot, '-o');
    % title('BER of different L and \alpha');
    title(['BER of different L and \alpha in Case ', num2str(channel_type)]);
    xlabel('step szie');
    ylabel('BER');
    grid on;
    legend('L=3','L=5','L=7','L=9','L=11','L=13','location','northwest');
return
