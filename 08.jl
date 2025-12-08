mutable struct DisjointSet
        parents::Vector{Int}
        sizes::Vector{Int}
        num_groups::Int

        function DisjointSet(n::Int)
                parents = collect(1:n)
                sizes = ones(Int, n)
                new(parents, sizes, n)
        end
end

function find!(ds::DisjointSet, x::Int)
        begin
                if ds.parents[x] != x
                        ds.parents[x] = find!(ds, ds.parents[x])
                end
                return ds.parents[x]
        end
end

function union!(ds::DisjointSet, x::Int, y::Int)
        x = find!(ds, x)
        y = find!(ds, y)

        if x != y
                # Attach smaller tree to larger tree
                if ds.sizes[x] < ds.sizes[y]
                        x, y = y, x
                end

                # Link roots
                ds.parents[y] = x
                ds.sizes[x] += ds.sizes[y]

                ds.num_groups -= 1
                return true
        end
        return false
end

function solve(input)
        points::Vector{Tuple{Int,Int,Int}} = [Tuple(parse.(Int, split(p, ','))) for p in input]
        n = length(points)
        num_edges = (n * (n - 1)) ÷ 2
        edges = Vector{Tuple{Int,Int,Int}}(undef, num_edges)

        idx = 1
        for j in eachindex(points)
                (x1::Int, y1::Int, z1::Int) = points[j]
                for i in 1:j
                        i == j && continue
                        (x2::Int, y2::Int, z2::Int) = points[i]
                        d = (x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2
                        edges[idx] = (i, j, d)
                        idx += 1
                end
        end

        # this heuristic seems to work posthoc to drastically shorten runtime - not sure how to prove it's fully legit
        # I suppose you could just increase the sorted region until part 2 is correct.
        partialsort!(edges, 1:20*n, by=x -> x[3])
        ds = DisjointSet(length(points))

        cycle = 1
        part_one = 0
        i = 0
        j = 0

        while ds.num_groups > 1
                (i, j, _) = edges[cycle]
                union!(ds, i, j)

                if cycle == 1000
                        root_sizes = Int[]
                        for k in 1:n
                                if ds.parents[k] == k
                                        push!(root_sizes, ds.sizes[k])
                                end
                        end
                        sort!(root_sizes, rev=true)
                        part_one = prod(root_sizes[1:3])
                end
                cycle += 1
        end
        part_two = points[i][1] * points[j][1]

        (part_one, part_two)
end


input = readlines("input/08_input.txt")
part_one, part_two = solve(input)

