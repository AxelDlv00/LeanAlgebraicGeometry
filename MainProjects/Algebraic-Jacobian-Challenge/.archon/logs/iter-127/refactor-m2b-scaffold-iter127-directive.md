# Refactor Directive

## Slug
m2b-scaffold-iter127

## Iter
127

## Problem

The genus-stratified body of the foundational `nonempty_jacobianWitness` (per STRATEGY.md § Decomposition + § M2):

```
theorem nonempty_jacobianWitness ... := by
  by_cases h : AlgebraicGeometry.genus C.left = 0
  · exact ⟨genusZeroWitness C h⟩       -- closed by milestone M2
  · exact ⟨positiveGenusWitness C ...⟩  -- closed by milestone M3
```

requires a named `genusZeroWitness` builder. The iter-126 plan committed iter-127 to scaffold this builder as a project declaration in `Jacobian.lean`, with a `sorry` body whose closure is gated on the iter-129+ shared cotangent-vanishing pile (specifically, the `isAlbaneseFor` field's substantive content via `rigidity_over_kbar`).

This is a **pure scaffold refactor**: introduce the named declaration with `sorry` body so that downstream M2 closure work (iter-129+) has a fixed API target to close. It is NOT prover work; do not attempt to close the body.

## Mathematical Justification

Given a smooth proper geometrically irreducible curve `C : Over (Spec (.of k))` of `genus C = 0`, the genus-0 Albanese variety of `C` is `Spec k` itself — i.e. the terminal object `𝟙_ (Over (Spec (.of k)))` — with its trivial group-scheme structure, smoothness of relative dimension 0, properness, and geometric irreducibility (the last is already proven in the project as `AlgebraicGeometry.geometricallyIrreducible_id_Spec k` at `Jacobian.lean:120-126`).

The `isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), IsAlbanese C P (𝟙_ _)` field of the witness encodes the universal property:
- The universal morphism `α : C ⟶ 𝟙_ _ = Spec k` is the structural map `toUnit C : C ⟶ 𝟙_ _` (terminal-arrow); this is forced by the universal property of terminal objects in `Over (Spec (.of k))`.
- For any `f : C ⟶ A` with `P ≫ f = η[A]` (i.e. `f` sends the marked point `P` to the identity element of `A`), the unique `g : 𝟙_ _ ⟶ A` such that `f = toUnit C ≫ g` exists and equals `η[A]` itself; the conclusion `f = toUnit C ≫ η[A]` is exactly the conclusion of `rigidity_over_kbar` (after a base-change-to-`k̄` + Galois-descent step, or directly via the over-k rigidity alternative if the iter-127 mathlib-analogist consult confirms it). Note: the conclusion `f = toUnit C ≫ η[A]` makes `f` factor through `toUnit C`, with the unique such `g = η[A]`.
- The vacuity case ($C(k) = \emptyset$) is not a separate branch here: the `isAlbaneseFor` field is **universally quantified** over `P : 𝟙_ _ ⟶ C`, so given any such `P` we MUST construct the universal data. If no `P` exists (Brauer–Severi conics over $\mathbb Q$), the universal-quantifier is vacuously satisfied at the type level.

The `J := 𝟙_ _` choice is determined uniquely (up to iso) by the universal property and is the standard model in the literature. `Spec k` is mathematically self-evident as the genus-0 Albanese.

## Changes Requested

### Option A (preferred): single declaration `genusZeroWitness` in `Jacobian.lean`

Add the following declaration to `AlgebraicJacobian/Jacobian.lean`, after the existing `JacobianWitness` structure (around line 161) and BEFORE the `nonempty_jacobianWitness` theorem (line 176). The exact insertion point can be your choice; put it before `nonempty_jacobianWitness` so the body restructure (iter-150+) can reference it cleanly.

```lean
/-- The Albanese witness for a smooth proper geometrically irreducible curve `C`
of genus `0` over `k`. The underlying scheme is `Spec k` (the terminal object), with
the trivial group structure, smoothness of relative dimension `0` (matching the
hypothesis `genus C = 0`), properness, and geometric irreducibility. The
`isAlbaneseFor` field encodes the universal property: for every $k$-rational
marked point `P` of `C`, the universal morphism `C ⟶ Spec k` is the unique
terminal map `toUnit C`; the substantive content is the rigidity statement
`rigidity_over_kbar` (M2.a; `AlgebraicJacobian.RigidityKbar`), gated on the
shared cotangent-vanishing pile (iter-129+).

**Status**: iter-127 scaffold — body is `sorry`. The body closure is iter-138+
work, after pieces (i)+(ii)+(iii) of the shared cotangent-vanishing pile land. -/
noncomputable def genusZeroWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (h : genus C = 0) :
    JacobianWitness C :=
  sorry
```

This is the simplest scaffold: a single declaration with a single `sorry` body.

### Option B (more granular): field-level scaffold

If you (the refactor agent) can fill the EASY fields in-body (using only Mathlib idioms / already-defined project declarations like `geometricallyIrreducible_id_Spec`), do so. The likely-fillable fields:

- `J := 𝟙_ _` (concretely; this is `Over.mk (𝟙 (Spec (.of k)))` if needed).
- `geomIrred := geometricallyIrreducible_id_Spec k` (already defined at `Jacobian.lean:120-126`; if this doesn't typecheck directly under the `(𝟙_ _).hom = 𝟙 (Spec ...)` interpretation, use `inferInstance` or rewrite via the terminal-object characterization).

The HARDER fields (likely require `sorry`):
- `grpObj : GrpObj (𝟙_ _)` — Mathlib may or may not have a `GrpObj` instance on the terminal of `Over (Spec (.of k))`; verify via `lean_loogle` / `lean_leansearch`. Falling back to `sorry` is acceptable if not found.
- `proper : IsProper (𝟙_ _).hom` — for `(𝟙_ _).hom : 𝟙_ _ ⟶ Spec (.of k)` which is `𝟙 (Spec (.of k))` (or equivalent); `IsProper (𝟙 _)` should be a Mathlib instance via `IsClosedImmersion.isProper` or similar.
- `smooth : Smooth (𝟙_ _).hom` — same, `Smooth (𝟙 _)` should be a Mathlib instance.
- `smoothGenus : SmoothOfRelativeDimension (genus C) (𝟙_ _).hom` — uses `h : genus C = 0`; after `rw [h]`, the goal is `SmoothOfRelativeDimension 0 (𝟙 _).hom`, which should be available via Mathlib.
- `isAlbaneseFor : ∀ P, IsAlbanese ...` — the substantive sorry.

Try Option B if it lands in <30 min of effort; otherwise fall back to Option A.

**Important**: `Option A is acceptable; do not over-invest in Option B if the typeclass-instance search proves elusive.** The goal is the named API anchor, not a complete construction.

### File location

- **Strongly preferred**: extend `AlgebraicJacobian/Jacobian.lean` (no new file). The declaration is intrinsically tied to `JacobianWitness` and `nonempty_jacobianWitness`, both defined in `Jacobian.lean`.
- **Acceptable alternative**: new file `AlgebraicJacobian/GenusZero.lean` with the declaration, imported by `Jacobian.lean` if needed. Choose this only if `Jacobian.lean` would exceed ~250 lines after the addition (currently 226; addition is ~10–30 LOC, so the file should stay under 260 — no need for a split).

### Import

If Option B's body requires `rigidity_over_kbar`, add `import AlgebraicJacobian.RigidityKbar` to `Jacobian.lean`. For Option A (single `sorry`), no new import is required (`AlgebraicJacobian.Genus` import is already present).

### Update protected file (if applicable)

`genusZeroWitness` is **non-protected** (it's a NEW declaration the project introduces for the genus-stratified body decomposition; `archon-protected.yaml` is unchanged).

### Blueprint cross-reference

The plan agent will update `Jacobian.tex` with the informal proof sketch + `\lean{AlgebraicGeometry.genusZeroWitness}` `\begin{theorem}` block in the iter-127 plan phase (inline, not by your dispatch). You do NOT edit the blueprint.

## Affected Files

- `AlgebraicJacobian/Jacobian.lean` — adds 1 new declaration (ca. 10–30 LOC), 1 new sorry under Option A (or 1–2 sorries under Option B).

No cascading breakage. The new declaration is an ADD; no existing declarations are renamed, deleted, or re-signed.

## Expected Outcome

- **Net sorry change**: +1 (Option A) or +1 to +2 (Option B). Project total: 2 → 3 (or 2 → 4).
  - `Jacobian.lean:179` `nonempty_jacobianWitness` (OFF-LIMITS, unchanged).
  - `RigidityKbar.lean:87` `rigidity_over_kbar` (NEW iter-126 scaffold, unchanged).
  - `Jacobian.lean:??` `genusZeroWitness` (NEW iter-127 scaffold — your output).
- **Compilation**: `lake env lean AlgebraicJacobian/Jacobian.lean` succeeds with only the expected `declaration uses 'sorry'` warning(s).
- **`lean_verify`**: every retained declaration in `Jacobian.lean` outside `genusZeroWitness` continues to `lean_verify` to kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`); `genusZeroWitness` itself will `lean_verify` to `sorryAx` per its scaffold body.
- **No new axioms** (per project standing rule + iter-126 user hint).
- **No protected signature changes** (`archon-protected.yaml` unchanged).

Report your work to `task_results/refactor-m2b-scaffold-iter127.md` per the descriptor's logging format.

## Notes for refactor agent

- The structure-level definition syntax `def f : T := { J := ..., grpObj := ... }` is the standard Lean record-construction pattern. The `where`-syntax can also be used.
- If you go with Option B, verify each instance with `lean_diagnostic_messages` after each field; don't try to close them all in one shot.
- The `Jacobian.lean` file is small (226 lines) and stable; you can read it in full before editing.
- The new declaration consumes the existing `JacobianWitness` structure (line 143) without modification.
- This is the THIRD scaffold-style refactor in the iter-125/iter-126/iter-127 sequence (iter-125 = Rigidity refactor; iter-126 = RigidityKbar scaffold + Differentials excise; iter-127 = genusZeroWitness scaffold). Each is a planned plan-phase deliverable.
