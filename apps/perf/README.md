# Perf

## Test runs

These results are preliminary. Compilation of templates may be optimized in the
future. This also doesn't show the memory usage during compilation (which
happens to be quite significant).

### Template sizes

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

### Autocompiled layout vs predefined layout

```
## render_view tests ##
generating templates...done (total size 0.60 MB)

No autocompile and no caching...done
  total:        1.42 s (10 iterations)
  avg per call: 137.33 ms
  first call:   181.72 ms
Autocompile but no caching...done
  total:        6.58 s (10 iterations)
  avg per call: 37.82 ms
  first call:   6237.45 ms
Autocompile with precompilation but no caching...done
  total:        0.35 s (10 iterations)
  avg per call: 34.44 ms
  first call:   42.24 ms

## define_layout tests ##
generating templates...done (total size 0.55 MB)

No autocompile and no caching...done
  total:        1.34 s (10 iterations)
  avg per call: 131.49 ms
  first call:   158.37 ms
Autocompile with precompilation but no caching...done
  total:        0.27 s (10 iterations)
  avg per call: 26.50 ms
  first call:   30.92 ms
Defining layout...done
  total:        7.90 s (10 iterations)
  avg per call: 0.01 ms
  first call:   7899.47 ms
No autocompile with layout...done
  total:        0.17 s (10 iterations)
  avg per call: 10.12 ms
  first call:   82.10 ms
```

### Precompiled layout

```
## compiled_layout tests ##
(total template size 0.55 MB)

Basic render_view, no autocompile and no caching...done
  total:        1.45 s (10 iterations)
  avg per call: 135.01 ms
  first call:   233.75 ms
Predefined layout, no autocompile and no caching...done
  total:        8.16 s (10 iterations)
  avg per call: 11.66 ms
  first call:   8050.75 ms
Precompiled layout, no autocompile and no caching...done
  total:        0.11 s (10 iterations)
  avg per call: 11.04 ms
  first call:   11.90 ms
Precompiled layout, no autocompile and no caching (using Layouts.render)...done
  total:        0.11 s (10 iterations)
  avg per call: 10.67 ms
  first call:   10.26 ms
Precompiled layout, no autocompile and no caching (using single module)...done
  total:        0.10 s (10 iterations)
  avg per call: 9.51 ms
  first call:   9.39 ms
```

### Compiled views

```
## compiled_view tests ##
(total template size 1.20 MB)

Basic render_view(basic_view), no autocompile and no caching...done
  total:        1.83 s (10 iterations)
  avg per call: 182.03 ms
  first call:   195.29 ms
Precompiled basic_view, no caching...done
  total:        0.00 s (10 iterations)
  avg per call: 0.09 ms
  first call:   0.16 ms
Basic render_view(nested_view), no autocompile and no caching...done
  total:        1.87 s (10 iterations)
  avg per call: 185.81 ms
  first call:   196.96 ms
Precompiled nested_view, no caching...done
  total:        0.01 s (10 iterations)
  avg per call: 0.29 ms
  first call:   4.03 ms
Precompiled nested_view, no caching (using single module)...done
  total:        0.00 s (10 iterations)
  avg per call: 0.18 ms
  first call:   0.27 ms
```
