#!/usr/bin/env python3

# Detailed K-map analysis for manual minimization
# Missionary-Cannibal Logic Design Project

def print_detailed_kmap(minterms, output_name):
    """Create detailed K-map with minterm numbers for manual analysis"""
    print(f"\n{'='*60}")
    print(f"DETAILED K-MAP ANALYSIS: {output_name}")
    print(f"{'='*60}")
    
    # Create 5-variable K-map structure
    # Variables: M1, M0, C1, C0, D (where D is direction)
    print("\n5-Variable K-Map Structure:")
    print("Variables: M1 M0 C1 C0 D")
    print("Arrangement: M1M0 (rows) × C1C0D (columns)\n")
    
    # Initialize K-map with minterm numbers
    kmap_values = [[0 for _ in range(8)] for _ in range(4)]
    kmap_minterms = [[0 for _ in range(8)] for _ in range(4)]
    
    # Fill the K-map
    for minterm in range(32):
        m1 = (minterm >> 4) & 1
        m0 = (minterm >> 3) & 1
        c1 = (minterm >> 2) & 1
        c0 = (minterm >> 1) & 1
        d = minterm & 1
        
        row = (m1 << 1) | m0  # M1M0
        col = (c1 << 2) | (c0 << 1) | d  # C1C0D
        
        kmap_values[row][col] = 1 if minterm in minterms else 0
        kmap_minterms[row][col] = minterm
    
    # Print K-map with values
    print("K-Map with Values (1 = minterm included, 0 = not included):")
    print("      C1C0D:  000 001 010 011 100 101 110 111")
    print("M1M0")
    for i, row_label in enumerate(['00', '01', '10', '11']):
        print(f"{row_label}           ", end="")
        for j in range(8):
            print(f"  {kmap_values[i][j]} ", end="")
        print()
    
    # Print K-map with minterm numbers
    print("\nK-Map with Minterm Numbers:")
    print("      C1C0D:  000 001 010 011 100 101 110 111")
    print("M1M0")
    for i, row_label in enumerate(['00', '01', '10', '11']):
        print(f"{row_label}           ", end="")
        for j in range(8):
            print(f"{kmap_minterms[i][j]:2d} ", end="")
        print()
    
    # Print column headers for reference
    print("\nColumn Interpretations:")
    col_headers = [
        "000: C1'C0'D'", "001: C1'C0'D", "010: C1'C0D'", "011: C1'C0D",
        "100: C1C0'D'", "101: C1C0'D", "110: C1C0D'", "111: C1C0D"
    ]
    for i, header in enumerate(col_headers):
        print(f"  Col {i}: {header}")
    
    print("\nRow Interpretations:")
    row_headers = ["00: M1'M0'", "01: M1'M0", "10: M1M0'", "11: M1M0"]
    for i, header in enumerate(row_headers):
        print(f"  Row {i}: {header}")
    
    return kmap_values, kmap_minterms

def identify_groupings(kmap_values, output_name):
    """Identify potential groupings for minimization"""
    print(f"\n\nGROUPING ANALYSIS FOR {output_name}:")
    print("-" * 40)
    
    # Count 1's in the K-map
    total_ones = sum(sum(row) for row in kmap_values)
    print(f"Total 1's in K-map: {total_ones} out of 32")
    print(f"Percentage coverage: {total_ones/32*100:.1f}%")
    
    # Suggest grouping strategy
    if total_ones > 16:
        print("\nSUGGESTION: Use Product of Sums (POS) - minimize 0's")
        print("Consider using complement and De Morgan's laws")
    else:
        print("\nSUGGESTION: Use Sum of Products (SOP) - minimize 1's")
    
    # Look for obvious patterns
    print("\nPOTENTIAL GROUPINGS TO LOOK FOR:")
    print("- Adjacent 1's (horizontal, vertical)")
    print("- Rectangular groups of 2, 4, 8, 16")
    print("- Wraparound groups (edges of K-map)")
    print("- Corner groups (4 corners)")
    
    # Check for specific patterns
    print("\nPATTERN ANALYSIS:")
    
    # Check rows
    for i, row in enumerate(kmap_values):
        ones_count = sum(row)
        if ones_count >= 6:  # Most of row is 1
            print(f"- Row {i} has {ones_count}/8 ones - consider row-based grouping")
    
    # Check columns
    for j in range(8):
        col_ones = sum(kmap_values[i][j] for i in range(4))
        if col_ones >= 3:  # Most of column is 1
            print(f"- Column {j} has {col_ones}/4 ones - consider column-based grouping")

def suggest_minimization_steps(output_name):
    """Provide step-by-step minimization guidance"""
    print(f"\n\nMINIMIZATION STEPS FOR {output_name}:")
    print("=" * 50)
    print("1. IDENTIFY LARGEST GROUPS FIRST:")
    print("   - Look for groups of 16 (half the K-map)")
    print("   - Then groups of 8")
    print("   - Then groups of 4")
    print("   - Finally groups of 2")
    print("\n2. ENSURE ALL 1's ARE COVERED:")
    print("   - Each 1 must be in at least one group")
    print("   - Overlapping groups are allowed and often beneficial")
    print("\n3. WRITE BOOLEAN EXPRESSIONS:")
    print("   - Each group becomes a product term")
    print("   - Variables that change within a group are eliminated")
    print("   - Variables that stay constant become literals")
    print("\n4. COMBINE TERMS:")
    print("   - Final expression is sum of all product terms")
    print("   - Apply Boolean algebra for further simplification")

def main():
    print("MISSIONARY-CANNIBAL K-MAP MINIMIZATION ANALYSIS")
    print("=" * 80)
    
    # Minterm lists from original Verilog
    functions = {
        "MISSIONARY_NEXT[1]": [0,1,3,6,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,28,29,30,31],
        "MISSIONARY_NEXT[0]": [0,1,3,6,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31],
        "CANNIBAL_NEXT[1]": [0,1,2,3,4,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,28,30],
        "CANNIBAL_NEXT[0]": [0,1,3,4,6,7,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,27,28,30,31]
    }
    
    for output_name, minterms in functions.items():
        kmap_values, kmap_minterms = print_detailed_kmap(minterms, output_name)
        identify_groupings(kmap_values, output_name)
        suggest_minimization_steps(output_name)
        print("\n" + "="*80 + "\n")
    
    print("NEXT STEPS:")
    print("-" * 20)
    print("1. Manually identify groupings in each K-map")
    print("2. Write optimized Boolean expressions")
    print("3. Implement optimized Verilog code")
    print("4. Compare gate count and timing with original")
    print("5. Verify functionality with testbench")

if __name__ == "__main__":
    main()

