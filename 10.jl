using DataStructures
using Memoize

function press_buttons(lights::BitVector, button::Union{Tuple{Int,Vararg{Int}},Int})
        new_lights = copy(lights)
        for b in button
                new_lights[b+1] = !new_lights[b+1]
        end
        return new_lights
end

function solve(input)
        presses = 0
        pattern = r"\[(.+)\] (.+)\ \{(.+)\}"
        button_pattern = r"\(([0-9,]+)\)"
        pattern_matches = match.(pattern, input)
        for i in eachindex(pattern_matches)
                target = BitVector(split(pattern_matches[i].captures[1], "") .== "#")
                buttons = pattern_matches[i].captures[2]
                buttons = [m.captures[1] for m in eachmatch(button_pattern, buttons)]
                buttons = split.(buttons, ",")
                buttons = [Tuple(parse.(Int, b)) for b in buttons]

                lights = falses(length(target))
                q = Queue{Tuple}()
                steps = 0

                seen = Set([lights])

                for b in buttons
                        enqueue!(q, (lights, b, steps))
                end

                while !isempty(q)
                        lights, b, steps = dequeue!(q)
                        lights == target && break
                        for b in buttons
                                next_lights = press_buttons(lights, b)
                                if !(next_lights in seen)
                                        push!(seen, next_lights)
                                        enqueue!(q, (next_lights, b, steps + 1))
                                end
                        end
                end
                presses += steps
        end
        presses
end
