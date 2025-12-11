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
        q = Queue{String}()
        push!(q, "you")

        while !isempty(q)
                node = dequeue!(q)
                if node == "out"
                        path_counter += 1
                        continue
                end

                steps = graph[node]
                for s in steps
                        push!(q, s)
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


        @memoize function path_count(node, dac, fft)
                if node == "out"
                        return dac && fft ? 1 : 0
                elseif node == "dac"
                        dac = true
                elseif node == "fft"
                        fft = true
                end

                x = 0
                for s in graph[node]
                        x += path_count(s, dac, fft)
                end
                return x
        end

        path_count("svr", false, false)
end
