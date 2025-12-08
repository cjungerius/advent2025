using DataStructures
using StatsBase

function solve(input)
        points = [parse.(Int, split(p, ',')) for p in input]
        pq = Pair{Tuple{Int,Int},Int}[]

        for j in 1:length(points)
                for i in 1:j-1
                        d = sum((points[j] .- points[i]) .^ 2)
                        push!(pq, (i, j) => d)
                end
        end

        sort!(pq, by=last)
        circuits = IntDisjointSet(length(points))
        cycles = 0
        part_one = 0
        i = 0
        j = 0

        while num_groups(circuits) > 1
                (i, j) = first(popfirst!(pq))
                union!(circuits, i, j)
                cycles += 1
                if cycles == 1000
                        roots = find_root.(Ref(circuits), 1:length(points))
                        sizes = sort!(counts(roots), rev=true)
                        part_one = *(sizes[1:3]...)
                end
        end
        part_two = points[i][1] * points[j][1]

        (part_one, part_two)
end


input = readlines("input/08_input.txt")
part_one, part_two = solve(input)

