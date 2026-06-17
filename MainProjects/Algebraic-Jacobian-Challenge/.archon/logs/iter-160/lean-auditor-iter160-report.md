# Lean Audit Report

## Slug
iter160

## Iteration
160

## Scope
- files audited: 15 (every `.lean` under the project tree, excluding `.lake/` and `.archon/lanes/` snapshots)
- files skipped (per directive): 0
- Method: focus file `AbelianVarietyRigidity.lean` read in full, line by line. All 15 files swept
  with compiler diagnostics (LSP `lean_diagnostic_messages`), a project-wide grep for suspect
  markers (`sorry`/`axiom`/`:= True`/`Classical.choice`/`TODO`/`placeholder`/`temporary`/
  `will fix`/`wrong but`), and an `axiom`/`:= True` keyword scan. Non-focus files (unmodified this
  iter) were verified clean via diagnostics + targeted grep rather than full re-read.

## Authoritative sorry inventory (from the compiler, not docstrings)

| file | line | declaration | status |
|------|------|-------------|--------|
| AbelianVarietyRigidity.lean | 151 | `rigidity_eqAt_closedPoint_of_proper_into_affine` | **NEW this iter** |
| AbelianVarietyRigidity.lean | 203 | `rigidity_eqOn_saturated_open_to_affine` (in-body `JacobsonSpace := sorry`, L237) | **NEW this iter** |
| AbelianVarietyRigidity.lean | 554 | `morphism_P1_to_grpScheme_const` | known scaffold |
| AbelianVarietyRigidity.lean | 578 | `genusZero_curve_iso_P1` | known scaffold |
| AbelianVarietyRigidity.lean | 603 | `rigidity_genus0_curve_to_grpScheme` | known scaffold |
| Jacobian.lean | 209 | `genusZeroWitness.key` region | known |
| Jacobian.lean | 299 | `nonempty_jacobianWitness` / positive-genus | known |
| RigidityKbar.lean | 75 | `rigidity_over_kbar` (CharZero fallback) | known |

No live `axiom` declarations anywhere. No `:= True` / fake-`rfl` bodies. `Classical.choice` appears
only in documented `noncomputable` extractions (MayerVietorisCover L514, Jacobian L342) — standard,
authorized, no new axiom.

## Per-file checklist

### AlgebraicJacobian.lean
- outdated comments: none — suspect definitions: none — dead-end proofs: none — bad practices: none — excuse-comments: none
- notes: import-only root, 14 lines. Clean.

### AlgebraicJacobian/AbelJacobi.lean
- outdated comments: none — suspect definitions: none — dead-end proofs: none — bad practices: 1 (lint) — excuse-comments: none
- notes:
  - L22 exceeds 100-char line limit (style lint only).

### AlgebraicJacobian/AbelianVarietyRigidity.lean  *(focus file)*
- outdated comments: **4 flagged** — suspect definitions: **2 flagged** — dead-end proofs: none — bad practices: 1 — excuse-comments: 1 (the JacobsonSpace gap, see below)
- notes:
  - **`morphism_eq_of_eqAt_closedPoints` (L107) is sound and genuinely `sorry`-free** (confirmed: no
    sorry warning at L107). Statement is a standard, true fact (reduced source + dense closed points
    + separated target ⟹ hom-extensionality via a dominant residue-field-coproduct probe). Good work.
    No issue.
  - **L237 `haveI : JacobsonSpace (...) := sorry` inside `rigidity_eqOn_saturated_open_to_affine`.**
    This sorry fills an *instance argument* that `morphism_eq_of_eqAt_closedPoints` requires. The
    in-code comment (L227–236) is **honest and explicit**: L235 states "this is the one place the
    present statement is not provable as literally typed." That admission is the finding: the theorem
    is stated with a clean signature that lacks any finite-type / Jacobson hypothesis, and is then
    propped up by a `sorry`'d instance. **Not laundering in the axiom sense** — the sorry is visible
    (warning at L203) and propagates via `#print axioms` to every downstream consumer
    (`rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`); nothing falsely claims clean.
    But it IS a `:= sorry` propping up an as-typed-unprovable statement, so it lands must-fix. Correct
    remediation (which the author names): add `[LocallyOfFiniteType (X ⊗ Y).hom]` (⟹ `[JacobsonSpace
    (X ⊗ Y).left]`, inherited by the open `U`) to the signature, not sorry the instance.
  - **`rigidity_eqAt_closedPoint_of_proper_into_affine` (L151, body `sorry`).** New top-level,
    load-bearing (consumed at L242). Its own docstring proof-sketch (L138–146) relies on
    "`κ(y) = k̄` (`[IsAlgClosed kbar]`, finite type)" — but the signature carries **no finite-type
    hypothesis**. So this statement is, by the author's own argument, likely not provable as literally
    typed for the same reason as the JacobsonSpace gap above. Sorry on a load-bearing claim that may
    be false/unprovable as stated → must-fix.
  - **Stale "lone residual sorry" docstrings (L26, L410, L434–435, L518).** All four assert that
    bridge 2 / `rigidity_eqOn_saturated_open_to_affine` is *the lone* residual `sorry` of the
    Rigidity-Lemma chain. The compiler shows **two** sorries in the chain now (L151 and L203's
    instance gap). The decomposition into `morphism_eq_of_eqAt_closedPoints` (real, sorry-free) +
    `rigidity_eqAt_closedPoint_of_proper_into_affine` (sorry) + the JacobsonSpace instance (sorry)
    *increased* the chain's sorry count 1→2 this iter, but the docstrings still say "lone". Actively
    misleading about proof completeness → major.
  - Known deferred scaffolds `morphism_P1_to_grpScheme_const` (L554), `genusZero_curve_iso_P1`
    (L578), `rigidity_genus0_curve_to_grpScheme` (L603) — per directive, not re-flagged as new.
  - `snd_left_isClosedMap` (L85), `rigidity_snd_lift` (L66), `rigidity_core` (L438),
    `rigidity_lemma` (L520), `rigidity_eqOn_dense_open` (L271) are sound and `sorry`-free in their own
    bodies (they inherit the chain sorry transitively, as the docstrings correctly note).

### AlgebraicJacobian/Differentials.lean
- all categories: none
- notes: clean (no diagnostics).

### AlgebraicJacobian/Genus.lean
- all categories: none
- notes: clean.

### AlgebraicJacobian/Jacobian.lean
- outdated comments: none — suspect definitions: 0 new — dead-end proofs: none — bad practices: none — excuse-comments: none
- notes:
  - Known sorries at L209, L299 (per directive). L263–265 comment ("inflate the sorry count, so the
    gate is recorded rather than papered over") is honest gate-recording behaviour, not an
    excuse-comment — good practice, no flag.

### AlgebraicJacobian/Rigidity.lean
- all categories: none
- notes: clean.

### AlgebraicJacobian/RigidityKbar.lean
- outdated comments: none — suspect definitions: none — dead-end proofs: none — bad practices: none — excuse-comments: none
- notes: known sorry at L75 (`rigidity_over_kbar`, the `[CharZero]` fallback route (a)). Per directive.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- all categories: none
- notes: clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- all categories: none
- notes: clean. L502–514 `Classical.choice` is documented as already in the kernel axiom set; no new
  axiom. Acceptable.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- all categories: none
- notes: clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- all categories: none
- notes: clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- all categories: none
- notes: clean.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- outdated comments: 1 (minor) — others: none
- notes: clean of sorries. L20–26 comment references the removed iter-145 `: True := sorry`
  placeholders; historical, describes removed code, not a live placeholder. Minor staleness.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- outdated comments: 2 (cosmetic, pre-flagged iter-159) — others: none
- notes: clean of sorries. Section docstrings around L297–327 and L428–451 were flagged iter-159 as
  stale/cosmetic. Still present; on read they describe historical step-by-step status of now-closed
  declarations. Not worse than cosmetic — minor only, per directive guidance.

## Must-fix-this-iter

- `AbelianVarietyRigidity.lean:237` — `haveI : JacobsonSpace ((U : ...).toScheme) := sorry` props up
  `rigidity_eqOn_saturated_open_to_affine`, whose signature carries no finite-type/Jacobson
  hypothesis. Author admits (L235) the statement "is not provable as literally typed." Why must-fix:
  a `:= sorry` supplying a missing hypothesis lets a clean-looking signature mask an
  under-hypothesized (as-typed-unprovable) statement; the fix is to add `[LocallyOfFiniteType
  (X ⊗ Y).hom]` to the chain signature, not to sorry the instance.
- `AbelianVarietyRigidity.lean:172` — `rigidity_eqAt_closedPoint_of_proper_into_affine := sorry` on a
  load-bearing claim whose own proof-sketch (L138–146) requires `κ(y) = k̄` from finite type, a
  hypothesis absent from the signature. Why must-fix: sorry on a load-bearing claim that is likely
  false/unprovable as literally typed (same missing finite-type hypothesis as L237).

## Major

- `AbelianVarietyRigidity.lean:26, 410, 434–435, 518` — docstrings assert
  `rigidity_eqOn_saturated_open_to_affine` is *the lone* residual `sorry` of the Rigidity-Lemma
  chain. The compiler shows **two** chain sorries (L151, L203). Stale and actively misleading about
  proof completeness; the chain's sorry count went 1→2 this iter while these comments still say
  "lone".

## Minor

- `AbelJacobi.lean:22`, `Jacobian.lean:355` — lines exceed the 100-char style limit (lint only).
- `Cotangent/ChartAlgebra.lean:20–26` — comment references removed iter-145 `: True := sorry`
  placeholders; historical, mildly stale.
- `Cotangent/GrpObj.lean:297–327, 428–451` — stale step-status section docstrings (pre-flagged
  iter-159); cosmetic, file has no live sorries.

## Excuse-comments (always called out separately)

- `AbelianVarietyRigidity.lean:235` (attached to `rigidity_eqOn_saturated_open_to_affine`, L203):
  "This is the one place the present statement is not provable as literally typed; everything else of
  bridge 2's route B is assembled below." Severity: **major→must-fix** (load-bearing). This is an
  honest, well-documented admission rather than a deceptive `-- will fix later` — credit for the
  transparency — but per the auditor mandate an admission that a load-bearing statement is not
  provable as typed (propped by an instance `sorry`) is treated as a must-fix, not workflow. The
  resolution is a signature change (add the finite-type hypothesis), already named in the comment.

## Severity summary

- **must-fix-this-iter**: 2 — `AbelianVarietyRigidity.lean:237` (JacobsonSpace instance `sorry` on an
  as-typed-unprovable statement) and `:172` (per-point slice-constancy `sorry`, same missing
  finite-type hypothesis). Both block their declarations until the chain signature gains the
  finite-type hypothesis.
- **major**: 1 — stale "lone residual sorry" docstrings (now two chain sorries).
- **minor**: 3 — two long-line lints + two stale historical/section docstrings.
- **excuse-comments**: 1 (also counted under must-fix; honestly documented, but the underlying
  as-typed-unprovability is the must-fix).

Overall verdict: The iter-160 globalisation connective `morphism_eq_of_eqAt_closedPoints` is sound
and genuinely `sorry`-free, but the two new sorries it feeds (`rigidity_eqAt_closedPoint_of_proper_into_affine`
and the in-body `JacobsonSpace := sorry`) both rest on a finite-type hypothesis the frozen chain
signature lacks — honestly flagged in-code, not axiom-laundering, but must-fix because they prop up
statements not provable as literally typed; the "lone residual sorry" docstrings are now stale (the
chain holds two sorries, not one).
