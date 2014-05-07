# Perf

Test run:

```
λ mix run
Benchmark in progress...
  No autocompile and no caching
    total:        1.46 s (10 iterations)
    avg per call: 148.10 ms
    first call:   124.82 ms
Benchmark in progress...
  Autocompile but no caching
    total:        6.29 s (10 iterations)
    avg per call: 38.44 ms
    first call:   5947.93 ms
Benchmark in progress...
  Autocompile with precompilation but no caching
    total:        0.37 s (10 iterations)
    avg per call: 35.44 ms
    first call:   45.95 ms
```
