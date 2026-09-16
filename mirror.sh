#!/usr/bin/env bash
# ==============================================================================
# Automated Mirror Script: Clone & Push Repositories to Private GitHub Account
# Generated for: vasusathishv
# Total Repositories: 46
# ==============================================================================

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# ==============================================================================
# PRE-FLIGHT CHECKS
# ==============================================================================

echo ""
echo "🔒 Verifying GitHub CLI authentication..."
if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI (gh) is not installed."
    echo "   Install via: brew install gh OR https://cli.github.com"
    exit 1
fi

if ! gh auth status > /dev/null 2>&1; then
    log_error "Not authenticated with GitHub CLI."
    echo "   Please run: gh auth login"
    exit 1
fi

log_success "GitHub CLI authenticated"

# Check for git
if ! command -v git &> /dev/null; then
    log_error "Git is not installed."
    exit 1
fi

log_success "Git is installed"

# ==============================================================================
# SETUP
# ==============================================================================

WORK_DIR="$(mktemp -d)"
log_info "Temporary work directory: $WORK_DIR"
cd "$WORK_DIR"

# Create log file for tracking failures
LOG_FILE="/tmp/mirror_failures_$(date +%s).log"
touch "$LOG_FILE"

REPOS=(
  "backgroundremover|https://github.com/nadermx/backgroundremover.git"
  "video-upscaler|https://github.com/nadermx/video-upscaler.git"
  "justabutton|https://github.com/nadermx/justabutton.git"
  "unitedstatesdollar|https://github.com/nadermx/unitedstatesdollar.git"
  "eff-prime-reservations|https://github.com/nadermx/eff-prime-reservations.git"
  "Flask-Angular-Ansible-Skeleton|https://github.com/nadermx/Flask-Angular-Ansible-Skeleton.git"
  "didishiptoday|https://github.com/nadermx/didishiptoday.git"
  "didyoushiptoday|https://github.com/nadermx/didyoushiptoday.git"
  "foro|https://github.com/nadermx/foro.git"
  "geocode|https://github.com/nadermx/geocode.git"
  "periodictableofelements|https://github.com/nadermx/periodictableofelements.git"
  "rembg|https://github.com/nadermx/rembg.git"
  "BackgroundMattingV2|https://github.com/nadermx/BackgroundMattingV2.git"
  "imaginAIry|https://github.com/nadermx/imaginAIry.git"
  "ollama|https://github.com/nadermx/ollama.git"
  "petals|https://github.com/nadermx/petals.git"
  "nanoGPT|https://github.com/nadermx/nanoGPT.git"
  "pdf-editor|https://github.com/nadermx/pdf-editor.git"
  "open-source-alternatives|https://github.com/nadermx/open-source-alternatives.git"
  "OCRmyPDF|https://github.com/nadermx/OCRmyPDF.git"
  "webvirtcloud|https://github.com/nadermx/webvirtcloud.git"
  "kvm-install-vm|https://github.com/nadermx/kvm-install-vm.git"
  "virt-scripts|https://github.com/nadermx/virt-scripts.git"
  "proxmoxer|https://github.com/nadermx/proxmoxer.git"
  "youtube-dl|https://github.com/nadermx/youtube-dl.git"
  "youtube-dl-api-server|https://github.com/nadermx/youtube-dl-api-server.git"
  "youtube-dl-web|https://github.com/nadermx/youtube-dl-web.git"
  "ChatGPT-at-Home|https://github.com/nadermx/ChatGPT-at-Home.git"
  "chat.petals.ml|https://github.com/nadermx/chat.petals.ml.git"
  "slate|https://github.com/nadermx/slate.git"
  "airdraw|https://github.com/nadermx/airdraw.git"
  "OpenRA|https://github.com/nadermx/OpenRA.git"
  "The-Art-of-Linear-Algebra|https://github.com/nadermx/The-Art-of-Linear-Algebra.git"
  "puppeteer-recaptcha-solver|https://github.com/nadermx/puppeteer-recaptcha-solver.git"
  "pgeocode|https://github.com/nadermx/pgeocode.git"
  "django-appointment|https://github.com/nadermx/django-appointment.git"
  "django-autosave|https://github.com/nadermx/django-autosave.git"
  "dns-zonefile|https://github.com/nadermx/dns-zonefile.git"
  "docx2csv|https://github.com/nadermx/docx2csv.git"
  "easycomplete|https://github.com/nadermx/easycomplete.git"
  "gpuowl|https://github.com/nadermx/gpuowl.git"
  "iguana|https://github.com/nadermx/iguana.git"
  "DingoQuadruped|https://github.com/nadermx/DingoQuadruped.git"
  "robotics_transformer|https://github.com/nadermx/robotics_transformer.git"
  "go-whatsapp-web-multidevice|https://github.com/aldinokemal/go-whatsapp-web-multidevice.git"
  "public-apis|https://github.com/public-apis/public-apis.git"
)

TOTAL_REPOS=${#REPOS[@]}
SUCCESS_COUNT=0
FAILED_COUNT=0

echo ""
echo "🚀 Starting mirroring of $TOTAL_REPOS repositories to @vasusathishv (Visibility: private)..."
echo "📝 Failure log: $LOG_FILE"
echo ""

# ==============================================================================
# MAIN MIRROR LOOP
# ==============================================================================

for i in "${!REPOS[@]}"; do
    CURRENT=$((i + 1))
    IFS="|" read -r NAME URL <<< "${REPOS[$i]}"
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 [$CURRENT/$TOTAL_REPOS] Processing: $NAME"
    echo "🔗 Upstream: $URL"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Step 1: Create Private Repository
    log_info "Creating private repo 'vasusathishv/$NAME' on GitHub..."
    if ! gh repo create "vasusathishv/$NAME" --private --description "Private mirror of $URL" 2>/dev/null; then
        log_warning "Repo already exists or creation failed, proceeding to push..."
    else
        log_success "Repository created successfully"
    fi

    # Step 2: Clone bare mirror with error handling
    log_info "Cloning bare mirror from upstream..."
    rm -rf "$NAME.git" 2>/dev/null || true
    
    if ! git clone --mirror "$URL" "$NAME.git"; then
        log_error "Failed to clone $NAME from $URL"
        echo "FAILED: $NAME - Clone failed at $(date)" >> "$LOG_FILE"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        continue
    fi
    
    log_success "Bare mirror cloned"

    # Step 3: Push full mirror to private repo
    log_info "Mirror pushing to git@github.com:vasusathishv/$NAME.git..."
    cd "$NAME.git"
    
    if git push --mirror "git@github.com:vasusathishv/$NAME.git" 2>/dev/null; then
        log_success "Successfully pushed via SSH"
    elif git push --mirror "https://github.com/vasusathishv/$NAME.git" 2>/dev/null; then
        log_success "Successfully pushed via HTTPS (SSH fallback)"
    else
        log_error "Failed to push mirror for $NAME"
        echo "FAILED: $NAME - Push failed at $(date)" >> "$LOG_FILE"
        FAILED_COUNT=$((FAILED_COUNT + 1))
        cd ..
        rm -rf "$NAME.git" 2>/dev/null || true
        continue
    fi
    
    cd ..
    rm -rf "$NAME.git" 2>/dev/null || true
    log_success "Successfully mirrored $NAME to your private GitHub!"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    
    echo ""
done

# ==============================================================================
# SUMMARY
# ==============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 MIRROR OPERATION COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
log_success "Successful: $SUCCESS_COUNT/$TOTAL_REPOS"
if [ $FAILED_COUNT -gt 0 ]; then
    log_error "Failed: $FAILED_COUNT/$TOTAL_REPOS"
    echo ""
    log_warning "Failed repositories (see $LOG_FILE):"
    cat "$LOG_FILE"
else
    log_success "ALL $TOTAL_REPOS REPOSITORIES SUCCESSFULLY MIRRORED!"
fi

echo ""
log_info "Cleaning up temporary directory: $WORK_DIR"
cd /
rm -rf "$WORK_DIR"

exit $([ $FAILED_COUNT -eq 0 ] && echo 0 || echo 1)
