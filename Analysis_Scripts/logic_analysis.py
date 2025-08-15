#!/usr/bin/env python3

# Complete logic analysis for the original missionary_cannibal.v file
# Generates truth table, K-maps, and optimized Boolean functions

import itertools
from collections import defaultdict

def generate_truth_table():
    """Generate complete truth table from the original Verilog implementation"""
    
    # Minterm lists from the original Verilog code
    missionary_next_0_minterms = [0,1,3,6,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31]
    missionary_next_1_minterms = [0,1,3,6,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,28,29,30,31]
    cannibal_next_1_minterms = [0,1,2,3,4,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,28,30]
    cannibal_next_0_minterms = [0,1,3,4,6,7,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,27,28,30,31]
    
    print("TRUTH TABLE FOR MISSIONARY-CANNIBAL PROBLEM")
    print("=" * 80)
    print(f"{'Minterm':<8} {'M1':<3} {'M0':<3} {'C1':<3} {'C0':<3} {'Dir':<3} | {'M_next[1]':<8} {'M_next[0]':<8} {'C_next[1]':<8} {'C_next[0]':<8}")
    print("-" * 80)
    
    truth_table = []
    
    for minterm in range(32):
        # Extract input bits: A[4:3] = missionary_curr, A[2:1] = cannibal_curr, A[0] = direction
        m1 = (minterm >> 4) & 1  # missionary_curr[1]
        m0 = (minterm >> 3) & 1  # missionary_curr[0]
        c1 = (minterm >> 2) & 1  # cannibal_curr[1]
        c0 = (minterm >> 1) & 1  # cannibal_curr[0]
        direction = minterm & 1
        
        # Calculate outputs based on minterm membership
        mn1 = 1 if minterm in missionary_next_1_minterms else 0
        mn0 = 1 if minterm in missionary_next_0_minterms else 0
        cn1 = 1 if minterm in cannibal_next_1_minterms else 0
        cn0 = 1 if minterm in cannibal_next_0_minterms else 0
        
        truth_table.append((minterm, m1, m0, c1, c0, direction, mn1, mn0, cn1, cn0))
        
        print(f"{minterm:<8} {m1:<3} {m0:<3} {c1:<3} {c0:<3} {direction:<3} | {mn1:<8} {mn0:<8} {cn1:<8} {cn0:<8}")
    
    return truth_table

def create_kmap_display(minterms, output_name):
    """Create a visual K-map display for 5-variable function"""
    print(f"\nK-MAP FOR {output_name}")
    print("=" * 50)
    print("5-variable K-map: M1 M0 C1 C0 Dir")
    print("Arranged as: M1M0\\C1C0Dir")
    print()
    
    # Create 5-variable K-map structure
    # We'll use a 4x8 arrangement: M1M0 (rows) x C1C0Dir (columns)
    kmap = [[0 for _ in range(8)] for _ in range(4)]
    
    # Fill the K-map
    for minterm in range(32):
        m1 = (minterm >> 4) & 1
        m0 = (minterm >> 3) & 1
        c1 = (minterm >> 2) & 1
        c0 = (minterm >> 1) & 1
        direction = minterm & 1
        
        row = (m1 << 1) | m0  # M1M0
        col = (c1 << 2) | (c0 << 1) | direction  # C1C0Dir
        
        kmap[row][col] = 1 if minterm in minterms else 0
    
    # Display the K-map
    print("     C1C0Dir: 000 001 010 011 100 101 110 111")
    print("M1M0")
    for i, row_label in enumerate(['00', '01', '10', '11']):
        print(f"{row_label}          ", end="")
        for j in range(8):
            print(f" {kmap[i][j]}  ", end="")
        print()
    
    # List the minterms
    print(f"\nMinterms for {output_name}: {sorted(minterms)}")
    print(f"Total minterms: {len(minterms)} out of 32")
    
    return kmap

def find_prime_implicants(minterms):
    """Find prime implicants using Quine-McCluskey method (simplified)"""
    # For demonstration, we'll identify some obvious groupings
    # This is a simplified version - full QM would be more complex
    
    print("\nPRIME IMPLICANT ANALYSIS:")
    print("-" * 30)
    
    # Convert minterms to binary representation for analysis
    binary_terms = []
    for m in minterms:
        binary = f"{m:05b}"
        binary_terms.append((m, binary))
    
    # Group by number of 1's (simplified approach)
    groups = defaultdict(list)
    for m, binary in binary_terms:
        ones_count = binary.count('1')
        groups[ones_count].append((m, binary))
    
    print("Minterms grouped by number of 1's:")
    for count in sorted(groups.keys()):
        print(f"  {count} ones: {[m for m, _ in groups[count]]}")
    
    return groups

def analyze_boolean_function(minterms, output_name):
    """Analyze and suggest Boolean function simplification"""
    print(f"\nBOOLEAN FUNCTION ANALYSIS FOR {output_name}")
    print("=" * 60)
    
    # Create K-map
    kmap = create_kmap_display(minterms, output_name)
    
    # Find prime implicants
    groups = find_prime_implicants(minterms)
    
    # Generate SOP expression (sum of minterms)
    sop_terms = []
    for m in sorted(minterms):
        # Convert minterm to product term
        m1 = 'M1' if (m >> 4) & 1 else "M1'"
        m0 = 'M0' if (m >> 3) & 1 else "M0'"
        c1 = 'C1' if (m >> 2) & 1 else "C1'"
        c0 = 'C0' if (m >> 1) & 1 else "C0'"
        d = 'D' if m & 1 else "D'"
        term = f"{m1}{m0}{c1}{c0}{d}"
        sop_terms.append(f"({term})")
    
    print(f"\nSum of Products (SOP) - Original:")
    print(f"{output_name} = ", end="")
    if len(sop_terms) <= 5:
        print(" + ".join(sop_terms))
    else:
        print(f"Sum of {len(sop_terms)} product terms")
        print("First 5 terms:", " + ".join(sop_terms[:5]), "+ ...")
    
    return kmap

def main():
    print("MISSIONARY-CANNIBAL LOGIC ANALYSIS")
    print("=" * 80)
    print("Based on original minterm implementation")
    print("Inputs: M1M0 (missionary_curr), C1C0 (cannibal_curr), D (direction)")
    print("Outputs: missionary_next[1:0], cannibal_next[1:0]")
    print()
    
    # Generate truth table
    truth_table = generate_truth_table()
    
    # Minterm lists from original Verilog
    missionary_next_0_minterms = [0,1,3,6,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31]
    missionary_next_1_minterms = [0,1,3,6,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,28,29,30,31]
    cannibal_next_1_minterms = [0,1,2,3,4,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,28,30]
    cannibal_next_0_minterms = [0,1,3,4,6,7,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,27,28,30,31]
    
    # Analyze each output
    functions = [
        (missionary_next_1_minterms, "MISSIONARY_NEXT[1]"),
        (missionary_next_0_minterms, "MISSIONARY_NEXT[0]"),
        (cannibal_next_1_minterms, "CANNIBAL_NEXT[1]"),
        (cannibal_next_0_minterms, "CANNIBAL_NEXT[0]")
    ]
    
    for minterms, name in functions:
        analyze_boolean_function(minterms, name)
        print("\n" + "="*80 + "\n")
    
    # Summary
    print("SUMMARY OF BOOLEAN FUNCTIONS (Original - Unoptimized)")
    print("=" * 60)
    print(f"MISSIONARY_NEXT[1] = Σm({','.join(map(str, missionary_next_1_minterms))})")
    print(f"MISSIONARY_NEXT[0] = Σm({','.join(map(str, missionary_next_0_minterms))})")
    print(f"CANNIBAL_NEXT[1] = Σm({','.join(map(str, cannibal_next_1_minterms))})")
    print(f"CANNIBAL_NEXT[0] = Σm({','.join(map(str, cannibal_next_0_minterms))})")
    print()
    print("Variables: M1, M0 (missionary_curr[1:0])")
    print("          C1, C0 (cannibal_curr[1:0])")
    print("          D (direction)")
    print()
    print("Next Step: Apply Karnaugh Map minimization to reduce gate count")
    print("and improve timing performance.")

if __name__ == "__main__":
    main()

