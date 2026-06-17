# Lean ↔ Blueprint Check Report

## Slug
quot039

## Iteration
039

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration (all `\lean{...}`-referenced blocks checked)

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: yes — `(_π : X ⟶ S) ... (_L _F : X.Modules) (_s : S) : Polynomial ℚ`; matches the "function `s ↦ Φ_{F,s} ∈ ℚ[λ]`" prose.
- **Proof follows sketch**: N/A (body is `sorry`; the blueprint notes this is a frozen iter-176 skeleton until graded-Euler-characteristic infrastructure is available)
- **notes**: `\leanok` on the definition block is correct — a sorry is present.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u` contravariant functor, matching the prose.
- **Proof follows sketch**: N/A (frozen iter-176 sorry body)
- **notes**: Blueprint block carries `\leanok`; sorry confirmed at line 165.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `(_V : S.Modules) (_d : ℕ) : (Over S)ᵒᵖ ⥤ Type u`, matching the prose.
- **Proof follows sketch**: N/A (frozen iter-176 sorry body)
- **notes**: Sorry confirmed at line 201.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes (line 225)
- **Signature matches**: yes — `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, matches prose.
- **Proof follows sketch**: N/A (frozen iter-176 sorry body)
- **notes**: Sorry confirmed at line 228.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover}` (chapter: `lem:section_localization_descent_of_cover`)
- **Lean target exists**: yes (line 1627)
- **Signature matches**: yes — takes general-U `Hfr` hypothesis (for every open `U ≤ D(r)`) and concludes `IsLocalizedModule (powers f)` for the global restriction `Γ(M,⊤) → Γ(M,D(f))`.
- **Proof follows sketch**: yes — three fields (`map_units`, `surj`, `exists_of_eq`) match the blueprint's proof outline exactly.
- **notes**: Axiom-clean; blueprint `\leanok` marker is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear}` (chapter: `lem:isLocalizedModule_ringEquiv_semilinear`)
- **Lean target exists**: yes (line 1712)
- **Signature matches**: yes — ring iso `σ`, semilinear `AddEquiv` pair, intertwining `R'`-linear `h`, concludes `IsLocalizedModule (S.map σ) h`.
- **Proof follows sketch**: yes — three fields transported across the semilinear pair as described.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_restrictScalars_powers_algebraMap}` (chapter: `lem:isLocalizedModule_restrictScalars_powers_algebraMap`)
- **Lean target exists**: yes (line 1762)
- **Signature matches**: yes — `R`-algebra `Rr`, localization at `powers (algebraMap R Rr f)` descends to `powers f` after `restrictScalars R`.
- **Proof follows sketch**: yes.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackTopIso}` (chapter: `lem:pullback_gamma_top_iso`)
- **Lean target exists**: yes (line 1843)
- **Signature matches**: yes — `Γ((pullback f).obj M, ⊤) ≅ Γ(M, f.opensRange)`.
- **Proof follows sketch**: yes.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaImageRingEquiv}` (chapter: `def:gamma_image_ring_equiv`)
- **Lean target exists**: yes (line 1857)
- **Signature matches**: yes — `Γ(X,V) ≃+* Γ(Y, j ''ᵁ V)`.
- **Proof follows sketch**: N/A (definition).
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_semilinear}` (chapter: `lem:gamma_pullback_image_iso_hom_semilinear`)
- **Lean target exists**: yes (line 1867)
- **Signature matches**: yes — σ_V-semilinearity of the section transport hom.
- **Proof follows sketch**: yes.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent}` (chapter: `lem:section_localization_descent`)
- **Lean target exists**: **no** — this declaration does not exist in the Lean file at all.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The blueprint at line 3897 already carries a NOTE acknowledging the decl does not yet exist and is the genuine remaining content of gap1. This is a known planned-not-yet-created gap, not an abandoned decl. See **Red flags** below for the stale proof-sketch concern.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` (chapter: `lem:qcoh_affine_isIso_fromTildeΓ`)
- **Lean target exists**: **no** — does not exist in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Also a known planned-not-yet-created gap; acknowledged in the blueprint NOTE at line 3991.

---

## Red flags

### Stale `\lean{...}` hints pointing at non-existent decls
Two `\lean{...}` hints reference declarations that do not yet exist in the Lean file:

- `lem:section_localization_descent` (blueprint line 3888):  
  `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent}`  
  → The Lean file does not contain this declaration. The blueprint already annotates this (NOTE at line 3897). The `\leanok` marker is **absent** (the block has no `\leanok`), which is correct — no sorry is present for this decl.

- `lem:qcoh_affine_isIso_fromTildeΓ` (blueprint line 3989):  
  `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}`  
  → Similarly absent from the Lean file, similarly acknowledged in the blueprint.

These are not renamed/abandoned decls; they represent future proof obligations that the blueprint pre-documents. No `\leanok` is claimed for either, so no incorrect marker is in play. **Not blocking.**

---

## Unreferenced declarations (informational)

The following declarations added this iteration have **no** `\lean{...}` reference in any blueprint block. These are the three items the directive flags as DAG-unmatched coverage debt:

### 1. `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_basicOpen_cover` (line 1665)
A variant of `lem:section_localization_descent_of_cover` where `Hfr` is supplied only for **basic opens** `D(s) ≤ D(r)` rather than every open `U ≤ D(r)`. The Lean comment explains this is the **instantiable** form: the per-element P1 transport only produces a localization on basic opens of the affine slice `Spec R_r`, while the sheaf-gluing engines (`descent_surj`, `descent_smul_eq_zero`) only ever consult `Hfr` at basic opens `D(r)` and overlaps `D(r)·D(r')`.

**Proposed blueprint label**: `lem:section_localization_descent_of_basicOpen_cover`  
**Depends on**: `lem:map_units_restrict_basicOpen`, `lem:existsUnique_gluing_mathlib`, `lem:eq_of_locally_eq_mathlib` (same as `lem:section_localization_descent_of_cover`); the proof is a thin wrapper around `descent_surj` and `descent_smul_eq_zero` re-fed with basic-open hypotheses.  
**Role**: This is the form `lem:section_localization_descent` will actually instantiate (replacing the general-U `_of_cover` reference in the current proof sketch).

### 2. `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_powers_transport` (line 1905)
The *combined* bridge (I)+(II): chains `isLocalizedModule_of_ringEquiv_semilinear` (bridge I) with `isLocalizedModule_restrictScalars_powers_algebraMap` (bridge II) into a single transport lemma. Given a ring-iso `σ : S ≃+* A`, a localization `g` at `powers f'` over `S`, σ-semilinear `AddEquiv` pair, and an `A`-linear intertwining map `h`, the `restrictScalars R` of `h` is `IsLocalizedModule (powers f)` over `R`.

**Proposed blueprint label**: `lem:isLocalizedModule_powers_transport`  
**Depends on**: `lem:isLocalizedModule_ringEquiv_semilinear`, `lem:isLocalizedModule_restrictScalars_powers_algebraMap` (both already in blueprint)  
**Role**: The combined chaining lemma that turns P1's `IsIso fromTildeΓ` (on the slice `Spec R_r`) + section isos into the `R`-linear `Hfr` data the cover-form descent consumes. The blueprint's NOTE at line 3768–3782 describes this chaining in prose but has no dedicated block for the combined form.

### 3. `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_iso` (line 1936)
Iso-invariance of `IsIso M.fromTildeΓ`: if `M ≅ M'` as modules on `Spec R` and `M.fromTildeΓ` is an iso, then so is `M'.fromTildeΓ`. Proved in two lines via `isIso_fromTildeΓ_iff` and `Functor.essImage.ofIso`.

**Proposed blueprint label**: `lem:isIso_fromTildeΓ_of_iso`  
**Depends on**: `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (already in blueprint as `lem:isIso_fromTildeΓ_iff`)  
**Role**: Transports the P1 `IsIso fromTildeΓ` for the iterated-pullback module across `pullbackComp` coherences to the single composite open immersion pullback. Used in the Hfr production chain but not yet wired into the named descent proof.

---

## Blueprint adequacy for this file

### Coverage
Of the declarations that represent substantive mathematical content in this file, approximately 28 have corresponding `\lean{...}` pins in the blueprint. The three new decls above are the unmatched ones. All other substantive decls are blueprinted.

### The `lem:section_localization_descent` proof sketch is stale (major)

**The problem**: The proof of `lem:section_localization_descent` (blueprint lines 3949–3985) says:

> "It suffices to produce the per-cover-element localization data Hfr of **`lem:section_localization_descent_of_cover`**: for every open U ≤ D(r)..."  
> "Feeding Hfr and the cover to **`lem:section_localization_descent_of_cover`** yields..."

This routes the assembly through the **general-U** `_of_cover` form (hypothesis: every open `U ≤ D(r)`). But the prover has established that this form cannot be instantiated for quasi-coherent `M`: the per-element P1 transport only produces a localization on **basic opens** of the affine slice `Spec R_r`, not on arbitrary opens. The general-U hypothesis is too strong to discharge.

The **actual route** uses `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` (basic-open form, hypothesis: only basic opens `D(s) ≤ D(r)`), which is instantiable precisely because the sheaf-gluing engines only consult `Hfr` at basic opens and overlaps `D(r·r') = D(r) ⊓ D(r')`.

**Consequence**: A prover following the current proof sketch would attempt to produce Hfr for every open `U ≤ D(r)`, hit the quasi-compactness wall for non-basic opens, and get stuck. The proof sketch must be updated to:
1. Add `lem:section_localization_descent_of_basicOpen_cover` to the `\uses` chain (replacing `lem:section_localization_descent_of_cover` as the descent to instantiate)
2. Update lines 3958–3962 and 3978–3979 to route through `_of_basicOpen_cover` and state that `Hfr` need only hold at basic opens `D(s) ≤ D(r)`
3. Optionally keep `lem:section_localization_descent_of_cover` in `\uses` as an intermediate step if the proof goes general-U → basic-open (but this is unnecessary; the basic-open form is a direct build)

The `\uses` at line 3889 and 3950 both reference `lem:section_localization_descent_of_cover` without the basic-open form — these need updating once `lem:section_localization_descent_of_basicOpen_cover` is added to the blueprint.

### Proof-sketch depth: **under-specified** for `lem:section_localization_descent`
The above constitutes under-specification: the sketch names the wrong descent form and would send a prover down a dead end. All other proof sketches checked are adequate.

### Hint precision: **loose** for `lem:section_localization_descent`
The proof-body `\uses` at line 3950 does not include `lem:section_localization_descent_of_basicOpen_cover` (which does not yet have a blueprint block) or `lem:isLocalizedModule_powers_transport`. It also omits `lem:isIso_fromTildeΓ_of_iso`, though that omission is less impactful given the decl's triviality.

### Generality: matches need
No generality issues found. All decls are at the right level.

### Recommended chapter-side actions

1. **Add block `lem:section_localization_descent_of_basicOpen_cover`** for `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` — the instantiable variant. State that `Hfr` need only hold for basic opens `D(s)` contained in cover members. Note that the general-U `_of_cover` form is also axiom-clean but its `Hfr` hypothesis cannot be discharged for arbitrary quasi-coherent `M` (only for globally-presented ones).

2. **Add block `lem:isLocalizedModule_powers_transport`** for `isLocalizedModule_powers_transport` — the combined (I)+(II) chaining lemma. The blueprint currently documents the two components separately; the combined form is the thing the Hfr production step actually calls.

3. **Add block `lem:isIso_fromTildeΓ_of_iso`** for `isIso_fromTildeΓ_of_iso` — minimal, one `\lean{...}` line with a two-sentence statement suffices.

4. **Update `lem:section_localization_descent` proof sketch** (lines 3958–3979) to route through `_of_basicOpen_cover` instead of `_of_cover`, and update the `\uses` in both the lemma block (line 3889) and its proof block (line 3950) to include the correct variant.

---

## Severity summary

| Finding | Severity |
|---|---|
| `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` not in blueprint | **major** |
| `isLocalizedModule_powers_transport` not in blueprint | **major** |
| `isIso_fromTildeΓ_of_iso` not in blueprint | **minor** |
| Proof sketch of `lem:section_localization_descent` routes through general-U `_of_cover` (dead end for QCoh M); should route through `_of_basicOpen_cover` | **major** |
| `lem:section_localization_descent` `\uses` chain missing `_of_basicOpen_cover` and `isLocalizedModule_powers_transport` | **major** |
| `lem:section_localization_descent` `\lean{...}` pin points at not-yet-existing decl (known gap, documented in blueprint NOTE) | informational |
| `lem:qcoh_affine_isIso_fromTildeΓ` `\lean{...}` pin points at not-yet-existing decl (known gap, documented) | informational |

**Overall verdict**: The three new feeder decls (`isLocalizedModule_basicOpen_descent_of_basicOpen_cover`, `isLocalizedModule_powers_transport`, `isIso_fromTildeΓ_of_iso`) are axiom-clean and correct, but the first two are unblueprinted. The more actionable issue is that the proof sketch of `lem:section_localization_descent` directs assembly through the general-U `_of_cover` form, which the prover has established is not instantiable for quasi-coherent M; the sketch must be updated to the basic-open form before a prover attempts to close `isLocalizedModule_basicOpen_descent`. No must-fix-this-iter issues exist for currently formalized declarations — all four frozen scaffold stubs carry authorized sorries, and the axiom-clean proofs match their signatures.
