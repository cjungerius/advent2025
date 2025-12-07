function solve(input)
        beampos = zeros(Int, length(input[1]))
        splits = 0

        beampos[findfirst('S', input[1])] = 1
        for line in input[2:end]
                for (b, v) in enumerate(beampos)
                        if line[b] == '^' && v != 0
                                beampos[b-1] += v
                                beampos[b+1] += v
                                beampos[b] = 0
                                splits += 1
                        end
                end
        end

        timelines = sum(beampos)
        (splits, timelines)
end

input = readlines("input/07_input.txt")
partone, parttwo = solve(input)
