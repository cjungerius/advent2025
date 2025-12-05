function solve(input)
        fresh_ranges = Vector{Int}[]
        ingredients = Int[]
        flip = false
        for line in input
                if line == ""
                        flip = true
                        continue
                end

                if flip
                        push!(ingredients, parse(Int, line))
                else
                        push!(fresh_ranges, parse.(Int, split(line, "-")))
                end
        end

        sort!(fresh_ranges, by=x -> x[1])
        fresh_ranges_merged = Vector{Int}[]
        push!(fresh_ranges_merged, fresh_ranges[1])

        for r in fresh_ranges[2:end]
                old_lower, old_upper = fresh_ranges_merged[end]
                lower, upper = r
                if lower > old_upper + 1
                        push!(fresh_ranges_merged, r)
                else
                        fresh_ranges_merged[end][2] = max(old_upper, upper)
                end
        end

        part_one = 0
        for ingredient in ingredients
                i = searchsortedlast(fresh_ranges_merged, (ingredient, ), by=x -> x[1])
                part_one += i > 0 && fresh_ranges_merged[i][1] ≤ ingredient ≤ fresh_ranges_merged[i][2]
        end

        part_two = sum([r[2] - r[1] + 1 for r in fresh_ranges_merged])


        part_one, part_two
end
