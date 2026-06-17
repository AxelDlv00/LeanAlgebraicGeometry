# Effort Breaker Report

## Slug
fbc-gstar

## Target
`lem:base_change_mate_gstar_transpose` (chapter `Cohomology_FlatBaseChange.tex`)

## Status
COMPLETE — target re-expressed as a 5-lemma `\uses`-linked chain (Seams A/B/C), proof rewritten
to a short 4-move combine. The under-specified "Γ_R(θ_in) = ρ follows from the counit-triangle"
sentence is now a named chain citing the concrete proved atoms.

## Effort before → after
- target `effort_local`: **4914 → 2978** (−39%; `effort_total` 9752 → 8574)
- sub-lemmas added: **5** (each `effort_local` 904–1364, all well below the original monolith)

## Chain added (target ← L5 … L1)
Inserted, bottom-up, immediately before the target lemma block.

**Seam A — inner value identity `Γ_R(θ_in) = ρ` (the ex-monolith), cut into three:**
- `\label{lem:base_change_mate_inner_unitReduce}` `\lean{AlgebraicGeometry.base_change_mate_inner_unitReduce}` — concrete square (`g'=pr₁`, `f'=pr₂`): Γ of the inner composite, after the transparent coherences collapse, distributes into its four Γ-image factors. `\uses{…_legs_unitExpand, …_legs_gammaDistribute, gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom, pullback_fst_snd_specMap_tensor}` (effort 1364).
- `\label{lem:base_change_mate_inner_eCancel}` `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel}` — the load-bearing telescoping: the e-unit (iso), the surviving `pushforwardComp.hom` (identity Γ-image), and the trailing `pullbackComp.hom` cancel against the matching e-pieces baked into the codomain read, leaving only the affine `(Spec ιA)`-unit. `\uses{base_change_mate_inner_unitReduce, gammaMap_pushforwardComp_hom_eq_id, pullback_isEquivalence_of_iso, base_change_mate_codomain_read}` (effort 1044).
- `\label{lem:base_change_mate_inner_value_eq}` `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` — **top of Seam A**: `Γ_R(θ_in) = ρ`. Surviving affine unit = Seam-1 algebraic unit; read over Spec R → ρ. `\uses{base_change_mate_inner_eCancel, base_change_mate_unit_value, pushforward_spec_tilde_iso, def:base_change_mate_inner_value}` (effort 1225). Carries the Stacks `% SOURCE`/quote (the `X' = Spec(R'⊗A)` step).

**Seam B — generator close:**
- `\label{lem:base_change_mate_gstar_generator_close}` `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` — `ext_ψ(ρ) ≫ ε^alg = regroup⁻¹`, one-generator ext (`r'⊗m ↦ (1⊗r')⊗m`). `\uses{base_change_mate_regroupEquiv, def:base_change_mate_inner_value}` (effort 904). Carries the Stacks "boils down to the equality" `% SOURCE`/quote.

**Seam C — counit transport (extracted from the landed `huce` scaffold):**
- `\label{lem:base_change_mate_gstar_counit_transport}` `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` — conjugating the geometric counit `ε_g` by the tilde/pullback dictionaries equals the algebraic counit `ε^alg`; the counit-triangle coherence for the composed adjunction (dual of Seam 1). `\uses{pullback_spec_tilde_iso, gammaPushforwardNatIso, unit_conjugateEquiv_mathlib}` (effort 1059).

**Target proof rewritten** to the 4-move chain: counit factorization → Seam C (counit transport) →
Seam A (`inner_value_eq`) → Seam B (`generator_close`). Statement and `\lean{}` unchanged.
`\uses{base_change_mate_domain_read, base_change_mate_codomain_read, base_change_mate_regroupEquiv,
pullback_spec_tilde_iso, base_change_mate_gstar_counit_transport, base_change_mate_inner_value_eq,
base_change_mate_gstar_generator_close}`.

## Seam C decision
The directive left Seam C (dictionary cancellation) as fold-or-extract. I **extracted** it as its
own lemma: it is a genuine separate step — it is exactly the master counit-transport identity the
prover already **landed and compiled** in the Lean scaffold (`huce` = `conjugateEquiv_counit_symm`
+ `hpullinv` + the two `comp_counit_app` splits, fused). Extracting it (a) gives the prover a named
target that the landed scaffold proves almost verbatim, and (b) was what actually dropped the
target's `effort_local` (the metric is blueprint-prose size; a terse target proof is the win).

## Still hard (re-break candidates)
- `lem:base_change_mate_inner_eCancel` — the e-cancellation telescoping is the genuine
  load-bearing categorical step (originally the ~150-LOC `…_legs` step-iii (3)). It is now isolated
  and citing the right atoms, but if the prover finds it still too large, re-dispatch the breaker
  to split the three cancellations (e-unit iso / `pushforwardComp.hom` identity / `pullbackComp.hom`
  inverse) into one sub-lemma each against the codomain-read structure.

## Could not decompose (strategy items)
- None. All five steps decompose to single mathematical moves over proved atoms.

## References consulted
- `references/stacks-coherent.tex` L928–938 — verbatim: "We use Schemes, Lemma … to describe
  pullbacks and pushforwards of $\mathcal{F}$. Namely, $X' = \Spec(R' \otimes_R A)$ and
  $\mathcal{F}'$ is the quasi-coherent sheaf associated to $(R' \otimes_R A) \otimes_A M$." and
  "Thus we see that the lemma boils down to the equality $(R' \otimes_R A) \otimes_A M = R'
  \otimes_R M$ as $R'$-modules." — quoted on `inner_value_eq` and `generator_close` respectively.
- `analogies/fbc-mate.md`, `analogies/fbc-conjugateequiv-counit-symm.md` — the conjugate-mate
  calculus (Seam-1 template + verified counit dual `conjugateEquiv_counit_symm`); used for proof
  shape, not source citation.

## Notes for dispatcher
- `\lean{}` names assigned by convention (the prover must create these five decls):
  `AlgebraicGeometry.base_change_mate_inner_unitReduce`,
  `AlgebraicGeometry.base_change_mate_inner_eCancel`,
  `AlgebraicGeometry.base_change_mate_inner_value_eq`,
  `AlgebraicGeometry.base_change_mate_gstar_generator_close`,
  `AlgebraicGeometry.base_change_mate_gstar_counit_transport`.
- `inner_value_eq` re-states the (sorry-backed, being-retired) `base_change_mate_fstar_reindex`
  but is proved by a fresh inline route through the proved standalone atoms — NOT routed through
  `fstar_reindex`/`…_legs`. Per directive, the dead `fstar_reindex*` blocks are left untouched.
- The three Γ-collapse atoms (`gammaMap_pushforwardComp_hom_eq_id`, `…_inv_eq_id`,
  `gammaMap_pushforwardCongr_hom`) remain `private` in Lean — fine, their consumers
  (`inner_unitReduce`/`inner_eCancel`) are in the same file. Known minor, not a fix here.
- `counit_transport` should be liftable almost verbatim from the **landed** `huce` derivation in
  `base_change_mate_gstar_transpose` (iter-022 scaffold, lines ~1552–1589): pull the `set adjL/adjR/β`
  + `hpullinv` + `huce`/`hcounitL`/`hcounitR` block out into the named lemma.
- No marker edits (`\leanok`/`\mathlibok`) made anywhere. Pre-existing dangling `\uses{lem:base_change_regroup_linearEquiv}`
  in `base_change_mate_regroupEquiv` is unrelated to this break (not introduced/touched by me).
