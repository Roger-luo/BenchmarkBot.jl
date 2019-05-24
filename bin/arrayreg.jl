using BenchmarkBot

runbenchmarks(
    package="YaoArrayRegister",
    target=BenchmarkConfig(
        id="origin/multithreading",
        env = Dict("JULIA_NUM_THREADS"=>4),
        juliacmd=`julia -O3`
    )
    baseline=BenchmarkConfig(
        id="master",
        env = Dict("JULIA_NUM_THREADS"=>1),
        juliacmd=`julia -O3`
    )
)

runbenchmarks(
    package="YaoArrayRegister",
    target=BenchmarkConfig(
        id="origin/multithreading",
        env = Dict("JULIA_NUM_THREADS"=>1),
        juliacmd=`julia -O3`
    )
    baseline=BenchmarkConfig(
        id="master",
        env = Dict("JULIA_NUM_THREADS"=>1),
        juliacmd=`julia -O3`
    )
)
