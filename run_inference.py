#!/usr/bin/env python3
"""
Simple inference script for VABitNet using ctransformers
"""

from ctransformers import AutoModelForCausalLM
import sys

# Path to the model
MODEL_PATH = "models/bitnet_b1_58-large/ggml-model-i2_s.gguf"

def main():
    print("=" * 60)
    print("VABitNet - BitNet 1.58-bit LLM Inference")
    print("=" * 60)
    print()
    print("Loading BitNet model...")
    print(f"Model: {MODEL_PATH}")
    print()
    
    try:
        # Initialize the model
        llm = AutoModelForCausalLM.from_pretrained(
            MODEL_PATH,
            model_type="llama",
            context_length=2048,
            threads=4,
            gpu_layers=0  # CPU only
        )
        
        print("✓ Model loaded successfully!")
        print()
        print("=" * 60)
        print("Interactive Mode")
        print("=" * 60)
        print("Type your prompt and press Enter. Type 'quit' to exit.")
        print()
        
        while True:
            try:
                # Get user input
                prompt = input("\n>>> ").strip()
                
                if prompt.lower() in ['quit', 'exit', 'q']:
                    print("\nGoodbye!")
                    break
                
                if not prompt:
                    continue
                
                print("\nGenerating response...\n")
                
                # Generate response with streaming
                for text in llm(
                    prompt,
                    max_new_tokens=200,
                    temperature=0.7,
                    top_p=0.9,
                    top_k=40,
                    repetition_penalty=1.1,
                    stream=True
                ):
                    print(text, end='', flush=True)
                
                print("\n")  # New line after completion
                
            except KeyboardInterrupt:
                print("\n\nGoodbye!")
                break
            except Exception as e:
                print(f"\nError during generation: {e}")
                continue
                
    except Exception as e:
        print(f"\n✗ Error loading model: {e}")
        print("\nMake sure the model file exists at:")
        print(f"  {MODEL_PATH}")
        sys.exit(1)

if __name__ == "__main__":
    main()
