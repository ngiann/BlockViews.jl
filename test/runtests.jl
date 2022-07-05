using BlockViews
using BlockArrays
using Random
using Test


@testset "BlockViews.jl" begin
    
    len1, len2 = ceil(Int, rand()*10), ceil(Int, rand()*10)

    dimx = ceil.(Int, rand(len1)*10)

    dimy = ceil.(Int, rand(len2)*10)

    B = PseudoBlockArray{Float32}(undef, dimx, dimy)

    for x in 1:length(dimx)
        for y in 1:length(dimy)
            B[Block(x,y)] = randn(dimx[x], dimy[y])
        end
    end


    A = zeros(sum(dimx), sum(dimy))

    b = BlockView(dimx, dimy)


    for x in 1:length(dimx)
        for y in 1:length(dimy)
            for i in 1:dimx[x]
                for j in 1:dimy[y]
                    setelement!(A, b, (x, y), (i, j), B[BlockIndex((x, y), (i, j))])
                end
            end
        end
    end

    @test A == B

end
