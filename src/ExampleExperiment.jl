module ExampleExperiment

# Learning Updates

struct QLearning
    γ::Float64
end

struct TD
    γ::Float64
end

struct NStepQLearning
    γ::Float64
    n::Int
end

struct NStepTDLearning
    γ::Float64
    n::Int
end

struct QLambda
    γ::Float64
    λ::Float64
end

struct TDLambda
    γ::Float64
    λ::Float64
end

macro create_lu_build_trait(lu_type, trait)
    fn = :lu_build_trait
    quote
        function $(esc(fn))(::Type{$lu_type})
            $trait()
        end
    end
end

lu_build_trait(lu) = @error "$(lu) not supported! Please implement `construct_rnn_layer`"

# Fun with constructors:
struct LUBuildVanilla end

@create_lu_build_trait QLearning LUBuildVanilla
@create_lu_build_trait TD LUBuildVanilla

struct LUBuildNStep end
# If there are a lot use a for loop
for lu in [NStepQLearning, NStepTDLearning]
    @eval begin
        @create_lu_build_trait $(lu) LUBuildNStep
    end
end

struct LUBuildTrace end

@create_lu_build_trait QLambda LUBuildTrace
@create_lu_build_trait TDLambda LUBuildTrace

"""
    construct_learning_update(config)

Construct the learning update. Types of constructors:
- LUBuildVanilla
- LUBuildNStep
- LUBuildTrace
"""
function construct_learning_update(config)
    lu = if isdefined(ExampleExperiment, Symbol(config["learning_update"]))
        getproperty(ExampleExperiment, Symbol(config["learning_update"]))
    else
        @error "Oh No! Learning Update not defined"
    end

    construct_learning_update(lu, config)
end

construct_learning_update(lu, config) =
    construct_learning_update(lu_build_trait(lu), lu, config)

function construct_learning_update(::LUBuildVanilla, lu, config)
    lu(config["gamma"])
end

function construct_learning_update(::LUBuildNStep, lu, config)
    lu(config["gamma"], config["nstep"])
end

function construct_learning_update(::LUBuildTrace, lu, config)
    lu(config["gamma"], config["lambda"])
end



# Macro Tools are for doing better configs.
include("macro_tools.jl")



end
