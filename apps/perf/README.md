# Perf

Test run:

```
λ mix run

generating templates...done (total size 0.06 MB)

No autocompile and no caching...done
  total:        0.13 s (10 iterations)
  avg per call: 10.57 ms
  first call:   30.23 ms
Autocompile but no caching...done
  total:        0.59 s (10 iterations)
  avg per call: 3.83 ms
  first call:   553.03 ms
Autocompile with precompilation but no caching...done
  total:        0.04 s (10 iterations)
  avg per call: 3.61 ms
  first call:   3.28 ms

generating templates...done (total size 0.60 MB)

No autocompile and no caching...done
  total:        1.38 s (10 iterations)
  avg per call: 136.05 ms
  first call:   153.04 ms
Autocompile but no caching...done
  total:        6.44 s (10 iterations)
  avg per call: 35.04 ms
  first call:   6124.44 ms
Autocompile with precompilation but no caching...done
  total:        0.36 s (10 iterations)
  avg per call: 35.09 ms
  first call:   47.90 ms

generating templates...done (total size 1.20 MB)

No autocompile and no caching...done
  total:        3.22 s (10 iterations)
  avg per call: 321.51 ms
  first call:   322.85 ms
Autocompile but no caching...done
  total:        13.79 s (10 iterations)
  avg per call: 133.65 ms
  first call:   12587.91 ms
Autocompile with precompilation but no caching...done
  total:        1.35 s (10 iterations)
  avg per call: 133.44 ms
  first call:   145.77 ms
```
