import sys

def main():
    name = sys.argv[1] if len(sys.argv) > 1 else "World"
    print(f"Hello from Python, {name}!")

if __name__ == "__main__":
    main()
