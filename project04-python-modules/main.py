from helper import greet, calculate_sum

def main():
    print(greet("Bazel"))
    nums = [1, 2, 3, 4, 5]
    print(f"Sum of {nums} = {calculate_sum(nums)}")

if __name__ == "__main__":
    main()
