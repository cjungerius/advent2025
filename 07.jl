function solve(input)
        beampos = Dict{Int,Int}()
        beampos_buff = Dict{Int,Int}()
        splits = 0

        beampos[findfirst('S', input[1])] = 1
        for line in input[2:end]
                for (b, v) in beampos
                        if line[b] == '.'
                                beampos_buff[b] = get(beampos_buff, b, 0) + v
                        elseif line[b] == '^'
                                beampos_buff[b-1] = get(beampos_buff, b - 1, 0) + v
                                beampos_buff[b+1] = get(beampos_buff, b + 1, 0) + v
                                splits += 1
                        end
                end
                beampos, beampos_buff = beampos_buff, beampos
                empty!(beampos_buff)
        end

        timelines = sum(values(beampos))
        (splits, timelines)
end

input = readlines("input/07_input.txt")
partone, parttwo = solve(input)
