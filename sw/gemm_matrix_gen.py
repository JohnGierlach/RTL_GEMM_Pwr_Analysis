import random
import os

# CHANGE DIRECTORY FOR YOUR SETUP
directory = "sw\\matrix_vals"

# Directory will be named matrix_vals_k#
def get_directory(k):
    dir_name = f"sw/matrix_vals/matrix_vals_k{k}"
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)
    return dir_name
# Set Matrix Dimensions
m = 4
n = 4

def select_k(size):
    if size == "small":
        return 4
    elif size == "medium":
        return 8
    elif size == "large":
        return 32
    else:
        return 4  # default

k = select_k("small")  # Change to "small", "medium", or "large"

# Set output directory
directory = get_directory(k)

# Initialize matrices
A_matrix = [[None] * k for i in range(m)]      # m x k
B_matrix = [[None] * n for i in range(k)]      # k x n
C_matrix = [[None] * n for i in range(m)]      # m x n

def matrix_gen(rows, cols, matrix):
    for i in range(rows):
        for j in range(cols):
            value = random.randint(1, 25)
            matrix[i][j] = str(value)

def write_matrix_to_file(matrix, file_name):
    file_path = f"{directory}/{file_name}"
    with open(file_path, "w") as file:
        for row in matrix:
            file.write(" ".join(row) + "\n")

# Generate matrices
matrix_gen(m, k, A_matrix)
matrix_gen(k, n, B_matrix)
matrix_gen(m, n, C_matrix)

# Write matrices to files
write_matrix_to_file(A_matrix, "A_Matrix.txt")
write_matrix_to_file(B_matrix, "B_Matrix.txt")
write_matrix_to_file(C_matrix, "C_Matrix.txt")

print(f"Completed Randomized Matrix Generation with k={k}")