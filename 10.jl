using DataStructures
using JuMP
using HiGHS

function bv_to_uint(bv::BitVector)
        x = 0
        for (i, bit) in pairs(bv)
                x |= bit << (i - 1)
        end
        return x
end

function list_to_mask(idxs)
        x = 0
        for i in idxs
                x |= 1 << i
        end
        return x
end

function solve(input)
        presses = 0
        pattern = r"\[(.+)\] (.+)\ \{(.+)\}"
        button_pattern = r"\(([0-9,]+)\)"
        pattern_matches = match.(pattern, input)
        for i in eachindex(pattern_matches)
                target = BitVector(split(pattern_matches[i].captures[1], "") .== "#")
                target_num = bv_to_uint(target)
                buttons = pattern_matches[i].captures[2]
                buttons = [m.captures[1] for m in eachmatch(button_pattern, buttons)]
                buttons = split.(buttons, ",")
                buttons = [parse.(Int, b) for b in buttons]
                buttons = [list_to_mask(b) for b in buttons]

                lights::Int = 0
                q = Queue{Tuple{UInt,Int}}()
                steps = 0

                seen = Set{UInt}([lights])
                enqueue!(q, (lights, steps))

                while !isempty(q)
                        lights, steps = dequeue!(q)
                        lights == target_num && break
                        for b in buttons
                                next_lights = lights ⊻ b
                                if !(next_lights in seen)
                                        push!(seen, next_lights)
                                        enqueue!(q, (next_lights, steps + 1))
                                end
                        end
                end
                presses += steps
        end
        presses
end

function solve2(input)
        pattern = r"\[(.+)\] (.+)\ \{(.+)\}"
        button_pattern = r"\(([0-9,]+)\)"
        pattern_matches = match.(pattern, input)
        data = Tuple[]
        for i in eachindex(pattern_matches)
                b = parse.(Int, split(pattern_matches[i].captures[3], ","))
                buttons = pattern_matches[i].captures[2]
                buttons = [m.captures[1] for m in eachmatch(button_pattern, buttons)]
                buttons = split.(buttons, ",")
                buttons = [Tuple(parse.(Int, b)) for b in buttons]
                A = zeros(Int, length(b), length(buttons))
                for button in eachindex(buttons)
                        A[:, button] = [c in buttons[button] for c in 0:length(b)-1]
                end
                push!(data, (A, b))
        end

        model = direct_model(HiGHS.Optimizer())
        set_silent(model)

        total_vars = sum(size(d[1], 2) for d in data)

        @variable(model, x[1:total_vars] >= 0, Int)

        var_ptr = 1

        for (A, b) in data
                rows, cols = size(A)
                current_vars = x[var_ptr:var_ptr+cols-1]
                @constraint(model, A * current_vars .== b)
                var_ptr += cols
        end

        @objective(model, Min, sum(x))
        optimize!(model)
        return Int(sum(value.(x)))
end
