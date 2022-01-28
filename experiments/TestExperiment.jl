module TestExperiment

import Reproduce: Reproduce, experiment_wrapper
import ExampleExperiment: ExampleExperiment, Macros
import .Macros:  @generate_config_funcs, @info_str
import Random
import ProgressMeter: ProgressMeter, Progress

@generate_config_funcs begin

    info"""
    ## Document your config!
    - `seed::Int`: Seed of RNG.
    """
    "seed" => 1
    "steps" => 50


    info"""
    ## Agent params
    - `learning_update::String`: The update function.
    More params can be found with [`construct_learning_update`](@ref)

    """
    "learning_update" => "QLearning"
    "gamma" => 0.9
    
end

function main_experiment(config; progress=false, testing=false)
    Reproduce.experiment_wrapper(config; use_git_info=false, testing=testing) do config

        Random.seed!(config["seed"])

        results = zeros(config["steps"])
        lu = ExampleExperiment.construct_learning_update(config)

        prg_bar = Progress(config["steps"], desc="MyProgBar")
        for i in 1:config["steps"]
            results[i] = rand()
            sleep(0.1)
            if progress
                ProgressMeter.next!(prg_bar)
            end
        end

        results = (rews=rand(config["steps"]))
        (;save_results=results, learning_update=lu)
    end
end

function working_experiment(; kwargs...)

    config = default_config()
    for (k, v) in kwargs
        config[string(k)] = v
    end

    main_experiment(config; progress=true, testing=true)
end

end
