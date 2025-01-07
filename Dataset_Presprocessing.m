
%DataPath
mkdir('C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\N')
mkdir('C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\S')
mkdir('C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\V')
mkdir('C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\F')
mkdir('C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\Q')
%loading of patients
patients = [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, ...
            111, 112, 113, 114, 115, 116, 117, 118, 119, 121, ...
            122, 123, 124, 200, 201, 202, 203, 205, 207, 208, 209, ...
            210, 212, 213, 214, 215, 217, 219, 220, 221, 222, 223, ...
            228, 230, 231, 232, 233, 234];


% [signal,Fs, tm] = rdsamp( 'mitdb/100',1); % Load signals
% [ann,anntype,subtype]=rdann('mitdb/100', 'atr')
% fs = 360;
% disp(signal)
% plot(tm,signal)
%Segmentation of signals
window_size = 360 %no of signals per heartbeat
segments = []; %for storing segmented heartbeat

%We define the filter/Analytic Morlet
fb = cwtfilterbank('SignalLength',window_size,'Wavelet','amor','VoicesPerOctave',12);

%Loop through all patient records
N_index = 0; % Initialize the index counter outside the loops
S_index = 0;
V_index = 0;
F_index = 0;
Q_index = 0;
%file_path = ['mitdb/', patient]
for i = 1:length(patients)
    patient = num2str(patients(i));
    file_path = ['mitdb/', patient];
    % Load ECG signals
    [signal, Fs, tm] = rdsamp(file_path, 1);  % Load signals
    
    % Load annotations
    [ann, anntype, subtype] = rdann(file_path, 'atr');  % Load annotations
    
    % Loop through each annotation
    for j = 1:length(ann)
        r_peak = ann(j);
        
        % Ensure R-peak is within valid window size range
        if r_peak > window_size/2 && r_peak + window_size/2 <= length(signal)
            segment = signal(r_peak - window_size/2 : r_peak + window_size/2 - 1);
            
            % Apply the Morlet wavelet filter
            cfs = abs(fb.wt(segment));
            im = ind2rgb(im2uint8(rescale(cfs)), colormap);
            
            % Handle Normal beats (N)
            if anntype(j) == 'N' ||  anntype(j) =='.' || anntype(j) == 'L' || anntype(j) == 'R' || anntype(j) == 'e' || anntype(j) == 'j'
                N_index = N_index + 1;
                Folderpath = 'C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\N\';
                filename = strcat(Folderpath, 'N_', sprintf('%d.jpg', N_index));
                imwrite(imresize(im, [227, 227]), filename);
            
            % Handle Ventricular beats (V)
            elseif anntype(j) == 'A' || anntype(j) == 'a' || anntype(j) == 'J' || anntype(j) == 'S'
                S_index = S_index + 1;
                Folderpath = 'C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\S\';
                filename = strcat(Folderpath, 'S_', sprintf('%d.jpg', S_index));
                imwrite(imresize(im, [227, 227]), filename);
            elseif anntype(j) == 'V' || anntype(j) == 'E'
                V_index = V_index + 1;
                Folderpath = 'C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\V\';
                filename = strcat(Folderpath, 'V_', sprintf('%d.jpg', V_index));
                imwrite(imresize(im, [227, 227]), filename);   
            elseif anntype(j) == 'F'
                F_index = F_index + 1;
                Folderpath = 'C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\F\';
                filename = strcat(Folderpath, 'F_', sprintf('%d.jpg', F_index));
                imwrite(imresize(im, [227, 227]), filename);   
            elseif anntype(j) == 'Q' || anntype(j) == 'f'  %We exclude Paced Beats according to AAMI Standard
                Q_index = Q_index + 1;
                Folderpath = 'C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\ECG_images_3\Q\';
                filename = strcat(Folderpath, 'Q_', sprintf('%d.jpg', Q_index));
                imwrite(imresize(im, [227, 227]), filename);                 
            end
        end
    end
end
% 
%  %Display the table
%  disp(ECG_data)

ddd

