import cocotb
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
import random

# ALU operation codes (these should match your ALU implementation)
ALU_ADD = 0b0000
ALU_SUB = 0b0001
ALU_AND = 0b0010
ALU_OR  = 0b0011
ALU_XOR = 0b0100
ALU_SLL = 0b0101
ALU_SRL = 0b0110
ALU_SRA = 0b0111

@cocotb.test()
async def test_alu_add(dut):
    """Test ALU addition operation"""
    dut.op.value = ALU_ADD
    dut.a.value = 15
    dut.b.value = 10
    
    await Timer(1, units='ns')
    
    expected = 25
    assert dut.result.value == expected, f"ADD failed: {dut.a.value} + {dut.b.value} = {dut.result.value}, expected {expected}"

@cocotb.test()
async def test_alu_sub(dut):
    """Test ALU subtraction operation"""
    dut.op.value = ALU_SUB
    dut.a.value = 20
    dut.b.value = 8
    
    await Timer(1, units='ns')
    
    expected = 12
    assert dut.result.value == expected, f"SUB failed: {dut.a.value} - {dut.b.value} = {dut.result.value}, expected {expected}"

@cocotb.test()
async def test_alu_and(dut):
    """Test ALU AND operation"""
    dut.op.value = ALU_AND
    dut.a.value = 0b1111
    dut.b.value = 0b1010
    
    await Timer(1, units='ns')
    
    expected = 0b1010
    assert dut.result.value == expected, f"AND failed: {dut.a.value:04b} & {dut.b.value:04b} = {dut.result.value:04b}, expected {expected:04b}"

@cocotb.test()
async def test_alu_or(dut):
    """Test ALU OR operation"""
    dut.op.value = ALU_OR
    dut.a.value = 0b1100
    dut.b.value = 0b1010
    
    await Timer(1, units='ns')
    
    expected = 0b1110
    assert dut.result.value == expected, f"OR failed: {dut.a.value:04b} | {dut.b.value:04b} = {dut.result.value:04b}, expected {expected:04b}"

@cocotb.test()
async def test_alu_xor(dut):
    """Test ALU XOR operation"""
    dut.op.value = ALU_XOR
    dut.a.value = 0b1100
    dut.b.value = 0b1010
    
    await Timer(1, units='ns')
    
    expected = 0b0110
    assert dut.result.value == expected, f"XOR failed: {dut.a.value:04b} ^ {dut.b.value:04b} = {dut.result.value:04b}, expected {expected:04b}"

@cocotb.test()
async def test_alu_shift_left(dut):
    """Test ALU shift left operation"""
    dut.op.value = ALU_SLL
    dut.a.value = 0b0001
    dut.b.value = 2
    
    await Timer(1, units='ns')
    
    expected = 0b0100
    assert dut.result.value == expected, f"SLL failed: {dut.a.value:04b} << {dut.b.value} = {dut.result.value:04b}, expected {expected:04b}"

@cocotb.test()
async def test_alu_shift_right_logical(dut):
    """Test ALU shift right logical operation"""
    dut.op.value = ALU_SRL
    dut.a.value = 0b1000
    dut.b.value = 2
    
    await Timer(1, units='ns')
    
    expected = 0b0010
    assert dut.result.value == expected, f"SRL failed: {dut.a.value:04b} >> {dut.b.value} = {dut.result.value:04b}, expected {expected:04b}"

@cocotb.test()
async def test_alu_overflow(dut):
    """Test ALU overflow conditions"""
    dut.op.value = ALU_ADD
    dut.a.value = 0xFFFFFFFF  # Max 32-bit value
    dut.b.value = 1
    
    await Timer(1, units='ns')
    
    # Check if overflow is handled correctly
    # This depends on your ALU implementation
    cocotb.log.info(f"Overflow test: {dut.a.value} + {dut.b.value} = {dut.result.value}")

@cocotb.test()
async def test_alu_random(dut):
    """Test ALU with random inputs"""
    operations = [ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR]
    
    for _ in range(100):  # Run 100 random tests
        op = random.choice(operations)
        a = random.randint(0, 0xFFFF)  # 16-bit random values
        b = random.randint(0, 0xFFFF)
        
        dut.op.value = op
        dut.a.value = a
        dut.b.value = b
        
        await Timer(1, units='ns')
        
        # Calculate expected result based on operation
        if op == ALU_ADD:
            expected = (a + b) & 0xFFFFFFFF  # Mask to 32-bit
        elif op == ALU_SUB:
            expected = (a - b) & 0xFFFFFFFF
        elif op == ALU_AND:
            expected = a & b
        elif op == ALU_OR:
            expected = a | b
        elif op == ALU_XOR:
            expected = a ^ b
        
        if op in [ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR]:
            assert dut.result.value == expected, f"Random test failed: op={op}, a={a}, b={b}, result={dut.result.value}, expected={expected}"

@cocotb.test()
async def test_alu_edge_cases(dut):
    """Test ALU edge cases"""
    test_cases = [
        (ALU_ADD, 0, 0),
        (ALU_SUB, 0, 0),
        (ALU_AND, 0, 0xFFFFFFFF),
        (ALU_OR, 0, 0),
        (ALU_XOR, 0xFFFFFFFF, 0xFFFFFFFF),
    ]
    
    for op, a, b in test_cases:
        dut.op.value = op
        dut.a.value = a
        dut.b.value = b
        
        await Timer(1, units='ns')
        
        cocotb.log.info(f"Edge case: op={op}, a={a:08x}, b={b:08x}, result={dut.result.value:08x}")

# Additional comprehensive tests
@cocotb.test()
async def test_alu_comprehensive(dut):
    """Comprehensive test covering all operations"""
    
    # Test all operations with known values
    test_vectors = [
        # (op, a, b, expected_result)
        (ALU_ADD, 10, 5, 15),
        (ALU_SUB, 10, 5, 5),
        (ALU_AND, 0xF0F0, 0x0F0F, 0x0000),
        (ALU_OR, 0xF0F0, 0x0F0F, 0xFFFF),
        (ALU_XOR, 0xF0F0, 0x0F0F, 0xFFFF),
    ]
    
    for op, a, b, expected in test_vectors:
        dut.op.value = op
        dut.a.value = a
        dut.b.value = b
        
        await Timer(1, units='ns')
        
        result = dut.result.value
        assert result == expected, f"Test failed: op={op}, a={a:04x}, b={b:04x}, result={result:04x}, expected={expected:04x}"
        
        cocotb.log.info(f"PASS: op={op}, a={a:04x}, b={b:04x}, result={result:04x}")