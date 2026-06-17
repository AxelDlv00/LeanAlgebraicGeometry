# Lean Audit Report

## Slug
iter163

## Iteration
163

## Scope
- files audited: 3 (1 primary, 2 secondary cross-check)
- files skipped (per directive): 0
- Directive narrowed scope to the prover-touched file + 2 secondary consistency checks. Compilation
  state confirmed via LSP: `AbelianVarietyRigidity.lean` builds with exactly 3 `sorry` warnings
  (L919, L943, L968) and no errors. The two new lemmas verified axiom-clean (only `propext`,
  `Classical.choice`, `Quot.sound`; no `sorryAx`).

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 6 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (candidate unused instances)
- **excuse-comments**: none
- **notes**:
  - **Focus 1 — the two new lemmas are SOUND and COMPLETE.** `hom_additive_decomp_of_rigidity`
    (L809) and `av_regularMap_isHom_of_zero` (L879) both compile with no `sorry` and verify
    axiom-clean (`{propext, Classical.choice, Quot.sound}`). No hidden sorry, no false-hypothesis
    laundering. Every *value* hypothesis is load-bearing: in `hom_additive_decomp_of_rigidity`,
    `hh : lift v₀ w₀ ≫ h = η[A]` is consumed by `hwg`/`hvf` (L840–841) which feed the two collapse
    facts `hcolV`/`hcolW`; in `av_regularMap_isHom_of_zero`, `hα` is used both as `one_hom` (L903)
    and in deriving the base point hypothesis for the Cor-1.5 application (L896). The `rigidity_lemma`
    call (L855) discharges `IsSeparated A.hom` from `IsProper A.hom` via `inferInstance` (L824).
  - **Candidate unused instances (minor).** In `hom_additive_decomp_of_rigidity`, the `A`-side
    instances `[Smooth A.hom]` and `[GeometricallyIrreducible A.hom]` (L817) appear to play no role
    in the proof: the group structure comes from `[GrpObj A]`, separatedness from `[IsProper A.hom]`,
    and `rigidity_lemma` (applied with `Z := A`) only requires `IsSeparated A.hom`. If genuinely
    unused they merely over-strengthen the antecedent (a reusability cost, not a soundness issue),
    and may be deliberate "abelian-variety packaging." They are transitively required at the call
    site in `av_regularMap_isHom_of_zero` (passed as the `B`-side `Smooth B.hom`/`GeometricallyIrreducible B.hom`),
    so removing them would also lighten that lemma's hypotheses. Prover should confirm by attempting
    removal. (See "Minor".)
  - **Focus 3 — pervasive STALE "lone residual sorry" status comments.** Multiple docstrings still
    assert that the Rigidity-Lemma chain has a residual `sorry` located in
    `rigidity_eqAt_closedPoint_of_proper_into_affine` ("Step 1's geometric slice/section assembly").
    That theorem (L258–395) is now **fully proven** — its body ends at L395 with no `sorry`, and the
    file compiles with the only sorries being the 3 downstream scaffolds (L919/943/968). The chain
    `rigidity_snd_lift → eq_comp_of_isAffine_of_properIntegral → rigidity_eqAt_closedPoint... →
    rigidity_eqOn_saturated_open_to_affine → rigidity_eqOn_dense_open → rigidity_core →
    rigidity_lemma` carries no `sorry`. Stale claims at L29, L239, L255, L408–410, L485, L644–645,
    L669–671, L757–759. (See "Major".)
  - **Focus 2 — scaffold sorry docstrings.** `genusZero_curve_iso_P1` (L943) and
    `rigidity_genus0_curve_to_grpScheme` (L968): docstrings accurately describe open obligations
    (Riemann–Roch / assembly of the other two) and their `SCAFFOLD`/`Status: sorry` markers are
    truthful. `morphism_P1_to_grpScheme_const` (L919): docstring (L910–912) and the file header
    (L32–33) assert the base case "rests on the theorem of the cube (blueprint
    `thm:theorem_of_the_cube`)". This is a *dependency claim about intended proof*, not reflected in
    any Lean code (body is `sorry`). Flag to verify against the current blueprint — if the cube node
    was excised it is a stale dependency reference. (See "Major".)
  - The three open sorries (L928/952/981) are honestly-marked, accurately-typed `SCAFFOLD`
    obligations — the project's disclosed frontier, not suspect/laundered bodies. Treated as
    expected open work (minor), not must-fix; see rationale under "Minor".

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none (no references to the rigidity chain / cube found)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Cross-checked only per directive (consistency). Grep for `rigidity_eqAt`, `lone residual`,
    `rigidity_genus0`, `rigidity_eqOn`, `theorem of the cube` returned no matches — no stale
    cross-file comments referencing the audited chain. No full re-audit performed (out of scope).

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none found
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Cross-checked only per directive. Grep for `rigidity_eqAt`, `lone residual`, `rigidity_genus0`,
    `rigidity_eqOn`, `AbelianVarietyRigidity`, `cube` returned no matches. No stale references to
    the audited chain. No full re-audit performed (out of scope).

## Must-fix-this-iter

None. The two new lemmas are axiom-clean and complete; the three remaining `sorry` bodies are
fully-disclosed scaffolds with accurate status markers (not suspect/laundered bodies), so they do
not meet the must-fix "suspect body" bar. (Judgment recorded explicitly per the strict-severity
reminder: a `:= sorry` whose docstring openly says "Status: scaffold — body is `sorry`" is the
opposite of a suspect body — it is transparent, blueprint-tracked frontier work, not code being
passed off as done.)

## Major

- `AbelianVarietyRigidity.lean:255` — `rigidity_eqAt_closedPoint_of_proper_into_affine` docstring
  reads "**Status (iter-160): `sorry` (the genuinely-deep residual of the Rigidity-Lemma chain)**",
  and its title line (L239) calls it "the residual deep geometry". The body (L258–395) is now
  **fully proven** (verified: compiles, no `sorry`; downstream chain axiom-clean). The status comment
  actively misrepresents the proof state of the very declaration it annotates. Highest-priority
  stale comment.
- `AbelianVarietyRigidity.lean:408-410` — `rigidity_eqOn_saturated_open_to_affine` docstring says it
  is "isolated here as a named top-level obligation with a precise statement and `sorry` body" and
  gives a "≈1–2 further iterations" estimate. It is now proven (assembled from
  `morphism_eq_of_eqAt_closedPoints` + `rigidity_eqAt_closedPoint_of_proper_into_affine`, both
  proven). Stale.
- `AbelianVarietyRigidity.lean:29` (file-header) — "The lone residual `sorry` of the chain is the
  *geometric* slice/section assembly of Step 1". Stale: the chain has no residual `sorry`.
- `AbelianVarietyRigidity.lean:485` — `rigidity_eqOn_dense_open` docstring: "The chain's lone
  residual `sorry` is the *geometric* slice/section assembly of Step 1." Stale.
- `AbelianVarietyRigidity.lean:644-645` and `:669-671` — `rigidity_core` docstring: repeats "the
  lone residual `sorry` is Step 1's geometric slice/section assembly
  (`rigidity_eqAt_closedPoint_of_proper_into_affine`)". Stale (twice).
- `AbelianVarietyRigidity.lean:757-759` — `rigidity_lemma` docstring "Status (iter-161)": "The lone
  residual `sorry` of the whole chain is Step 1's geometric slice/section assembly
  (`rigidity_eqAt_closedPoint_of_proper_into_affine`)." Stale.
- `AbelianVarietyRigidity.lean:910-912` (and header `:32-33`) — `morphism_P1_to_grpScheme_const`
  docstring asserts the single-curve base case "rests on the theorem of the cube (blueprint
  `thm:theorem_of_the_cube`), recorded there as a deferred deep input." Not derivable from Lean
  (body is `sorry`); flagged for cross-check against the current blueprint, since a stale
  cube-dependency claim would mislead the next planner. (If the project's blueprint no longer
  contains a cube node on the genus-0 path, this docstring is stale.)

## Minor

- `AbelianVarietyRigidity.lean:817` — `[Smooth A.hom]`, `[GeometricallyIrreducible A.hom]` on `A` in
  `hom_additive_decomp_of_rigidity` appear unused by the proof (group structure from `GrpObj A`,
  separatedness from `IsProper A.hom`). Candidate for removal to generalise the lemma; prover should
  confirm. Not a soundness concern.
- `AbelianVarietyRigidity.lean:919,943,968` — three open `SCAFFOLD` sorries
  (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`).
  Honestly marked, accurately typed; the project's declared remaining obligations. Listed for
  visibility, not as defects.

## Excuse-comments (always called out separately)

None. No `-- TODO replace`, `-- placeholder`, `-- temporary`, `-- wrong but works`, or
`-- will fix later` style comments were found. The `sorry` bodies are openly status-marked scaffolds,
which is disclosure rather than an excuse-comment.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 7 (all stale status/dependency comments; no soundness issues — 6 are the
  now-false "lone residual sorry" framing, 1 is the cube-dependency claim to verify)
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: The two new lemmas (`hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`)
are sound, complete, and axiom-clean with load-bearing value-hypotheses; the only real issues are
pervasive stale "lone residual sorry" docstrings that now contradict the proven state of
`rigidity_eqAt_closedPoint_of_proper_into_affine` (the chain is sorry-free) plus a cube-dependency
docstring worth verifying against the blueprint.
