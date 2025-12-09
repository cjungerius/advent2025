function reorder(a, b)
        return a > b ? (b, a) : (a, b)
end

function ranges_overlap(a1, a2, b1, b2)
        return !(a2 < b1 || b2 < a1)
end

function edge_intersects_rect(edge, rect)
        (x1, y1), (x2, y2) = edge
        (xmin, ymin), (xmax, ymax) = rect
        x1, x2 = reorder(x1, x2)
        y1, y2 = reorder(y1, y2)
        xmin, xmax = reorder(xmin, xmax)
        ymin, ymax = reorder(ymin, ymax)

        if x1 == x2 # vertical edge
                x = x1
                return xmin < x < xmax && ranges_overlap(y1, y2, ymin + 1, ymax - 1)

        elseif y1 == y2 # horizontal edge
                y = y1
                return ymin < y < ymax && ranges_overlap(x1, x2, xmin + 1, xmax - 1)
        end
end

function solve(input)
        biggest_tile = 0
        biggest_green_tile = 0
        coords = [Tuple(parse.(Int, split(line, ','))) for line in input]
        edges = [(coords[i], coords[mod1(i + 1, length(coords))]) for i in 1:length(coords)]


        for j in eachindex(coords)
                x1, y1 = coords[j]
                for i in 1:j-1
                        x2, y2 = coords[i]
                        (x1 == x2 || y1 == y2) && continue
                        candidate = (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
                        if candidate > biggest_green_tile
                                if !any(e -> edge_intersects_rect(e, ((x1, y1), (x2, y2))), edges)
                                        biggest_green_tile = candidate
                                end
                        end

                        biggest_tile = max(biggest_tile, candidate)
                end
        end
        (biggest_tile, biggest_green_tile)
end



