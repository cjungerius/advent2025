function solve(input)
    pos = 50
    passwd1 = 0
    passwd2 = 0
    for line in input
        sign = line[1] == 'L' ? -1 : 1
        val = parse(Int, line[2:end])
        startatzero = pos == 0
        pos += sign*val

        if pos > 99
            passwd2 += div(pos, 100)
        elseif pos <= 0
            passwd2 -= (div(pos,100) - !startatzero)
        end

        pos = mod(pos, 100)
        passwd1 += (pos == 0)
    end
    (passwd1, passwd2)
end


input = readlines("input/01_input.txt")
solution = solve(input)
println("part 1 solution: ", solution[1])
println("part 2 solution: ", solution[2])