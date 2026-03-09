#!/bin/bash
# Advanced cache performance test

set -e

echo "=========================================="
echo "Bazel Cache Performance Test"
echo "=========================================="

cleanup() {
    echo "Cleaning..."
    rm -rf /tmp/bazel-disk-cache
    bazel clean --expunge > /dev/null 2>&1
    pkill -f cache_server.py 2>/dev/null || true
}

measure_time() {
    local label="$1"
    shift
    echo "" >&2
    echo ">>> $label" >&2
    local start=$(date +%s.%N)
    "$@" > /dev/null 2>&1
    local end=$(date +%s.%N)
    local duration=$(echo "$end - $start" | bc -l)
    printf "Time: %.2f seconds\n" $duration >&2
    echo "$duration"
}

# Test 1: No cache baseline
echo ""
echo "=== Test 1: No Cache (Baseline) ==="
cleanup
time1=$(measure_time "First build (no cache)" bazel build //...)

# Test 2: Disk cache
echo ""
echo "=== Test 2: Disk Cache ==="
cleanup
time2=$(measure_time "First build (write to disk cache)" bazel build //... --disk_cache=/tmp/bazel-disk-cache)
bazel clean > /dev/null 2>&1
time3=$(measure_time "Second build (read from disk cache)" bazel build //... --disk_cache=/tmp/bazel-disk-cache)

speedup=$(echo "scale=2; $time1 / $time3" | bc -l)
echo ""
echo "Disk cache speedup: ${speedup}x"

# Test 3: HTTP cache
echo ""
echo "=== Test 3: HTTP Remote Cache ==="
echo "Starting HTTP cache server..."
python3 cache_server.py > /dev/null 2>&1 &
SERVER_PID=$!
sleep 2

cleanup
time4=$(measure_time "First build (write to HTTP cache)" bazel build //... --remote_cache=http://localhost:8080)
bazel clean > /dev/null 2>&1
time5=$(measure_time "Second build (read from HTTP cache)" bazel build //... --remote_cache=http://localhost:8080)

kill $SERVER_PID 2>/dev/null || true
speedup_http=$(echo "scale=2; $time1 / $time5" | bc -l)
echo "HTTP cache speedup: ${speedup_http}x"

# Summary
echo ""
echo "=========================================="
echo "Performance Summary"
echo "=========================================="
printf "No cache:          %.2f sec (baseline)\n" $time1
printf "Disk cache(write): %.2f sec\n" $time2
printf "Disk cache(read):  %.2f sec (%.1fx faster)\n" $time3 $speedup
printf "HTTP cache(write): %.2f sec\n" $time4
printf "HTTP cache(read):  %.2f sec (%.1fx faster)\n" $time5 $speedup_http
echo "=========================================="

cleanup
