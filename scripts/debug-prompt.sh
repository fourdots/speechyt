#!/bin/bash
# Debug: See what prompt is actually generated with actual previous message

# Copy test message to history for simulation
mkdir -p "$HOME/Documents/dev-projects/speechyt/history"
cp "$HOME/Documents/dev-projects/speechyt/test-actual-previous.txt" "$HOME/Documents/dev-projects/speechyt/history/test_$(date +%Y%m%d_%H%M%S).txt"

# Simulate the build function (with new base prompt)
build_initial_prompt() {
    local LAST_TRANSCRIPT=$(ls -t "$HOME/Documents/dev-projects/speechyt/history/"*.txt 2>/dev/null | head -n 1)
    
    if [ -f "$LAST_TRANSCRIPT" ]; then
        local RECENT_CONTEXT=$(tail -c 500 "$LAST_TRANSCRIPT" | tr '\n' ' ')
        echo "Previous: ${RECENT_CONTEXT} Context: Fantom Works dev project uses Supervisor and Laravel. Artisan, workers, queue, scheduler, jobs and tasks. Redis and web interface. OctoBrowser, organic traffic, proxy providers DataImpulse and Evomi."
    else
        echo "Fantom Works dev project uses Supervisor and Laravel. Artisan, workers, queue, scheduler, jobs and tasks. Redis and web interface. OctoBrowser, organic traffic, proxy providers DataImpulse and Evomi."
    fi
}

# Test both limits
echo "=========================================="
echo "800 CHARACTER LIMIT (CURRENT):"
echo "=========================================="
PROMPT_800=$(build_initial_prompt | head -c 800)
echo "$PROMPT_800"
echo ""
echo "Length: ${#PROMPT_800} chars"
echo "Estimated tokens: ~$((${#PROMPT_800} / 4))"
echo ""

echo "=========================================="
echo "850 CHARACTER LIMIT (ALTERNATIVE):"
echo "=========================================="
PROMPT_850=$(build_initial_prompt | head -c 850)
echo "$PROMPT_850"
echo ""
echo "Length: ${#PROMPT_850} chars"
echo "Estimated tokens: ~$((${#PROMPT_850} / 4))"
echo ""

echo "=========================================="
echo "RECOMMENDATION: Use 800 (safer buffer)"
echo "=========================================="
