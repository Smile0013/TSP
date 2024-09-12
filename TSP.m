%% ________________________________________________________________________
% napisao: Martin Martinic
% datum: 10.6.2022.
% svrha: druga zadaca za evolucijske algoritme
% kratki opis: kod rjesava TSP problem pomocu generacijskih algoritama.
% Implementirano je sest razlicitih algoritama krizanja te je moguce
% pokrenuti jedan ili vise njih u svrhu usporedbe.
% 
% potrebne datoteke: TSP.m, OX.m, PMX.m, ERX.m, CX.m, AEX.m,
% HGreX.m, TSPlength.m, findNeighbour.m, "koordinate gradova u txt obliku"
% napomena: sve sto korisnik treba/smije mjenjati se nalazi unutar podrucja
% RUCNO UNESENI PARAMETRI koje se nalazi od linije: 18 do linije: 38
%% ________________________________________________________________________

clear all
clc

%% _________________________RUCNO UNESENI PARAMETRI________________________
% ucitavanje koordinati u X, Y koordinatnom sustavu gradova iz datoteke
CityCoordinateFile = 'koordinate.txt';

numOfMem = 21;              % broj clanoca unutar populacije
numOfGenerations = 100;    % broj iteracija

X_chance = 0.98;    % vjerojatnos da se dva susjedna clana krizaju (0-1)
mut_chance = 0.02;  % vjerojatnost da dva susjedna gena mutiraju (0-1)

% naziv         |vrijeme izvodenja       |potreban broj
% krizanja      |po generacija           |generacija
%_______________|________________________|_________________________________
% 1:OX          |brz                     |malo
% 2:PMX         |brz                     |srednje malo do lokalnog minimuma
% 3:ERX         |spor                    |srednje
% 4:CX          |Jako brz                |malo do lokalnog minimuma
% 5:AEX         |spor                    |srednje malo
% 6:HGreX       |jako spor               |izuzetno malo
% popis algoritama krizanja koj zelite izvrsiti
Xtype_list = [1, 2, 3, 4, 5, 6];
%% ________________________________________________________________________
%
%
%
%
%
%% _______________________UCITAVANJE POTREBNIH DATOTEKA____________________
CityCoordinates = importdata(CityCoordinateFile);

if isfile ('LookupTable.csv')
    % ukoliko lookup trblica postoji ponuditi ce se opcija da ju se izbrise
    
    while 1
        selector = input('Lookup tablica postoji.\nZelite li ju zadrzati Y/N:\n', 's');
        selector = upper(selector);
    
        if selector == 'N'
            delete('LookupTable.csv');
            break
        elseif selector == 'Y'
            break
        end
    end
end


if ~isfile ('LookupTable.csv')
    % ukoliko lookup tablica ne postoji ista ce se izraditi
    
    % inicialne nul vrijednosti
    LookupTable = zeros(size(CityCoordinates, 1));
    
    for city1 = 1:size(CityCoordinates, 1)
        for city2 = 1:size(CityCoordinates, 1)
            
            % racunanje udaljenosti izmedu svih gradova pomocu pitagorinog
            % poucka
            distace = sqrt(...
                (CityCoordinates(city1, 1) - CityCoordinates(city2, 1))^2 + ...
                (CityCoordinates(city1, 2) - CityCoordinates(city2, 2))^2);
            
            % pohrana izracunatih vrijednosti u tablicu
            LookupTable(city1, city2) = distace;
            
        end
    end
    
    % pohrana matlab variable u obliku csv datoteke
    writetable(array2table(LookupTable), 'LookupTable.csv');
    
end

LookupTable = importdata('LookupTable.csv'); % citanje distacei iz csva
LookupTable = LookupTable.data;


%% ____________________________NULTA GENERACIJA____________________________
intPopulation = zeros(numOfMem, size(CityCoordinates, 1));
for member = 1:numOfMem
    % kreiranje inicialne populacije ko skup nasumi?nih permutacija
    intPopulation(member, :) = randperm(size(CityCoordinates, 1));
    
end

intDist = zeros(numOfMem, 1);
for member = 1:numOfMem
    % izra?cn ukupne udaljenosti putujuceg trgovca za sve clanove
    % generacije
    intDist(member) = TSP_length(intPopulation(member, :), LookupTable);
    
end

% stvaranje putanje za ispis
MemberCityCoordinates =...
    [CityCoordinates; zeros(1, size(CityCoordinates, 2))];

for X_type_pointer = 1:length(Xtype_list)

Xtype = Xtype_list(X_type_pointer);
    
population_1 = intPopulation;   % stara populacija
population_2 = population_1;    % nova populacija

dist_1 = intDist;   % stara ukupna udaljenost za sve clanove generacije
dist_2 = dist_1;    % nova ukupna udaljenost za sve clanove generacije

%% ____________________________TSP ALGORITAM_______________________________
% lista ukupne udaljenosti elitnih clanova
eliteMemberSum = Inf(numOfGenerations, 1);

dist_e = Inf(numOfGenerations, 1);

for generation = 1:numOfGenerations
    
    % kako bi se mogla izracunati fitnes funkcija koja nema egzaktno 
    % rjesenje potreno je usporediti rijesenje sa svim rjesenjima
    normalizedDist = (sum(dist_1) - dist_1) / sum(sum(dist_1) - dist_1);
    
    %% ________________________ODABIR RODITELJA____________________________
    
    for parent = 1:numOfMem
        
        member = 1; % clan populacije koji ce pokusava prezivjeti
        survivalEnviermant = rand;  % uvjett okoline za prezivjeti
        % sansa da ce clan prezivjeti
        survivalMember = normalizedDist(member);
        
        while survivalEnviermant > survivalMember
            % ukolikko prvi clan nije prezivio pretrazuje se koji clan je
            % prezivio
            member = member + 1;
            survivalMember = survivalMember + normalizedDist(member);
            
        end
        
        % prezivjeli clanovi postaju roditelji sljedece generacije
        population_2(parent, :) = population_1(member, :);
            
    end
    
    %% ____________________________KRIZANJE________________________________
    switch Xtype
        
        case 1  % OX
            
            population_2 = OX(population_2, X_chance);
            legendTXT = "OX";
            
        case 2 % PMX
            
            population_2 = PMX(population_2, X_chance);
            legendTXT = "PMX";
            
        case 3 % ERX
            
            population_2 = ERX(population_2, X_chance);
            legendTXT = "ERX";
            
        case 4 % CX
            
            population_2 = CX(population_2, X_chance);
            legendTXT = "CX";
            
        case 5 % AEX
            
            population_2 = AEX(population_2, X_chance);
            legendTXT = "AEX";
            
        case 6 % HGreX
            
            population_2 = HGreX(population_2, X_chance, LookupTable);
            legendTXT = "HGreX";
            
    end
    
    %% _____________________________MUTACIJA_______________________________
    dirOfMut = [-1 1];  % tjekom mutacije moguce je da se izmjeni grad prvi
                        % s ljeva ili prvi s desna grada koji mutira
                        
    for mutMem = 1:numOfMem
        for mutCity_1 = 1:size(CityCoordinates, 1)
            if rand < mut_chance
                mutCity_2 = mutCity_1 + dirOfMut(randi(length(dirOfMut)));
    
                mutCity_2(mutCity_2 > size(CityCoordinates, 1)) = 1;
                mutCity_2(mutCity_2 < 1) = size(CityCoordinates, 1);
    
                tempPopulation_2 = population_2;

                tempPopulation_2(mutMem, mutCity_1) =...
                    population_2(mutMem, mutCity_2);
                tempPopulation_2(mutMem, mutCity_2) =...
                    population_2(mutMem, mutCity_1);
    
            end
        end
    end
    
    population_2 = tempPopulation_2;
    
    
    %% ___________________________ELITNI CLAN______________________________ 
    for member = 1:numOfMem
        % izracun ukupne udaljenosti putujuceg trgovca za sve clanove
        % generacije
        dist_2(member) = TSP_length(population_2(member, :), LookupTable);
        
    end
    
    % clan sa najmanjom udaljenosti u populaciji,
    % pozicija tog clana u populaciji
    [minDistInPop, posOfMinInPop] = min(dist_2);
    
    if minDistInPop <= min(eliteMemberSum)
        eliteMemberSum(generation) = minDistInPop;
        eliteMember = population_2(posOfMinInPop, :);
    else
        eliteMemberSum(generation) = eliteMemberSum(generation - 1);
        population_2(posOfMinInPop, :) = eliteMember;
    end
    
    dist_e(generation) = TSP_length(eliteMember, LookupTable);
    
    dist_1 = dist_2;
    population_1 = population_2;
    %generation
    
end

%% ___________________NAJKRACI PUT PO GENERACIJAMA_________________________
figure(Xtype)
plot((1:generation), dist_e)
legend(legendTXT)

%% ___________________NAJKRACI PUT VIZUALIZACIJA___________________________
% pohrana putanje elitnog clana po koordinatnom sustavu
for city = 1:size(CityCoordinates, 1)
    MemberCityCoordinates(city, :) = CityCoordinates(eliteMember(city), :);
end
MemberCityCoordinates(end, :) = CityCoordinates(eliteMember(1), :);

% iscrtavanje grafa
figure(Xtype*100)
plot(MemberCityCoordinates(:, 1), MemberCityCoordinates(:, 2))

end

