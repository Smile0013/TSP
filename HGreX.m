function newPopulation = HGreX(population, x_chance, lookupTable)
% HGreX krizanje funkcionira na sljedeci nacin:
% Potomak nasljedi prvi clan iz prvog roditelja, nakon toga trazi susjede u
% oba roditelja i uspore?uje udaljenosti. U potomka se zapisuje onaj susjed
% koji je najblize clanu. Ukoliko clan nema susjeda nasumicno se se bira
% iduci clan
%
% PRIMJER:
% p1 = (1 2 3 5 4 6 7 8 9)
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 x x x x x x x x)
%         v             v
% p1 = (1 2 3 5 4 6 7 8 9) 
%           v   v
% p2 = (4 5 2 1 8 7 6 9 3) udaljenost 1-2 je najkraca pa se bira 2
%
% c1 = (1 2 x x x x x x x)
%       v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%         v   v
% p2 = (4 5 2 1 8 7 6 9 3) udaljenost 2-3 je najkraca pa se bira 3
%
% c1 = (1 2 3 x x x x x x)
%         v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%       v             v
% p2 = (4 5 2 1 8 7 6 9 3) udaljenost 3-4 je najkraca pa se bira 4
%
% c1 = (1 2 3 4 x x x x x)
%             v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%         v             v
% p2 = (4 5 2 1 8 7 6 9 3) udaljenost 4-5 je najkraca pa se bira 5
%
% c1 = (1 2 3 4 5 x x x x)
%           v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%       v   v
% p2 = (4 5 2 1 8 7 6 9 3) kako svi susjedi od clana 5 su vec unutar
%                          potomka nasumicno se odavire sljedeci clan, u 
%                          ovom slucaju to je 9
%
% c1 = (1 2 3 4 5 9 x x x)
%       v             v
% p1 = (1 2 3 5 4 6 7 8 9) 
%                   v   v
% p2 = (4 5 2 1 8 7 6 9 3) udaljenost 9-8 je najkraca pa se bira 8
%
% c1 = (1 2 3 4 5 9 8 x x)
%                   v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%             v   v
% p2 = (4 5 2 1 8 7 6 9 3) udaljenost 8-7 je najkraca pa se bira 7
%
% c1 = (1 2 3 4 5 9 8 7 x)
%               v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%               v   v
% p2 = (4 5 2 1 8 7 6 9 3) udaljenost 7-6 je najkraca pa se bira 6
%
% c1 = (1 2 3 4 5 9 8 7 6)

newPopulation = population;
numOfCouples = fix(size(population, 1) / 2); % broj parova

for couple = 1:numOfCouples
    
    if rand < x_chance
        
        p1 = population((2 * couple - 1), :);   % p1 = (1 2 3 5 4 6 7 8 9)
        p2 = population((2 * couple), :);       % p2 = (4 5 2 1 8 7 6 9 3)
        
        c1 = zeros(1, size(population, 2));     % c1 = (0 0 0 0 0 0 0 0 0)
        c1(1) = p1(1);                          % c1 = (1 0 0 0 0 0 0 0 0)
        c2 = zeros(1, size(population, 2));     % c2 = (0 0 0 0 0 0 0 0 0)
        c2(1) = p2(1);                          % c2 = (4 0 0 0 0 0 0 0 0)
        
        for Xp = 2:1:size(population, 2)
            
            for child = 1:2
            
            switch child
                % izmjenjuje prvg i drugog potomka kako bi se mogli u
                % jednoj petlji pronaci istovremeno susjedi za prvog i
                % drugog potomka
                case 1
                    c = c1;
                        
                case 2
                    c = c2;
            end
            
            % lista susjeda prethodnog grada
            neirghbours = findNeighbour(c(Xp-1), p1, p2);
            
            % pronalazenje adekvatnog iduceg grada
            valid_neigh_counter = 0;
            valid_neigh = [];
            len_of_neigh = [];
            
            for neigh = 1:length(neirghbours)
                if ~ismember(neirghbours(neigh), c)
                    
                    valid_neigh_counter = valid_neigh_counter + 1;
                    
                    % iz liste susjeda izdva susjede koji se vec nalaze
                    % unutar potomka te u zasebnu listu sprema udanjenosti
                    % od clana do susjeda
                    valid_neigh(valid_neigh_counter) = neirghbours(neigh);
                    len_of_neigh(valid_neigh_counter) =...
                        TSP_length([(c(Xp-1)), (neirghbours(neigh))], lookupTable);
                    
                end
            end
            
            next_city_candidat =...
                valid_neigh(len_of_neigh == min(len_of_neigh));
            
            if ~isempty(next_city_candidat)
                % ukoliko predhodni grad ima validnih susjeda
                next_city =...
                    next_city_candidat(randi(length(next_city_candidat)));
            else
                % ukoliko prethodni grad nema validnih susjeda
                all_citys = 1:size(population, 2);
                next_city_candidat = all_citys(~ismember(all_citys, c));
                next_city =...
                    next_city_candidat(randi(length(next_city_candidat)));
            end
            
            c(Xp) = next_city;
                
                switch child
                    % pohranjivanje privremene variable c u odgovarajuceg
                    % potomka
                    case 1
                        c1 = c;
                    case 2
                        c2 = c;
                end
            end
        end
        
        newPopulation((2 * couple - 1), :) = c1;
        newPopulation((2 * couple), :) = c2;
        
    end
end

end
