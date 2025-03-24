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
```

### Docker Container

You can run the container with the following command.

```bash
docker run -d -p 8000:8000 <image-name>:<tag>
```

Example:

```bash
docker run -p 9001:8000 benchmark:frankenphp
docker run -p 9002:8000 benchmark:swoole
docker run -p 9003:8000 benchmark:roadrunner
```

## Benchmark

I used [wrk](https://github.com/wg/wrk)
