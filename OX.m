function newPopulation = OX(population, x_chance)
% OX krizanje funkcionira na sljedeci nacin: 
% nasumicno se odrede dva mjesta krizanje geni izmedu mjesta krizanja se 
% kopiraju iz jednog roditelja u jedno dijete a iz drugog roditelja u 
% drugo. Nakon toga preostali geni se popunjavaju jedan po jedan 
% redosljednom kako su u drugom roditelju preskacuci gene koji se nalaze 
% vec unutar kopiranih gena
%            
% PRIMJER:
% p1 = (1 2 3|5 4 6 7|8 9)
% p2 = (4 5 2|1 8 7 6|9 3)
%           
% c1 = (x x x|5 4 6 7|x x) korak kopiranja gena izmedu kriziznih tocaka
%                     v
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (x x x|5 4 6 7|9 x)
%                       v
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (x x x|5 4 6 7|9 3)
%       v                  buduci da se 4 vec nalazi unutar segmenta koji je kopiran taj broj se preskace
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (x x x|5 4 6 7|9 3)
%         v                buduci da se 5 vec nalazi unutar segmenta koji je kopiran taj broj se preskace
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (x x x|5 4 6 7|9 3)
%           v
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (2 x x|5 4 6 7|9 3)
%             v
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (2 1 x|5 4 6 7|9 3)
%               v
% p2 = (4 5 2|1 8 7 6|9 3)
% c1 = (2 1 8|5 4 6 7|9 3)

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
        
        %% _____________________OD DRUGE TOCKE DO KRAJA____________________ 
        % Xp je pokazivac od druge tocke prekida do kraja
        Xp = (max(X_point) + 1);
        Xp1 = Xp;
        if Xp1 > size(population, 2)
            Xp1 = 1;
        end
        Xp2 = Xp;
        if Xp2 > size(population, 2)
            Xp2 = 1;
        end
        
        while Xp <= size(population, 2)
            
            % c1
            while ismember(p2(Xp1), c1)
                Xp1 = Xp1 + 1;
                if Xp1 > size(population, 2)
                    Xp1 = 1;
                end
            end
            c1(Xp) = p2(Xp1);
            
            % c2
            while ismember(p1(Xp2), c2)
                Xp2 = Xp2 + 1;
                if Xp2 > size(population, 2)
                    Xp2 = 1;
                end
            end
            c2(Xp) = p1(Xp2);
            
            Xp = Xp +1;
            
        end
        
        %% _____________________OD POCETKA DO PRVE TOCKE___________________
        % Xp je pokazivac od pocetka do prve tocke
        Xp = 1;
        while Xp < min(X_point)
            
            % c1
            while ismember(p2(Xp1), c1)
                Xp1 = Xp1 + 1;
                if Xp1 > size(population, 2)
                    Xp1 = 1;
                end
            end
            c1(Xp) = p2(Xp1);
            
            % c2
            while ismember(p1(Xp2), c2)
                Xp2 = Xp2 + 1;
                if Xp2 > size(population, 2)
                    Xp2 = 1;
                end
            end
            c2(Xp) = p1(Xp2);
            
            Xp = Xp +1;
            
        end
       
        newPopulation((2 * couple - 1), :) = c1;
        newPopulation((2 * couple), :) = c2;
    end

end

end
