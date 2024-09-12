function cityDistance = TSP_length(member, lookupTable)
% ulazni parametar je lista gradova i tablica udaljenosti istih a kao
% rezultat vraca ukupnu duljinu puta
% member = clan generacije (lista gradova)
% lookupTable = tablica sa udaljenostima izmedu gradova


cityDistance = 0;

for city = 1:(length(member) - 1)
    
    cityDistance = cityDistance + lookupTable(member(city), member((city+1)));
    
end

cityDistance = cityDistance + lookupTable(member(end), member(1));

end