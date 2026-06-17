# Iter-265 objectives (per-lane bars + reversing signals)

Authoritative prover-facing spec = PROGRESS.md `## Current Objectives`. This is the compact attempt log.

## Lane 1 — DUAL `Picard/TensorObjSubstrate/DualInverse.lean` [fine-grained]
- **Target:** `sliceDualTransport` fields `invFun` (L410, linchpin) + `naturality` (L337); round-trips
  `left_inv`/`right_inv` (L413/415); if all close, `dual_restrict_iso` isoMk naturality (L546).
- **Bar:** internal holes 4→1 (invFun + round-trips). naturality finishes the decl (4→0).
- **pc265:** CONVERGING (1 field/iter on the internal-holes metric). Early `naturality` read; pivot to
  invFun if it stalls.
- **Reverse:** invFun fails the di264-adequate recipe ⇒ report the exact step; reassess `≃ₗ`-by-hand
  packaging (NOT a route pivot).

## Lane 2 — D3′ `Picard/TensorObjSubstrate.lean` [fine-grained]
- **Target:** `sheafificationCompPullback_comp_tail` (L2578). STEP 1 = extract the presheaf↔sheaf
  `forget ∘ pushforward = pushforward ∘ forget` bridge as a named lemma + prove. STEP 2 = paste blueprint
  (a)–(e).
- **Bar:** close the tail (file-sorry 3→2) OR land STEP-1 bridge axiom-clean (decompose deliverable).
- **pc265:** STUCK; primary corrective (blueprint DECOMPOSE) DONE this phase (bw-tos265/bc265/br265).
- **Reverse:** (a)–(e) blocks WITH the bridge proved ⇒ 6th PARTIAL ⇒ cross-domain analogist on the
  bicategorical-cocycle/mate-assembly shape.

## Lane 3 — ENGINE `Cohomology/CechHigherDirectImage.lean` [mathlib-build]
- **Target:** `pushPullMap_comp` (pentagon) ONLY. STRETCH (if comp closes early): `pushPullFunctor` +
  `CechNerve` (L89).
- **Bar:** `pushPullMap_comp` axiom-clean (no sorry). A ~150-LOC pentagon is a full iter.
- **pc265:** CHURNING-mechanical-false-positive (real decl/iter; 4% into an 85–140-iter phase).
- **Reverse:** comp not closed by iter-266 ⇒ blueprint sub-lemma decomposition of the pentagon.

## RACE: DualInverse imports TensorObjSubstrate — Lane 2 must keep the file COMPILABLE (typed sorry OK).
