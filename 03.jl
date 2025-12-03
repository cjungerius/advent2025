function solve(banks)
        total = 0
        for b in banks
                d1, loc1 = findmax(b[1:end-1])
                d2, loc2 = findmax(b[loc1+1:end])
                total += parse(Int, d1 * d2)
        end
        total
end

function solve2(banks)
        total = 0
        for b in banks
                switched_on = [b[1]]
                removals = length(b) - 12
                for val in b[2:end]
                        while removals > 0 && !isempty(switched_on) && val > switched_on[end]
                                pop!(switched_on)
                                removals -= 1
                        end
                        push!(switched_on, val)
                end
                total += parse(Int, *(switched_on[1:12]...))
        end
        total
end

input = readlines("input/03_input.txt")

solution = [solve(input), solve2(input)]
println("part 1 solution: ", solution[1])
println("part 2 solution: ", solution[2])
