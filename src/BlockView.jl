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

    #############################
    # Check validity of indices #
    #############################

    @assert(x >= 1)
    @assert(x <= b.block_rows)

    @assert(y >= 1)
    @assert(y <= b.block_cols)

    if i < 1
        error("i must be positive integer, but i is $i")
    end

    if j < 1
        error("j must be positive integer, but j is $j")
    end

    if i > b.Nx[x]
        error("$i exceeds size of ($x, $y)-th block matrix of size " * string(b.Nx[x]) * "×" * string(b.Ny[y]))
    end

    if j > b.Ny[y]
        error("$j exceeds size of ($x, $y)-th block matrix of size " * string(b.Nx[x]) * "×" * string(b.Ny[y]))
    end

    ################
    # Assign value #
    ################

    @views startx = x == 1 ? 0 : sum(b.Nx[1:x-1])
    @views starty = y == 1 ? 0 : sum(b.Ny[1:y-1])

    A[startx + i, starty + j] = val

    nothing

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