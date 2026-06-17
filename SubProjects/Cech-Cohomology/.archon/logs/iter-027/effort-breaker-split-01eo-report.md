# Effort Breaker Report

## Slug
split-01eo

## Target
`lem:cech_to_cohomology_on_basis` (Lean pin `AlgebraicGeometry.cech_eq_cohomology_of_basis`, Stacks 01EO)

## Status
COMPLETE — target re-expressed as a 4-link `\uses` chain cut at the directive's four mathematical seams; graph re-verified acyclic with no broken `\uses`.

## Effort before → after
- target `effort_local`: **4641 → 2788**
- sub-lemmas added: **4** (each with statement + complete informal proof + `\uses` + verbatim `% SOURCE QUOTE PROOF`)

## Chain added (target ← L4 ← L3/L2 ← L1)
All in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, inserted just above the top lemma.

| Label | Proposed `\lean{}` | `\uses` (statement) | effort_local |
|---|---|---|---|
| `lem:cech_ses_of_basis` | `AlgebraicGeometry.cechComplex_shortExact_of_basis` | `def:cech_complex, lem:ses_cech_h1` | 1349 |
| `lem:quotient_vanishing_cech` | `AlgebraicGeometry.quotient_cech_vanishing_of_basis` | `def:cech_complex, lem:cech_ses_of_basis, lem:injective_cech_acyclic` | 878 |
| `lem:absolute_cohomology_one_vanishing` | `AlgebraicGeometry.absoluteCohomology_one_eq_zero_of_basis` | `def:absolute_cohomology, lem:cech_ses_of_basis, lem:ext_covariant_les_mathlib, lem:ext_eq_zero_of_injective_mathlib, lem:ext_homequiv_zero_mathlib, lem:jshriek_corepr` | 1440 |
| `lem:absolute_cohomology_pos_vanishing` | `AlgebraicGeometry.absoluteCohomology_eq_zero_of_basis` | `def:absolute_cohomology, lem:quotient_vanishing_cech, lem:absolute_cohomology_one_vanishing, lem:ext_covariant_les_mathlib, lem:ext_eq_zero_of_injective_mathlib` | 1718 |

Top lemma `lem:cech_to_cohomology_on_basis`:
- statement `\uses` rewritten to `{def:cech_complex, def:absolute_cohomology, lem:cech_ses_of_basis, lem:quotient_vanishing_cech, lem:absolute_cohomology_one_vanishing, lem:absolute_cohomology_pos_vanishing}` (the heavy direct deps `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:cech_acyclic_affine` are now reached transitively through the sub-lemmas);
- proof body rewritten to a short assembly that chains L1→L2→L3→L4.

Mapping to the directive's seams: seam 1 = `lem:cech_ses_of_basis`; seam 2 = `lem:quotient_vanishing_cech`; seam 3 = `lem:absolute_cohomology_one_vanishing`; seam 4 = `lem:absolute_cohomology_pos_vanishing` (this last is the full conclusion, so the top lemma's proof is essentially "this is L4, assembled from L1–L3").

Graph re-verification (`archon dag-query`): target dep_count 6, `lem:absolute_cohomology_pos_vanishing` rdep_count 1, ancestors traversal returns 46 nodes with no unresolved label. LaTeX `\begin/\end` balanced (lemma 46/46, proof 37/37).

## IMPORTANT — general-vs-affine specialization assessment (open strategic question #2)

**Headline finding.** Three of the four sub-lemmas (L1–L3) can be scaffolded in a **cover-local, hypothesis-driven** form that never mentions `Cov` or "cofinal system" at all — the cofinality/condition-(2) datum is needed *only* to discharge a section-surjectivity hypothesis, which these lemmas can simply *take as input*. The full `Cov`-cofinal-system encoding is forced into exactly **one** place: L4 (the induction) and the top lemma, because there the quotient `Q` must re-enter the inductive class, which requires re-deriving its section surjectivity from cofinality. Critically, **the inductive class is NOT "quasi-coherent modules"** (`Q = I/F` need not be quasi-coherent), so even the affine instantiation cannot specialize the inductive predicate to quasi-coherent inputs — it must use the abstract "vanishing higher Čech for the cover system" predicate, with quasi-coherent `F` only as the *seed*. No colimit/Čech-over-a-basis machinery is ever required (we work cover-by-cover throughout); the only bespoke infra is a lightweight `Cov` record + a `Prop`-valued predicate.

Per sub-lemma:

- **L1 `cechComplex_shortExact_of_basis` — general ≈ affine, cheap.** State per *single* cover, taking section-level exactness on every face as a hypothesis (so neither `Cov` nor cofinality appears):
  ```
  theorem cechComplex_shortExact_of_basis {X : Scheme.{u}} {U : Opens X}
      (𝒰 : <open cover of U, e.g. the project's cover datum with face opens U_{i₀…i_p}>)
      {S : ShortComplex X.Modules} (hS : S.ShortExact)
      (hsec : ∀ (i : <index tuple of 𝒰 in any degree>),
        Function.Surjective ⇑((toPresheaf S.X₂).presheaf.map (faceOp 𝒰 i) ≫ … )) -- I(V) ↠ Q(V) on every face V = U_{i₀…i_p}
      : (sectionCechComplexShortComplex 𝒰 hS).ShortExact   -- HomologicalComplex.ShortExact of section Čech complexes
  ```
  Rests on the project's `sectionCechComplex`/`def:section_cech_complex` (degree-p term already `∏ F(U_{i₀…i_p})`), `lem:ses_cech_h1` to *produce* `hsec` at instantiation, and "product of SES is SES, degreewise" + naturality of the alternating face maps. No absent infra.

- **L2 `quotient_cech_vanishing_of_basis` — general = affine, cheap.** Also per single cover; pure homological algebra on the L1 output:
  ```
  theorem quotient_cech_vanishing_of_basis {X : Scheme.{u}} {U : Opens X}
      (𝒰 : <cover of U>) {S : ShortComplex X.Modules} (hS : S.ShortExact)
      (hSES : (sectionCechComplexShortComplex 𝒰 hS).ShortExact)    -- from L1
      (hI : ∀ p, 0 < p → IsZero (cechCohomology 𝒰 S.X₂ p))         -- injective_cech_acyclic
      (hF : ∀ p, 0 < p → IsZero (cechCohomology 𝒰 S.X₁ p))         -- condition (3) for F
      : ∀ p, 0 < p → IsZero (cechCohomology 𝒰 S.X₃ p)
  ```
  Uses Mathlib's `HomologicalComplex.ShortExact`→long-exact-sequence + `lem:injective_cech_acyclic`. No `Cov`/cofinality. Absent infra: only the project's own `cechCohomology` accessor on `sectionCechComplex` (homology of the section complex) — confirm it exists or add a thin def.

- **L3 `absoluteCohomology_one_eq_zero_of_basis` — general = affine, cheap.** Pure `Ext`-algebra on `X.Modules`; the only geometric input is section surjectivity at `U`, taken as a hypothesis. The three `absoluteCohomology_covariant_exact₁/₂/₃` wrappers already exist in `AbsoluteCohomology.lean`:
  ```
  theorem absoluteCohomology_one_eq_zero_of_basis {X : Scheme.{u}} (U : Opens X)
      {S : ShortComplex X.Modules} (hS : S.ShortExact) [Injective S.X₂]
      (hsurj : Function.Surjective ⇑(sectionsMap U S.g))   -- I(U) ↠ Q(U), supplied by L1 at U
      : ∀ e : Ext (jShriekOU U) S.X₁ 1, e = 0               -- H¹(U,F) = 0
  ```
  Anchors: `absoluteCohomology_covariant_exact₁/₃`, `absoluteCohomology_eq_zero_of_injective`, `absoluteCohomologyZeroAddEquiv` (all already in the Lean file). No `Cov`/cofinality. Cheap.

- **L4 `absoluteCohomology_eq_zero_of_basis` — this is where the general form costs.** Needs the `Cov` datum once, as a fixed parameter, plus a `Prop`-valued predicate that the quotient inherits. Recommended encoding (modest, NO colimit machinery):
  ```
  -- bespoke, lightweight: a cover system on a basis (conditions (1)+(2) of 01EO)
  structure BasisCovSystem (X : Scheme.{u}) where
    B    : Set (Opens X)                              -- basis, closed under the relevant ∩
    Cov  : Set (Σ U : Opens X, <cover of U>)          -- the admissible covers
    faces_mem : ∀ c ∈ Cov, U c ∈ B ∧ ∀ tuple, faceOpen c tuple ∈ B          -- (1)
    cofinal  : ∀ V ∈ B, <coverings of V in Cov are cofinal among all coverings of V>  -- (2)
  -- per-F part of conditions (3): the inductive predicate (abstract module, NOT QCoh)
  def HasVanishingHigherCech (s : BasisCovSystem X) (F : X.Modules) : Prop :=
    ∀ c ∈ s.Cov, ∀ p, 0 < p → IsZero (cechCohomology (cover c) F p)

  theorem absoluteCohomology_eq_zero_of_basis (s : BasisCovSystem X)
      {F : X.Modules} (hF : HasVanishingHigherCech s F)
      {U : Opens X} (hU : U ∈ s.B) {p : ℕ} (hp : 0 < p)
      : ∀ e : Ext (jShriekOU U) F p, e = 0
  ```
  Proof shape: induction on `p`, generalizing over all `F` with `HasVanishingHigherCech s F`; closure-under-quotient is L2 (giving `HasVanishingHigherCech s Q`) plus `ses_cech_h1`+`s.cofinal` to re-supply L3's `hsurj` for `Q` at each `U ∈ s.B`; base case is L3.

  - **General-form cost:** the `BasisCovSystem` record and the `cofinal` field. The cofinality field is the one genuinely new abstraction; it is used *only* as the hypothesis fed to `ses_cech_h1` (which already abstracts "a cofinal system of coverings with Ȟ¹=0"), so it can be stated exactly in the shape `ses_cech_h1` consumes — no new colimit/derived-functor infrastructure, no "Čech cohomology over a basis" colimit. Estimated: one small structure + one predicate.
  - **Affine-specialized alternative for 02KG:** instantiate `s.B` = affine opens, `s.Cov` = standard covers; `faces_mem` = standard opens closed under ∩; `cofinal` = standard-open cofinality (Stacks `schemes-lemma-standard-open` — **see "Could not decompose" below: this Lean lemma may be partially absent**). The seed `HasVanishingHigherCech s F` for quasi-coherent `F` is `lem:cech_acyclic_affine`. The induction body is unchanged and still runs over abstract modules.
  - **Recommendation to planner:** scaffold L1–L3 in the cover-local hypothesis-driven signatures above (cheap, no `Cov`), and scaffold L4 + the top lemma against the `BasisCovSystem`/`HasVanishingHigherCech` encoding. Do **not** specialize L4's inductive predicate to QCoh — it would be unsound (`Q` is not QCoh). The affine collapse happens entirely at the `BasisCovSystem` *instantiation* used by 02KG, not inside L1–L4.

## Could not decompose cleanly / hard pieces (absent infra)

- **`s.cofinal` ⇒ a Lean "standard covers are cofinal" lemma (Stacks `schemes-lemma-standard-open`).** Needed only at the 02KG *instantiation* of `BasisCovSystem`, not by L1–L4 themselves. Whether Mathlib has standard-open cofinality of affine covers in a directly usable form is unverified here; flag for the planner as a possible separate small scaffold (it is geometry, independent of this chain). It does not block scaffolding L1–L4.
- **`cechCohomology` accessor on `sectionCechComplex`.** L2 (and the `HasVanishingHigherCech` predicate) reference "Ȟᵖ(𝒰,F) = homology of the section Čech complex". Confirm the project already exposes this (it is implicit in `lem:injective_cech_acyclic`'s vanishing clause and in `lem:ses_cech_h1`); if only the complex and not a named `cechCohomology p` def exists, add a thin definitional wrapper. Not a mathematical gap, just a naming/scaffold item.
- No step was left mathematically un-decomposed: every gap the original monolithic proof crossed (section SES → SES of complexes → Čech LES → quotient stability → Ext LES base case → induction) is carried by exactly one `L_i`, and the top lemma's proof now only chains them. None of L1–L4 is itself a re-break candidate at this granularity (each is a single mathematical move modulo the named anchors).

## References consulted
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — the in-chapter verbatim transcription of Stacks 01EO proof (`% SOURCE QUOTE PROOF`, lines ~3132–3188, itself copied verbatim from `references/stacks-cohomology.tex` L1695–1776). Each sub-lemma carries the matching verbatim source fragment as its own `% SOURCE QUOTE PROOF`. No new reference retrieval was needed.

## Notes for dispatcher
- `\lean{}` names assigned by convention (confirm/scaffold, all in `AlgebraicGeometry`): `cechComplex_shortExact_of_basis`, `quotient_cech_vanishing_of_basis`, `absoluteCohomology_one_eq_zero_of_basis`, `absoluteCohomology_eq_zero_of_basis`. The top pin `cech_eq_cohomology_of_basis` is unchanged (still does not exist; now a thin assembly of L4).
- Top lemma statement `\uses` deliberately lists all four sub-lemmas so the dag edges are present (dependency edges are built from the **statement** block's `\uses`, not the proof block's — verified empirically this iter).
- No new macros required. No `\leanok`/`\mathlibok` added or removed; existing Ext anchors reused, not duplicated.
- Strategic flag for the planner (open question #2): scaffold L1–L3 in cover-local hypothesis-driven form (no `Cov`), reserve the `BasisCovSystem` + `HasVanishingHigherCech` encoding for L4 + the top lemma; the inductive predicate must stay abstract (not QCoh). Standard-open cofinality for 02KG is a separable side-scaffold.
