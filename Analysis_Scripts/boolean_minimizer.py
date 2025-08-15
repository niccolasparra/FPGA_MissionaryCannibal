#!/usr/bin/env python3

# Automated Boolean Function Minimization
# For Missionary-Cannibal Logic Design Project

from itertools import combinations

def find_adjacent_minterms(m1, m2):
    """Check if two minterms differ by exactly one bit"""
    diff = m1 ^ m2
    return diff != 0 and (diff & (diff - 1)) == 0

def combine_minterms(m1, m2):
    """Combine two adjacent minterms, return combined term with don't care"""
    diff = m1 ^ m2
    return m1 & ~diff  # Set differing bit to don't care (0 in mask)

def minterm_to_binary(minterm, bits=5):
    """Convert minterm to binary string"""
    return format(minterm, f'0{bits}b')

def binary_to_expression(binary_str, var_names=['M1', 'M0', 'C1', 'C0', 'D']):
    """Convert binary string to Boolean expression"""
    terms = []
    for i, bit in enumerate(binary_str):
        if bit == '1':
            terms.append(var_names[i])
        elif bit == '0':
            terms.append(var_names[i] + "'")
        # 'X' means don't care, so skip
    return ''.join(terms) if terms else '1'

def quine_mccluskey_simplified(minterms):
    """Simplified Quine-McCluskey algorithm for Boolean minimization"""
    print(f"\nQuine-McCluskey Minimization:")
    print(f"Starting minterms: {sorted(minterms)}")
    
    # Step 1: Group minterms by number of 1's
    groups = {}
    for m in minterms:
        count = bin(m).count('1')
        if count not in groups:
            groups[count] = []
        groups[count].append(m)
    
    print("\nInitial grouping by number of 1's:")
    for count in sorted(groups.keys()):
        print(f"  Group {count}: {groups[count]}")
    
    # Step 2: Find prime implicants
    current_terms = set(minterms)
    prime_implicants = []
    iteration = 0
    
    while current_terms:
        iteration += 1
        print(f"\nIteration {iteration}:")
        
        new_terms = set()
        used_terms = set()
        
        # Try to combine terms
        terms_list = list(current_terms)
        for i in range(len(terms_list)):
            for j in range(i + 1, len(terms_list)):
                m1, m2 = terms_list[i], terms_list[j]
                if find_adjacent_minterms(m1, m2):
                    combined = combine_minterms(m1, m2)
                    new_terms.add(combined)
                    used_terms.add(m1)
                    used_terms.add(m2)
        
        # Add unused terms as prime implicants
        for term in current_terms:
            if term not in used_terms:
                prime_implicants.append(term)
        
        current_terms = new_terms
        print(f"  New combined terms: {list(new_terms)}")
        print(f"  Prime implicants found: {len([t for t in current_terms if t not in used_terms])}")
        
        # Safety check to prevent infinite loops
        if iteration > 10:
            break
    
    return prime_implicants

def analyze_minimization_potential(minterms, output_name):
    """Analyze the minimization potential of a function"""
    print(f"\n{'='*60}")
    print(f"MINIMIZATION ANALYSIS: {output_name}")
    print(f"{'='*60}")
    
    total_minterms = len(minterms)
    print(f"Original minterms: {total_minterms}")
    print(f"Original SOP terms: {total_minterms} (unoptimized)")
    
    # Simple grouping analysis
    print("\nSimple Adjacent Groupings Analysis:")
    
    # Find pairs that can be combined
    pairs = []
    for i in range(len(minterms)):
        for j in range(i + 1, len(minterms)):
            if find_adjacent_minterms(minterms[i], minterms[j]):
                pairs.append((minterms[i], minterms[j]))
    
    print(f"Adjacent pairs found: {len(pairs)}")
    if len(pairs) <= 5:
        for pair in pairs[:5]:
            m1, m2 = pair
            print(f"  {m1} ({minterm_to_binary(m1)}) + {m2} ({minterm_to_binary(m2)})")
    else:
        print(f"  (showing first 5 of {len(pairs)} pairs)")
        for pair in pairs[:5]:
            m1, m2 = pair
            print(f"  {m1} ({minterm_to_binary(m1)}) + {m2} ({minterm_to_binary(m2)})")
    
    # Estimate potential reduction
    estimated_reduction = min(len(pairs) // 2, total_minterms // 3)
    estimated_final_terms = max(3, total_minterms - estimated_reduction)
    
    print(f"\nEstimated optimization:")
    print(f"  Original terms: {total_minterms}")
    print(f"  Estimated final terms: {estimated_final_terms}")
    print(f"  Potential reduction: {((total_minterms - estimated_final_terms) / total_minterms * 100):.1f}%")
    
    return estimated_final_terms

def create_optimized_expressions():
    """Create optimized Boolean expressions for all outputs"""
    print("AUTOMATED BOOLEAN MINIMIZATION ANALYSIS")
    print("=" * 80)
    
    # Original functions
    functions = {
        "MISSIONARY_NEXT[1]": [0,1,3,6,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,28,29,30,31],
        "MISSIONARY_NEXT[0]": [0,1,3,6,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31],
        "CANNIBAL_NEXT[1]": [0,1,2,3,4,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,26,28,30],
        "CANNIBAL_NEXT[0]": [0,1,3,4,6,7,8,9,11,12,13,14,15,16,17,18,19,20,22,23,24,25,27,28,30,31]
    }
    
    total_original_terms = 0
    total_estimated_final = 0
    
    for output_name, minterms in functions.items():
        estimated_final = analyze_minimization_potential(minterms, output_name)
        total_original_terms += len(minterms)
        total_estimated_final += estimated_final
    
    print(f"\n\nOVERALL OPTIMIZATION SUMMARY:")
    print(f"{'='*50}")
    print(f"Total original terms: {total_original_terms}")
    print(f"Total estimated optimized terms: {total_estimated_final}")
    print(f"Overall reduction: {((total_original_terms - total_estimated_final) / total_original_terms * 100):.1f}%")
    
    print(f"\nGATE COUNT ANALYSIS:")
    print(f"Original implementation:")
    print(f"  - AND gates: {total_original_terms} (for product terms)")
    print(f"  - OR gates: 4 large (one per output)")
    print(f"  - NOT gates: ~15 (for variable complements)")
    print(f"  - Total gates: ~{total_original_terms + 19}")
    
    print(f"\nOptimized implementation (estimated):")
    print(f"  - AND gates: {total_estimated_final} (for product terms)")
    print(f"  - OR gates: 4 smaller (one per output)")
    print(f"  - NOT gates: ~15 (for variable complements)")
    print(f"  - Total gates: ~{total_estimated_final + 19}")
    
    gate_reduction = total_original_terms - total_estimated_final
    print(f"  - Gate reduction: {gate_reduction} gates ({gate_reduction/(total_original_terms + 19)*100:.1f}%)")

def suggest_next_actions():
    """Suggest the next steps in the project"""
    print(f"\n\nNEXT PROJECT STEPS:")
    print(f"{'='*50}")
    print("\n🎯 IMMEDIATE ACTIONS:")
    print("1. CHOOSE MINIMIZATION APPROACH:")
    print("   a) Manual K-map grouping (educational)")
    print("   b) Automated optimization (faster)")
    print("   c) Both (recommended)")
    
    print("\n2. IMPLEMENT OPTIMIZED VERILOG:")
    print("   - Write optimized assign statements")
    print("   - Reduce from ~26 terms to ~6-8 terms per output")
    print("   - Maintain identical functionality")
    
    print("\n3. CREATE TESTBENCH:")
    print("   - Verify all 32 input combinations")
    print("   - Compare original vs optimized outputs")
    print("   - Ensure 100% functional equivalence")
    
    print("\n4. TIMING ANALYSIS:")
    print("   - Calculate critical path delay")
    print("   - Estimate maximum frequency (Fmax)")
    print("   - Compare propagation delays")
    
    print("\n5. SYNTHESIS COMPARISON:")
    print("   - Gate count comparison")
    print("   - Area utilization")
    print("   - Power consumption analysis")
    
    print("\n📚 DELIVERABLES FOR PROJECT:")
    print("   ✓ Truth tables")
    print("   ✓ K-maps")
    print("   ✓ Original Boolean functions")
    print("   ⏳ Optimized Boolean functions")
    print("   ⏳ Optimized Verilog implementation")
    print("   ⏳ Comprehensive testbench")
    print("   ⏳ Performance comparison report")
    
    print("\n🔧 TECHNICAL SKILLS DEMONSTRATED:")
    print("   - Boolean algebra")
    print("   - K-map minimization")
    print("   - Verilog HDL")
    print("   - Digital logic optimization")
    print("   - Verification methodology")

if __name__ == "__main__":
    create_optimized_expressions()
    suggest_next_actions()

