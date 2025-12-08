function find_rolls(input, frontier)
        roll_count = 0
        removable = Tuple{Int,Int}[]
        new_frontier = Set{Tuple{Int,Int}}()
        (y_max, x_max) = size(input)
        surround = filter(x -> x != (0, 0), [(i, j) for i in -1:1 for j in -1:1])
        potential_frontier = falses(8)
        y_s, x_s = (0, 0)
        for (y, x) in frontier
                input[y, x] == '.' && continue
                fill!(potential_frontier, false)
                for (i, s) in enumerate(surround)
                        y_s = y + s[1]
                        x_s = x + s[2]
                        !(1 <= y_s <= y_max) && continue
                        !(1 <= x_s <= x_max) && continue
                        potential_frontier[i] = input[y_s, x_s] == '@'
                end
                if sum(potential_frontier) < 4
                        roll_count += 1
                        push!(removable, (y, x))
                        for i in eachindex(potential_frontier)
                                !potential_frontier[i] && continue
                                push!(new_frontier, (y, x) .+ surround[i])
                        end
                end
        end
        (roll_count, removable, new_frontier)
end

function solve(input)
        input = stack(input, dims=1)
        frontier = Set{Tuple{Int,Int}}([(y, x) for y in 1:size(input)[1] for x in 1:size(input)[2]])
        roll_count, removable, frontier = find_rolls(input, frontier)
        part_1 = roll_count
        part_2 = roll_count
        while length(removable) > 0
                for r in removable
                        input[r[1], r[2]] = '.'
                end
                roll_count, removable, frontier = find_rolls(input, frontier)
                part_2 += roll_count
        end
        (part_1, part_2)
end

function solve_sets(input)
        rolls = Set{Tuple{Int,Int}}()
        surround = filter(x -> x != (0, 0), [(i, j) for i in -1:1 for j in -1:1])

        for y in eachindex(input)
                for x in eachindex(input[y])
                        if input[y][x] == '@'
                                push!(rolls, (y, x))
                        end
                end
        end

        frontier = copy(rolls)
        toremove = Set{Tuple{Int,Int}}()
        newfrontier = Set{Tuple{Int,Int}}()
        partone = 0
        parttwo = 0

        while !isempty(frontier)
                for (y, x) in frontier
                        neighbors = [(y, x) .+ s for s in surround]
                        if sum(neighbors .∈ (rolls,)) < 4
                                push!(toremove, (y, x))
                                intersect!(neighbors, rolls)
                                !isempty(neighbors) && push!(newfrontier, neighbors...)
                        end
                end
                partone == 0 && (partone = length(toremove))
                parttwo += length(toremove)
                setdiff!(rolls, toremove)
                setdiff!(newfrontier, toremove)
                frontier, newfrontier = newfrontier, frontier
                empty!(toremove)
                empty!(newfrontier)
        end

        partone, parttwo
end
