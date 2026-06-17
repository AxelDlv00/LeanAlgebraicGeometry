# Lean ↔ Blueprint Check Report

## Slug
flat-iter051

## Iteration
051

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

## Focus declarations (per directive)
- `module_finite_of_ringEquiv_semilinear` (no blueprint block yet)
- `gf_qcoh_finite_sections_of_genSections` → `lem:gf_qcoh_finite_sections_of_genSections`
- `gf_qcoh_fintype_finite_sections` → `lem:gf_qcoh_fintype_finite_sections`

---

## Per-declaration

### `\lean{AlgebraicGeometry.gf_qcoh_finite_sections_of_genSections}` (chapter: `lem:gf_qcoh_finite_sections_of_genSections`)

- **Lean target exists**: yes — line 2612
- **Signature matches**: **no** — blueprint prose says "a quasi-coherent sheaf of modules of **finite type**", implying `[F.IsFiniteType]` is a hypothesis. The Lean signature only carries `[F.IsQuasicoherent]` (no `[F.IsFiniteType]`). The Lean is strictly more general: it requires only quasi-coherence plus an explicit finite generating family `σ` with `[σ.IsFiniteType]`, making the abstract `IsFiniteType` hypothesis superfluous. The blueprint is **over-specified**.
- **Proof follows sketch**: yes — the three-step structure (a) quasi-coherence transport via `isQuasicoherent_pullback_fromSpec`, (b) generating family transport via `GeneratingSections.map`, (c) section comparison via `gammaPullbackImageIso` + semilinear transport with `module_finite_of_ringEquiv_semilinear` matches the proof sketch in the blueprint. Mathematical content is faithful.
- **notes**:
  - `\uses{}` lists `lem:qcoh_section_localization_basicOpen` as a direct dependency but the Lean proof does not call this lemma directly (appears at most transitively); the `\uses{}` list should be updated to replace it with the actual direct deps.
  - `\uses{}` is missing `module_finite_of_ringEquiv_semilinear` (called at step c) and the section-comparison isos `gammaPullbackImageIso` / `gammaPullbackImageIso_hom_semilinear`.

---

### `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` (chapter: `lem:gf_qcoh_fintype_finite_sections`)

- **Lean target exists**: yes — line 2674
- **Signature matches**: yes — blueprint says "quasi-coherent sheaf of modules with F of finite type"; Lean has `[F.IsQuasicoherent] [F.IsFiniteType]`. Exact match.
- **Proof follows sketch**: yes — blueprint proof sketch (cover extraction via `gf_finiteType_affine_finite_cover_generated` → per-patch finiteness via `gf_qcoh_finite_sections_of_genSections` → locality assembly via `gf_finite_sections_of_basicOpen_finite_cover`) matches the Lean proof body exactly.
- **notes**: `\uses{}` includes `lem:gf_qcoh_sections_free_epi` which is not directly called; it is a transitive dependency through `lem:gf_qcoh_finite_sections_of_genSections`. Not wrong (transitive deps in `\uses{}` are acceptable), but marginally misleading.

---

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`) — incidental check

- **Lean target exists**: yes — line 2714
- **Signature matches**: yes — blueprint states the Nitsure §4 theorem (noetherian integral base, finite-type morphism, coherent sheaf → generic flatness). Lean signature matches.
- **Proof follows sketch**: N/A — the Lean proof body ends with `sorry`. The blueprint's statement block has `\leanok` (declaration formalized with a sorry-stub), but the proof block has no `\leanok`. This is the correct and expected state for a theorem that is not yet proved. No issue.
- **notes**: The `sorry` in `genericFlatness` is documented in the file header and proof comments as intentional ("terminates in an honest sorry"). The blueprint markers are consistent: statement `\leanok` is correct (declaration exists), proof block lacks `\leanok` (proof incomplete). Not a red flag.

---

## Red flags

No `axiom` declarations. No suspect bodies (`:= True`, `:= rfl` on non-trivial claims). No excuse-comments on the three focus declarations. The `sorry` in `genericFlatness` is expected and marked correctly.

---

## Unreferenced declarations (informational)

### `module_finite_of_ringEquiv_semilinear` — **should be in blueprint** (major)

Lean lines 2573–2591:
```lean
theorem module_finite_of_ringEquiv_semilinear {R R' : Type*} [CommRing R] [CommRing R']
    {M : Type*} [AddCommGroup M] [Module R M] {M' : Type*} [AddCommGroup M'] [Module R' M']
    (σ : R ≃+* R') (e : M ≃+ M') (he : ∀ (a : R) (x : M), e (a • x) = σ a • e x)
    [Module.Finite R M] : Module.Finite R' M'
```

This is a **substantive new helper**, explicitly noted in the docstring as "project-local" (Mathlib has `Module.Finite.equiv` for same-ring linear transport and `Module.Free.of_ringEquiv` for free transport across a ring iso, but neither covers the ring-iso + semilinear additive iso case). It is called inside `gf_qcoh_finite_sections_of_genSections` at step (c) as the semilinear transport mechanism. The proof is non-trivial. It has no `\lean{...}` reference anywhere in the blueprint chapter. The blueprint's proof sketch for `lem:gf_qcoh_finite_sections_of_genSections` references "a semilinear comparison" but does not give this helper its own block or `\lean{...}` pin.

This should have a named blueprint block (e.g. `lem:module_finite_of_ringEquiv_semilinear`) in the G1 base-case section of the chapter.

---

## Blueprint adequacy for this file

- **Coverage**: 2 of the 3 focus declarations have `\lean{...}` blocks. `module_finite_of_ringEquiv_semilinear` has none. Among all ~200 declarations in the file, the coverage is generally high — this is the one new helper from iter-051 that the blueprint didn't receive a block for.
- **Proof-sketch depth**: adequate for `gf_qcoh_fintype_finite_sections` (proof sketch matches Lean exactly). Under-specified for `gf_qcoh_finite_sections_of_genSections` — the sketch references a "semilinear comparison" in step (c) without naming the semilinear transport lemma, so a prover reading the blueprint would not know `module_finite_of_ringEquiv_semilinear` was needed or that it had to be proved from scratch.
- **Hint precision**: **loose** for `lem:gf_qcoh_finite_sections_of_genSections`. The prose says "of finite type" (implying `IsFiniteType`) when the Lean correctly uses only `IsQuasicoherent` + the generating family. A prover following the blueprint would have imposed an unnecessary `IsFiniteType` hypothesis.
- **Generality**: **too narrow** for `lem:gf_qcoh_finite_sections_of_genSections`. Blueprint describes the lemma as if it requires `[F.IsFiniteType]`; the Lean proves the strictly more general statement (`[F.IsQuasicoherent]` only) that is also needed by `gf_qcoh_fintype_finite_sections`.
- **Recommended chapter-side actions**:
  1. **Fix** the prose for `lem:gf_qcoh_finite_sections_of_genSections`: remove "of finite type" / `[F.IsFiniteType]` from the hypothesis list. The correct statement is: "a quasi-coherent sheaf F, an affine open D, and a finite generating family σ of F|_D."
  2. **Add** a `\begin{lemma}...\end{lemma}` block for `module_finite_of_ringEquiv_semilinear` in the G1 base-case section (before `lem:gf_qcoh_finite_sections_of_genSections`), with `\lean{AlgebraicGeometry.module_finite_of_ringEquiv_semilinear}` and a one-sentence proof sketch ("transport `Module.Finite` via a ring isomorphism σ and a σ-semilinear additive isomorphism e").
  3. **Update** `\uses{}` for `lem:gf_qcoh_finite_sections_of_genSections`: remove `lem:qcoh_section_localization_basicOpen` (transitive only, not direct); add `lem:module_finite_of_ringEquiv_semilinear`.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| Blueprint over-states `[F.IsFiniteType]` as hypothesis of `lem:gf_qcoh_finite_sections_of_genSections`; Lean correctly does NOT require it | **major** |
| `module_finite_of_ringEquiv_semilinear` is a substantive new helper with no `\lean{...}` blueprint block | **major** |
| `\uses{}` for `lem:gf_qcoh_finite_sections_of_genSections` lists `lem:qcoh_section_localization_basicOpen` as direct dep but it is transitive; missing `module_finite_of_ringEquiv_semilinear` | **minor** |
| `gf_qcoh_fintype_finite_sections`: clean match | — |
| `genericFlatness` sorry: expected, blueprint markers consistent | — |

**Overall verdict**: Blueprint over-states one hypothesis for the G1 base-case lemma and is missing the semilinear transport helper block; Lean implementations are correct and more general than the blueprint describes — 3 declarations checked, 2 major findings (both blueprint-side, no Lean errors).
