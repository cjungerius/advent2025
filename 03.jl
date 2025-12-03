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
                switched_on = [1:length(b)...]
                while length(switched_on) > 12
                        for (i, v) in enumerate(switched_on)
                                if i == length(switched_on) || b[switched_on[i+1]] > b[v]
                                        popat!(switched_on, i)
                                        break
                                end
                        end
                end
                total += parse(Int, b[switched_on])
        end
        total
end

input = readlines("input/03_input.txt")

solution = [solve(input), solve2(input)]
println("part 1 solution: ", solution[1])
println("part 2 solution: ", solution[2])
