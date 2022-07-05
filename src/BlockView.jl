struct BlockView
    Nx::Array{Int, 1}
    Ny::Array{Int, 1}
    block_rows::Int
    block_cols::Int
end


function BlockView(Nx, Ny)

    BlockView(Nx, Ny, length(Nx), length(Ny))

end


function setelement!(A::AbstractMatrix, b::BlockView, (x, y)::Tuple{T, T}, (i, j)::Tuple{T, T}, val::Real) where T <: Int

    checkvalidityofindex(b, x, y, i, j)

    @views startx = x == 1 ? 0 : sum(b.Nx[1:x-1])
    @views starty = y == 1 ? 0 : sum(b.Ny[1:y-1])

    A[startx + i, starty + j] = val

    nothing

end


function setblock!(A::AbstractMatrix, b::BlockView, (x, y)::Tuple{T, T}, val) where T<:Int

    checkvalidityofindex(b, x, y, 1, 1)

    @views startx = x == 1 ? 0 : sum(b.Nx[1:x-1])
    @views starty = y == 1 ? 0 : sum(b.Ny[1:y-1])

    A[startx+1:startx+b.Nx[x], starty+1:starty+b.Ny[y]] = val

    nothing

end


function getelement(A::AbstractMatrix, b::BlockView, (x, y)::Tuple{T, T}, (i, j)::Tuple{T, T}, val::Real) where T <: Int

    checkvalidityofindex(b, x, y, i, j)

    @views startx = x == 1 ? 0 : sum(b.Nx[1:x-1])
    @views starty = y == 1 ? 0 : sum(b.Ny[1:y-1])

    A[startx + i, starty + j]

end


function checkvalidityofindex(b, x, y, i, j)

    if x < 1
        error("x must be a positive integer, but x is $x")
    end

    if x > b.block_rows
        error("x must not exceed number of blocks in rows which is "*string(b.block_rows))
    end

    if y < 1
        error("y must be a positive integer, but y is $y")
    end

    if y > b.block_cols
        error("x must not exceed number of blocks in columns which is "*string(b.block_cols))
    end


    if i < 1
        error("row index i must be positive integer, but i is $i")
    end

    if j < 1
        error("column index j must be positive integer, but j is $j")
    end

    if i > b.Nx[x]
        error("row index $i exceeds size of ($x, $y)-th block matrix of size " * string(b.Nx[x]) * "×" * string(b.Ny[y]))
    end

    if j > b.Ny[y]
        error("column index $j exceeds size of ($x, $y)-th block matrix of size " * string(b.Nx[x]) * "×" * string(b.Ny[y]))
    end

    return true

end


function Base.show(io::IO, b::BlockView)

    print(io, "("*string(b.block_rows)*"×"*string(b.block_cols)*") block view of a ("*string(sum(b.Nx))*"×"*string(sum(b.Ny))*") matrix\n\n")
   
    for i in 1:b.block_rows
        
        for j in 1:b.block_cols
            print(io, "("*string(b.Nx[i])*"×"*string(b.Ny[j])*") ")
        end
        
        i < b.block_rows ? print(io, "\n") : nothing

    end
       
end