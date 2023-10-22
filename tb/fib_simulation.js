// Shows how the RISC CPU we designed calculates Fibonacci sequence
// Copy the code below and paste it into your browser console

function fibOutput(limit) {
    let F1 = 1; F2 = 0, temp = 0, cycle = 0;
    if (!Number.isInteger(limit) || limit <= 0) return 0;
    while (temp < limit) {
        console.log("----------------");
        console.log(`Cycle: ${cycle++}`);
        console.log(`Load F2: ${F2}`);
        temp = F2;
        console.log(`Update TEMP: ${temp}`);
        console.log(`Calculate F1(${F1}) + F2(${F2}): ${F1 + F2}`);
        F2 = F1 + F2;
        console.log(`Update F2: ${F2}`);
        console.log(`Load TEMP: ${temp}`);
        F1 = temp;
        console.log(`Update F1: ${F1}`);
        console.log(temp === limit ? `Reaching LIMIT (${limit})` : `Compare accumulator (${temp}) with LIMIT (${limit})`);
    }
}

fibOutput(144);

// ----------------
// Cycle: 0
// Load F2: 0
// Update TEMP: 0
// Calculate F1(1) + F2(0): 1
// Update F2: 1
// Load TEMP: 0
// Update F1: 0
// Compare accumulator (0) with LIMIT (144)
// ----------------
// Cycle: 1
// Load F2: 1
// Update TEMP: 1
// Calculate F1(0) + F2(1): 1
// Update F2: 1
// Load TEMP: 1
// Update F1: 1
// Compare accumulator (1) with LIMIT (144)
// ----------------
// Cycle: 2
// Load F2: 1
// Update TEMP: 1
// Calculate F1(1) + F2(1): 2
// Update F2: 2
// Load TEMP: 1
// Update F1: 1
// Compare accumulator (1) with LIMIT (144)
// ----------------
// Cycle: 3
// Load F2: 2
// Update TEMP: 2
// Calculate F1(1) + F2(2): 3
// Update F2: 3
// Load TEMP: 2
// Update F1: 2
// Compare accumulator (2) with LIMIT (144)
// ----------------
// Cycle: 4
// Load F2: 3
// Update TEMP: 3
// Calculate F1(2) + F2(3): 5
// Update F2: 5
// Load TEMP: 3
// Update F1: 3
// Compare accumulator (3) with LIMIT (144)
// ----------------
// Cycle: 5
// Load F2: 5
// Update TEMP: 5
// Calculate F1(3) + F2(5): 8
// Update F2: 8
// Load TEMP: 5
// Update F1: 5
// Compare accumulator (5) with LIMIT (144)
// ----------------
// Cycle: 6
// Load F2: 8
// Update TEMP: 8
// Calculate F1(5) + F2(8): 13
// Update F2: 13
// Load TEMP: 8
// Update F1: 8
// Compare accumulator (8) with LIMIT (144)
// ----------------
// Cycle: 7
// Load F2: 13
// Update TEMP: 13
// Calculate F1(8) + F2(13): 21
// Update F2: 21
// Load TEMP: 13
// Update F1: 13
// Compare accumulator (13) with LIMIT (144)
// ----------------
// Cycle: 8
// Load F2: 21
// Update TEMP: 21
// Calculate F1(13) + F2(21): 34
// Update F2: 34
// Load TEMP: 21
// Update F1: 21
// Compare accumulator (21) with LIMIT (144)
// ----------------
// Cycle: 9
// Load F2: 34
// Update TEMP: 34
// Calculate F1(21) + F2(34): 55
// Update F2: 55
// Load TEMP: 34
// Update F1: 34
// Compare accumulator (34) with LIMIT (144)
// ----------------
// Cycle: 10
// Load F2: 55
// Update TEMP: 55
// Calculate F1(34) + F2(55): 89
// Update F2: 89
// Load TEMP: 55
// Update F1: 55
// Compare accumulator (55) with LIMIT (144)
// ----------------
// Cycle: 11
// Load F2: 89
// Update TEMP: 89
// Calculate F1(55) + F2(89): 144
// Update F2: 144
// Load TEMP: 89
// Update F1: 89
// Compare accumulator (89) with LIMIT (144)
// ----------------
// Cycle: 12
// Load F2: 144
// Update TEMP: 144
// Calculate F1(89) + F2(144): 233
// Update F2: 233
// Load TEMP: 144
// Update F1: 144
// Reaching LIMIT (144)