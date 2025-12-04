function find_rolls(input)
        roll_count = 0
        removable = Tuple{Int,Int}[]
        y_max = length(input)
        x_max = length(input[1])
        surround = filter(x -> x != (0, 0), [(i, j) for i in -1:1 for j in -1:1])
        for y in 1:y_max
                for x in 1:x_max
                        input[y][x] == "." && continue
                        rolls = 0
                        for s in surround
                                y_s = y + s[1]
                                x_s = x + s[2]
                                !(1 <= y_s <= y_max) && continue
                                !(1 <= x_s <= x_max) && continue
                                rolls += input[y_s][x_s] == "@"
                        end
                        if rolls < 4
                                roll_count += 1
                                push!(removable, (y, x))
                        end
                end
        end
        (roll_count, removable)
end

function solve(input)
        input = split.(input, "")
        roll_count, removable = find_rolls(input)
        part_1 = roll_count
        part_2 = roll_count
        while length(removable) > 0
                for r in removable
                        input[r[1]][r[2]] = "."
                end
                roll_count, removable = find_rolls(input)
                part_2 += roll_count
        end
        (part_1, part_2)
end
