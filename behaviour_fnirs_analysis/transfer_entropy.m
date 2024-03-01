%% directed phase transfer entropy

function [dPTExy,dPTEyx]=transfer_entropy(X,Y)
data = [X,Y];
L = size(data,1);  
N = size(data,2); 
PTE = zeros(N, N);

%% Compute time series of the phases 
complex_data = hilbert(data);  
phase_data = angle(complex_data);
phase_data = phase_data + pi;   % [-¦Ð, ¦Ð]¡ª¡ª>[0, 2¦Ð],¦Ð=3.14


binsize = 3.49 * mean(std(phase_data))*L^(-1/3); % binsize as in Scott et al.
bins_w = [0:binsize:2*pi]; % BINS; NOTE: the last bin has a different size when using 'scott'. Does this matter?
Nbins = length(bins_w);


counter1 = 0; counter2 = 0;
for j=1:N
    for i=2:L-1
        counter1 = counter1 + 1;
        if (phase_data(i-1,j)-pi)*(phase_data(i+1,j)-pi)<0, % make sure phase is in range [-pi pi]
            counter2 = counter2 + 1;
        end; 
    end; 
end; 
delay = round(counter1/counter2);


%% PTE
for i = 1:N      
    for j = 1:N
        if i~=j
        % y and x are past states. ypr is the observed variable.
            Py = zeros(Nbins,1);                
            Pypr_y = zeros(Nbins,Nbins);       
            Py_x = zeros(Nbins,Nbins);        
            Pypr_y_x = zeros(Nbins,Nbins,Nbins);

   
            aa_ypr = phase_data(1+delay:end,i);     
            bb_y = phase_data(1:end-delay,i);    
            cc_x = phase_data(1:end-delay,j);   
        
           
            rn_ypr = ceil((phase_data(1+delay:end,i)/binsize));  
            rn_y = ceil((phase_data(1:end-delay,i)/binsize));   
            rn_x = ceil((phase_data(1:end-delay,j)/binsize));   


            for kk = 1:(L-delay)  
                Py(rn_y(kk)) = Py(rn_y(kk))+1;
                Pypr_y(rn_ypr(kk),rn_y(kk)) = Pypr_y(rn_ypr(kk),rn_y(kk))+1;
                Py_x(rn_y(kk),rn_x(kk)) = Py_x(rn_y(kk),rn_x(kk))+1;
                Pypr_y_x(rn_ypr(kk),rn_y(kk),rn_x(kk)) = Pypr_y_x(rn_ypr(kk),rn_y(kk),rn_x(kk))+1;
            end

            Py = Py/(L-delay);          
            Pypr_y = Pypr_y/(L-delay);  
            Py_x = Py_x/(L-delay);
            Pypr_y_x = Pypr_y_x/(L-delay);

            
            Hy = -nansum(Py.*log2(Py));                       
            ggggggggg = nansum(Pypr_y.*log2(Pypr_y));
            Hypr_y = -nansum(nansum(Pypr_y.*log2(Pypr_y)));
            Hy_x = -nansum(nansum(Py_x.*log2(Py_x)));
            Hypr_y_x = -nansum(nansum(nansum(Pypr_y_x.*log2(Pypr_y_x))));

            % Compute PTE
            PTE(i,j) = Hypr_y + Hy_x - Hy - Hypr_y_x;
    
        end
    end
end
%% Compute dPTE
tmp = triu(PTE) + tril(PTE)';
dPTE = [triu(PTE./tmp,1) + tril(PTE./tmp',-1)];
dPTExy = dPTE(2,1);
dPTEyx = dPTE(1,2);

