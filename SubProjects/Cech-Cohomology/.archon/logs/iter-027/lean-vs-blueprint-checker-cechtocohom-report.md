# Lean ↔ Blueprint Check Report

## Slug
cechtocohom

## Iteration
027

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechToCohomology.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (covers block at line 10: `% archon:covers AlgebraicJacobian/Cohomology/CechToCohomology.lean`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechComplex_shortExact_of_basis}` (chapter: `\lem:cech_ses_of_basis`)

- **Lean target exists**: yes — `cechComplex_shortExact_of_basis` at line 192
- **Signature matches**: **no** — significant divergence (see detail below)
- **Proof follows sketch**: partial — the Lean proof strategy (degreewise via `shortExact_piMap`) matches the blueprint's "product of short exact sequences is short exact" idea, but the blueprint sketch operates in the cover-global (B, Cov) framework; the Lean proof is cover-local and handles only one fixed cover
- **notes**:
  - Blueprint statement (lines 3226–3240) is set in the cover-global framework "Let X, B, Cov be as in Lemma~\ref{lem:cech_to_cohomology_on_basis}", takes a short exact sequence `0 → F → I → Q → 0` of **O_X-modules** (sheaves), requires condition (3) = F has vanishing higher Čech cohomology for Cov, and concludes "for every U ∈ Cov the induced sequence of section Čech complexes is short exact".
  - Lean signature is:
    ```lean
    theorem cechComplex_shortExact_of_basis {ι : Type u}
        (U : ι → TopologicalSpace.Opens X)
        (P : ShortComplex X.PresheafOfModules)
        (hface : ∀ (p : ℕ) (σ : Fin (p + 1) → ι), (faceShortComplex U P σ).ShortExact) :
        (sectionCechComplexShortComplex U P).ShortExact
    ```
  - Three structural differences: (1) cover-local (`U : ι → Opens X`) vs. cover-global (B, Cov); (2) `ShortComplex X.PresheafOfModules` (presheaves) vs. `ShortComplex X.Modules` (sheaves of O_X-modules); (3) raw per-face hypothesis `hface` vs. derived condition (3) + `ses_cech_h1` surjectivity.
  - The Lean form is mathematically more general and correct; the blueprint needs updating to reflect the actual landed abstraction.

### `\lean{AlgebraicGeometry.quotient_cech_vanishing_of_basis}` (chapter: `\lem:quotient_vanishing_cech`)

- **Lean target exists**: yes — `quotient_cech_vanishing_of_basis` at line 224
- **Signature matches**: **no** — cover-global vs. cover-local divergence (see detail)
- **Proof follows sketch**: yes — the blueprint proof sketch (LES of Čech cohomology, middle term vanishes by `injective_cech_acyclic`, right term is conditioned from (3)) is faithfully captured by `cechHomology_quotient_vanishing` (LES δIso argument)
- **notes**:
  - Blueprint statement (lines 3281–3285) says "With notation as in Lemma~\ref{lem:cech_ses_of_basis}" (cover-global), assumes "I is an injective O_X-module", concludes Q has vanishing higher Čech cohomology for Cov.
  - Lean signature is:
    ```lean
    theorem quotient_cech_vanishing_of_basis {ι : Type u}
        (U : ι → TopologicalSpace.Opens X)
        (P : ShortComplex X.PresheafOfModules)
        (hSES : (sectionCechComplexShortComplex U P).ShortExact)
        (hI : ∀ p, 0 < p → IsZero (cechCohomology U P.X₂ p))
        (hF : ∀ p, 0 < p → IsZero (cechCohomology U P.X₁ p)) :
        ∀ p, 0 < p → IsZero (cechCohomology U P.X₃ p)
    ```
  - Differences: (1) cover-local vs. cover-global; (2) no injectivity hypothesis — instead takes `hI` and `hF` directly as IsZero-of-cechCohomology; (3) requires `hSES` (the L1 SES output) as an explicit input, which the blueprint derives internally; (4) still `PresheafOfModules` not `Modules`.
  - Again, Lean form is more abstract and general; the blueprint must be updated.

---

## Red flags

*(None of the following categories apply to this file — the section is included for completeness.)*

### Placeholder / suspect bodies
None. All 12 declarations in the file have complete proof bodies; no `:= sorry`, no `:= True`, no `:= Classical.choice _` on substantive claims.

### Excuse-comments
None. No `-- TODO`, `-- temporary`, `-- placeholder`, or `-- wrong but works` comments anywhere in the file.

### Axioms / `Classical.choice` on non-trivial claims
No `axiom` declarations. The file is confirmed axiom-clean (`[propext, Classical.choice, Quot.sound]` only — standard Lean 4 logical axioms). Both main targets verified axiom-clean by the prover.

---

## Unreferenced declarations (informational)

10 declarations have no `\lean{...}` reference in the blueprint (1 private excluded):

| Declaration | Line | Character | Assessment |
|---|---|---|---|
| `sectionCechCosimplicialMap` | 30 | `noncomputable def` | Helper — functoriality brick. Acceptable as infrastructure. |
| `sectionCechCosimplicialFunctor` | 46 | `noncomputable def` | Helper — packaged functor. Acceptable. |
| `sectionCechComplexFunctor` | 81 | `noncomputable def` | Helper — chain-functor composition. Acceptable. |
| `sectionCechComplexMap` | 87 | `noncomputable def` | Helper — induced chain map. Acceptable. |
| `cechCohomology` | 95 | `noncomputable def` | **Substantive**: named Čech-cohomology accessor `Ȟᵖ(𝒰,F)`, referenced by both L2 signature and the downstream L3/L4 chain. Worthy of a `\begin{definition}` block. |
| `shortExact_piMap` | 110 | `theorem` | **Substantive and public**: the AB4* theorem "a product of short exact sequences in Ab is short exact". This is the key mathematical content behind L1 (the blueprint's "product of short exact sequences" sentence). Has no blueprint block; should be a named lemma in the chapter. |
| `faceShortComplex` | 159 | `noncomputable def` | Helper — per-`(p,σ)` face short complex. Used as a building block. Could have a thin definition block; acceptable without. |
| `sectionCechComplexShortComplex` | 170 | `noncomputable def` | **Substantive**: defines the short complex `0 → Č(F) → Č(I) → Č(Q) → 0` of section Čech complexes. It is the return type of L1 and explicit input of L2; should appear in the blueprint as a definition. |
| `cechHomology_quotient_vanishing` | 209 | `theorem` | **Substantive**: the abstract homological core of L2 — given an SES of cochain complexes in which X₂ and X₁ have vanishing positive homology, so does X₃ (via δIso). No blueprint block; this is the proof-reuse vehicle and warrants a named blueprint lemma. |
| `pi_π_map_apply` | 101 | `private lemma` | Private helper — OK, no blueprint block needed. |

**Summary**: 2 substantive "should-be-in-blueprint" declarations (`shortExact_piMap`, `cechHomology_quotient_vanishing`), 2 borderline-worthy ones (`cechCohomology`, `sectionCechComplexShortComplex`), 6 infrastructure helpers (acceptable without blueprint blocks).

---

## Blueprint adequacy for this file

### Coverage
2/11 public declarations have a corresponding `\lean{...}` block in the chapter. Unreferenced: 4 infrastructure helpers (acceptable), 2 substantive theorems (flagged), 2 borderline definitions (flagged), 1 private helper (OK).

### Proof-sketch depth
**Under-specified for the actual landed signatures.** The blueprint proof sketches for `lem:cech_ses_of_basis` and `lem:quotient_vanishing_cech` are adequate in broad mathematical outline (product-of-SES + LES argument), but they operate entirely in the cover-global framework (B, Cov) that the Lean did NOT use. A prover reading the blueprint sketches as written would implement a different signature. The proofs landed because the prover adapted to the cover-local form; the sketch does not document this adaptation.

The missing sketch for `shortExact_piMap` (AB4* content) is the one genuinely mathematical sub-step that requires real Lean effort (`Epi (Pi.map φ)` is not `inferInstance` in Ab, requires elementwise `Concrete.productEquiv` argument). The blueprint's one-sentence "a product of short exact sequences is short exact" does not expose this obstacle.

### Hint precision
**Wrong for the landed form.** The `\lean{...}` hints correctly name the declarations (`cechComplex_shortExact_of_basis`, `quotient_cech_vanishing_of_basis`), so name-matching is exact. But the blueprint statement prose pinning the types (`ShortComplex X.Modules`, cover-global (B, Cov)) does not match what those declarations actually have (`ShortComplex X.PresheafOfModules`, cover-local). This is a precision failure in the prose, not just a hint issue.

### Generality
**Too narrow.** The blueprint describes the cover-global variant (sufficient for Serre vanishing and 01EO), but the Lean landed a more general cover-local, presheaf-level form. The blueprint should be updated to document the landed level of generality, since the upstream instantiation (from sheaves + basis framework) is a separate step not yet formalized.

### Recommended chapter-side actions (blueprint-writing subagent should address)

1. **Must-fix — Rewrite `lem:cech_ses_of_basis` statement** to reflect the cover-local signature:
   - Replace "(B, Cov) framework + condition (3)" with "fix a family `U : ι → Opens X` of opens, a short complex `P` of presheaves of modules, and a per-face short-exactness hypothesis `hface : ∀ p σ, (faceShortComplex U P σ).ShortExact`".
   - Change "O_X-modules (sheaves)" to "presheaves of O_X-modules" throughout.
   - The conclusion becomes "`(sectionCechComplexShortComplex U P).ShortExact`".
   - Add a remark that the instantiation to the (B, Cov) framework uses `ses_cech_h1` for the per-face surjectivity, as a separate step.

2. **Must-fix — Rewrite `lem:quotient_vanishing_cech` statement** to reflect the cover-local signature:
   - Replace "I is an injective O_X-module" with explicit hypotheses `hSES`, `hI`, `hF`.
   - Explain that `hI` follows from `injective_cech_acyclic` at instantiation time.
   - Cover-local form: takes the SES of Čech complexes explicitly.

3. **Major — Add `\begin{lemma}` block for `shortExact_piMap`** (AB4* theorem): "A product of short exact sequences in Ab is short exact." `\lean{AlgebraicGeometry.shortExact_piMap}`. Include a proof note flagging that `Epi (Pi.map φ)` requires an elementwise surjectivity argument (not a typeclass instance).

4. **Major — Add `\begin{lemma}` block for `cechHomology_quotient_vanishing`**: the abstract homological form of L2 (for any SES of cochain complexes in Ab, not tied to section Čech). `\lean{AlgebraicGeometry.cechHomology_quotient_vanishing}`.

5. **Minor — Add thin `\begin{definition}` blocks** for `cechCohomology` and `sectionCechComplexShortComplex`, since both are named in the signatures of the `\lean{}`-pinned declarations.

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint prose for `lem:cech_ses_of_basis` describes cover-global form / `Modules` (sheaves); Lean landed cover-local / `PresheafOfModules` | **must-fix** (blueprint) |
| Blueprint prose for `lem:quotient_vanishing_cech` describes cover-global form with injectivity; Lean takes explicit cover-local + vanishing hypotheses | **must-fix** (blueprint) |
| `shortExact_piMap` (public theorem, AB4* content) has no blueprint block | **major** |
| `cechHomology_quotient_vanishing` (abstract homological lemma, L2's proof vehicle) has no blueprint block | **major** |
| `sectionCechComplexShortComplex`, `cechCohomology` have no blueprint blocks | **minor** |
| Blueprint proof sketch for L1 omits the `Epi (Pi.map φ)` obstacle | **minor** |

**Overall verdict**: Both declared lemmas exist with exactly the right names and have complete, axiom-clean proofs — no Lean-side red flags — but the blueprint prose for both `lem:cech_ses_of_basis` (L1) and `lem:quotient_vanishing_cech` (L2) describes a cover-global, sheaves-of-modules signature that the landed Lean code does not match; the blueprint must be updated to the cover-local, presheaves-of-modules form that was actually formalized, and two substantive helper theorems (`shortExact_piMap`, `cechHomology_quotient_vanishing`) lack blueprint coverage.
