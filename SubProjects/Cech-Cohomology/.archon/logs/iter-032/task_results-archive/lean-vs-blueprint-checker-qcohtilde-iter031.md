# Lean ↔ Blueprint Check Report

## Slug
qcohtilde-iter031

## Iteration
031

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (sections ~L3615–L4095 covering the 01HV/01I8 Route-P blocks)

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections, ..._hom, ..._inv}` (chapter: `lem:qcoh_iso_tilde_sections`)

- **Lean target exists**: yes — all three declarations present at lines 62–86
- **Signature matches**: partial. The blueprint's stated lemma is the *unconditional* form ("let F be a quasi-coherent O_X-module… natural isomorphism F ≅ M̃"), but the Lean declaration is **conditional** on `[IsIso F.fromTildeΓ]`. The `% NOTE:` comment in the blueprint at L3623–3629 explicitly acknowledges this gap.
- **Proof follows sketch**: yes. The blueprint proof (L3661–3665) says "once the counit is known to be an isomorphism, the asserted iso is its inverse (the one-line conditional argument formalized)"; the Lean body is exactly `(asIso F.fromTildeΓ).symm`. The `_hom`/`_inv` simp lemmas are trivially `:= rfl`, consistent with the definitional characterisation in the blueprint.
- **`\leanok` status**: `\leanok` is **absent** from both the statement block (L3615) and the proof block (L3652). The three Lean declarations are axiom-clean. The absence is **deliberate**: the blueprint's stated result is the unconditional quasi-coherent form, which is not yet formalized; `\leanok` is correctly withheld until `lem:isIso_fromTildeGamma_of_quasicoherent` (P4) discharges the conditional hypothesis. The `% NOTE:` records this explicitly.
- **notes**: No red flags. The partial-match is known, documented, and not a blocker for any work that uses the conditional form. The `_hom`/`_inv` simp lemmas have correct `rfl` bodies, appropriate because the definitions are definitional equalities.

---

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` (chapter: `lem:qcoh_iso_tilde_sections_of_presentation`)

- **Lean target exists**: yes — line 71
- **Signature matches**: yes. Blueprint says "an O_X-module F that admits a global presentation (F.Presentation) is isomorphic to tilde(Γ(X,F))". Lean: `(F : (Spec R).Modules) (P : F.Presentation) : F ≅ tilde (moduleSpecΓFunctor.obj F)`.
- **Proof follows sketch**: yes. Blueprint proof (L3699–3706): "A global presentation makes fromTildeΓ an isomorphism (lem:isIso_fromTildeGamma_of_presentation); with IsIso in hand, lem:qcoh_iso_tilde_sections produces the iso as the inverse of the counit." Lean: `haveI := isIso_fromTildeΓ_of_presentation F P; (asIso F.fromTildeΓ).symm` — exact match.
- **`\leanok`**: present on statement (L3674) and proof (L3698). Correct.
- **notes**: clean.

---

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_presentation}` (chapter: `lem:isIso_fromTildeGamma_of_presentation`)

- **Lean target exists**: N/A — this is a Mathlib lemma, not in QcohTildeSections.lean. Blueprint marks it `\mathlibok` (L3712). Correct.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks this `\mathlibok`. The Lean file uses it as `isIso_fromTildeΓ_of_presentation F P` (no local definition needed). Consistent.

---

### `\lean{AlgebraicGeometry.free_isQuasicoherent}` (chapter: `lem:free_isQuasicoherent`)

- **Lean target exists**: yes — line 102 (instance)
- **Signature matches**: yes. Blueprint: "For any index type ι the free O_X-module O_X^(ι) on ι generators is quasi-coherent." Lean: `instance free_isQuasicoherent (ι : Type u) : (SheafOfModules.free.{u} (R := (Spec R).ringCatSheaf) ι).IsQuasicoherent`. Matches.
- **Proof follows sketch**: yes. Blueprint proof says "it is the sheaf tilde(R^(ι))… quasi-coherence is preserved under the isomorphism O_X^(ι) ≅ tilde(R^(ι))." Lean: `(SheafOfModules.isQuasicoherent.{u} ...).prop_of_iso (tildeFinsupp (R := R) ι) inferInstance` — exactly uses quasi-coherence closure under isomorphism + tilde recognition.
- **`\leanok`**: present on statement (L3803). Proof block has no body in the blueprint (one-sentence argument, no explicit proof block), so there is nothing to mark. Correct.
- **notes**: clean.

---

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_subcover}` (chapter: `lem:exists_finite_basicOpen_subcover`) — **THIS ITER'S FOCUS**

- **Lean target exists**: yes — line 149
- **Signature matches**: yes, precisely.
  - Blueprint: "Given U : ι → (Spec R).Opens with ⊔_i U_i = ⊤, there exist n : ℕ, f : Fin n → R, φ : Fin n → ι such that ∀ j, D(f j) ≤ U(φ j) and Ideal.span (range f) = ⊤."
  - Lean: `{ι : Type*} (U : ι → (Spec R).Opens) (hU : ⨆ i, U i = ⊤) : ∃ (n : ℕ) (f : Fin n → R) (φ : Fin n → ι), (∀ j, PrimeSpectrum.basicOpen (f j) ≤ U (φ j)) ∧ Ideal.span (Set.range f) = ⊤`
  - Perfect match.
- **Proof follows sketch**: yes, faithfully.
  - Blueprint sketch (L3854–3865): (1) basic opens form a basis, so refine to basic-open cover; (2) Spec R is quasi-compact, extract finite subcover; (3) finite family covers Spec R ↔ span{fⱼ} = R.
  - Lean proof:
    - Step 1: `PrimeSpectrum.isBasis_iff_nbhd` to find a basic open at each point inside the cover member. ✓
    - Step 2: `isCompact_univ.elim_finite_subcover` for quasi-compactness. ✓
    - Step 3: `PrimeSpectrum.iSup_basicOpen_eq_top_iff` to convert coverage to ideal generation. ✓
  - All three steps match the blueprint sketch. The Lean proof chooses `Finset.equivFin` for index reindexing (not mentioned in the sketch, but a routine bookkeeping detail).
- **`\leanok`**: present on statement (L3825) and proof (L3854). Correct.
- **notes**: clean. The blueprint's `\lean{}` pin is precise and the statement + proof are in full agreement.

---

### `\lean{AlgebraicGeometry.qcoh_localized_sections}` (chapter: `lem:qcoh_localized_sections`) — **DELIBERATELY DEFERRED**

- **Lean target exists**: no — `qcoh_localized_sections` is absent from QcohTildeSections.lean. This is the deliberate deferral documented in the project memory and the Lean file's `## Handoff` section.
- **Signature matches**: N/A (not formalized)
- **Proof follows sketch**: N/A
- **`\leanok`**: absent from both statement and proof blocks. Correct for an unformalized declaration.
- **notes**: The blueprint lemma (L3869–3913) states and sketches the proof that `Γ(D(f), F) = Γ(X, F)_f` as an `IsLocalizedModule` for a quasi-coherent F. See **Blueprint adequacy** section below for depth assessment.

---

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_genSections}` (chapter: `lem:isIso_fromTildeGamma_of_genSections`)

- **Lean target exists**: yes — line 116
- **Signature matches**: yes. Blueprint: "given σ : F.GeneratingSections and τ : (Ker σ.π).GeneratingSections, the counit fromTildeΓ is an isomorphism." Lean: `(F : (Spec R).Modules) (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) : IsIso F.fromTildeΓ`. Exact.
- **Proof follows sketch**: yes. Blueprint proof (L4031–4039): "assemble σ, τ into F.Presentation; feed to lem:isIso_fromTildeGamma_of_presentation." Lean: `have P : F.Presentation := { generators := σ, relations := τ }; exact isIso_fromTildeΓ_of_presentation F P`. Perfect.
- **`\leanok`**: present on statement (L4016) and proof (L4032). Correct.
- **notes**: clean.

---

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections}` (chapter: `lem:qcoh_iso_tilde_sections_of_genSections`)

- **Lean target exists**: yes — line 129
- **Signature matches**: yes. Blueprint: "F ≅ tilde(Γ(X,F)) from σ : F.GeneratingSections and τ : (Ker σ.π).GeneratingSections." Lean: `(F : (Spec R).Modules) (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) : F ≅ tilde (moduleSpecΓFunctor.obj F)`. Exact.
- **Proof follows sketch**: yes. Blueprint: "lem:isIso_fromTildeGamma_of_genSections gives IsIso; then lem:qcoh_iso_tilde_sections gives the iso." Lean: `haveI := isIso_fromTildeΓ_of_genSections F σ τ; (asIso F.fromTildeΓ).symm`. Perfect.
- **`\leanok`**: present on statement (L4042) and proof (L4055). Correct.
- **notes**: clean.

---

### Blueprint-only blocks not yet in Lean (future work — expected absences)

The following `\lean{...}` pins appear in the chapter but have NO corresponding declaration in QcohTildeSections.lean. All lack `\leanok`. These are P2–P4 future targets, correctly absent:

- `lem:qcoh_global_generation` → `AlgebraicGeometry.qcoh_global_generation` (P2, depends on P1)
- `lem:tilde_preserves_kernels` → `AlgebraicGeometry.tildePreservesFiniteLimits` (Mathlib gap or separate file)
- `lem:qcoh_kernel_qcoh` → `AlgebraicGeometry.qcoh_kernel_qcoh` (P3, depends on P1+P2)
- `lem:isIso_fromTildeGamma_of_quasicoherent` → `AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent` (P4, unconditional 01I8 instance)

---

## Red flags

None found in the Lean file.

### Placeholder / suspect bodies
None. All axiom-clean, no `:= sorry`, no `:= True`, no suspect Classical.choice.

### Excuse-comments
None. The file's `## Handoff` section and the in-file module docstring accurately document the Mathlib gap and the conditional status; these are architectural notes, not excuse-comments.

### Axioms
None. No `axiom` declarations in the file.

---

## Unreferenced declarations (informational)

All 8 declarations in QcohTildeSections.lean are `\lean{...}`-referenced:
`qcoh_iso_tilde_sections`, `qcoh_iso_tilde_sections_hom`, `qcoh_iso_tilde_sections_inv`,
`qcoh_iso_tilde_sections_of_presentation`, `free_isQuasicoherent`,
`isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`,
`exists_finite_basicOpen_subcover`.

No unreferenced declarations.

---

## Blueprint adequacy for this file

### (A) For the 8 formalized declarations

- **Coverage**: 8/8 Lean declarations have a corresponding `\lean{...}` block. 0 unreferenced substantive declarations.
- **Proof-sketch depth**: **adequate** for all 8 formalized blocks. Each blueprint proof matches the Lean argument; sketches were detailed enough for the formalization actually performed.
- **Hint precision**: **precise**. Every `\lean{...}` hint names the exact Lean identifier and the Mathlib predicate used (`IsIso F.fromTildeΓ`, `F.Presentation`, `F.GeneratingSections`, `Ideal.span`, `PrimeSpectrum.basicOpen`).
- **Generality**: matches need for the 8 declarations.

### (B) For `lem:qcoh_localized_sections` (P1) — the unformalized block

The blueprint's proof sketch at L3897–3913 is **under-specified** for formalization at the P1 level. Two sub-gaps are silently elided:

#### P1a — Affine restriction infrastructure (MISSING from sketch)
The sketch says "quasi-coherence provides, over each affine D(fⱼ) = Spec R_{fⱼ}, a presentation of F|_{D(fⱼ)}" (L3900–3904). But the inference chain is not spelled out:

1. `D(fⱼ)` must be identified as an affine open `Spec R_{fⱼ}` — requires `IsAffineOpen.basicOpen_isAffineOpen` or equivalent.
2. The restriction functor `(Spec R).Modules → (Spec R_{fⱼ}).Modules` along the open immersion `Spec R_{fⱼ} ↪ Spec R` must be constructed.
3. `[IsQuasicoherent F]` on `Spec R` (which gives `QuasicoherentData` on a COVERING of Spec R) must yield `[IsQuasicoherent (F|_{D(fⱼ)})]` on `Spec R_{fⱼ}`, and then a `Presentation` for `F|_{D(fⱼ)}` via `qcoh_iso_tilde_sections_of_presentation` applied locally.

Steps 2–3 require affine restriction infrastructure that is absent from Mathlib (`grep` confirms no `IsQuasicoherent` content in `Mathlib/AlgebraicGeometry/` beyond `Modules/Tilde.lean`).

The blueprint's `\uses` (L3871) lists only `lem:exists_finite_basicOpen_subcover` and `lem:qcoh_iso_tilde_sections_of_presentation`, but does NOT capture the implicit dependency on the affine restriction morphism.

#### P1b — `IsLocalizedModule` span-cover patching (MISSING from sketch)
The sketch says "Patching these localisation statements across the finite cover with the sheaf condition for F…shows that the restriction Γ(X,F) → Γ(D(f),F) inverts the powers of f universally, i.e. is an IsLocalizedModule for {f^k}" (L3907–3912).

The Lean formalisation of this "patching" step requires a primitive of the form:
- "Given a finite cover D(f₁),...,D(fₙ) with span{fⱼ} = R, and for each j an `IsLocalizedModule R_{fⱼ} (Γ(X,F) →  Γ(D(fⱼ),F))`, deduce `IsLocalizedModule R_f (Γ(X,F) → Γ(D(f),F))` for any f ∈ R"

This is the `IsLocalizedModule` local-on-span patching — something like `IsLocalizedModule.of_span_cover`. This primitive is absent from Mathlib. The blueprint sketch gestures at it with "Patching…with the sheaf condition" but does not name the required algebraic lemma or confirm whether it exists in Mathlib.

### Recommended chapter-side actions for `lem:qcoh_localized_sections`

A blueprint-writing agent should land the following before P1 is attempted:

1. **Add P1a sub-lemma** (or remark): "Restriction to a basic open yields a quasi-coherent module with a presentation." State precisely which Mathlib morphisms (`AlgebraicGeometry.basicOpenInclusion f`, `Scheme.Modules.pullback`, or equivalent) are used to form `F|_{D(f)}` as a `(Spec R_f).Modules` object, and how `IsQuasicoherent F` on `Spec R` yields `IsQuasicoherent (F|_{D(f)})` (or a `Presentation`) on `Spec R_f`. If this infrastructure is absent from Mathlib, flag it explicitly as a new gap (P1a gap).

2. **Add P1b sub-lemma**: "IsLocalizedModule is local on a spanning cover." State the precise algebraic primitive needed — something like: if `Ideal.span (range fⱼ) = ⊤` and the restriction `Γ(X,F) → Γ(D(fⱼ),F)` is `IsLocalizedModule` at `fⱼ` for each j, then it is `IsLocalizedModule` at f for the monoid `{f^k}`. Reference whether this exists in Mathlib (e.g. as `IsLocalizedModule.of_span_cover` or `IsLocalizedModule.pi`); if absent, flag as a new gap (P1b gap).

3. **Update `\uses`** for `lem:qcoh_localized_sections` to include the P1a and P1b sub-lemmas.

4. **Add `% NOTE:`** on the sketch explaining the two sub-gaps and that the blueprint-recommendation to the planner is to decompose P1 into P1a+P1b before attempting formalization.

---

## Severity summary

| Finding | Severity |
|---|---|
| `lem:qcoh_iso_tilde_sections` — conditional Lean form vs. unconditional blueprint statement | **minor**: documented with `% NOTE:`, not blocking any active work; the `\leanok` is correctly absent pending P4 |
| `lem:qcoh_localized_sections` — blueprint proof sketch silently elides P1a (affine restriction infra) and P1b (IsLocalizedModule span-cover patching), neither of which exists in Mathlib | **must-fix-this-iter**: a prover cannot formalize P1 from the current sketch; the planner must dispatch the blueprint-writing subagent to decompose P1 into P1a+P1b sub-lemmas with explicit Mathlib pointers (or gap flags) before P1 is assigned |

**Overall verdict**: The 8 formalized declarations in QcohTildeSections.lean are clean, axiom-free, and match their blueprint blocks faithfully; the new `exists_finite_basicOpen_subcover` (P0) is in full agreement with the blueprint statement and proof sketch. The sole must-fix is on the blueprint side: `lem:qcoh_localized_sections`'s proof sketch is under-specified for the P1a (affine restriction) and P1b (IsLocalizedModule patching) sub-gaps, and the planner must land a P1a+P1b blueprint decomposition before assigning P1 to a prover.
