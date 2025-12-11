using DataStructures
using Memoize

function solve(input)
        graph = Dict{String,Vector{String}}()
        for line in input
                key, values = split(line, ": ")
                values = split(values, " ")
                graph[key] = values

        end

        path_counter = 0
        path_2_counter = 0
        q = Queue{Vector{String}}()
        push!(q, ["svr"])

        while !isempty(q)
                path = dequeue!(q)
                if path[end] == "out"
                        path_counter += 1
                        if "dac" in path && "fft" in path
                                path_2_counter += 1
                        end
                        continue
                end

                steps = graph[path[end]]
                for s in steps
                        if !(s in path)
                                push!(q, [path..., s])
                        end
                end
        end

        path_counter
end

function solve2(input)

        graph = Dict{String,Vector{String}}()
        for line in input
                key, values = split(line, ": ")
                values = split(values, " ")
                graph[key] = values

        end

        memo = Dict{Tuple{String,Set{String}},Int}()

        function path_count(node, visited)
                val = get!(memo, (node, visited)) do
                        if node == "out"
                                return ("dac" in visited) && ("fft" in visited) ? 1 : 0
                        else
                                x = 0
                                for s in graph[node]
                                        if !(s in visited)
                                                new_visited = push!(copy(visited), s)
                                                x += path_count(s, new_visited)
                                        end
                                end
                        end
                        return x
                end
                return val
        end

        path_count("svr", Set{String}([]))
end
