# Blueprint Writer Directive

## Slug
rrformula-h0h1split

## Target chapter
blueprint/src/chapters/RiemannRoch_RRFormula.tex

## Strategy context

This chapter is the **RR.2** sub-build for the project's Riemann–Roch
bridge `genus-0 ⟹ ℙ¹`. Per STRATEGY.md row "Genus-0 RR.2 — RR formula
for genus 0" (Iters left ~8–12; elapsed 13 from iter-174 — OVER_BUDGET
per iter-187 progress-critic).

iter-186 Lane H decomposed the monolithic Tier-3 `\sorry` body of the
main theorem `thm:euler_char_eq_deg_plus_one_minus_genus` into a
3-piece Hartshorne IV.1 sub-helper structure in Lean
(`RiemannRoch/RRFormula.lean`):

- `eulerCharacteristic_shortExact_add` (L322): for a SES
  `0 → S.X₁ → S.X₂ → S.X₃ → 0`, `χ(S.X₂) = χ(S.X₁) + χ(S.X₃)`.
  Tier-3 typed sorry. Substrate: project-side LES carrier for
  `ModuleCat kbar`-valued sheaf cohomology + 6-term alternating-rank
  identity.
- `eulerCharacteristic_iso` (L347): `F ≅ G ⟹ χ(F) = χ(G)`.
  Closed iter-186 Tier-1 axiom-clean via `LinearEquiv.ofLinear`
  on `Abelian.Ext.postcompOfLinear` of `mk₀ e.hom` / `mk₀ e.inv`.
- `eulerCharacteristic_skyscraperSheaf` (L405):
  `χ(skyscraperSheaf P.point (ModuleCat.of kbar kbar)) = 1`.
  Tier-3 typed sorry. Decomposes into H⁰ identification
  (~30-60 LOC axiom-clean via the project's
  `constantSheafGammaHom_linearEquiv` chain) + **H¹ vanishing
  (Mathlib gap — flasque-cohomology not formalized at b80f227)**.

The iter-187 progress-critic returned **CHURNING + OVER_BUDGET** for
this lane with the corrective: "Blueprint expansion — split H⁰ half
from H¹ Mathlib-gap half; annotate H¹ as a gated placeholder to prevent
further decomposition cycles on an already-decomposed sub-problem."

## Required content

The proof block of `thm:euler_char_eq_deg_plus_one_minus_genus` in the
chapter currently references the 3-piece decomposition informally but
does not pin the Lean sub-helpers. The required edits:

### Required content R-1 (MF-1 from iter-187 blueprint-reviewer)

**Add 3 `\lean{...}` pins** inside the proof block of
`thm:euler_char_eq_deg_plus_one_minus_genus`, corresponding to the 3
iter-186 sub-helpers. The Lean fully-qualified names are:

- `AlgebraicGeometry.Scheme.eulerCharacteristic_shortExact_add`
- `AlgebraicGeometry.Scheme.eulerCharacteristic_iso`
- `AlgebraicGeometry.Scheme.eulerCharacteristic_skyscraperSheaf`

The natural form is to introduce each as its own
`\begin{lemma}...\end{lemma}` block (consumed by
`thm:euler_char_eq_deg_plus_one_minus_genus`), with each lemma
carrying its substantive informal statement + a brief proof sketch
(mathematical, not syntactic), plus its `\lean{...}` pin and `\uses{...}`
where applicable. Cross-reference the parent theorem's proof block
to these new lemma labels via `\uses{...}` updates.

### Required content R-2 (progress-critic CHURNING corrective)

For `eulerCharacteristic_skyscraperSheaf` specifically, **split the
proof sketch into two named sub-paragraphs**:

- **H⁰ half** — `H⁰(C, skyscraper P kbar) ≅ kbar`. Axiom-clean
  closure projection ~30-60 LOC via the project's existing
  `Scheme.HModule_zero_linearEquiv kbar (skyscraperSheaf P kbar)`
  → `Scheme.constantSheafGammaHom_linearEquiv` →
  `SheafGammaObj_linearEquiv_top kbar (skyscraperSheaf P kbar)` chain.
  The proof reduces (after `LinearEquiv.finrank_eq`) to
  `Module.finrank kbar ((skyscraperSheaf P kbar).val.obj (op ⊤))
  = 1`, which is definitionally `Module.finrank kbar kbar = 1`.
  Iter-187+ target.

- **H¹ half** — `H¹(C, skyscraper P kbar) = 0`. Mathematically true
  (skyscraper sheaves are flasque; flasque sheaves have vanishing
  higher cohomology). **GATED ON MATHLIB**: Mathlib `b80f227` does
  not ship a `Hⁿ(X, F) = 0 for flasque F` lemma at the `ModuleCat`-
  flavoured `Abelian.Ext`-cohomology level. The closure depends on
  either: (a) Mathlib upstream `Sheaf.flasque_vanishing_cohomology`
  contribution; OR (b) a project-side flasque-cohomology bridge
  (~150-300 LOC, off critical path).

  Add a `% NOTE: gated on Mathlib flasque cohomology` annotation
  to this sub-paragraph so a future plan agent reading the chapter
  can immediately identify the gating.

The downstream consumer (the `thm:euler_char_eq_deg_plus_one_minus_genus`
proof) calls `eulerCharacteristic_skyscraperSheaf` whose body in turn
reduces to **H⁰ result + H¹ result** combined by definition of `χ`.
Make this clear in the proof block so the iter-187+ prover can attack
the H⁰ half independently as a separate Lean helper.

### Required content R-3 (informational — supplementary detail)

For `eulerCharacteristic_shortExact_add`, the proof sketch should
explicitly cite the substrate gap: project-side LES carrier for
`ModuleCat kbar`-valued sheaf cohomology + 6-term alternating-rank
identity via composed `Submodule.finrank_quotient_add_finrank`
invocations. Mathlib `Abelian.Ext.covariantSequence` exists but
per-degree finiteness + Grothendieck vanishing `H^i = 0` for `i ≥ 2`
require additional project-side work. Add a `% NOTE: gated on
project-side LES carrier + finiteness machinery` annotation to that
sub-block.

## References

- Hartshorne, *Algebraic Geometry*, IV §1 (Riemann–Roch theorem for
  curves), particularly the proof structure pp. 295–296 with the
  SES + skyscraper-divisor inductive step. Read from
  `references/hartshorne-algebraic-geometry.pdf`.
- Stacks tag 02UA (Euler characteristic of a SES; LES-of-cohomology
  via flat base change in special case). Read from
  `references/stacks-coherent.tex` if needed.

## Out of scope

- Do NOT add `\leanok` / `\mathlibok` markers (sync_leanok manages
  these between prover/review phases).
- Do NOT touch sibling chapters (`RiemannRoch_OCofP.tex`,
  `RiemannRoch_WeilDivisor.tex`, etc.).
- Do NOT add Lean tactic code. Proof sketches must be mathematical
  prose only.
- Do NOT speculate beyond R-1, R-2, R-3.

## Notes

The iter-186 review landed `% NOTE` annotations on
`Picard_LineBundlePullback.tex` documenting semantic debt — that is
the model for the `% NOTE: gated on ...` annotations requested in R-2
and R-3 above.
