# Lean ↔ Blueprint Check Report

## Slug
quot-iter024

## Iteration
025

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

Only the QuotScheme.lean declarations are checked here; the GradedHilbertSerre.lean
declarations (which this chapter also covers via `% archon:covers`) are out of scope
for this checker instance.

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: yes — `(_π : X ⟶ S) ... (_L _F : X.Modules) (_s : S) : Polynomial ℚ`; blueprint says "function s ↦ Φ_{F,s} ∈ ℚ[λ]" ✓
- **Proof follows sketch**: N/A — body is `sorry`, protected stub by design (known)
- **notes**: Protected by `archon-protected.yaml`; `sorry` is expected until Snapper/graded-Euler infrastructure lands.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u`; blueprint says contravariant functor `(Sch/S)^op → Set` ✓
- **Proof follows sketch**: N/A — body is `sorry`, protected stub by design (known)
- **notes**: Protected stub; `sorry` expected.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u`; blueprint says contravariant functor ✓
- **Proof follows sketch**: N/A — body is `sorry`, protected stub by design (known)
- **notes**: Protected stub; `sorry` expected.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes (line 225)
- **Signature matches**: partial — Lean delivers only `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, whereas the blueprint prose claims smooth, projective, relative dimension `d(r-d)`, tautological quotient, and Plücker embedding. The blueprint itself carries a NOTE at lines 2826–2830 acknowledging this is a "weakened existence skeleton".
- **Proof follows sketch**: N/A — `sorry`, known protected stub
- **notes**: Signature under-delivery is acknowledged in the blueprint NOTE. **Known/informational** for this iter; the full-signature skeleton is iter-177+ work.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (chapter: `def:is_locally_free_of_rank`)
- **Lean target exists**: yes (line 253, namespace `SheafOfModules`)
- **Signature matches**: yes — `(M : X.Modules) (d : ℕ) : Prop` using open cover + free-module isomorphism; blueprint says "locally free of rank d when X admits an open cover {U i} on each of which the restriction is isomorphic to O_{U i}^{⊕d}" ✓
- **Proof follows sketch**: N/A (definition, no proof body in blueprint)
- **notes**: Real definition, axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (chapter: `def:modules_annihilator`)
- **Lean target exists**: yes (line 298)
- **Signature matches**: yes — `(F : X.Modules) : X.IdealSheafData`; uses `IdealSheafData.ofIdeals fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1)` ✓
- **Proof follows sketch**: yes — blueprint says to package via `ofIdeals`, which is exactly what Lean does. The `ofIdeals` trick sidesteps the basic-open coherence that requires `lem:qcoh_section_localization_basicOpen`; the blueprint NOTE at lines 2330–2334 documents this correctly.
- **notes**: `\leanok` in blueprint is correct. Real definition, axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (chapter: `lem:modules_annihilator_ideal_le`)
- **Lean target exists**: yes (line 305)
- **Signature matches**: yes — `(annihilator F).ideal U ≤ Module.annihilator Γ(X, U.1) Γ(F, U.1)`; blueprint says the "always-available (`ofIdeals`) direction of the characterization" ✓
- **Proof follows sketch**: yes — one-line Lean proof `IdealSheafData.ideal_ofIdeals_le _ _`; blueprint says "proved directly in Lean" ✓
- **notes**: `\leanok` in blueprint is correct.

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (chapter: `lem:annihilator_localization_eq_map`)
- **Lean target exists**: yes (line 362, namespace `Module`)
- **Signature matches**: yes — for finitely generated M with `[IsLocalizedModule S f]`, `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)` ✓
- **Proof follows sketch**: yes — the Lean proof (lines 369–422) exactly follows the blueprint's proof strategy: upper inclusion via `mk'_surjective` + common multiplier over generators (lines 388–411), lower inclusion via `Ideal.map_le_iff_le_comap` (lines 412–421); proof is axiom-clean.
- **notes**: `\leanok` in blueprint is correct. Substantive proof.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (chapter: `lem:qcoh_section_localization_basicOpen`)
- **Lean target exists**: **no** — this declaration does not appear anywhere in `QuotScheme.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint carries `% NOTE (iter-024 review)` at lines 2475–2486 correctly documenting this gap. Block is appropriately left without `\leanok`. See dedicated analysis below.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (chapter: `def:schematic_support`)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes — `(F : X.Modules) : Scheme.{u}` = `(annihilator F).subscheme` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` in blueprint is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (chapter: `def:schematic_support_immersion`)
- **Lean target exists**: yes (line 320)
- **Signature matches**: yes — `(F : X.Modules) : schematicSupport F ⟶ X` = `(annihilator F).subschemeι` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` in blueprint is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (chapter: `def:has_proper_support`)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `(f : X ⟶ S) (F : X.Modules) : Prop` = `IsProper (schematicSupportι F ≫ f)` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` in blueprint is correct.

---

## Red flags

### Placeholder / suspect bodies
- `Scheme.hilbertPolynomial` (line 123): `:= sorry` — **known protected stub**, not a red flag for this iter.
- `Scheme.QuotFunctor` (line 161): `:= sorry` — **known protected stub**.
- `Scheme.Grassmannian` (line 198): `:= sorry` — **known protected stub**.
- `Scheme.Grassmannian.representable` (line 225): `by sorry` — **known protected stub**.

No other sorry bodies, no `:= True`/`:= Classical.choice _` suspects, no excuse-comments found.

---

## Unreferenced declarations (informational)

The following declarations in `QuotScheme.lean` have **no `\lean{...}` pin** in the blueprint:

| Declaration | Line | Assessment |
|---|---|---|
| `AlgebraicGeometry.isLocalizedModule_tilde_restrict` | 467 | **Substantive — coverage debt** |
| `AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ` | 510 | **Substantive — coverage debt** |

Both are axiom-clean theorems with multi-line proofs. They are mentioned inside the `% NOTE` of
`lem:qcoh_section_localization_basicOpen` (lines 2479–2480) as identifiers in a comment, but they
have no dedicated `\begin{lemma}...\end{lemma}` block and no `\lean{...}` pin. This is confirmed by
exhaustive grep: neither name appears as a `\lean{...}` argument anywhere in the chapter.

### `AlgebraicGeometry.isLocalizedModule_tilde_restrict`
**Role** (from docstring, line 454–466): For `N : ModuleCat R` and `f : R`, the presheaf
restriction map of the associated sheaf `Ñ = tilde N` from `Γ(Ñ, ⊤)` to `Γ(Ñ, D(f))` exhibits
`IsLocalizedModule (powers f)`. This is the affine Spec-local heart of
`lem:qcoh_section_localization_basicOpen`. The proof (lines 471–490) uses
`IsLocalizedModule.of_linearEquiv_right` to transport the existing Mathlib instance
(`tilde.toOpen`) across the global-sections isomorphism `tilde.isoTop`.

**Recommended label**: `lem:tilde_restrict_isLocalizedModule`

### `AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ`
**Role** (from docstring, line 492–509): For `M : (Spec R).Modules` with `[IsIso M.fromTildeΓ]`
(i.e., `M` in the essential image of `tilde`), the presheaf restriction from `Γ(M, ⊤)` to
`Γ(M, D(f))` is `IsLocalizedModule (powers f)`. This transports
`isLocalizedModule_tilde_restrict` across the presheaf isomorphism induced by `M.fromTildeΓ`.
The proof (lines 514–546) uses `IsLocalizedModule.of_linearEquiv` and
`IsLocalizedModule.of_linearEquiv_right` together with the naturality square of the presheaf map.

**Recommended label**: `lem:restrict_of_isIso_fromTildeGamma_isLocalizedModule`

---

## Keystone block `lem:qcoh_section_localization_basicOpen` — detailed status

### (1) Accuracy of the `% NOTE (iter-024 review)` comment (blueprint lines 2475–2486)

The NOTE is **accurate** on all substantive claims:

- Claim: "the pinned Lean decl `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`
  does NOT yet exist (general scheme X, arbitrary quasi-coherent F)."  
  **Verified**: the declaration does not appear anywhere in `QuotScheme.lean`. ✓

- Claim: "The iter-024 prover built two affine-Spec ingredients axiom-clean —
  `isLocalizedModule_tilde_restrict` (part 2's Spec-local core) and
  `isLocalizedModule_restrict_of_isIso_fromTildeΓ` (affine engine for a sheaf in the essential
  image of `tilde`)."  
  **Verified**: both declarations appear in `QuotScheme.lean` at lines 467 and 510,
  both with complete proofs and no `sorry`. ✓

- Claim: "the general statement is gated on two currently-Mathlib-absent prerequisites: (gap 1)
  the QCoh(Spec R) ≃ Mod R identification `IsQuasicoherent M → IsIso M.fromTildeΓ`... and
  (gap 2) the affine transport U ↦ Spec Γ(X,U)..."  
  **Consistent with code**: the docstring of `isLocalizedModule_restrict_of_isIso_fromTildeΓ`
  (line 507) says "The general quasi-coherent case additionally requires the (currently
  Mathlib-absent) bridge `IsQuasicoherent M → IsIso M.fromTildeΓ`." Gap 1 is confirmed; gap 2
  is implicit in the Spec-level nature of both intermediate theorems (they work over `Spec R`,
  not an arbitrary scheme). ✓

### (2) Pin-without-decl status

The block `lem:qcoh_section_localization_basicOpen` pins
`\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}`, which does not exist.
This is appropriate: leaving the pin in place preserves the dependency graph and the `\uses{}`
wiring for when the declaration eventually lands. The block has no `\leanok`, which is correct.

### (3) Proof-sketch depth for guiding the open formalization

The proof sketch (blueprint lines 2515–2539) outlines:
1. Part 1 via `lem:isLocalization_basicOpen_mathlib` ✓ (Mathlib-backed)
2. Part 2 via: identify U with Spec Γ(X,U) → M|_U ≅ Ñ → transport localization fact

**Adequacy gap**: the sketch does NOT mention the two intermediate theorems
(`isLocalizedModule_tilde_restrict`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`)
that the iter-024 prover had to construct, does NOT flag the `fromTildeΓ` gap within the proof
text (only in the statement NOTE), and does NOT add these as `\uses{}` dependencies. A prover
following only the sketch would encounter these sub-problems cold. This is a **major** blueprint
adequacy gap for the proof sketch of the keystone.

The statement-level `\uses{}` at line 2474 only cites `lem:isLocalization_basicOpen_mathlib`;
it should also cite the two new intermediate results once they have blueprint labels.

---

## Blueprint adequacy for this file

- **Coverage**: 13/13 substantive Lean declarations in `QuotScheme.lean` have a corresponding
  blueprint block OR are protected sorry stubs (12 blocks + 2 unreferenced). Unreferenced
  declarations: 0 pure helpers + **2 substantive** (flagged above). Protected stubs: 4 (all
  `\lean{...}` pinned, `\leanok` marker correct given presence of sorry in statement body).

- **Proof-sketch depth**: **under-specified** for `lem:qcoh_section_localization_basicOpen`.
  The proof sketch names the mathematical steps but omits the two intermediate Lean-level
  theorems the iter-024 prover required, and does not flag the `fromTildeΓ` gap in the proof
  text. All other formalized blocks have sketches matching their Lean proofs.

- **Hint precision**: **precise** for all blocks with existing Lean decls. The one mismatched
  hint (`lem:qcoh_section_localization_basicOpen` pinning a non-existent decl) is correctly
  annotated with a `% NOTE` and no `\leanok`.

- **Generality**: matches need for all formalized declarations.

- **Recommended chapter-side actions**:

  1. **Add a lemma block for `isLocalizedModule_tilde_restrict`** between
     `lem:isLocalization_basicOpen_mathlib` and `lem:qcoh_section_localization_basicOpen`:
     ```latex
     \begin{lemma}\leanok
     [Basic-open restriction of a $\widetilde{N}$-sheaf localizes]
       \label{lem:tilde_restrict_isLocalizedModule}
       \lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}
       \uses{lem:isLocalization_basicOpen_mathlib}
       For $N : \mathrm{ModuleCat}\ R$ and $f \in R$, the presheaf restriction
       map of the associated sheaf $\widetilde{N}$ from global sections
       $\Gamma(\widetilde{N}, \top)$ to $\Gamma(\widetilde{N}, D(f))$ exhibits
       $\mathrm{IsLocalizedModule}(\mathrm{powers}\ f)$ over $R$.
       ...
     \end{lemma}
     ```
     Proof sketch: transport the existing Mathlib instance
     `tilde.toOpen N (D f) : IsLocalizedModule (powers f)` across the global-sections
     isomorphism `tilde.isoTop N : N ≃ₗ Γ(Ñ, ⊤)` using
     `IsLocalizedModule.of_linearEquiv_right`.

  2. **Add a lemma block for `isLocalizedModule_restrict_of_isIso_fromTildeΓ`** immediately
     after the above:
     ```latex
     \begin{lemma}\leanok
     [Basic-open restriction localizes for sheaves in the essential image of $\widetilde{(-)}$]
       \label{lem:restrict_of_isIso_fromTildeGamma_isLocalizedModule}
       \lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}
       \uses{lem:tilde_restrict_isLocalizedModule}
       For $M : (\mathrm{Spec}\ R).\mathrm{Modules}$ with $[\mathrm{IsIso}\ M.\mathrm{fromTildeΓ}]$
       (i.e., $M$ in the essential image of $\widetilde{(-)}$), the presheaf
       restriction $\mathcal{M}(\top) \to \mathcal{M}(D(f))$ is
       $\mathrm{IsLocalizedModule}(\mathrm{powers}\ f)$.
       ...
     \end{lemma}
     ```
     Proof sketch: compose `isLocalizedModule_tilde_restrict` for `N = Γ(M, ⊤)`
     with the component isomorphisms of the presheaf isomorphism induced by `M.fromTildeΓ`
     via `IsLocalizedModule.of_linearEquiv` and `IsLocalizedModule.of_linearEquiv_right`.
     Note the current Mathlib gap: the assumption `[IsIso M.fromTildeΓ]` stands in for
     `IsQuasicoherent M`, which Mathlib does not yet bridge.

  3. **Update `\uses{}` in `lem:qcoh_section_localization_basicOpen`** statement and proof
     blocks to add
     `lem:tilde_restrict_isLocalizedModule, lem:restrict_of_isIso_fromTildeGamma_isLocalizedModule`
     once those blocks exist.

  4. **Expand the proof sketch** of `lem:qcoh_section_localization_basicOpen` to name the
     two intermediate lemmas and flag gap 2 (affine transport / section reconciliation) explicitly
     in the proof text, not only in the `% NOTE`. The current sketch silently elides the
     `fromTildeΓ` gap.

---

## Severity summary

| Finding | Severity |
|---|---|
| `isLocalizedModule_tilde_restrict` has no blueprint block (substantive, axiom-clean decl) | **major** |
| `isLocalizedModule_restrict_of_isIso_fromTildeΓ` has no blueprint block (substantive, axiom-clean decl) | **major** |
| `lem:qcoh_section_localization_basicOpen` proof sketch omits the two new theorems from `\uses{}` and doesn't flag gap 2 in proof text | **major** |
| `Grassmannian.representable` Lean skeleton under-delivers blueprint statement (missing smoothness, relative dimension, Plücker embedding) | **informational** (known protected stub) |

No must-fix-this-iter findings: the two unreferenced declarations are real axiom-clean proofs that
improve coverage, not wrong code; their absence from the blueprint is a documentation gap, not a
correctness bug in the Lean. The keystone pin-without-decl is correctly handled. No excuse-comments,
no weakened-wrong definitions, no unauthorized axioms.

**Overall verdict**: QuotScheme.lean is mathematically sound and the blueprint is structurally accurate, but iter-024 added two substantive affine-Spec stepping-stone theorems (`isLocalizedModule_tilde_restrict` and `isLocalizedModule_restrict_of_isIso_fromTildeΓ`) with no corresponding blueprint blocks — major coverage debt requiring two new lemma blocks and proof-sketch expansion in `lem:qcoh_section_localization_basicOpen`. — 13 declarations checked, 0 red flags (4 known sorry stubs excluded).
