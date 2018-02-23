function bp = stat_descriptor3d(im,b,dt,s)
%% stat_descriptor3d - pruning blob position based on statistical
%% measures
%
%   INPUT:
%       im      - blob channel
%       b       - detected blob positions
%       dt      - descriptor values
%       s       - blob size
%
%   OUTPUT:
%       bp      - pruned blob positions
%
%   AUTHOR:
%       Boguslaw Obara

%% settings
dmax = sqrt( s(1)^2 + s(2)^2 + s(3)^2 ); 
bp = b; ts = size(bp,1);
stop = 1; stopmin = 0; j = 1;
xy2z = s(1)/s(3); % X/Z resolution

%% loop
while(stop>0)
    ix = 1;
    if j>ts; break; end
    m = 10000000;
    for i=1:ts
        if i~=j 
            d = sqrt(   (bp(i,1)-bp(j,1))^2 + ... 
                        (bp(i,2)-bp(j,2))^2 + ... 
                        (xy2z*bp(i,3)-xy2z*bp(j,3))^2);
            if m > d
                m = d; ix = i; jx = j;
            end
        end
    end
 
    if (m<dmax)
        s1 = dt(bp(jx,4),3);        
        s2 = dt(bp(ix,4),3);        
        if s1<s2
            bp(jx,:) = [];
        else
            bp(ix,:) = [];
        end
        stopmin = 1;
        ts = size(bp,1);   
    end
    j = j + 1;
    
    if j>ts
        if stopmin>0
            stopmin = 0;
            j = 1;
        else
            stop = 0;
        end
    end
end

%% sort
bp = sortrows(bp,4);

end