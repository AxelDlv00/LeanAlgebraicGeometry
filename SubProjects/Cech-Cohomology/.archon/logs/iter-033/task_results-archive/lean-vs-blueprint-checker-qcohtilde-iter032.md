# Lean ↔ Blueprint Check Report

## Slug
qcohtilde-iter032

## Iteration
032

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks: `lem:qcoh_iso_tilde_sections`, `lem:qcoh_iso_tilde_sections_of_presentation`,
   `lem:exists_finite_basicOpen_subcover`, `lem:isLocalizedModule_of_span_cover`,
   `lem:free_isQuasicoherent`, `lem:isIso_fromTildeGamma_of_genSections`,
   `lem:qcoh_iso_tilde_sections_of_genSections`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections}` (chapter: `lem:qcoh_iso_tilde_sections`)

- **Lean target exists**: yes (line 63)
- **Signature matches**: yes — conditional form `(F : (Spec R).Modules) [IsIso F.fromTildeΓ] : F ≅ tilde (moduleSpecΓFunctor.obj F)`. The blueprint's informal statement says "quasi-coherent F" but the blueprint's own `% NOTE:` comment (lines 3646–3652) explicitly documents this is the conditional form and the unconditional upgrade awaits the 01I8 instance; this discrepancy is fully acknowledged and intentional.
- **Proof follows sketch**: yes — one-liner `(asIso F.fromTildeΓ).symm` matches the blueprint proof "the isomorphism is the inverse of the tilde–Γ counit".
- **notes**: `\leanok` is absent from the statement block in the blueprint, but `sync_leanok` manages this deterministically — not a checker finding.

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_hom}` and `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_inv}` (grouped in `lem:qcoh_iso_tilde_sections`)

- **Lean target exists**: yes (lines 79–81 and 84–87)
- **Signature matches**: yes — `@[simp]` lemmas asserting `.hom = inv F.fromTildeΓ` and `.inv = F.fromTildeΓ`, matching the blueprint grouping.
- **Proof follows sketch**: yes / N/A (trivial `rfl`).

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation}` (chapter: `lem:qcoh_iso_tilde_sections_of_presentation`)

- **Lean target exists**: yes (line 72)
- **Signature matches**: yes — `(F : (Spec R).Modules) (P : F.Presentation) : F ≅ tilde (moduleSpecΓFunctor.obj F)`, matching "an O_X-module F admitting a global presentation is isomorphic to tilde{Γ(X, F)}".
- **Proof follows sketch**: yes — `haveI := isIso_fromTildeΓ_of_presentation F P; (asIso F.fromTildeΓ).symm` exactly implements the blueprint's "a global presentation makes fromTildeΓ an iso via Lemma lem:isIso_fromTildeGamma_of_presentation; then apply lem:qcoh_iso_tilde_sections".
- **notes**: Statement and proof blocks both carry `\leanok`.

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_subcover}` (chapter: `lem:exists_finite_basicOpen_subcover`)

- **Lean target exists**: yes (line 150)
- **Signature matches**: yes — `{ι : Type*} (U : ι → (Spec R).Opens) (hU : ⊔ i, U i = ⊤) : ∃ (n : ℕ) (f : Fin n → R) (φ : Fin n → ι), (∀ j, PrimeSpectrum.basicOpen (f j) ≤ U (φ j)) ∧ Ideal.span (Set.range f) = ⊤`. Matches blueprint: "there exist finitely many f_1, ..., f_n ∈ R and φ : {1,...,n}→ι such that D(f_j) ⊆ U_{φ(j)} and span{f_j} = R".
- **Proof follows sketch**: yes — point-wise basis refinement + quasicompactness (`isCompact_univ.elim_finite_subcover`) + `PrimeSpectrum.iSup_basicOpen_eq_top_iff` matches the blueprint's three-step: basis → refine → unit-ideal criterion.
- **notes**: Statement and proof blocks both carry `\leanok`.

### `\lean{AlgebraicGeometry.isLocalizedModule_of_span_cover}` (chapter: `lem:isLocalizedModule_of_span_cover`)

- **Lean target exists**: yes (line 330)
- **Signature matches**: yes. Full signature is:
  ```
  (g : M →ₗ[R] N) (f : R) {n : ℕ} (s : Fin n → R)
  (hs : Ideal.span (Set.range s) = ⊤)
  (h : ∀ j, IsLocalizedModule (Submonoid.powers f)
        (IsLocalizedModule.map (Submonoid.powers (s j))
          (LocalizedModule.mkLinearMap (Submonoid.powers (s j)) M)
          (LocalizedModule.mkLinearMap (Submonoid.powers (s j)) N) g)) :
  IsLocalizedModule (Submonoid.powers f) g
  ```
  This is an exact realisation of the blueprint's: `g : M → N` R-linear, `f : R`, `s : Fin n → R`, `Ideal.span (Set.range s) = ⊤`, per-`j` hypothesis is `IsLocalizedModule (powers f)` of the `(powers (s j))`-localised induced map `g_{s_j}`, conclusion `IsLocalizedModule (powers f) g`.
  `IsLocalizedModule.map (Submonoid.powers (s j)) (LocalizedModule.mkLinearMap ...) (LocalizedModule.mkLinearMap ...) g` is exactly the induced map on `(s j)`-localisations as described in the blueprint.
- **Proof follows sketch**: yes. The proof structure (lines 338–378) matches the blueprint proof (lines 3971–4011) clause-by-clause:
  - Clause 1 (`map_units`): `f` acts invertibly on `N` — via `bijective_of_localized_span` + `map_smul_endFun`, matching "multiplication by f on N is an isomorphism iff bijective on cover".
  - Clause 2 (surjection): uniform exponent `K = Finset.univ.sup k` and `A = Finset.univ.sup a` matching "Choose a common k = max_j k_j"; assembly via `mem_range_of_span_pow` + partition of unity.
  - Clause 3 (equaliser): analogous `K, A` uniform bounds, `eq_zero_of_span_pow` for vanishing.
  All three match the blueprint's "Each is verified by descent along the spanning cover."
- **notes**: Statement and proof blocks both carry `\leanok`.

### `\lean{AlgebraicGeometry.free_isQuasicoherent}` (chapter: `lem:free_isQuasicoherent`)

- **Lean target exists**: yes (line 103, as an `instance`)
- **Signature matches**: yes — `(ι : Type u) : (SheafOfModules.free.{u} (R := (Spec R).ringCatSheaf) ι).IsQuasicoherent`, matching "for any index type ι the free O_X-module is quasi-coherent".
- **Proof follows sketch**: yes / partial (sketch is one sentence; proof uses `tildeFinsupp` iso + `prop_of_iso`, matching "obtained from the identification of the free O_X-module with the tilde of the free R-module").
- **notes**: Statement block carries `\leanok`.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_genSections}` (chapter: `lem:isIso_fromTildeGamma_of_genSections`)

- **Lean target exists**: yes (line 117)
- **Signature matches**: yes — `(F : (Spec R).Modules) (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) : IsIso F.fromTildeΓ`, matching "given σ : F.GeneratingSections and τ : (Ker σ.π).GeneratingSections, the counit fromTildeΓ is an iso".
- **Proof follows sketch**: yes — `have P : F.Presentation := { generators := σ, relations := τ }; exact isIso_fromTildeΓ_of_presentation F P` matches "the two families assemble into F.Presentation and feed to Lemma lem:isIso_fromTildeGamma_of_presentation".
- **notes**: Statement and proof blocks carry `\leanok`.

### `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections_of_genSections}` (chapter: `lem:qcoh_iso_tilde_sections_of_genSections`)

- **Lean target exists**: yes (line 130)
- **Signature matches**: yes — `(F : (Spec R).Modules) (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) : F ≅ tilde (moduleSpecΓFunctor.obj F)`, matching blueprint.
- **Proof follows sketch**: yes — `haveI := isIso_fromTildeΓ_of_genSections F σ τ; (asIso F.fromTildeΓ).symm` matches "apply isIso_fromTildeΓ_of_genSections then lem:qcoh_iso_tilde_sections".
- **notes**: Statement and proof blocks carry `\leanok`.

---

## Private helpers for `isLocalizedModule_of_span_cover`

All 7 `private` helpers are genuine proof-internal steps with no blueprint `\lean{...}` tags:

| Helper | Role | Blueprint correspondence |
|--------|------|--------------------------|
| `exists_sum_pow_eq_one` | Partition of unity for power family | "there are r_j with Σ r_j s_j^{N_j} = 1" |
| `mem_range_of_span_pow` | Span-cover descent for surjectivity | Assembly step: "f^k y = Σ r_j g(m_j) = g(Σ r_j m_j)" |
| `eq_zero_of_span_pow` | Span-cover descent for vanishing | "locality of being zero on a spanning cover" |
| `map_smul_endFun` | `LocalizedModule.map` vs. `algebraMap` agreement | Internal algebraic coherence for `map_units` clause |
| `bump_eq` | Uniform-exponent arithmetic | "replacing m_j by f^{k-k_j} m_j" — exponent bumping |
| `per_j_surj` | Per-member surjectivity extraction | "surjectivity of g_{s_j} as a localisation yields m_j, a_j, k_j" |
| `per_j_eq` | Per-member equaliser extraction | "equaliser clause gives k_j with f^{k_j} z = 0 in M_{s_j}" |

All are correctly `private`, correctly absent from the blueprint's `\lean{...}` system.

---

## Red flags

None.

- No `:= sorry`, `:= True`, or suspect placeholder bodies anywhere in the file.
- No excuse-comments (`-- TODO replace`, `-- temporary`, `-- placeholder`, `-- wrong but works`).
- No `axiom` declarations in the file.
- No `Classical.choice _` patterns on substantive claims.
- The `Handoff` section (lines 382–427) is informal prose and comments in the module doc, not declarations — no blueprint issue.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` blueprint block but are informational/packaging only:

- `qcoh_iso_tilde_sections_hom` and `qcoh_iso_tilde_sections_inv` — grouped in the same `\lean{...}` block as `qcoh_iso_tilde_sections` at blueprint line 3642–3644. ✓
- All 7 `private` helpers — confirmed genuine internal steps, see above.

The following blueprint blocks (in scope for this chapter section) have **no Lean counterpart yet** (expected gaps, not checker failures):
- `lem:isQuasicoherent_restrict_basicOpen` — explicitly marked P1a in the blueprint `% NOTE:` comment; absent from Mathlib; project-to-build.
- `lem:qcoh_localized_sections` — gated behind P1a.
- `lem:isIso_fromTildeGamma_of_quasicoherent` — future P4 target.
- `lem:qcoh_global_generation`, `lem:tilde_preserves_kernels`, `lem:qcoh_kernel_qcoh` — all future targets downstream of P1a.

---

## Blueprint adequacy for this file

- **Coverage**: 8/8 public Lean declarations have a `\lean{...}` block in the chapter (counting the 3 `qcoh_iso_tilde_sections_*` declarations grouped in one block). The 7 private helpers are internal (acceptable). 0 substantive unreferenced declarations.
- **Proof-sketch depth**: **adequate**. The `isLocalizedModule_of_span_cover` proof sketch is detailed — explicitly works through all three `IsLocalizedModule` clauses, names the uniform-exponent strategy (`max_j k_j`, `max_j a_j`), and the partition-of-unity assembly. The prover could have faithfully formalized each clause directly from the blueprint text.
- **Hint precision**: **precise**. Every `\lean{...}` hint names the correct Lean declaration with the correct Lean name. The per-j hypothesis is spelled out in the blueprint prose ("`IsLocalizedModule (powers f) g_{s_j}` where g_{s_j} is the induced map") with enough specificity to find `IsLocalizedModule.map` as the Lean carrier.
- **Generality**: **matches need**. The blueprint formulates `isLocalizedModule_of_span_cover` with `Fin n → R` indexing and `Ideal.span (Set.range s) = ⊤`, which is exactly what the Lean file uses. No parallel API needed.
- **Conditional vs. unconditional `qcoh_iso_tilde_sections`**: The blueprint's informal statement says "quasi-coherent F" but the `% NOTE:` comment (lines 3646–3652) clearly documents the conditional form and explains why. This is adequate documentation of the gap. The proof block also explains the conditional discharge strategy. **No blueprint inadequacy here.**
- **Recommended chapter-side actions**: None from this check. The `\leanok` sync for `qcoh_iso_tilde_sections` statement block is a `sync_leanok` task, not a blueprint-writer task.

---

## Severity summary

**must-fix-this-iter**: 0

**major**: 0

**minor**: 0 (the `\leanok` absence on `lem:qcoh_iso_tilde_sections` statement is a sync artifact, not a blueprint adequacy or Lean correctness issue)

**Overall verdict**: Clean. All 8 public Lean declarations match their blueprint counterparts exactly; the conditional form of `qcoh_iso_tilde_sections` is correctly documented with a blueprint `% NOTE:` comment; all 7 private helpers are genuine proof-internal steps; the blueprint proof sketch for `isLocalizedModule_of_span_cover` is detailed enough to have guided the formalization faithfully; no red flags of any kind.
