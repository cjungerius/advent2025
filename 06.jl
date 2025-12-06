using DelimitedFiles

function solve(input)
        partone = 0
        rows, cols = size(input)
        for i in 1:cols
                operation = input[end, i] == "+" ? (+) : (*)
                column = input[1, i]
                for j in 2:rows-1
                        column = operation(column, input[j, i])
                end
                partone += column
        end
        partone
end

function solve2(input)
        operations = split(input[end], " ", keepempty=false)
        lines = []
        i = length(operations)
        numdone = false
        cols = length(input[1])
        rows = length(input)
        nums = Int[]
        op_index = 1
        op = operations[op_index] == "+" ? (+) : (*)
        parttwo = 0
        for i in 1:cols
                thiscol = strip(*([input[j][i] for j in 1:rows-1]...))
                if isempty(thiscol)
                        parttwo += op(nums...)
                        empty!(nums)
                        op_index += 1
                        op = operations[op_index] == "+" ? (+) : (*)
                else
                        push!(nums, parse(Int, thiscol))
                end
        end
        parttwo += op(nums...)

        parttwo
end

fname = "input/06_input.txt"
input1 = readdlm(fname)
solve(input1)
input2 = readlines(fname)
solve2(input2)
