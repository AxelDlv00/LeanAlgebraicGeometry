# Session 76 (iter-076) — hSec closed; project to ONE sorry

## Metadata
- Sorry count (non-frozen): **2 → 1**. Closed: `cechSection_isZero_homology` / `cechAugmented_exact`
  (`CechAugmentedResolution.lean`). Remaining project sorry: `cech_computes_higherDirectImage`
  (`CechHigherDirectImage.lean:780`, frozen/protected P5b assembly).
- Target attempted: `hSec` Step-3(d) of `cechAugmented_exact` (P5a-resolution route).
- Edits: 3, all to `CechAugmentedResolution.lean`. Prover builds: 0 succeeded (all exit 137).

## Target: cechSection_isZero_homology / cechAugmented_exact — SOLVED

### What the prover did (3 edits)
1. `import AlgebraicJacobian.Cohomology.CechSectionIdentification` (line 11).
2. Added the named wrapper lemma `cechSection_isZero_homology` (line 155), body:
   ```lean
   isZero_homology_of_iso_homotopy_id_zero (cechSection_complex_iso 𝒰 F V) p
     (cechSection_contractible 𝒰 F V i hiV)
   ```
   Its `let`-bound return type (`α/cc/K/Kp/GV` chain) is verbatim the return type of
   `cechSection_complex_iso`; both CSI lemmas target the same concrete `D'`, so the glue
   `isZero_homology_of_iso_homotopy_id_zero` unifies definitionally.
3. Replaced the Step-3(d) `sorry` (≈line 229→243) with `exact cechSection_isZero_homology 𝒰 F V i hiV p`.

This is exactly the close that blueprint-reviewer `gate076` prescribed (it had spelled out the intended
`exact` at `CechAugmentedResolution.lean:220–222`), and it matches the pre-authored blueprint block
`lem:cechSection_isZero_homology` (bp:9491) statement + `\uses`. No improvisation; in-scope.

### Verification — the central story of this iter
- **Prover could NOT verify.** Every `lake build` returned **exit 137** (SIGKILL). The host has 1 TiB
  free, so this is NOT host OOM — it is a **prover-sandbox memory-cgroup cap** below the host. The target
  module is the heaviest in the tree (imports the full CSI chain + CechHigherDirectImage +
  AffineSerreVanishing + QcohTildeSections); a cold build exceeds the cap. The iter-073 build wall
  recurred on a heavier file.
- **sync_leanok did not verify it either:** iter=76, sha 9b7122c, +0/−0, chapters_touched=[]. The module
  `.olean` is stale (predates the 01:06 edit); `lem:cechSection_isZero_homology` got no `\leanok`.
- **Review-agent kernel build = GREEN (exit 0).** From a 512 GiB cap (`memory.max` = 549755813888,
  `ulimit -v` unlimited) I rebuilt `AlgebraicJacobian.Cohomology.CechAugmentedResolution` → exit 0, 0
  errors (`.archon/logs/iter-076/review-verify-build.log`). The close is **kernel-sound**, not just
  LSP-clean — clearing the kernel-soundness-trap risk.
- Two read-only subagents independently corroborate: `lean-vs-blueprint-checker iter076` (fully aligned,
  6 decls, 0 red flags, no sorries/axioms, definitional close) and `lean-auditor iter076` (sorry-free,
  axiom-free, wrapper faithfulness confirmed, `let`-chain verbatim-identical).

### Notable property
- `lean-auditor` flags that `cechAugmented_exact` does **not use** its `h𝒰` (affine), `[X.IsSeparated]`,
  or `hF` (quasi-coherent) hypotheses — the proof establishes a strictly stronger result. This is
  **expected, not a bug**: the local discharger is the F-agnostic, cover-agnostic prepend-`i` contracting
  homotopy (ARCHON_MEMORY: "F-agnostic + cover-agnostic, needs NO qcoh/tilde/affineness"); the augmented
  Čech complex of *sheaves* is a resolution for arbitrary F. The hypotheses are kept to match the
  blueprinted Stacks signature and the downstream call site. Informational only.

## Remaining sorry: cech_computes_higherDirectImage (CHDI:780) — BLOCKED→now unblocked
- Frozen/protected P5b Route-A assembly; NOT dispatched this iter (was blocked on `cechAugmented_exact`).
  Now the last project sorry. `\uses` closure all in place (`cechAugmented_exact` done,
  `rightDerivedIsoOfAcyclicResolution`, `cech_term_pushforward_acyclic`,
  `acyclic_resolution_computes_derived`). Also wants the ~6-LOC `EnoughInjectives` connector.

## Key findings / patterns
- **Prover/host memory-cap mismatch:** exit 137 with 1 TiB host free = sandbox cgroup cap, not OOM.
  Heaviest leaf modules can't cold-build inside the prover cap. Mitigations: pre-warm import-closure
  oleans, raise the prover cap, or LSP-mode + review-build/sync as the verification gate.
- **Named-wrapper extraction pattern:** when a blueprint pre-authors a leaf lemma whose body is a
  one-liner over already-proved deps, the prover gives it a signature whose `let`-bound return type is
  copied verbatim from the dep's return type — guaranteeing definitional unification of the wrapping
  glue. Reusable.

## Recommendations for next session
See `recommendations.md`. Headline: resolve the build wall before the next heavy lane; P5b +
EnoughInjectives connector are the unblocked, parallelisable last work.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:cechSection_isZero_homology`: added proof `\leanok`
  (manual override — `sync_leanok` missed it because the heavy module exceeded its build budget; I
  first-hand confirmed exit-0 `lake build` + 0 literal sorries + 0 axioms in the cone via the
  review-agent build and both review subagents).
- `Cohomology_CechHigherDirectImage.tex`, `lem:isZero_of_faithful_preservesZeroMorphisms`: added proof
  `\leanok` (same override rationale; declared `CechAugmentedResolution.lean:55`, 0 sorries, in the
  now-green module).

## Low-severity notes
- `lean-auditor` major (hygiene, not blocking): stale planner-strategy comment (`CechAugmentedResolution.lean`
  169–189) names 6 unused lemmas; stale module-doc (23–24) names 3 phantom ingredients; comment @235 names
  `combHomotopy` where the real mechanism is `Homotopy.mkCoinductive`. Review agent cannot edit `.lean`;
  flagged for a cleanup/refactor lane (see recommendations).
- Stale .lean docstrings claim a `coreIso_comm_leg` sorry that no longer exists
  (`CechSectionIdentification.lean:20`, `CechSectionIdentificationLeg.lean:15`).
