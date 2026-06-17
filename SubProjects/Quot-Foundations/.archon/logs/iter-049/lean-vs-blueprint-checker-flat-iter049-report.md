# Lean ↔ Blueprint Check Report

## Slug
flat-iter049

## Iteration
049

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.gf_affine_finite_standard_subcover}` (lem:gf_affine_finite_standard_subcover, seam 1b)

- **Lean target exists**: yes — lines 2355–2378
- **Signature matches**: yes — blueprint: "affine W, indexed open cover {U i}, ∃ finite t ⊆ Γ(X,W) with Ideal.span t = ⊤ and each D(g) ≤ some U i"; Lean: exactly this, with `hW : IsAffineOpen W`, `U : ι → X.Opens`, `hcov : W ≤ ⨆ i, U i`, output `∃ t : Finset Γ(X, W), Ideal.span (t : Set Γ(X, W)) = ⊤ ∧ ∀ g ∈ t, ∃ i, X.basicOpen g ≤ U i`.
- **Proof follows sketch**: yes — blueprint sketch: basic opens form basis → each cover member refines to basic opens → quasi-compactness extracts finite subfamily → span = ⊤ is coverage. Lean proof uses exactly `IsAffineOpen.exists_basicOpen_le`, `IsAffineOpen.self_le_iSup_basicOpen_iff`, and `Ideal.span_eq_top_iff_finite`.
- **Axiom check**: clean — `{propext, Classical.choice, Quot.sound}` only.
- **Blueprint `\leanok`**: present ✓
- **Notes**: fully matched, no issues.

---

### `\lean{AlgebraicGeometry.gf_finite_gen_iff_free_epi}` (lem:gf_finite_gen_iff_free_epi, seam 1c)

- **Lean target exists**: yes — lines 2390–2403
- **Signature matches**: partial mismatch (see below)
- **Proof follows sketch**: yes — blueprint sketch: "a finite family of sections = an O_Y-linear map O_Y^{⊕I} → F|_Y; generation = surjectivity on every stalk = epi; converse is the same". Lean proof is a two-line `constructor` argument reading off `σ.π` (forward) and `M.freeHomEquiv π` (backward), which is exactly the described bijection.
- **Axiom check**: clean — `{propext, Classical.choice, Quot.sound}` only.
- **Blueprint `\leanok`**: **ABSENT** — blueprint lists `\lean{AlgebraicGeometry.gf_finite_gen_iff_free_epi}` but has no `\leanok` tag, so the blueprint tracking does not record this proof as done even though the Lean proof is axiom-clean.
- **Notes**:
  1. The blueprint states "Let Y be an open of a scheme and F a **quasi-coherent** sheaf of modules." The Lean declaration drops the quasi-coherence requirement entirely and is stated for any `SheafOfModules.{u} R` over an arbitrary Grothendieck topology (category C, topology J). The Lean docstring explains this: "Stated in the abstract SheafOfModules generality so it applies to the sliced restrictions F.over Y." The Lean is strictly more general than the blueprint prose implies; the blueprint's "quasi-coherent" qualification is both unnecessary and misleading.
  2. The Lean statement exposes three typeclass conditions (`HasWeakSheafify J AddCommGrpCat.{u}`, `J.WEqualsLocallyBijective AddCommGrpCat.{u}`, `J.HasSheafCompose …`) that are entirely absent from the blueprint. These are structural requirements on the Grothendieck topology needed for `SheafOfModules.free` to make sense; the blueprint gives no hint of them.
  3. The Lean RHS uses `SheafOfModules.free I` while the blueprint writes `O_Y^{⊕I}`. These are the same object (the free sheaf of modules of rank I), but the Lean name is not mentioned in the blueprint.

---

## Red flags

### Placeholder / suspect bodies
None in the two newly added declarations. The only `sorry` in the file is at line 2526 (body of `genericFlatness`), which is pre-existing and expected.

### Excuse-comments
None on the two new declarations.

### Axioms / Classical.choice on non-trivial claims
None — both declarations are axiom-clean.

---

## Unreferenced declarations (informational)

Both `gf_affine_finite_standard_subcover` and `gf_finite_gen_iff_free_epi` are `\lean{...}`-referenced in the blueprint. No new substantive declarations were added that lack blueprint references.

---

## Blueprint adequacy for this file

### Seam 1b (`lem:gf_affine_finite_standard_subcover`)
- **Coverage**: referenced and `\leanok` present ✓
- **Proof-sketch depth**: adequate — the four-step sketch (`basic-opens form a basis → refine cover → quasi-compactness → span = ⊤`) is a faithful blueprint for the Lean proof.
- **Hint precision**: precise — `\lean{AlgebraicGeometry.gf_affine_finite_standard_subcover}` matches the actual Lean name.
- **Generality**: matches need.
- **Recommended chapter-side actions**: none.

### Seam 1c (`lem:gf_finite_gen_iff_free_epi`)
- **Coverage**: `\lean{...}` present but `\leanok` **absent** — the proof is complete but the blueprint tracking tag is missing.
- **Proof-sketch depth**: adequate (the 5-line proof sketch is correct and sufficient).
- **Hint precision**: loose → wrong in one dimension: the blueprint says "quasi-coherent sheaf" but the Lean proof requires no quasi-coherence; this divergence could mislead a prover into adding an unnecessary `IsQuasicoherent` hypothesis.
- **Generality**: too narrow — the blueprint fixes a scheme Y and a qcoh F, while the Lean proof is a pure `SheafOfModules` result over any Grothendieck topology; the typeclass conditions enabling `SheafOfModules.free` are entirely absent from the blueprint.
- **Recommended chapter-side actions**:
  1. Add `\leanok` to `\begin{lemma}` for `lem:gf_finite_gen_iff_free_epi`.
  2. Replace "a quasi-coherent sheaf of modules" with "a sheaf of modules" (the quasi-coherence assumption is not needed and is not imposed in Lean).
  3. Optionally note that the Lean formulation is in abstract `SheafOfModules` generality over any Grothendieck topology, to explain the typeclass hypotheses visible in the Lean code.

### Seam 1a (`lem:gf_localGenerators_restrict`) — blocked, intentionally absent
- The Lean declaration `AlgebraicGeometry.gf_localGenerators_restrict` does **not exist** in the file; per the directive this is expected (blocked because the `pushforward`/epi route is not available). Blueprint correctly has no `\leanok`.
- Blueprint proof sketch (stalk argument) is detailed and correct; adequacy is fine for when this is eventually landed.

### Assembly (`lem:gf_finiteType_affine_finite_cover_generated`) — blocked, intentionally absent
- The Lean declaration `AlgebraicGeometry.gf_finiteType_affine_finite_cover_generated` does **not exist** in the file; expected (waits on 1a). Blueprint correctly has no `\leanok`.
- Blueprint proof sketch is detailed and references 1a, 1b, 1c correctly.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| Missing `\leanok` on `lem:gf_finite_gen_iff_free_epi` (Lean proof is done but tracking tag absent) | **major** |
| Blueprint says "quasi-coherent sheaf" for seam 1c; Lean requires no quasi-coherence; statement is too narrow | **major** |
| Blueprint omits all three typeclass conditions (`HasWeakSheafify`, `WEqualsLocallyBijective`, `HasSheafCompose`) needed by seam 1c | **major** |
| `SheafOfModules.free I` in Lean vs `O_Y^{⊕I}` in blueprint (same object, unnamed in blueprint) | **minor** |

**Overall verdict**: Both new declarations (`gf_affine_finite_standard_subcover` and `gf_finite_gen_iff_free_epi`) are axiom-clean and their Lean proofs are complete; seam 1b is fully aligned with the blueprint; seam 1c has three blueprint-side defects — missing `\leanok`, an erroneous quasi-coherence requirement, and absent typeclass conditions — all fixable by a single blueprint-writing pass on `lem:gf_finite_gen_iff_free_epi`.
