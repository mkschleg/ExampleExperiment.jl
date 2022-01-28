# ExampleExperiment


This is an example experiment for using Reproduce and julia as a way to conduct
machine learning experiments.


The example is simple. The source code for the experiment (i.e. shared code used by all experiments)
is found in `src/ExampleExperiment.jl`.  Some custom macro tools are also found in `macro_tools.jl` 
and these will likely be moved into reproduce or some other package eventually.

## How to use

Your way into the example is through the experiments folder in `experiments/TestExperiment.jl`. This contains
a module of the same name as the file. For ease of loading I recommend adding

```sh
export JULIA_LOAD_PATH="${PWD}/test/:${PWD}/experiments/:$JULIA_LOAD_PATH"
```

to your load path in an `.envrc`. I use `direnv` to manage the julia version and load path of all my julia projects.
You can also add these directories through adding the strings to `LOAD_PATH` in the julia repl.

```julia
push!(LOAD_PATH, new_path)
```

Next you will just want to import
```julia
import TestExperiment
```
which will import the module defined in `experiments/TestExperiment.jl`.

The module contains several functions. The first two obvious functions are `main_experiment` and `working_experiment`. 
`main_experiment` is what reproduce looks for to run the experiment. `working_experiment` is a helper function to more
quickly iterate.

The macro `@create_config_func` also creates several functions using the input code block as information. 
- `default_config()` returns a dictionary of the parameters you define in the code block (through the pairs). This documentation
  is constructed from the info strings, which are discarded when building the dictionary. These strings are markdown and will be 
  the documentation for the `default_config` function.
- `help()` displays the info string in the block.
- `create_toml_template(file=nothing; database=false)`: Create a toml template. If file is nothing return the toml string to the repl.
  If database is true this makes a config for database backend.

These functions help document decisions you make on your default config and make making TOMLs significantly easier. To see an example config
(that was generated but then edited) look in `configs\test_experiment.toml`.

## Testing

I use `ReTest` for my testing needs. I test for consistency in many of my experiments, but I still need to write this up 
in this repo.

