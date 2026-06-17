# Recommendations for the next plan-agent iteration

## TL;DR

Iteration 0 (this session) produced a verified gap report. **No protected
sorry can be closed without first building infrastructure.** The plan
agent should pick exactly *one* of three independent tracks for
iteration 1, and should NOT re-attempt any of the 9 protected
declarations directly. Refactor directives are likely to introduce
new files and a new blueprint chapter.

## Closest-to-completion targets (priority for next plan iteration)

### Track A — Helper H1 (rigidity for morphisms of abelian varieties)
**Location:** new file, e.g. `AlgebraicJacobian/Rigidity.lean`.
**Statement** (from `task_results/AbelJacobi.md`):
```lean
theorem AlgebraicGeometry.GrpObj.eq_of_eqOnOpen
    {k : Type u} [Field k]
    {X Y : Over (Spec (.of k))}
    [SmoothOfRelativeDimension n X.hom] [IsProper X.hom] [GeometricallyIrreducible X.hom]
    [GrpObj X]
    [SmoothOfRelativeDimension m Y.hom] [IsProper Y.hom] [GeometricallyIrreducible Y.hom]
    [GrpObj Y]
    (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
    (h : ∀ x ∈ U, g₁.left.base x = g₂.left.base x) :
    g₁ = g₂
```
**Why it is the highest-leverage standalone target:**
- Provable from current Mathlib alone (uses
  `Mathlib/AlgebraicGeometry/Group/Abelian.lean` Stacks 0BFD plus
  standard scheme-theoretic properness/irreducibility lemmas).
- Independently unlocks the **uniqueness half** of
  `exists_unique_ofCurve_comp` (the existence half still needs Phase
  C/E).
- Fits inside one new file with one new blueprint sub-section; no
  refactor of existing protected files needed.
**Risk:** the Mumford-style proof is non-trivial (image of a proper
irreducible into a separated scheme is closed irreducible; the equaliser
of two morphisms into a separated scheme is closed; subgroup scheme
equal to ambient on a non-empty open implies equal everywhere). Each
sub-step is in Mathlib but assembling them is multi-iteration.

### Track B — Phase A step 1 (`HasSheafCompose` instance)
**Location:** new file, e.g. `AlgebraicJacobian/Cohomology/SheafCompose.lean`.
**Statement** (from `task_results/Genus.md`):
```lean
instance (X : TopCat) :
    (TopologicalSpace.Opens.grothendieckTopology X).HasSheafCompose
      (CategoryTheory.forget₂ CommRingCat RingCat ⋙
       CategoryTheory.forget₂ RingCat AddCommGrpCat) := sorry
```
**Why:** First step in the 5-step chain that makes `genus` definable.
Once it lands, Helper 4 (`Scheme.structureAddCommGrpSheaf`) becomes a
~20-line definition.
**Caveat:** Step 2 (`HasSheafify (Opens.gT X) AddCommGrpCat`) is the
hardest in the chain — should be handled by a separate sub-task; but
even partial progress here makes the gap visible to Mathlib upstream
maintainers.

### Track C — Phase B/C step 1 (`Scheme.LineBundle`)
**Location:** new file, e.g. `AlgebraicJacobian/Picard/LineBundle.lean`.
**Statement** (from `task_results/Jacobian.md`):
```lean
def AlgebraicGeometry.Scheme.LineBundle (X : Scheme) : Type _ := sorry
noncomputable instance (X : Scheme) :
    CommGroup (AlgebraicGeometry.Scheme.LineBundle X) := sorry
def AlgebraicGeometry.Scheme.Pic (X : Scheme) : Type _ :=
  AlgebraicGeometry.Scheme.LineBundle X
def AlgebraicGeometry.Scheme.Pic.pullback {X Y : Scheme} (f : X ⟶ Y) :
    AlgebraicGeometry.Scheme.Pic Y →* AlgebraicGeometry.Scheme.Pic X := sorry
```
**Why:** Smallest self-contained Phase C step (no cohomology dependency,
only quasi-coherent-sheaf machinery via `AlgebraicGeometry.Scheme.Modules`).
Seeds steps 2–6 of the Jacobian gap chain.

## Recommended single track for iteration 1

**Track A (rigidity)** is the recommended next iteration because:
- It is the *only* track that produces a verifiable theorem closure (no
  upstream sub-sorries introduced).
- It is independent of `Jacobian C`, so progress is measurable in the
  same iteration even if `exists_unique_ofCurve_comp` itself stays
  blocked.
- The Mathlib pieces it depends on are all present (Stacks 0BFD,
  `Smooth`, `IsProper`, `GeometricallyIrreducible`).

If parallelism is desired, run Track A and Track C concurrently; defer
Track B (cohomology) to iteration 2 once Tracks A/C have shaken out
naming conventions for new files.

## Promising approaches that need more work

- The `OXAsAddCommGrpSheaf` sketch in `Genus.lean`'s docstring is
  ready-to-instantiate once Helper 1 (HasSheafCompose) lands. Plan
  agent should preserve this sketch in any future refactor.
- The Jacobian module docstring documents the `thm:Pic_representable`
  bundling explicitly; this is the single Phase-C theorem to issue once
  steps 1–6 are in place.

## Targets currently blocked — DO NOT assign to a prover

All 9 protected declarations are blocked by missing Mathlib infrastructure
and **should NOT** appear as direct proof targets in the next
iteration's `PROGRESS.md`:

| Declaration                                     | Block reason                               |
|-------------------------------------------------|--------------------------------------------|
| `AlgebraicGeometry.genus`                       | Phase A (coherent cohomology) absent       |
| `AlgebraicGeometry.Jacobian`                    | Phase C step 4 (Pic⁰ representability) absent |
| `AlgebraicGeometry.Jacobian.instGrpObj`         | Bundled with Jacobian                      |
| `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus` | Joint A + C                       |
| `AlgebraicGeometry.Jacobian.instIsProper`       | Bundled with Jacobian + step 7             |
| `AlgebraicGeometry.Jacobian.instGeometricallyIrreducible` | Bundled with Jacobian + step 9 |
| `AlgebraicGeometry.Jacobian.ofCurve`            | Needs Jacobian + Helper H2                  |
| `AlgebraicGeometry.Jacobian.comp_ofCurve`       | Needs ofCurve                              |
| `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp` | Needs Helpers H1 + H2 + dual AV    |

The plan agent should issue **infrastructure helpers** (Helpers H1–H4
in `task_results/AbelJacobi.md`; the 5-step chain in
`task_results/Genus.md`; the 9-step Phase C scaffold in
`task_results/Jacobian.md`) instead of re-attempting protected
declarations.

## Reusable proof patterns discovered

- **Forbidden-shortcut sanity check.** Before any constant-scheme
  candidate is attempted, the prover should reduce
  `smoothOfRelativeDimension_genus` over that candidate to
  `genus C = 0` (or the equivalent dimensional contradiction). The
  prover did this for `Jacobian C := 𝟙_ _`; the same check rules out
  `𝔸¹_k`, `Spec L`, etc.
- **`lean_run_code` for type-checking sketches.** The prover used
  `lean_run_code` four times to verify (a) `TopCat.Sheaf C X = Sheaf
  (Opens.grothendieckTopology X) C` is `rfl`, (b) the forget composite
  type-checks, (c) `OXAbPresheaf` (without sheaf condition) type-checks.
  This pattern lets the prover discover *exactly* where the type-checker
  refuses, enabling precise gap reporting.
- **Search-trail-as-evidence.** Each task result includes a numbered
  search trail (`lean_local_search`, `lean_leansearch`,
  `lean_loogle`) with one-line summaries. Future review/audit can
  reproduce the gap from the trail without re-running searches.

## Refactor directive guidance for plan agent

If Track A is selected, the plan agent should write a
`REFACTOR_DIRECTIVE.md` requesting:
1. Create `AlgebraicJacobian/Rigidity.lean` with the H1 statement and
   `sorry`.
2. Add a new blueprint chapter `Rigidity.tex` (or a section in
   `AbelJacobi.tex`) for the rigidity theorem with `\lean{...}` hint.
3. Wire the new file into `AlgebraicJacobian.lean` (the umbrella import).

If Track C is selected, similarly:
1. Create `AlgebraicJacobian/Picard/LineBundle.lean` with sorries for
   `LineBundle`, the `CommGroup` instance, `Pic`, and `pullback`.
2. Add a new blueprint chapter `Picard.tex` extracted from §3.1 of
   `Jacobian.tex`.
3. Wire into the umbrella import.

Refactor agent must be careful not to rename / re-sign any of the 9
protected declarations.
