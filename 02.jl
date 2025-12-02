#function solve(input)
#	#this code is fast for solving part one but I think it's neater to do both parts in a single function
#        numdigits = x -> floor(log10(x)) + 1
#        solution = 0
#        ranges = split(input, ',')
#        for r in ranges
#
#                begin_r, end_r = parse.(Int, split(r, '-'))
#                if numdigits(begin_r) % 2 != 0
#                        begin_r = 10^(numdigits(begin_r))
#                end
#                if numdigits(end_r) % 2 != 0
#                        end_r = 10^(numdigits(end_r) - 1) - 1
#                end
#
#                begin_r > end_r && continue
#
#                begin_half = begin_r ÷ 10^(numdigits(begin_r) / 2)
#                end_half = end_r ÷ 10^(numdigits(end_r) / 2)
#
#                for h in begin_half:end_half
#                        candidate = h * 10^numdigits(h) + h
#                        candidate < begin_r && continue
#                        candidate > end_r && break
#                        solution += candidate
#                end
#        end
#
#        solution
#end

function solve(input)
        numdigits = x -> floor(log10(x)) + 1
        ranges = split(input, ',')
        part_one = Set{Int}()
        part_two = Set{Int}()
        solution = 0
        for r in ranges
                begin_r, end_r = parse.(Int, split(r, '-'))
                min_length = numdigits(begin_r)
                max_length = numdigits(end_r)
                for seg_len in 1:max_length÷2
                        min_reps = max(ceil(Int, min_length / seg_len), 2)
                        max_reps = floor(Int, max_length / seg_len)
                        min_reps > max_reps && continue
                        for rep in min_reps:max_reps
                                for segment::Int in 10^(seg_len-1):10^(seg_len)-1
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
