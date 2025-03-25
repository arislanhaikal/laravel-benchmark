The original test is from [thecaliskan/laravel-benchmark](https://github.com/thecaliskan/laravel-benchmark)
I only modified the test to new version to run on VPS and added the results to the table.

## Testing Endpoint

```bash
http://yourdomain.com/api/health-check
http://yourdomain.com/api/static
http://yourdomain.com/api/random
http://yourdomain.com/api/http-request
```

## Docker Build

The Dockerfile is included in the repository. You can build the image and run the container with the following commands.
Dockerfile originally from [exaco/laravel-octane-dockerfile](https://github.com/exaco/laravel-octane-dockerfile)

```bash
docker build -t <image-name>:<tag> -f <your-octane-driver>.Dockerfile .
```

Example:

```bash
docker build -t benchmark:frankenphp -f FrankenPHP.Alpine.Dockerfile .
docker build -t benchmark:swoole -f Swoole.Alpine.Dockerfile .
docker build -t benchmark:roadrunner -f RoadRunner.Alpine.Dockerfile .
docker build -t benchmark:basic -f Basic.Alpine.Dockerfile .
```

### Docker Container

You can run the container with the following command.

```bash
docker run -d -p 8000:8000 <image-name>:<tag>
```

Example:

```bash
docker run --name frankenphp -p 9001:8000 benchmark:frankenphp
docker run --name swoole -p 9002:8000 benchmark:swoole
docker run --name roadrunner -p 9003:8000 benchmark:roadrunner
docker run --name basic -p 9004:8000 benchmark:basic
```

## Benchmark

I used [wrk](https://github.com/wg/wrk) to test the endpoints. You can install it.
This testing with 2 threads and 100 connections.

```bash
wrk -c100 http://yourdomain.com/api/health-check/
wrk -c100 http://yourdomain.com/api/static/
wrk -c100 http://yourdomain.com/api/random/
wrk -c100 http://yourdomain.com/api/http-request/
```

## Testing Results

### Hardware

I used a VPS from [Nevacloud](https://nevacloud.com) with the following hardware.

-   3 vCPU
-   4 GB RAM
-   60 GB NVMe SSD

### Results (Requests per Second)

#### Average Results

| Server     | Health Check | Static | Random | HTTP Request |
| ---------- | ------------ | ------ | ------ | ------------ |
| FrankenPHP | 799.09       | 859.94 | 65.97  | 4.32         |
| Swoole     | 887.84       | 918.95 | 67.01  | 2.18         |
| RoadRunner | 237.63       | 249.02 | 67.82  | 5.70         |
| Basic      | 126.47       | 129.21 | 26.85  | 0.79         |

-   The results are based on the test environment. You can test your own environment and compare the results.

## Summary

This benchmark compares the performance of different Laravel Octane drivers (FrankenPHP, Swoole, RoadRunner, and Basic) under various endpoints. The tests were conducted on a VPS with 3 vCPUs, 4 GB RAM, and 60 GB NVMe SSD using `wrk` with 2 threads and 100 connections.

### Key Observations:

-   **FrankenPHP** and **Swoole** performed the best overall, with Swoole slightly outperforming FrankenPHP in most cases.
-   **RoadRunner** showed moderate performance, especially in the "Random" and "HTTP Request" endpoints.
-   **Basic** driver had the lowest performance across all endpoints, particularly struggling with "HTTP Request."

These results highlight the significant performance benefits of using optimized drivers like FrankenPHP or Swoole for high-concurrency scenarios.
