using Pkg
Pkg.add("Dynare")

using Dynare

context = @dynare "dynare_model.mod"