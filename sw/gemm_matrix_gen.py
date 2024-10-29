import random

# CHANGE DIRECTORY FOR YOUR SETUP
directory = "sw\\matrix_vals"

# Set Matrix Dimentions
m = 4;
n = 4;

# Initialize matrix dimensions
A_matrix = [[None] * m for _ in range(n)]
B_matrix = [[None] * m for _ in range(n)]
C_matrix = [[None] * m for _ in range(n)]

# Generates random values of matrix to give unique GEMM results
def matrix_gen(m,n,matrix):
    
    for i in range(m):
        for j in range(n):
            value = random.uniform(1, 25)
            formatted_val = "{:.1f}".format(value)
            matrix[i][j] = formatted_val

# Writes unqiue matrix values for A, B, and C matrix
def write_matrix_to_file(matrix, file_name):
    
    file_path = f"{directory}/{file_name}"
    
    with open(file_path, "w") as file:
        for i in range(m):
            for j in range(n):
                file.write(matrix[i][j] + " ")
            file.write("\n")

# Create A, B and C matrix            
matrix_gen(m, n, A_matrix)
matrix_gen(m, n, B_matrix)
matrix_gen(m, n, C_matrix)

# Write A, B and C matrix to files
write_matrix_to_file(A_matrix, "A_Matrix.txt")
write_matrix_to_file(B_matrix, "B_Matrix.txt")
write_matrix_to_file(C_matrix, "C_Matrix.txt")

print("Completed Randomized Matrix Generation")
