# Effort-breaker directive — split `lem:cech_to_cohomology_on_basis` (Stacks 01EO)

## Target
`lem:cech_to_cohomology_on_basis` in
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (statement at lines ~3078–3130,
full informal proof at ~3189–3262). Lean pin: `AlgebraicGeometry.cech_eq_cohomology_of_basis`
(this Lean declaration does NOT yet exist — it is a scaffold target; you are decomposing the
blueprint so the next iter can scaffold + prove SMALL pieces in parallel, not the whole 4641-effort
theorem at once).

This is the Stacks Project Čech-to-cohomology comparison on a basis, Tag **01EO**
(`lemma-cech-vanish-basis`). Source already transcribed verbatim in the chapter
(`% SOURCE QUOTE` at ~3088–3104 and `% SOURCE QUOTE PROOF` at ~3132–3188); the original is in
`references/stacks-cohomology.tex` around L1695–1776. Re-read that span if you need the precise
source wording for any sub-lemma's citation.

## Granularity
**One level** — cut the proof at its real mathematical seams (the 3–4 main steps below), one
sub-lemma per seam, each with its own `\label`, `\lean{...}` (proposed Lean name), `\uses{...}`,
verbatim `% SOURCE` fragment where it maps to a source sentence, and a complete informal proof.
Keep `lem:cech_to_cohomology_on_basis` as the top assembled statement, rewritten so its proof now
just chains the sub-lemmas via `\uses`. Do NOT go finer than one-claim-per-lemma unless a step
genuinely needs it.

## Proof structure (cut along these seams — already spelled out in the existing proof body)
The argument is a **dimension shift** on `\mathcal F` (the inductive variable being "an
`O_X`-module with vanishing higher Čech cohomology for `Cov`"), using NO affine sheaf-cohomology
input. The seams:

1. **SES of Čech complexes from a basis** — given the section-level short exact sequence
   `0 → F(U) → I(U) → Q(U) → 0` for every `U ∈ B` (which itself comes from `lem:ses_cech_h1`
   applied with the cofinality condition (2) and `Ȟ¹(𝒰,F)=0`), and using condition (1) that every
   Čech term is a product of values over elements of `B`, produce the short exact sequence of Čech
   complexes `0 → Č•(𝒰,F) → Č•(𝒰,I) → Č•(𝒰,Q) → 0` for each `𝒰 ∈ Cov`. Deps:
   `lem:ses_cech_h1` (+ the basis conditions). This is the term-wise-product → SES-of-complexes
   step.

2. **Quotient preserves vanishing-higher-Čech** — from the long exact sequence of Čech cohomology
   of the SES in (1), together with `Ȟᵖ(𝒰,F)=0` (the inductive hypothesis, condition (3)) and
   `Ȟᵖ(𝒰,I)=0` for `p>0` (`lem:injective_cech_acyclic`, the injective `I`), conclude
   `Ȟᵖ(𝒰,Q)=0` for all `p>0` and every `𝒰 ∈ Cov`: `Q = I/F` is again a sheaf with vanishing
   higher Čech cohomology for `Cov`. Deps: (1), `lem:injective_cech_acyclic`.

3. **Sheaf-cohomology base case `H¹(U,F)=0`** — run the covariant Ext long exact sequence
   (`def:absolute_cohomology`, `lem:ext_covariant_les_mathlib`) of `0 → F → I → Q → 0` at fixed
   first argument `j_!O_U`. Use `H⁰(U,-)=Γ(U,-)` (`lem:jshriek_corepr` ∘
   `lem:ext_homequiv_zero_mathlib`) so that the section-level surjectivity `I(U) ↠ Q(U)` from the
   SES makes the connecting map `H⁰(U,Q) → H¹(U,F)` zero; with `H¹(U,I)=0` (injective vanishing,
   `lem:ext_eq_zero_of_injective_mathlib`, `I` the 2nd Ext arg) this forces `H¹(U,F)=0`. Deps:
   `def:absolute_cohomology`, `lem:ext_covariant_les_mathlib`,
   `lem:ext_eq_zero_of_injective_mathlib`, `lem:ext_homequiv_zero_mathlib`, `lem:jshriek_corepr`,
   and step (1)'s section-level surjectivity.

4. **Dimension-shift induction `Hᵖ(U,F)=0, p>0`** — apply the base case (3) to `Q` (which by (2)
   is again a valid inductive sheaf) to get `H¹(U,Q)=0`, then the Ext LES with
   `Hᵖ(U,I)=Hᵖ⁺¹(U,I)=0` shifts `H¹(U,Q)=0 ⟹ H²(U,F)=0`, and iterate. The cleanest Lean shape is
   an induction on `p` with the inductive statement quantified over all such `F` simultaneously
   (so `Q` can take the role of `F` at the next stage). Deps: (2), (3),
   `lem:ext_covariant_les_mathlib`, `lem:ext_eq_zero_of_injective_mathlib`.

## Formalization-shape question to flag (IMPORTANT — feed the planner)
The blueprint states 01EO in full **general** form (an abstract ringed space `X`, a basis `B`, and
a set `Cov` of open coverings cofinal at each basic open, with conditions (1)–(3)). The only
downstream consumer is `lem:affine_serre_vanishing` (02KG), which instantiates `B` = affine opens
and `Cov` = standard affine covers. In your report's "Could not complete / hard pieces" section,
explicitly assess **for each sub-lemma** whether formalizing it in the general `Cov`-cofinal-system
form pulls in substantial absent infrastructure (a Lean encoding of "a set of covers cofinal at
each basic open", colimit/cofinal Čech cohomology over a basis, etc.) versus whether an
**affine/standard-cover-specialized** signature would make that sub-lemma cheap while still serving
02KG. Propose, per sub-lemma, a concrete Lean signature sketch (hypotheses + conclusion in the
project's notation) for the next iter's scaffold. This is open strategic question #2; your
assessment is what lets the planner pick the signature before scaffolding. Do NOT change the
top-level statement's generality yourself — just report the trade-off.

## Constraints
- You write ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (and may spawn a
  `reference-retriever` into `references/**` if you need source text you don't have — but the
  Stacks 01EO source is already in `references/stacks-cohomology.tex`).
- Every new sub-lemma block gets `\label`, `\lean{...}` (a proposed name in the
  `AlgebraicGeometry` namespace), accurate `\uses{...}` reflecting the deps listed above, and a
  complete informal proof. Keep the existing `% SOURCE`/`% SOURCE QUOTE` discipline: where a
  sub-lemma corresponds to a sentence of the 01EO source proof, carry that verbatim fragment as
  its `% SOURCE QUOTE PROOF`.
- Do NOT add or remove `\leanok` (sync-managed). `\mathlibok` only on genuine Mathlib anchors
  (the Ext anchors already exist; don't duplicate them).
- Keep the `\uses` graph acyclic and ensure the top lemma's `\uses` now points at your new
  sub-lemmas.

## Report
- The list of new sub-lemma labels + proposed `\lean{}` names + their `\uses`.
- The per-sub-lemma general-vs-affine-specialization assessment + proposed Lean signatures.
- Anything you could not decompose cleanly (hard pieces needing a further break or absent infra).
