function newPopulation = CX(population, x_chance)
% CX krizanje funkcionira na sljedeci nacin:
% Potomak nasljedi prvi clan od prvog roditelja, potom se se gleda koji je
% clan na toj lokacijii u drugom roditelju te se taj clan prepisuje u prvog
% potomka na mijesto iz prvog roditelja. Postupak se ponavlja sve dok se
% može, a kada se više ne može preostali clanovi se direktno prepisuju iz
% drugog roditelja.
%
% PRIMJER:
% p1 = (1 2 3 5 4 6 7 8 9)
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 x x x x x x x x)
%       v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 x x x 4 x x x x)
%               v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 x x x 4 x x 8 x)
%                     v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 x x x 4 x x 8 9)
%                       v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 x 3 x 4 x x 8 9)
%           v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 2 3 x 4 x x 8 9)
%         v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 2 3 5 4 x x 8 9)
%             v             kako je 1 vec u potommku preostali clanovi se 
% p2 = (4 5 2 1 8 7 6 9 3)  samo prekopiraju iz drugog roditelja
%                 v v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 2 3 5 4 7 6 8 9)

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

        for child = 1:2
            
            switch child
                % izmjenjuje prvg i drugog potomka kako bi se mogli u
                % jednoj petlji pronaci istovremeno susjedi za prvog i
                % drugog potomka
                case 1
                    next_city = p2(p1 == c1(1));
                    parent1 = p1;
                    parent2 = p2;
                    c = c1;
                        
                case 2
                    next_city = p1(p2 == c2(1));
                    parent1 = p2;
                    parent2 = p1;
                    c = c2;
            end
                
            while ~ismember(next_city, c)
                % dok god grad nije vec clan potomka pohrani taj grad u
                % potomka
                c(parent1 == next_city) = next_city;
                next_city = parent2(parent1 == next_city);
            end
            
            % sve gdje su ostale nule se prepisuju clanovi iz drugog
            % roditelja
            c(c == 0) = parent2(c == 0);
            
            switch child
                % pohranjivanje privremene variable c u odgovarajuceg
                % potomka
                case 1
                    c1 = c;
                case 2
                    c2 = c;
            end
            
        end

        newPopulation((2 * couple - 1), :) = c1;
        newPopulation((2 * couple), :) = c2;
        
    end
end

end
