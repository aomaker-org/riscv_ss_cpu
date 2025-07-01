// jules/docker/riscv_example/src/rust/main.rs

// This version attempts to use the standard library.
// QEMU user mode might provide enough syscall emulation for this to work
// when linked against a RISC-V std lib (e.g., from a target like riscv32gc-unknown-linux-gnu).
// If not, a #![no_std] version with a custom print mechanism would be needed.

fn main() {
    println!("Hello, World from Rust (RISC-V)!");
}
