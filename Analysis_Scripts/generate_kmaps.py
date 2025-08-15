#!/usr/bin/env python3

# Generate correct K-maps for the Missionary-Cannibal State Machine
# This will give you the actual Boolean expressions for the flip-flops

def print_kmap(minterms, title, variables=['Q3', 'Q2', 'Q1', 'Q0']):
    """Print a K-map for 4 variables with the given minterms"""
    print(f"\n{title}")
    print("=" * len(title))
    
    # Create 4x4 K-map
    kmap = [[0 for _ in range(4)] for _ in range(4)]
    
    # Fill K-map based on minterms
    for minterm in range(16):
        q3 = (minterm >> 3) & 1
        q2 = (minterm >> 2) & 1
        q1 = (minterm >> 1) & 1
        q0 = minterm & 1
        
        # Map to K-map position (Gray code ordering)
        row = (q3 << 1) | q2  # Q3Q2
        col_map = [0, 1, 3, 2]  # Gray code: 00,01,11,10
        col = col_map[(q1 << 1) | q0]  # Q1Q0 in Gray code
        
        kmap[row][col] = 1 if minterm in minterms else 0
    
    # Print K-map
    print("      Q1Q0:  00  01  11  10")
    print("    Q3Q2")
    row_labels = ['00', '01', '11', '10']
    for i, label in enumerate(row_labels):
        print(f"    {label}    ", end="")
        for j in range(4):
            print(f" {kmap[i][j]}  ", end="")
        print()
    
    print(f"\nMinterms: {sorted(minterms)}")
    return kmap

def analyze_state_machine():
    """Analyze the state machine and generate K-maps for each flip-flop"""
    
    print("MISSIONARY-CANNIBAL STATE MACHINE ANALYSIS")
    print("=" * 50)
    
    # Define state transitions based on our design
    state_transitions = {
        0:  1,   # S0 (0000) -> S1 (0001)
        1:  2,   # S1 (0001) -> S2 (0010)
        2:  3,   # S2 (0010) -> S3 (0011)
        3:  4,   # S3 (0011) -> S4 (0100)
        4:  5,   # S4 (0100) -> S5 (0101)
        5:  6,   # S5 (0101) -> S6 (0110)
        6:  7,   # S6 (0110) -> S7 (0111)
        7:  8,   # S7 (0111) -> S8 (1000)
        8:  9,   # S8 (1000) -> S9 (1001)
        9:  10,  # S9 (1001) -> S10 (1010)
        10: 11,  # S10 (1010) -> S11 (1011)
        11: 0,   # S11 (1011) -> S0 (0000) - Auto restart
        # Unused states go to 0
        12: 0, 13: 0, 14: 0, 15: 0
    }
    
    # Generate minterms for each flip-flop
    q3_minterms = []
    q2_minterms = []
    q1_minterms = []
    q0_minterms = []
    
    for current_state in range(16):
        next_state = state_transitions[current_state]
        
        # Extract next state bits
        q3_next = (next_state >> 3) & 1
        q2_next = (next_state >> 2) & 1
        q1_next = (next_state >> 1) & 1
        q0_next = next_state & 1
        
        # Add to minterm lists if the next state bit is 1
        if q3_next: q3_minterms.append(current_state)
        if q2_next: q2_minterms.append(current_state)
        if q1_next: q1_minterms.append(current_state)
        if q0_next: q0_minterms.append(current_state)
    
    # Print state transition table
    print("\nSTATE TRANSITION TABLE:")
    print("Current State | Next State | Binary")
    print("------------- | ---------- | --------")
    for i in range(12):  # Only valid states
        current = i
        next_st = state_transitions[i]
        print(f"S{current:2d} ({current:04b}) | S{next_st:2d} ({next_st:04b}) | {current:04b} -> {next_st:04b}")
    
    # Generate K-maps
    print_kmap(q3_minterms, "K-MAP FOR Q3+ (Next State of MSB)")
    print_kmap(q2_minterms, "K-MAP FOR Q2+ (Next State of Q2)")
    print_kmap(q1_minterms, "K-MAP FOR Q1+ (Next State of Q1)")
    print_kmap(q0_minterms, "K-MAP FOR Q0+ (Next State of LSB)")
    
    # Generate Boolean expressions (simplified)
    print("\n" + "=" * 50)
    print("BOOLEAN EXPRESSIONS FOR FLIP-FLOP INPUTS:")
    print("=" * 50)
    
    print(f"\nQ3+ minterms: {q3_minterms}")
    print("Q3+ = Q3'Q2Q1Q0 + Q3Q2'Q1' + Q3Q2'Q1Q0' + Q3Q2'Q1Q0")
    print("Simplified: Q3+ = Q3'Q2Q1Q0 + Q3Q2'(Q1' + Q1Q0' + Q1Q0)")
    print("Final: Q3+ = Q3'Q2Q1Q0 + Q3Q2'")
    
    print(f"\nQ2+ minterms: {q2_minterms}")
    print("Q2+ = Q3'Q2'Q1Q0 + Q3'Q2Q1'Q0' + Q3'Q2Q1Q0' + Q3'Q2Q1Q0")
    print("Simplified: Q2+ = Q3'Q2'Q1Q0 + Q3'Q2Q1'")
    
    print(f"\nQ1+ minterms: {q1_minterms}")
    print("Q1+ = Q3'Q2'Q1'Q0 + Q3'Q2'Q1Q0' + Q3'Q2Q1'Q0 + Q3'Q2Q1Q0' + Q3Q2'Q1' + Q3Q2'Q1Q0'")
    
    print(f"\nQ0+ minterms: {q0_minterms}")
    print("Q0+ = Q3'Q2'Q1'Q0' + Q3'Q2'Q1Q0 + Q3'Q2Q1'Q0 + Q3'Q2Q1Q0 + Q3Q2'Q1'Q0 + Q3Q2'Q1Q0")
    print("Simplified: Q0+ = Q0' (alternating pattern)")
    
    # Output logic analysis
    print("\n" + "=" * 50)
    print("OUTPUT LOGIC (MOORE MACHINE):")
    print("=" * 50)
    
    # Define outputs for each state
    outputs = {
        0:  (3, 3, 0),  # S0: M=3, C=3, F=0
        1:  (3, 1, 0),  # S1: M=3, C=1, F=0
        2:  (3, 2, 0),  # S2: M=3, C=2, F=0
        3:  (3, 0, 0),  # S3: M=3, C=0, F=0
        4:  (3, 1, 0),  # S4: M=3, C=1, F=0
        5:  (1, 1, 0),  # S5: M=1, C=1, F=0
        6:  (2, 2, 0),  # S6: M=2, C=2, F=0
        7:  (0, 2, 0),  # S7: M=0, C=2, F=0
        8:  (0, 3, 0),  # S8: M=0, C=3, F=0
        9:  (0, 1, 0),  # S9: M=0, C=1, F=0
        10: (0, 2, 0),  # S10: M=0, C=2, F=0
        11: (0, 0, 1),  # S11: M=0, C=0, F=1 (FINISHED!)
    }
    
    print("\nOUTPUT TABLE:")
    print("State | Q3Q2Q1Q0 | M1M0 | C1C0 | F")
    print("------|----------|------|------|---")
    for state in range(12):
        m, c, f = outputs[state]
        m_binary = format(m, '02b')
        c_binary = format(c, '02b')
        state_binary = format(state, '04b')
        print(f"S{state:2d}   | {state_binary}     | {m_binary}   | {c_binary}   | {f}")
    
if __name__ == "__main__":
    analyze_state_machine()

