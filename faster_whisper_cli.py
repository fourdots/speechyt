#!/usr/bin/env python3
"""
faster-whisper CLI wrapper for SpeechyT with GPU support
"""
import sys
import argparse
from pathlib import Path
from faster_whisper import WhisperModel

def main():
    parser = argparse.ArgumentParser(description='Transcribe audio using faster-whisper with GPU')
    parser.add_argument('audio_file', help='Audio file to transcribe')
    parser.add_argument('--model', default='base.en', help='Model to use (default: base.en)')
    parser.add_argument('--language', default='en', help='Language code (default: en)')
    parser.add_argument('--device', default='cuda', help='Device: cuda or cpu (default: cuda)')
    parser.add_argument('--compute_type', default='float16', help='Compute type (default: float16)')
    parser.add_argument('--output_dir', required=True, help='Output directory for transcription')
    parser.add_argument('--output_format', default='txt', help='Output format (default: txt)')
    parser.add_argument('--initial_prompt', default='', help='Initial prompt for context')
    
    args = parser.parse_args()
    
    # Load model with GPU
    try:
        model = WhisperModel(
            args.model,
            device=args.device,
            compute_type=args.compute_type if args.device == 'cuda' else 'int8'
        )
    except Exception as e:
        print(f"Error loading model: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Transcribe
    try:
        segments, info = model.transcribe(
            args.audio_file,
            language=args.language,
            initial_prompt=args.initial_prompt if args.initial_prompt else None
        )
        
        # Collect all text
        transcription = ' '.join([segment.text for segment in segments])
        
        # Write to output file
        audio_path = Path(args.audio_file)
        output_path = Path(args.output_dir) / f"{audio_path.stem}.{args.output_format}"
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(transcription.strip())
        
        print(f"Transcription saved to: {output_path}")
        
    except Exception as e:
        print(f"Error during transcription: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
