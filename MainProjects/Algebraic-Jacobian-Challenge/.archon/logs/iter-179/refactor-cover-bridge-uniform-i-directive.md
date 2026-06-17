# Refactor Directive

## Slug
cover-bridge-uniform-i

## Problem

`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:120-160` defines
`gmScalingP1_cover_X_iso (i : Fin 2)` via a `match i with | ⟨0, _⟩ => …
| ⟨1, _⟩ => …`. Two structural defects compound to defeat the chart-bridge
proof chain (`gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
`gmScalingP1_collapse_at_zero`), which now stand only via the temporary
project axioms `gmScalingP1_chart_data_temp` and
`gmScalingP1_collapse_at_zero_temp` (iter-177 HARD STOP corrective —
violates the project's "kernel-only axioms" end-state contract;
iter-181 RETIRE-OR-ESCALATE trigger live in `STRATEGY.md`).

1. **`⟨0, _⟩` vs `(0 : Fin 2)`** — Lean's elaborator does NOT reduce
   `(![X 0, X 1]) ⟨0, _⟩` to `X 0`. The proof `_ : 0 < 2` carried in
   `⟨0, _⟩` is a metavariable at elaboration time; `Matrix.cons_val_zero` /
   `Matrix.cons_val_one` only fire on the canonical `Fin.OfNat` form. So
   each branch of the `match` specialises the iso target type with `X 0` /
   `X 1` instead of the generic `(![X 0, X 1]) i`, breaking the defeq
   chain in `pullback.congrHom` ↔ `pullbackSpecIso`.

2. **Inline `by`-tactic proof closures in `projectiveLineBarAffineCover`** —
   in `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean:175-221`, the
   `f_deg : ∀ i, (![X 0, X 1]) i ∈ 𝒜 1` and `hm : ∀ i, 0 < (![1, 1]) i`
   proofs are inline `(fun i => by fin_cases i <;> simp [...])`. The kernel
   must `whnf` these tactic-built proof closures during defeq, which times
   out at 200k–800k heartbeats (verified iter-178 analogist consult).

Persistent diagnosis at `analogies/gmscaling-cover-bridge.md` (iter-178).

## Mathematical Justification

The Mathlib idiom is correct (`Scheme.AffineOpenCover.openCover_f` returns
`Spec.map _` for `Proj.affineOpenCoverOfIrrelevantLESpan`; the underlying
cover is `Proj.awayι 𝒜 (f i) (f_deg i) (hm i)` by `rfl`). The project's
`match`-on-`i` specialisation is a divergence from the Mathlib pattern.
Refactoring to a uniform-in-`i` definition (a single expression with
`((![X 0, X 1]) i)` in the iso target type, NOT `MvPolynomial.X i`) keeps
the iso construction generic so the `pullbackSpecIso` Mathlib precedent
fires syntactically through `pullback.congrHom`.

Step 1 hoists the inline `by`-tactic proof closures of
`projectiveLineBarAffineCover` to top-level named declarations
(`projectiveLineBarAffineCover_fDeg`, `projectiveLineBarAffineCover_hm`).
This is structurally equivalent — the cover's value is unchanged — but
removes the kernel's need to `whnf` tactic closures during downstream
defeq, which is the second compounding factor.

Step 2 rewrites `gmScalingP1_cover_X_iso` as a SINGLE expression in `i`,
with target type carrying `((![X 0, X 1]) i)` rather than `X i`. After
this rewrite, the downstream lemmas `gmScalingP1_chart_PLB_eq`,
`gmScalingP1_chart_agreement`, `gmScalingP1_collapse_at_zero` become
provable from `pullbackSpecIso_hom_base` + `awayι_comp_PLB_hom`
generically (iter-179 prover lane handles Step 3).

End-state after Steps 1 + 2: GmScaling.lean compiles. The two TEMP project
axioms remain on the books (their consumers are the chart-bridge lemmas
whose bodies are rewritten in Step 3 by the prover, not by this refactor).
The bridge lemma signatures stay the same; only their proofs change in
Step 3.

## Changes Requested

### File: `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`

#### Add two new top-level private declarations IMMEDIATELY BEFORE the existing `projectiveLineBarAffineCover`

```lean
/-- **Per-chart degree-1 homogeneity witness** for the affine cover of
`ProjectiveLineBarScheme` by `D₊(X 0)` and `D₊(X 1)`. Hoisted to top-level
out of the inline `by fin_cases i <;> simp` proof inside
`projectiveLineBarAffineCover` (per `analogies/gmscaling-cover-bridge.md`
Step 1) so the kernel doesn't `whnf` tactic-built proof closures during
downstream defeq in `gmScalingP1`. -/
private noncomputable def projectiveLineBarAffineCover_fDeg
    (kbar : Type u) [Field kbar] :
    ∀ i, (![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar), MvPolynomial.X 1]) i ∈
      projectiveLineBarGrading kbar ((![1, 1] : Fin 2 → ℕ) i) :=
  fun i => by
    fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one,
      MvPolynomial.isHomogeneous_X]

/-- **Positive-degree witness** for the affine cover indexing. Hoisted to
top-level out of the inline `by fin_cases i <;> exact Nat.one_pos` proof
inside `projectiveLineBarAffineCover` for the same defeq reasons as
`projectiveLineBarAffineCover_fDeg`. -/
private lemma projectiveLineBarAffineCover_hm :
    ∀ i, 0 < (![1, 1] : Fin 2 → ℕ) i :=
  fun i => by fin_cases i <;> exact Nat.one_pos
```

#### Replace `projectiveLineBarAffineCover` (currently at L175-221)

Old body:
```lean
noncomputable def projectiveLineBarAffineCover (kbar : Type u) [Field kbar] :
    (ProjectiveLineBarScheme kbar).AffineOpenCover :=
  let f : Fin 2 → MvPolynomial (Fin 2) kbar := ![MvPolynomial.X 0, MvPolynomial.X 1]
  let m : Fin 2 → ℕ := ![1, 1]
  Proj.affineOpenCoverOfIrrelevantLESpan (projectiveLineBarGrading kbar) (m := m) f
    (fun i ↦ by
      fin_cases i <;> simp [f, m, Matrix.cons_val_zero, Matrix.cons_val_one,
        MvPolynomial.isHomogeneous_X])
    (fun i ↦ by fin_cases i <;> simp [m])
    (by classical … ⟨the irrelevant-LESpan proof … unchanged …⟩)
```

New body:
```lean
noncomputable def projectiveLineBarAffineCover (kbar : Type u) [Field kbar] :
    (ProjectiveLineBarScheme kbar).AffineOpenCover :=
  Proj.affineOpenCoverOfIrrelevantLESpan (projectiveLineBarGrading kbar)
    (m := ![1, 1])
    (![MvPolynomial.X 0, MvPolynomial.X 1])
    (projectiveLineBarAffineCover_fDeg kbar)
    projectiveLineBarAffineCover_hm
    (by classical … ⟨the irrelevant-LESpan proof — unchanged, preserve VERBATIM⟩)
```

Keep the existing `by classical … intro p hp … ⟩` irrelevant-LESpan proof
**VERBATIM**; only the first three arguments to
`Proj.affineOpenCoverOfIrrelevantLESpan` are touched.

### File: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`

#### Replace `gmScalingP1_cover_X_iso` (currently at L120-160)

Old (with `match i with | ⟨0, _⟩ => … | ⟨1, _⟩ => …`):
```lean
private noncomputable def gmScalingP1_cover_X_iso (kbar : Type u) [Field kbar] (i : Fin 2) :
    (gmScalingP1_cover kbar).X i ≅
      Spec (CommRingCat.of
        (TensorProduct kbar
          (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
            (MvPolynomial.X i : MvPolynomial (Fin 2) kbar))
          (GmRing kbar))) :=
  match i with
  | ⟨0, _⟩ => …
  | ⟨1, _⟩ => …
```

New (uniform in `i`, target type uses `((![X 0, X 1]) i)`):
```lean
private noncomputable def gmScalingP1_cover_X_iso (kbar : Type u) [Field kbar] (i : Fin 2) :
    (gmScalingP1_cover kbar).X i ≅
      Spec (CommRingCat.of
        (TensorProduct kbar
          (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
            ((![MvPolynomial.X 0, MvPolynomial.X 1] : Fin 2 → MvPolynomial (Fin 2) kbar) i))
          (GmRing kbar))) :=
  pullbackSymmetry _ _ ≪≫
    pullbackRightPullbackFstIso _ _ _ ≪≫
    pullback.congrHom
      (awayι_comp_PLB_hom kbar
        ((![MvPolynomial.X 0, MvPolynomial.X 1] : Fin 2 → MvPolynomial (Fin 2) kbar) i)
        (projectiveLineBarAffineCover_fDeg kbar i))
      (show (Gm kbar).hom =
          Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar))) from rfl) ≪≫
    pullbackSpecIso kbar _ (GmRing kbar)
```

**Why the target type uses `((![X 0, X 1]) i)` and not `X i`**:
this is the whole point of the refactor. `(![X 0, X 1]) i` is exactly
what `(projectiveLineBarAffineCover kbar).openCover.f i` reduces to
(definitionally, via `openCover_f` ∘ `affineOpenCoverOfIrrelevantLESpan`).
The downstream chart-bridge proof bodies (handled by iter-179's prover
lane, NOT this refactor) can then `fin_cases i` LOCALLY at the point of
need with `Matrix.cons_val_zero` / `Matrix.cons_val_one` doing the
splitting — but the iso construction itself stays generic.

### Other touches

The downstream definitions `gmScalingP1_chart kbar i`,
`gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
`gmScalingP1_collapse_at_zero` consume the OLD signature. Specifically
`gmScalingP1_chart` (L175-194) wraps `gmScalingP1_cover_X_iso` to produce
a morphism from `(gmScalingP1_cover kbar).X i` to
`((ProjectiveLineBar kbar) ⊗ Gm kbar).left`, factoring through the
chart-`i` ring map. The new target type uses
`(![X 0, X 1]) i` (the elements of `MvPolynomial (Fin 2) kbar`), so the
chart ring `MvPolynomial Unit kbar ⊗[kbar] GmRing kbar` does NOT change.
You DO need to:

- Update the type of `gmScalingP1_chart` to consume the new target type of
  `gmScalingP1_cover_X_iso` (it currently uses `MvPolynomial.X i`).
  This means changing the `TensorProduct kbar (HomogeneousLocalization.Away …
  (MvPolynomial.X i)) (GmRing kbar)` to `… ((![X 0, X 1]) i) …` in the
  intermediate `Spec` type. After this, `gmScalingP1_chart` should compile
  unchanged in body shape (it's a composition through the iso).

- Verify (by `lean_diagnostic_messages` after each Edit) that the file still
  compiles. The temp axioms `gmScalingP1_chart_data_temp` and
  `gmScalingP1_collapse_at_zero_temp` remain — they reference
  `gmScalingP1_chart`, `(gmScalingP1_cover kbar).f i`, etc., which now use
  the uniform target type but their statement (the existential on the chart
  data) doesn't change syntactically.

If `gmScalingP1_chart` or the temp axioms need re-statement to match the
new target type uniformly, do so (the temp axioms quantify over `i : Fin 2`
already, so the change is just propagating the new target type uniformly —
no statement changes, just type-arg changes).

## Affected Files

- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` — Step 1 (hoist).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — Step 2 (uniform-in-`i`).

NO other consumers should break (the cover's value is unchanged; the iso's
target type uses the same ring up to `((![X 0, X 1]) i) = X i` for concrete
`i`, which is the chart-bridge defeq the refactor unblocks for iter-179's
prover lane).

## Expected Outcome

After Steps 1 + 2:
- `lake build AlgebraicJacobian.Genus0BaseObjects.BareScheme` → green.
- `lake build AlgebraicJacobian.Genus0BaseObjects.GmScaling` → green
  (2 TEMP axioms still on the books; their bodies are NOT yet retired —
  iter-179's prover lane handles Step 3).
- `lake build AlgebraicJacobian` → green.
- File `BareScheme.lean` sorry-count: 2 → 2 (unchanged; honest scaffold
  sorries `projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`
  remain off-target).
- File `GmScaling.lean` sorry-count: 2 → 2 (unchanged; the 2 TEMP project
  AXIOMS remain — Step 3 retires them, not this refactor).

**Do NOT attempt Step 3** (the body retirements of `gmScalingP1_chart_PLB_eq`,
`gmScalingP1_chart_agreement`, `gmScalingP1_collapse_at_zero` that retire
the 2 TEMP axioms). That is the next iter-179 prover lane's job. Your job
ends when the file structurally compiles in the uniform-in-`i` form with
the temp axioms still load-bearing.

## Helper budget

You MAY add the 2 named hoisted declarations
(`projectiveLineBarAffineCover_fDeg` + `projectiveLineBarAffineCover_hm`)
in BareScheme.lean — these are part of Step 1. No other new helpers.

## Hard NOs

- Do NOT attempt to retire the TEMP axioms. They stay until Step 3.
- Do NOT touch `gmScalingP1`'s body (the `Over.homMk` constructor at L291-297).
- Do NOT touch the irrelevant-LESpan proof inside `projectiveLineBarAffineCover`
  (the `by classical … intro p hp …` block) — preserve it verbatim.
- Do NOT touch the `coequifibered` predicate-class shape (different consult).

## Reversal trigger

If after Step 2 a fresh syntactic mismatch surfaces between the uniform iso
target type and `awayι_comp_PLB_hom kbar`'s domain (i.e., `awayι_comp_PLB_hom`
expects a concrete `f` not `((![X 0, X 1]) i)`), fall back to the partial
`Fin.cases` variant: replace the `match i with | ⟨0, _⟩ … | ⟨1, _⟩ …` by
`Fin.cases (motive := …) (case0) (Fin.cases (motive := …) (case1)
Fin.elim0) i`, which produces the canonical `(0 : Fin 2)` index AND keeps
the uniform-in-`i` target type at the iso's level. Empirically verified
to work in the iter-178 consult.

If even that fails, REPORT the failure honestly (do NOT add new helpers,
do NOT add new project axioms). The fallback is the iter-181
RETIRE-OR-ESCALATE escalation pathway.
