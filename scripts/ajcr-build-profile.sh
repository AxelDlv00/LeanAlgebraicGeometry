#!/usr/bin/env bash
set -euo pipefail

# Batch independent AJCR module targets so Lake pays its workspace-startup cost once.
# The default is a no-build preflight; use --mode build only for the explicit leaves.

usage() {
  cat <<'EOF'
Usage: scripts/ajcr-build-profile.sh [options]

Options:
  --profile leaves       Use four independent, cache-safe AJCR leaf targets (default).
  --target TARGET        Add an explicit +AlgebraicJacobian.Module target (repeatable).
  --mode check|build     Run `lake build --no-build` (default) or build the targets.
  --compare              Compare separate Lake invocations with one grouped invocation.
  -h, --help             Show this help.

The helper rejects the finite-stage gluing cone and never invokes a bare project build.
Set AJCR_LAKE_BIN to select a Lake executable.
EOF
}

die() {
  printf 'ajcr-build-profile: %s\n' "$*" >&2
  exit 2
}

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
workspace_root=$(cd -- "$script_dir/.." && pwd)
project_dir="$workspace_root/MainProjects/Algebraic-Jacobian-Challenge-Rebuild"
lake_bin=${AJCR_LAKE_BIN:-lake}
profile=leaves
mode=check
compare=0
explicit_targets=()

while (($# > 0)); do
  case "$1" in
    --profile)
      (($# >= 2)) || die "--profile needs a value"
      profile=$2
      shift 2
      ;;
    --target)
      (($# >= 2)) || die "--target needs a value"
      explicit_targets+=("$2")
      shift 2
      ;;
    --mode)
      (($# >= 2)) || die "--mode needs a value"
      mode=$2
      shift 2
      ;;
    --compare)
      compare=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

case "$mode" in
  check|build) ;;
  *) die "--mode must be check or build" ;;
esac

command -v "$lake_bin" >/dev/null 2>&1 || die "Lake executable not found: $lake_bin"
[[ -f "$project_dir/lakefile.toml" ]] || die "AJCR project not found: $project_dir"
command -v /usr/bin/time >/dev/null 2>&1 || die "/usr/bin/time is required"
cd -- "$project_dir"

if ((${#explicit_targets[@]} > 0)); then
  targets=("${explicit_targets[@]}")
else
  case "$profile" in
    leaves)
      targets=(
        +AlgebraicJacobian.Algebra.ABDepth
        +AlgebraicJacobian.Curve.Basic
        +AlgebraicJacobian.AbelianVariety.Translation
        +AlgebraicJacobian.Descent.SemilinearAlgebras
      )
      ;;
    *)
      die "unknown profile: $profile"
      ;;
  esac
fi

validate_target() {
  local target=$1
  case "$target" in
    +AlgebraicJacobian.*) ;;
    *) die "target must be a module target beginning with +AlgebraicJacobian.: $target" ;;
  esac
  case "$target" in
    *Pic0FiniteStage*|*Pic0CriticalPath*)
      die "finite-stage targets are intentionally excluded from this profile: $target"
      ;;
  esac
}

for target in "${targets[@]}"; do
  validate_target "$target"
done

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/ajcr-build-profile.XXXXXX")
trap 'rm -rf -- "$tmp_dir"' EXIT

last_elapsed=
last_user=
last_sys=
last_rss=
last_jobs=

run_group() {
  local label=$1
  shift
  local out="$tmp_dir/$label.out"
  local timing="$tmp_dir/$label.time"
  local -a command=("$lake_bin" build)
  if [[ "$mode" == check ]]; then
    command+=(--no-build)
  fi
  command+=("$@")

  printf 'profile=%s mode=%s group=%s targets=%s\n' "$profile" "$mode" "$label" "$#"
  if /usr/bin/time -f $'elapsed_seconds=%e\nuser_seconds=%U\nsys_seconds=%S\nmax_rss_kb=%M' \
      -o "$timing" "${command[@]}" >"$out" 2>&1; then
    :
  else
    local rc=$?
    printf 'status=failed rc=%s\n' "$rc"
    tail -n 30 "$out" >&2
    return "$rc"
  fi

  last_elapsed=$(sed -n 's/^elapsed_seconds=//p' "$timing")
  last_user=$(sed -n 's/^user_seconds=//p' "$timing")
  last_sys=$(sed -n 's/^sys_seconds=//p' "$timing")
  last_rss=$(sed -n 's/^max_rss_kb=//p' "$timing")
  last_jobs=$(sed -nE 's/.*\(([0-9]+) jobs?\).*/\1/p' "$out" | tail -n 1)
  : "${last_jobs:=unknown}"
  printf 'status=ok elapsed_seconds=%s user_seconds=%s sys_seconds=%s max_rss_kb=%s jobs=%s\n' \
    "$last_elapsed" "$last_user" "$last_sys" "$last_rss" "$last_jobs"

  local diagnostic_count
  diagnostic_count=$(grep -Ec '(^| )(warning|error):' "$out" || true)
  if ((diagnostic_count > 0)); then
    printf 'diagnostics_count=%s sample:\n' "$diagnostic_count" >&2
    grep -E '(^| )(warning|error):' "$out" | head -n 8 >&2
  fi
}

printf 'project=%s\n' "$project_dir"
printf 'targets=%s\n' "${targets[*]}"

if ((compare)); then
  split_sum=0
  split_peak_rss=0
  for i in "${!targets[@]}"; do
    run_group "split-$i" "${targets[$i]}"
    split_sum=$(awk -v a="$split_sum" -v b="$last_elapsed" 'BEGIN { printf "%.3f", a + b }')
    split_peak_rss=$(awk -v a="$split_peak_rss" -v b="$last_rss" 'BEGIN { printf "%.0f", (a > b ? a : b) }')
  done
  run_group grouped "${targets[@]}"
  grouped_elapsed=$last_elapsed
  grouped_rss=$last_rss
  improvement_seconds=$(awk -v separate="$split_sum" -v grouped="$grouped_elapsed" \
    'BEGIN { printf "%.3f", separate - grouped }')
  improvement_percent=$(awk -v separate="$split_sum" -v grouped="$grouped_elapsed" \
    'BEGIN { if (separate == 0) printf "0.0"; else printf "%.1f", 100 * (separate - grouped) / separate }')
  rss_delta=$(awk -v separate="$split_peak_rss" -v grouped="$grouped_rss" \
    'BEGIN { printf "%.0f", grouped - separate }')
  printf 'comparison.split_sum_seconds=%s\n' "$split_sum"
  printf 'comparison.grouped_seconds=%s\n' "$grouped_elapsed"
  printf 'comparison.time_saved_seconds=%s\n' "$improvement_seconds"
  printf 'comparison.time_saved_percent=%s\n' "$improvement_percent"
  printf 'comparison.split_peak_rss_kb=%s\n' "$split_peak_rss"
  printf 'comparison.grouped_peak_rss_kb=%s\n' "$grouped_rss"
  printf 'comparison.rss_delta_kb=%s\n' "$rss_delta"
else
  run_group grouped "${targets[@]}"
fi
