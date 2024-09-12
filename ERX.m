function newPopulation = ERX(population, x_chance)
% ERX krizanje funkcionira na sljedeci nacin:
% Potomak nasljedi prvi clan od prvog roditelja, potom se promatraju
% susjedi tog clana u oba roditelja. Kada se izdvoje svi susjedi oni se
% analiziraju, onaj susjed koji ima najmanje potomaka ce biti susjed prvom
% clanu. Ukoliko je broj susjeda tih clanova izjednacen, sljedeci clan se
% bira nasumicno.
%
% PRIMJER:
% p1 = (1 2 3 5 4 6 7 8 9)
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 x x x x x x x x)
%         v             v
% p1 = (1 2 3 5 4 6 7 8 9) 
%           v   v
% p2 = (4 5 2 1 8 7 6 9 3)
% 2 ima susjede 1 3 5
% 9 ima susjede 1 3 6 8
% 8 ima susjede 1 7 9
% nasumicno se bura izmedu 2 i 8
%
% c1 = (1 8 x x x x x x x)
%                   v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%             v   v
% p2 = (4 5 2 1 8 7 6 9 3)
% 1 je vec u potomku
% 7 ima susjede 6 8
% 9 ima susjede 1 3 6 8
% 7 ima manje susjeda
%
% c1 = (1 8 7 x x x x x x)
%                 v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%               v   v
% p2 = (4 5 2 1 8 7 6 9 3)
% 6 ima susjede 4 7 9
% 8 je vec u potomku
%
% c1 = (1 8 7 6 x x x x x)
%               v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%                 v   v
% p2 = (4 5 2 1 8 7 6 9 3)
% 4 ima susjede 3 5 6
% 7 je vec u potomku
% 9 ima susjede 1 3 6 8
%
% c1 = (1 8 7 6 4 x x x x)
%             v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%         v             v
% p2 = (4 5 2 1 8 7 6 9 3)
% 5 ima susjede 2 3 4
% 6 je vec u potomku
% 3 ima susjede 2 4 5 9
%
% c1 = (1 8 7 6 4 5 x x x)
%           v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%       v   v
% p2 = (4 5 2 1 8 7 6 9 3)
% 3 ima susjede 2 4 5 9
% 4 je vec u potomku
% 2 ima susjede 1 3 5
%
% c1 = (1 8 7 6 4 5 2 x x)
%       v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%         v   v
% p2 = (4 5 2 1 8 7 6 9 3)
% 1 je vec u potomku
% 3 ima susjede 2 4 5 9
% 5 je vec u potomku
%
% c1 = (1 8 7 6 4 5 2 3 x)
%         v   v
% p1 = (1 2 3 5 4 6 7 8 9) 
%       v             v
% p2 = (4 5 2 1 8 7 6 9 3)
% 2 je vec u potomku
% 5 je vec u potomku
% 4 je vec u potomku
% 9 je jedini preostali tako da nisu bitni vise susjedi
%
% c1 = (1 8 7 6 4 5 2 3 9)

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
            % ponavlja se za svaki grad u clanu
            
            for child = 1:2     % ponavlja se za svakog potomka
                
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
            neigh_num_of_neigh = [];
            
            for neigh = 1:length(neirghbours)
                if ~ismember(neirghbours(neigh), c)
                    
                    valid_neigh_counter = valid_neigh_counter + 1;
                    
                    % iz liste susjeda izdva susjede koji se vec nalaze
                    % unutar potomka te u zasebnu listu sprema broj koliko
                    % ti susjedi imaju susjeda
                    valid_neigh(valid_neigh_counter) = neirghbours(neigh);
                    neigh_num_of_neigh(valid_neigh_counter) =...
                        length(findNeighbour(neirghbours(neigh), p1, p2));
                    
                end
            end

            next_city_candidat =...
                valid_neigh(neigh_num_of_neigh == min(neigh_num_of_neigh));
            
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
            %% ____________________________________________________________ 
            
        end
        
        newPopulation((2 * couple - 1), :) = c1;
        newPopulation((2 * couple), :) = c2;
        
    end
end

end
