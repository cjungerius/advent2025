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

input = readdlm("input/06_input.txt")

solve(input)
