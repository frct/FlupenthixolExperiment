% plot intra-block dynamics

%% prologue

clear all
close all
addpath('../../..') % in order to get nansem

doses = 0 : 3;
colour = {'red*-', 'g*-', 'b*-', 'm*-'};

%% performance plots

figure()

for d = doses
    load(['Flu' num2str(d) ' block cinetics'])
    
    
    subplot(1,2,1)
    hold on
    YLR = 100 * nanmean(Perf.LR);
    ELR = 100 * nansem(Perf.LR);
    errorbar(YLR, ELR, colour{d+1})
    axis square
    ylim([0 83])
    %xlim([0 7])
    xlabel('Trials')
    ylabel('% correct choices')
    title('Performance in low risk blocks')
    set(gca, 'XTick',[1 : 6])
    
    
    subplot(1,2,2)
    hold on
    YHR = 100 * nanmean(Perf.HR);
    EHR = 100 * nansem(Perf.HR);
    errorbar(YHR, EHR, colour{d+1})
    axis square
    ylim([0 83])
    %xlim([0 7])
    xlabel('Trials')
    ylabel('% correct choices')
    title('Performance in high risk blocks')
    set(gca, 'XTick',[1 : 6])
    
    save(['Average Performance for flu' num2str(d)], 'YLR', 'ELR', 'YHR', 'EHR')
end
legend('Flu0', 'Flu1', 'Flu2', 'Flu3', 'Location', 'SouthEast')
savefig(gcf,'Performance dynamics')
saveas(figure(1), 'Performance dynamics.pdf')

%% win-shift plots

figure()

for d = doses
    load(['Flu' num2str(d) ' block cinetics'])
    
    
    YLR = 100 * nanmean(Win.LR);
    ELR = 100 * nansem(Win.LR);
    subplot(1,2,1)
    hold on
    errorbar(YLR, ELR, colour{d+1})
    axis square
    ylim([0 70])
    %xlim([0 7])
    xlabel('Trials')
    ylabel('% win-shifts')
    title('Win-shift in low risk blocks')
    set(gca, 'XTick',[1 : 6])
    
    YHR = 100 * nanmean(Win.HR);
    EHR = 100 * nansem(Win.HR);
    subplot(1,2,2)
    hold on
    errorbar(YHR, EHR, colour{d+1})
    axis square
    ylim([0 70])
    %xlim([0 7])
    xlabel('Trials')
    ylabel('% win-shifts')
    title('Win-shift in high risk blocks')
    set(gca, 'XTick',[1 : 6])
    
    save(['Average Winshift for flu' num2str(d)], 'YLR', 'ELR', 'YHR', 'EHR')
end
legend('Flu0', 'Flu1', 'Flu2', 'Flu3')
savefig(gcf,'Winshift dynamics')
saveas(figure(2), 'Winshift dynamics.png')

%% lose-shift plots

figure()

for d = doses
    load(['Flu' num2str(d) ' block cinetics'])
    
    subplot(1,2,1)
    hold on
    YLR = 100 * nanmean(Lose.LR);
    ELR = 100 * nansem(Lose.LR);
    errorbar(YLR, ELR, colour{d+1})
    ylim([0 70])
    xlim([0 7])
    axis square
    xlabel('Trials')
    ylabel('% lose-shifts')
    title('Lose-shift in low risk blocks')
    set(gca, 'XTick',[1 : 6])
    
    subplot(1,2,2)
    hold on
    YHR = 100 * nanmean(Lose.HR);
    EHR = 100 * nansem(Lose.HR);
    errorbar(YHR, EHR, colour{d+1})
    ylim([0 70])
    xlim([0 7])
    axis square
    xlabel('Trials')
    ylabel('% lose-shifts')
    title('Lose-shift in low risk blocks')
    set(gca, 'XTick',[1 : 6])
    
    save(['Average Loseshift for flu' num2str(d)], 'YLR', 'ELR', 'YHR', 'EHR')
end
legend('Flu0', 'Flu1', 'Flu2', 'Flu3',  'Location', 'SouthEast')
savefig(gcf,'Loseshift dynamics')
saveas(gcf, 'Loseshift dynamics.png')

%% postface

rmpath('../../..') % in order to get nansem