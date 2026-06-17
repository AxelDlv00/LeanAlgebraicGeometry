# Lean ↔ Blueprint Check Report

## Slug
csi

## Iteration
057

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks `lem:cechBackbone_obj_widePullback`, `lem:widePullback_openImm_inter`,
  `lem:coproduct_distrib_fibrePower`, `lem:cech_backbone_left_sigma`, `lem:pushPull_sigma_iso`,
  `lem:pushPull_leg_sections`, `lem:pushPull_eval_prod_iso`, `lem:cechSection_complex_iso`,
  `lem:cechSection_contractible`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechBackbone_obj_widePullback}` (chapter: `lem:cechBackbone_obj_widePullback`)
- **Lean target exists**: yes — `CechSectionIdentification.lean:151`
- **Signature matches**: yes — both Lean and blueprint say the degree-`p` nerve object is
  `Over.mk (WidePullback.base (fun _ : Fin (p+1) => Sigma.desc 𝒰.f))`.
- **Proof follows sketch**: yes — blueprint says "pure unfolding"; Lean gives `Iso.refl _`.
  Blueprint `\leanok` on statement block is correct.
- **notes**: None.

### `\lean{AlgebraicGeometry.widePullback_openImm_inter}` (chapter: `lem:widePullback_openImm_inter`)
- **Lean target exists**: yes — `CechSectionIdentification.lean:80`
- **Signature matches**: yes — `widePullback X Z g ≅ (⨅ k, (g k).opensRange).toScheme`
  matches "the wide fibre power of open immersions is the intersection open `⨅ k, (g k).opensRange`".
- **Proof follows sketch**: partial — blueprint says "induction on the family, iterating the
  binary case"; Lean instead builds `hom`/`inv` directly from `IsOpenImmersion.lift` and the
  wide-pullback UP, bypassing induction. Mathematical content is identical; proof strategy differs.
- **notes**: The direct construction is arguably more robust than induction. Minor divergence only.

### `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso}` (chapter: `lem:coproduct_distrib_fibrePower`)
- **Lean target exists**: no — no declaration with this name or matching content exists in the
  Lean file. The blueprint carries a `% NOTE: build target` annotation acknowledging this.
- **Signature matches**: N/A — declaration absent.
- **Proof follows sketch**: N/A.
- **notes**: Documented multi-cycle gap. Blueprint correctly marks it as unformalized (no `\leanok`
  on statement). `cechBackbone_left_sigma` carries a `sorry` depending on this gap.

### `\lean{AlgebraicGeometry.cechBackbone_left_sigma}` (chapter: `lem:cech_backbone_left_sigma`)
- **Lean target exists**: yes — `CechSectionIdentification.lean:185`
- **Signature matches**: yes — `(coverCechNerveOver 𝒰).obj (op [p]) ≅ ∐ fun σ => Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))` matches blueprint prose.
- **Proof follows sketch**: N/A — body is `:= sorry`. Honest gap (depends on the unformalized
  `lem:coproduct_distrib_fibrePower`).
- **notes**: Blueprint `\leanok` on statement at line 7661 (sorry present = statement formalized,
  per convention). Spec is correct.

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes — `CechSectionIdentification.lean:234`
- **Signature matches**: yes — product decomposition of `pushPullObj F Y_p` over multi-indices
  matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry`. Honest gap (depends on `lem:cech_backbone_left_sigma`).
- **notes**: Blueprint `\leanok` on statement at line 7707 is correct.

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes — `CechSectionIdentification.lean:272`
- **Signature matches**: yes — `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ⊓ V, F)` matches.
- **Proof follows sketch**: yes — three-step chain (pushforward rfl; restrictFunctorIsoPullback;
  eqToIso on image-preimage) matches blueprint's three-step description.
- **notes**: Proof is axiom-clean (no sorry). Blueprint `\leanok` is on statement block;
  proof block does NOT yet carry `\leanok` — sync_leanok should add it in a subsequent run once
  the declaration verifies clean.

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes — `CechSectionIdentification.lean:321`
- **Signature matches**: yes — `Γ(V, pushPullObj F Y_p) ≅ ∏ᶜ fun σ => Γ(U_σ ⊓ V, F)` matches.
- **Proof follows sketch**: N/A — body is `:= sorry`. Honest gap (depends on Stub 2).
- **notes**: Blueprint `\leanok` at line 7796 is correct.

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` (chapter: `lem:cechSection_complex_iso`) ⚠
- **Lean target exists**: yes — `CechSectionIdentification.lean:410`
- **Signature matches**: **NO** — **critical mismatch**.
  - **Blueprint** (after iter-056 correction): iso to the AUGMENTED concrete section complex
    `D'_aug := (sectionCechComplex U'·).augment ε hε`. The blueprint statement and `% NOTE:`
    comment (lines 7829–7834) both say the RHS is `D'_aug`, not the bare `D'`.
  - **Lean**: `D ≅ D'` where `D' = sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) Fp` —
    the NON-augmented section complex. This is the pre-correction target that the prover
    explicitly proved is FALSE (iter-056 finding: `D'.X 0 = ∏_i Fp(U'_i) ≠ Γ(V,F)`).
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **notes**: The Lean file itself acknowledges this at lines 332–366 with a `⚠ PROVER FINDING`
  block ending "The original Stub 5/6 sorries below are left untouched (they cannot be closed
  as stated)." — this is an **excuse-comment** (wrong statement, left in place). Must be
  re-signed to the augmented target.

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`) ⚠
- **Lean target exists**: yes — `CechSectionIdentification.lean:475`
- **Signature matches**: **NO** — **critical mismatch**.
  - **Blueprint** (after iter-056 correction): `Homotopy (𝟙 D'_aug) 0` where `D'_aug` is the
    AUGMENTED section complex. Blueprint statement (line 7929–7935) and `% NOTE:` (lines 7904–7909)
    both explicitly say the augmented complex, and explain why the bare `D'` is not contractible.
  - **Lean**: `Homotopy (𝟙 D') 0` where `D' = sectionCechComplex ... Fp` (non-augmented).
    This is provably false: a one-member cover gives `H⁰(D') = Fp(V) ≠ 0`.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **notes**: Same excuse-comment as Stub 5. Both must be re-signed together.

---

## Red flags

### Placeholder / suspect bodies
- `cechSection_complex_iso` at line 424: body `:= sorry`. Blueprint claims the iso to
  `D'_aug` (augmented) is a substantive construction; the Lean target points to a provably-
  false non-augmented statement.
- `cechSection_contractible` at line 481: body `:= sorry`. Same issue — blueprint says
  `Homotopy (𝟙 D'_aug) 0`, Lean says `Homotopy (𝟙 D') 0` for the non-augmented `D'`.

### Excuse-comments
- `CechSectionIdentification.lean:332–366`: multi-paragraph `⚠ PROVER FINDING` block states
  "The original Stub 5/6 sorries below are left untouched (they cannot be closed as stated)."
  This is a workflow-comment excusing wrong declarations in place. Per checker rules, this
  is a red flag alongside the signature mismatch itself.

### Axioms / Classical.choice on non-trivial claims
- None. All six new declarations are axiom-clean (`sorry`-only or real proofs, no `axiom`
  declarations).

---

## Unreferenced declarations (informational)

The following three declarations were built this iter and have no `\lean{...}` reference in the
blueprint chapter:

| Declaration | Line | Role |
|---|---|---|
| `mem_iInf_opens_of_finite` | 62 | `private` helper for `widePullback_openImm_inter`. Acceptable. |
| `coverArrowOverCofan` | 111 | **substantive** — exhibits the colimit cofan for the cover arrow in `Over X`. Needed by Stub 1. |
| `coverArrowOverIsColimit` | 119 | **substantive** — proves the cofan is a colimit (coproduct) in `Over X`. Needed by Stub 1. |
| `coverArrowOverSigmaIso` | 140 | **substantive** — packages `coverArrowOverIsColimit` as the canonical iso `(∐ Over.mk (𝒰.f i)) ≅ Over.mk (Sigma.desc 𝒰.f)`. This is the "inner coproduct is coproduct in Over X" leaf of the Stub-1 distributivity step. |

`coverArrowOverCofan`, `coverArrowOverIsColimit`, and `coverArrowOverSigmaIso` together form an
independent geometric lemma chain that the blueprint's `lem:cech_backbone_left_sigma` proof
sketch implicitly relies on but does not name. The directive specifically asks whether
`coverArrowOverSigmaIso` and its helpers are covered — **they are not**. A dedicated blueprint
block (or at minimum a `\lean{...}` hint inside `lem:cech_backbone_left_sigma`) is needed.

---

## Blueprint adequacy for this file

- **Coverage**: 6/9 Lean declarations (excluding the 3 private/helper ones) have a corresponding
  `\lean{...}` block in the chapter. `coverArrowOverCofan/IsColimit/SigmaIso` (3 substantive
  declarations) are untracked.
- **Proof-sketch depth**: **adequate for existing blocks**; the corrected statement prose for
  Stubs 5/6 is detailed and correct (augmented form, two-part homotopy with engine + augmentation
  node). The Stub-1 `coverArrowOver*` leaf chain is the coverage gap.
- **Hint precision**: **correct** for existing `\lean{...}` references. The `% NOTE:` comments on
  `lem:cechSection_complex_iso` and `lem:cechSection_contractible` accurately describe the
  re-signing needed, so the chapter is giving the right guidance; the problem is the Lean hasn't
  acted on it yet.
- **Generality**: matches need for all covered blocks.

**Recommended chapter-side actions:**

1. Add a blueprint lemma (or a `\lean{...}` hint inside `lem:cech_backbone_left_sigma`) for
   `coverArrowOverSigmaIso`: "In `Over X` the cover arrow `Over.mk (Sigma.desc 𝒰.f)` is the
   coproduct of the member arrows `Over.mk (𝒰.f i)`", with `\lean{AlgebraicGeometry.coverArrowOverSigmaIso}`.
   The two helpers `coverArrowOverCofan` and `coverArrowOverIsColimit` are implementation details
   and need only an informal aside, not their own blocks.
2. Once the Lean is re-signed (Stubs 5/6), verify that the proof blocks for
   `lem:cechSection_complex_iso` and `lem:cechSection_contractible` do NOT get spurious `\leanok`
   from `sync_leanok` before the new signatures are committed (current sorries carry the old
   wrong type, so any `\leanok` on the proof block would be misleading).
3. Trigger `sync_leanok` for `lem:pushPull_leg_sections` — proof is axiom-clean but the proof
   block has no `\leanok` yet.

---

## Severity summary

| Finding | Item | Severity |
|---|---|---|
| Wrong signature: Lean `D ≅ D'` (non-augmented), blueprint says `D ≅ D'_aug` | `cechSection_complex_iso:424` | **must-fix-this-iter** |
| Wrong signature: Lean `Homotopy (𝟙 D') 0`, blueprint says `Homotopy (𝟙 D'_aug) 0` | `cechSection_contractible:481` | **must-fix-this-iter** |
| Excuse-comment on provably-wrong statements | `CechSectionIdentification.lean:332–366` | **must-fix-this-iter** (co-incident with the sig mismatch) |
| Three substantive declarations with no `\lean{...}` blueprint coverage | `coverArrowOver*` | **major** |
| Proof strategy diverges from blueprint sketch (direct vs inductive construction) | `widePullback_openImm_inter` | **minor** |
| `lem:pushPull_leg_sections` proof block missing `\leanok` despite axiom-clean proof | blueprint | **minor** (sync_leanok lag) |

**Overall verdict**: Two must-fix-this-iter findings (Stubs 5/6 signatures remain pointed at a
provably-false non-augmented target the blueprint has already corrected) and one major blueprint
coverage gap (the three `coverArrowOver*` declarations lack `\lean{...}` tracking). The four
remaining stubs (lines 189, 239, 330, and implicitly the `coproduct_distrib_fibrePower` gap) are
honest holes with correctly-specified blueprint targets. The six new Stub-1 backbone declarations
are axiom-clean and the two formalized ones (`cechBackbone_obj_widePullback`, `widePullback_openImm_inter`) match their blueprint blocks faithfully.
