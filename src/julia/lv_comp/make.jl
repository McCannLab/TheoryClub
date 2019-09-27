using Literate

function replace_includes(str)
    included = ["lv_model.jl", "lv_symbolic.jl"]
    path = @__DIR__

    for ex in included
        content = read(joinpath(path, ex), String)
        str = replace(str, "include(\"$(ex)\")" => content)
    end

    return str
end

Literate.markdown(joinpath(@__DIR__, "lv_comp.jl"), joinpath(@__DIR__, "docs/markdown/"), preprocess = replace_includes)
Literate.notebook(joinpath(@__DIR__, "lv_comp.jl"), joinpath(@__DIR__, "docs/notebook/"), preprocess = replace_includes)
