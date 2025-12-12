function solve(input)
        pieces = Int[]
        piece = 0
        part_one = 0
        for line in input
                if '#' in line
                        piece += count('#', line)
                elseif length(line) == 0
                        push!(pieces, piece)
                        piece = 0

                elseif 'x' in line
                        area, counts = split(line, ": ")
                        area = prod(parse.(Int, split(area, "x")))
                        counts = parse.(Int, split(counts, " "))
                        lower_bound = sum(pieces .* counts) # with perfect packing, we need this many squares
                        # it turns out this is all we need to check thanks to our inputs (thanks reddit!)
                        part_one += (area > lower_bound)
                end
        end
        part_one
end

input = readlines("input/12_input.txt")
