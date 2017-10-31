datac  = xlsread('dataorikmpp-c.xlsx');
datapq = xlsread('dataorikmpp-pq.xlsx');

[baris_datac, kolom_datac] = size(datac);
[baris_datapq, kolom_datapq] = size(datapq);

%hitung jarak dgn wrt point
b = 1;
for a = 1:baris_datac
    for j = 1:baris_datapq
        dd1 = abs(datac(a,1) - datapq(j,1)) + datac(a,1);
        dd2 = abs(datac(a,2) - datapq(j,2)) + datac(a,2);
        dd(b, 1) = dd1;
        dd(b, 2) = dd2;
        b = b+1;
    end
end

%dd dibagi per point wrt
[baris_dd, kolom_dd] = size(dd);
wrtc = cell(0,kolom_dd);
for c = 1:baris_datapq:baris_dd
    temp = dd(c:(c+(baris_datapq-1)) ,:);
    wrtc = [wrtc;temp];
end

%save wrtc ke file baru
[baris_wrtc, kolom_wrtc] = size(wrtc);
for d= 1:baris_wrtc
    csvwrite(sprintf('dslc%d.csv', d), wrtc(d));
end

f=length(dir('dslc*.csv'));
for f = 1:f
    dc = datac(f,:);
    filename = ['dslc' num2str(f) '.csv'];
    
    %read -> normalize + Fmin + Sum
    m = csvread(filename);
    [baris_m, kolom_m] = size(m);
    min_m = min(m);
    max_m = max(m);
    h = 1;
    for g = 1:baris_m
        m1 = (m(g,1) - min_m(1,1)) /(max_m(1,1) - min_m(1,1));
        m2 = (m(g,2) - min_m(1,2)) / (max_m(1,2) - min_m(1,2));
        normalize_m(h, 1) = h;
        normalize_m(h, 2) = m1;
        normalize_m(h, 3) = m2;
        normalize_m(h, 4) = min([m1 m2]);
        normalize_m(h, 5) = m1 + m2;
        h = h+1;
    end
    
    %sort by Fmin, Sum
    sorted_normalize_m = zeros (0,0);
    sorted_normalize_m = sortrows(normalize_m, [4 5]);
    
    
    %Salsa skyline
    S = zeros(0,0);
    Pstop = 0;
    for i = 1:length(sorted_normalize_m)
        data_temp = sorted_normalize_m(i,2:3);
        [baris_data_temp, kolom_data_temp] = size(data_temp);
        if isempty(S)
            S = [S;sorted_normalize_m(i,1:3)];
            Pstop = max(data_temp);
        else
            fmin = min(data_temp);
            [baris_S, kolom_S] = size(S);
            if fmin <= Pstop
                if data_temp(1,1) <= S(baris_S,2) || data_temp(1,2) <= S(baris_S,3)
                    for x = 1:kolom_data_temp
                        if data_temp(1,x) == fmin
                            d_fmin = x;
                        end
                    end
                    if (ismember(fmin, S(:,d_fmin+1))) == 0 | (data_temp(1,:) == S(:,2:3))
                        S = [S;sorted_normalize_m(i,1:3)];
                        Pstop = max(data_temp);
                    end
                end
            else
                break;
            end
        end
    end
end







%     [baris_sorted_normalize_m, kolom_sorted_normalize_m] = size(sorted_normalize_m);
%     S = zeros(0,0);
%     DSL = cell(0,3);
%     Pstop = 0;
%     j = 1;
%     for i = 1:baris_sorted_normalize_m
%         data_temp = sorted_normalize_m(i,2:3);
%         Pi = max(data_temp);
%         cek = isempty(S);
%         kondisi = 0;
%         if cek == 1
%             S = [S;sorted_normalize_m(i,1:3)];
%             Pstop = Pi;
%         elseif ((data_temp(1,1) == 0) || ((data_temp(1,2) == 0)
%                 S = [S;sorted_normalize_m(i,1:3)];
%                 Pstop = Pi;
%                 break;
%         elseif sorted_normalize_m(i,4) <= Pstop
%             [node_hasil] = DynamicDominance(index_node1, index_node2, data_normalisasi)
%         else sorted_normalize_m(i,4) >= Pstop
%             kondisi = 1;
%                     end
%                 end
%             end
%         end
%         j = j+1;
%         if kondisi == 1
%             break;
%         end
%     end
% end
%
%



%             if ((data_temp(1,1) == 0) || (data_temp(1,2) == 0))
%                 for j = 1:length(S)
%                     if data_temp(1,1) < S(j,2) || data_temp(1,2) < S(j,3)
%                         if ismember(fmin, S(:,2:3)) == 0
%                             S = [S;sorted_normalize_m(i,1:3)];
%                             Pstop = max(data_temp);
%                         else
%                             break;
%                         end
%                     else
%                         break;
%                     end
%                 end
%             else