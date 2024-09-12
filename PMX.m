function newPopulation = PMX(population, x_chance)
% PMX krizanje funkcionira na sljedeci nacin:
% nasumicno se odrede dva mjesta krizanje geni izmedu mjesta krizanja se 
% kopiraju iz jednog roditelja u jedno dijete a iz drugog roditelja u 
% drugo. Nakon toga preostali geni se popunjavaju na nacin da se njihova
% apsolutna pozicija pokusa sacuvati najvice moguce.
%            
% PRIMJER:
% p1 = (1 2 3|5 4 6 7|8 9)
% p2 = (4 5 2|1 8 7 6|9 3)
%           
% c1 = (x x x|5 4 6 7|x x) korak kopiranja gena izmedu kriziznih tocaka
%           v         v v  ovi clanove potomak moze direktno naslijediti
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (x x 2|5 4 6 7|9 3)
%                          kako ova dva clana se vec nalaze unutar potomka
%                          potrebno je provjeriti koji se clanovi nalaze na 
%                          pozicijama tih clanova u p2 prema poziciji tih
%       v v                clanova iz p1
% p2 = (4 5 2|1 8 7 6|9 3)
% 11 = (x x 2|5 4 6 7|9 3)
%
%             v v          5 se mjenja sa 1 a 4 se mjenja sa 8
% p1 = (1 2 3|5 4 6 7|8 9)
%             v v
% p2 = (4 5 2|1 8 7 6|9 3)
% 
%       v
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (8 x 2|5 4 6 7|9 3)
%         v
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (8 1 2|5 4 6 7|9 3)

newPopulation = population;
numOfCouples = fix(size(population, 1) / 2); % broj parova

for couple = 1:numOfCouples
    
    if rand < x_chance
        
        % odredivanje dvije tocke krizanja na nasumican nacin
        X_point = randi((size(population, 2)), 2, 1);
        while X_point(1) == X_point(2)
            X_point = randi((size(population, 2)), 2, 1);
        end
        
        p1 = population((2 * couple - 1), :);   % p1 = (1 2 3|5 4 6 7|8 9)
        p2 = population((2 * couple), :);       % p2 = (4 5 2|1 8 7 6|9 3)
        
        c1 = zeros(1, size(population, 2));     % c1 = (0 0 0|0 0 0 0|0 0)
        c1(min(X_point):max(X_point)) = p1(min(X_point):max(X_point));
                                                % c1 = (0 0 0|5 4 6 7|0 0)
        c2 = zeros(1, size(population, 2));     % c2 = (0 0 0|0 0 0 0|0 0)
        c2(min(X_point):max(X_point)) = p2(min(X_point):max(X_point));
                                                % c2 = (0 0 0|1 8 7 6|0 0)
        
        %% ______________PREPISIVANJE CLANOVA KOJI NISU PRISUTNI___________
        for Xp = 1:size(population, 2)
            if ~ismember(p2(Xp), c1)
                if c1(Xp) == 0
                    c1(Xp) = p2(Xp);            % c1 = (0 0 2|5 4 6 7|9 3)
                end
            end
            if ~ismember(p1(Xp), c2)
                if c2(Xp) == 0
                    c2(Xp) = p1(Xp);            % c2 = (0 2 3|1 8 7 6|0 9)
                end
            end
        end
        
        %% ________________DOPISIVANJE PREOSTALIH CLANOVA__________________
        for Xp = 1:size(population, 2)
            Xp1 = Xp;
            Xp2 = Xp;
            
            while ~ismember(Xp,c1)
                % u slucaju da je partner od broja koj nedostaje na
                % poziciji koja je vec postavljena while petlja ce traziti
                % sljedeceg najboljeg parnera
                if c1(p2==p1(p2==Xp1)) ~= 0
                    Xp1 = c1(p2==p1(p2==Xp1));
                else
                    c1(p2==p1(p2==Xp1)) = Xp;
                end
            end
            while ~ismember(Xp,c2)
                % u slucaju da je partner od broja koj nedostaje na
                % poziciji koja je vec postavljena while petlja ce traziti
                % sljedeceg najboljeg parnera
                if c2(p1==p2(p1==Xp2)) ~= 0
                    Xp2 = c2(p1==p2(p1==Xp2));
                else
                    c2(p1==p2(p1==Xp2)) = Xp;
                end
            end
        end

        
        newPopulation((2 * couple - 1), :) = c1;
        newPopulation((2 * couple), :) = c2;
    end

end

end
