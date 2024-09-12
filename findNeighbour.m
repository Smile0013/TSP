function c_neigh = findNeighbour(city, parent_1, parent_2)
% za grad 'city' pronalazi susjede u roditeljima 'parent_1' 'parent_2'

c_neigh =[];
c_neigh_temp = [0, 0, 0, 0]; % susjedi trenutnog grada

if ~exist('parent_2','var')
    % u slucaju da se traze susjedi unutar samo jednog roditelja
    parent_2 = [];
    neigh_num = 2;
else
    % u slucaju da se traze susjedi unutar oba roditelja
    neigh_num = 4;
end

for neighbour = 1:neigh_num % ponavlja se za svakog susjeda
    
    switch neighbour
    % izmjenjuje u kojem roditelju se traze susjedi
        case {1, 2}
            p = parent_1;
        case {3, 4}
            p = parent_2;
    end
    
    %______________________________________________________________________
    % definira se pozicija na kojoj se trazi susjed
    pos_of_neigh = find(p == city) - (-1)^neighbour;
    
    if pos_of_neigh < 1
        pos_of_neigh = length(parent_1);
    end
    if pos_of_neigh > length(parent_1)
         pos_of_neigh = 1;
    end
    %______________________________________________________________________
    
    % pohranjivanje susjeda u matrcu
    c_neigh_temp(neighbour) = p(pos_of_neigh);

end

% broj neponavljaju?ih susjeda
uniq_neigh = 0;

for neighbour = 1:length(c_neigh_temp)
    if ~ismember(c_neigh_temp(neighbour), c_neigh)
        uniq_neigh = uniq_neigh + 1;
        if c_neigh_temp(neighbour) ~= 0
            c_neigh(uniq_neigh) = c_neigh_temp(neighbour);
        end
    end
end

end
