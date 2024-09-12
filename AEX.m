function newPopulation = AEX(population, x_chance)
% AEX krizanje funkcionira na sljedeci nacin:
% Potomak nasljedi prva dva clana iz iz prvog roditelja. Nakon toga trazi
% susjeda drigog clana u drugom roditelju, te nasumi?no odabere jednog. Od
% tog clana ponovno trazi susjeda ali u prvom roditelju. Postupak se
% ponavlja dok se ne zatvori krug, tada se nasumicno bira sljedeci clan.
% Tako se dok se potomak ne popuni.
%
% PRIMJER:
% p1 = (1 2 3 5 4 6 7 8 9)
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 2 x x x x x x x)
%         v   v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 2 5 x x x x x x)
%           v   v
% p1 = (1 2 3 5 4 6 7 8 9) nasumicno se bira 3
%
% c1 = (1 2 5 3 x x x x x)
%       v             v
% p2 = (4 5 2 1 8 7 6 9 3) nasumicno se bira 9
%
% c1 = (1 2 5 3 9 x x x x)
%                   v   v
% p2 = (4 5 2 1 8 7 6 9 3)
%
% c1 = (1 2 5 3 9 6 x x x)
%               v   v
% p1 = (1 2 3 5 4 6 7 8 9) nasumicno se bira 4
%
% c1 = (1 2 5 3 9 6 4 x x)
%         v             v
% p2 = (4 5 2 1 8 7 6 9 3) kako su i 5 i 3 vec u potomku nasumicno se bira
%                          jedan broj u nizu [7 8] a to je 7
%
% c1 = (1 2 5 3 9 6 4 7 x)
%                 v   v
% p1 = (1 2 3 5 4 6 7 8 9)
%
% c1 = (1 2 5 3 9 6 4 7 8)

newPopulation = population;
numOfCouples = fix(size(population, 1) / 2); % broj parova

for couple = 1:numOfCouples
    
    if rand < x_chance
        
        p1 = population((2 * couple - 1), :);   % p1 = (1 2 3 5 4 6 7 8 9)
        p2 = population((2 * couple), :);       % p2 = (4 5 2 1 8 7 6 9 3)
        
        c1 = zeros(1, size(population, 2));     % c1 = (0 0 0 0 0 0 0 0 0)
        c1(1:2) = p1(1:2);                      % c1 = (1 2 0 0 0 0 0 0 0)
        c2 = zeros(1, size(population, 2));     % c2 = (0 0 0 0 0 0 0 0 0)
        c2(1:2) = p2(1:2);                      % c2 = (4 5 0 0 0 0 0 0 0)
 
        for Xp = 3:1:size(population, 2)
            
            for child = 1:2
                
                switch child
                    % izmjenjuje prvg i drugog potomka kako bi se mogli u
                    % jednoj petlji pronaci istovremeno susjedi za prvog i
                    % drugog potomka
                    case 1
                        c = c1;
                        if mod(Xp,2)
                            % ukoliko je pozicija sljedeceg clana neparna
                            p = p2;
                        else
                            % ukoliko je pozicija sljedeceg clana parna
                            p = p1;
                        end
                        
                    case 2
                        c = c2;
                        if mod(Xp,2)
                            % ukoliko je pozicija sljedeceg clana neparna
                            p = p1;
                        else
                            % ukoliko je pozicija sljedeceg clana parna
                            p = p2;
                        end
                end
                
                next_city = 0;
                next_city_candidat = findNeighbour(c(Xp-1), p);
                
                if ~ismember(next_city_candidat, c)
                    % ukoliko niti jedan od susjeda nije vec clan potomka
                    % nasumicno se bira sljedeci clan
                    next_city =...
                        next_city_candidat(randi(length(next_city_candidat)));
                else
                    try
                        % ukoliko je jedan od susjeda vec u potomku drugi 
                        % se automatski bira
                        next_city(1) =...
                            next_city_candidat(~ismember(next_city_candidat, c));
                    catch
                        % ukoliko niti jedan od susjeda nije u potomku
                        all_citys = 1:size(population, 2);
                        next_city_candidat =...
                            all_citys(~ismember(all_citys, c));
                        next_city =...
                            next_city_candidat(randi(length(next_city_candidat)));
                    end
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
