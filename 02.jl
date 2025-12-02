function solve(input)
        numdigits = x -> floor(log10(x)) + 1
        ranges = split(input, ',')
        part_one = Set{Int}()
        part_two = Set{Int}()
        for r in ranges
                begin_r, end_r = parse.(Int, split(r, '-'))
                min_length = numdigits(begin_r)
                max_length = numdigits(end_r)
                for seg_len in 1:max_length÷2
                        min_reps = max(ceil(Int, min_length / seg_len), 2)
                        max_reps = floor(Int, max_length / seg_len)
                        min_reps > max_reps && continue
                        for rep in min_reps:max_reps
                                lower_seg = 1
                                if seg_len * rep == min_length
                                        lower_seg = begin_r ÷ 10^(min_length - seg_len)
                                else
                                        lower_seg = 10^(seg_len - 1)
                                end
                                for segment::Int in lower_seg:10^(seg_len)-1
                                        candidate = segment
                                        for n in 1:rep-1
                                                candidate += segment * 10^(seg_len * n)
                                        end
                                        candidate < begin_r && continue
                                        candidate > end_r && break
                                        rep == 2 && push!(part_one, candidate)
                                        push!(part_two, candidate)
                                end
                        end
                end
        end
        (sum(part_one), sum(part_two))
end

input = readline("input/02_input.txt")

solution = solve(input)
println("part 1 solution: ", solution[1])
println("part 2 solution: ", solution[2])
