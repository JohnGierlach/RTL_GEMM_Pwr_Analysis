#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

using namespace std;

int iteration_count = 0;

// GEMM Function: C = alpha * A * B + beta * C
void gemm(int m, int n, int k, 
          double alpha, const vector<vector<double>>& A, 
          const vector<vector<double>>& B, 
          double beta, vector<vector<double>>& C) {
    
    // Ensure C is the correct size
    C.resize(m, vector<double>(n, 0.0));
    
    // Perform GEMM operation
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            double sum = 0.0;
            for (int p = 0; p < k; p++) {
                sum += A[i][p] * B[p][j];
                iteration_count++;
            }
            C[i][j] = alpha * sum + beta * C[i][j];
        }
    }

    cout << "Total iterations: " << iteration_count << endl;
}


vector<vector<double>> get_matrix_from_file(string filename){

    ifstream file(filename);
    vector<vector<double>> matrix;
    string line;

    // Check if the file is open
    if (!file.is_open()) {
        cerr << "Error: Could not open the file." << endl;
        //return 1; // Return an error code
    }

    // Read the file line by line
    while (getline(file, line)) {
        vector<double> curr_row; // Temporary vector to store the current row
        stringstream ss(line); // Create a string stream from the line
        double value;

        // Read each space-separated value from the line
        while (ss >> value) {
            curr_row.push_back(value); // Add value to the current row
        }

        matrix.push_back(curr_row); // Add the row to the matrix
    }

    file.close();
    return matrix;
}

void write_matrix_to_file(vector<vector<double>> matrix){
    
    string filename = "C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/Result_Matrix.txt";

    ofstream outfile(filename);

    // Check if the file was successfully opened
    if (!outfile.is_open()) {
        cerr << "Error: Could not open file " << filename << " for writing." << endl;
        return;
    }

    // Write each element of the matrix to the file
    for (const auto& row : matrix) {
        for (size_t j = 0; j < row.size(); ++j) {
            outfile << row[j];
            if (j < row.size() - 1) {
                outfile << " ";  // Separate elements with a space
            }
        }
        outfile << "\n";  // New line after each row
    }

    outfile.close(); // Close the file
    cout << "Matrix written to " << filename << endl;

}


int main() {
    // Hardcoded k values and corresponding folders
    vector<int> k_values = {4, 8, 32};
    for (int k : k_values) {
        string folder = "C:/Users/JohnG/Desktop/Codes/Projects/RTL_GEMM_Pwr_Consumption/RTL_GEMM_Pwr_Analysis/sw/matrix_vals/matrix_vals_k" + to_string(k);
        string A_mat_filename = folder + "/A_Matrix.txt";
        string B_mat_filename = folder + "/B_Matrix.txt";
        string C_mat_filename = folder + "/C_Matrix.txt";

        vector<vector<double>> A = get_matrix_from_file(A_mat_filename);
        vector<vector<double>> B = get_matrix_from_file(B_mat_filename);
        vector<vector<double>> C = get_matrix_from_file(C_mat_filename);

        int m = A.size();
        int n = B[0].size();
        double alpha = 1.0, beta = 1.0;

        gemm(m, n, k, alpha, A, B, beta, C);

        // Write result to a file in the same folder
        string result_filename = folder + "/Result_Matrix.txt";
        ofstream outfile(result_filename);
        if (!outfile.is_open()) {
            cerr << "Error: Could not open file " << result_filename << " for writing." << endl;
            continue;
        }
        for (const auto& row : C) {
            for (size_t j = 0; j < row.size(); ++j) {
                outfile << row[j];
                if (j < row.size() - 1) outfile << " ";
            }
            outfile << "\n";
        }
        outfile.close();
        cout << "Matrix written to " << result_filename << endl;
    }
    return 0;
}
