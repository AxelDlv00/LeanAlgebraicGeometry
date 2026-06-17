# Blueprint Writer Directive

## Slug
acyclic

## Target chapter
blueprint/src/chapters/Cohomology_AcyclicResolution.tex

## Strategy context

This chapter isolates the one abstract, scheme-independent homological-algebra result on which
the Čech computation of higher direct images rests (Route A): **an acyclic resolution computes
the right-derived functor** (Leray's acyclicity, Stacks Tag 015E). It will back a NEW Lean file
`AcyclicResolution.lean` (not yet scaffolded). The companion geometric chapter applies it with
`G = f_*` to identify `Hⁱ(Čech complex) ≅ (pushforward f).rightDerived i F`.

**Critical constraint the current chapter violates.** The chapter's proofs of
`lem:acyclic_dimension_shift` and `lem:acyclic_resolution_computes_derived` are written entirely
in terms of "the δ-functor (long exact sequence) structure of the right-derived functors
`{R^k G}`". **Mathlib provides NO long-exact-sequence / δ-functor at the `Functor.rightDerived n`
object level.** A Lean prover following the current prose would try to construct infrastructure
that does not exist. The chapter must be rewritten so the proof rests only on primitives that
either exist in Mathlib or are isolated as their own explicitly-stated to-build declarations.

**The honest mathematical picture (established by the iter-002 strategy-critic, with Mathlib
names verified this iter).** The comparison-of-resolutions argument and the dimension-shift
argument share ONE hard kernel: an **SES-acyclicity-propagation / LES fragment for
`rightDerived`**. There is no avoiding a connecting-homomorphism argument. The good news is that
it is *buildable* from infrastructure Mathlib DOES provide:
- `CategoryTheory.InjectiveResolution.isoRightDerivedObj` — any injective resolution `I` of `A`
  computes `(R^n G)(A) ≅ Hⁿ(G(I•))` [Mathlib, verified — already an anchor in this chapter].
- `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ` — injectives are `G`-acyclic
  [Mathlib, verified — already an anchor].
- `CategoryTheory.Functor.rightDerivedZeroIsoSelf` — `R⁰G ≅ G` for left-exact `G` [anchor].
- `CategoryTheory.ShortComplex.ShortExact.homology_exact₃` and `…ShortExact.δ`, in
  `Mathlib.Algebra.Homology.HomologySequence` — the **complex-level** homology long exact
  sequence and connecting map for a short exact sequence of homological complexes in an abelian
  category [Mathlib, verified this iter]. THIS is the connecting-map primitive; it lives at the
  level of complexes, NOT at the `rightDerived n` object level.
- A **horseshoe** lift of a short exact sequence of objects `0→A→B→C→0` to a degreewise-split
  short exact sequence of injective resolutions `0→I_A→I_B→I_C→0`. Mathlib has
  `InjectiveResolution.of`/`.self` but does NOT appear to ship `InjectiveResolution.ofShortExact`
  (the horseshoe). Treat the horseshoe lift as a **to-build project dependency** — give it its
  own declaration block (see Required content) so the DAG records it as an honest gap, rather
  than burying it inside a proof.

## Required content

Rewrite the chapter so its load-bearing proofs are feasible. Concretely:

1. **Keep** `def:right_acyclic` and the three `\mathlibok` anchors
   (`lem:right_derived_injective_resolution`, `lem:right_derived_vanishes_injective`,
   `lem:right_derived_zero_iso_self`) — the reviewer verified all three anchors are faithful.

2. **Add a Mathlib dependency anchor** for the complex-level homology long exact sequence /
   connecting map. State it in the project's notation: for a short exact sequence
   `0 → S.X₁ → S.X₂ → S.X₃ → 0` of cochain complexes (`HomologicalComplex`) in an abelian
   category, there is a connecting map `δ` and a long exact homology sequence
   `⋯ → Hⁿ(S.X₂) → Hⁿ(S.X₃) →^δ Hⁿ⁺¹(S.X₁) → Hⁿ⁺¹(S.X₂) → ⋯`. Mark `\mathlibok` with
   `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}` (and mention `.δ` in prose).
   Cite Mathlib as the source (this is a Mathlib-provided result, so the `% SOURCE` lines are not
   required for a `\mathlibok` anchor — a `\textit{Provided by Mathlib.}` line as in the existing
   anchors is the right form).

3. **Recast `lem:acyclic_dimension_shift`** (or replace it with a new sub-lemma — your choice of
   the cleanest decomposition) as the **SES-acyclicity-propagation kernel**, stated and proved
   from the primitives above, NOT from a phantom `rightDerived`-level δ-functor. The mathematical
   content: given a left-exact additive `G` and a short exact sequence `0 → A → J → Z → 0` with
   `J` right-`G`-acyclic, the connecting maps give `(RᵏG)(Z) ≅ (Rᵏ⁺¹G)(A)` for `k ≥ 1` and
   `(R¹G)(A) ≅ coker(G(J) → G(Z))`. **The proof must explain how the `rightDerived`-level LES is
   obtained from the complex-level one**: lift `0→A→J→Z→0` to a degreewise-split SES of injective
   resolutions via the horseshoe (declaration in item 4), apply `G` (degreewise-split ⇒ the
   resulting `0 → G(I_A) → G(I_J) → G(I_Z) → 0` is still a short exact sequence of complexes even
   though `G` is not exact), then read off the homology LES via the anchor in item 2 and identify
   `Hⁿ(G(I_•)) = (RⁿG)(•)` via `isoRightDerivedObj`. Acyclicity of `J` kills the relevant terms.

4. **Add a declaration block for the horseshoe lift** (the to-build sub-gap): given
   `0→A→B→C→0` exact, there is a short exact sequence of injective resolutions
   `0→I_A→I_B→I_C→0` that is degreewise split. Give it a `\label`, a speculative
   `\lean{...}` hint (e.g. `\lean{CategoryTheory.InjectiveResolution.ofShortExact}` [expected];
   confirm-or-rename at scaffold time), and an informal proof (degreewise: choose injective
   envelopes compatibly; the standard horseshoe construction). This is Archon-to-build (Mathlib
   lacks it), so no external SOURCE quote is required, but you MAY cite a standard reference
   (Weibel, *An Introduction to Homological Algebra*, Horseshoe Lemma 2.2.8, dual form) in prose
   if you wish — only if you can ground it; do NOT fabricate a verbatim quote. Wire it into the
   kernel's `\uses{}`.

5. **Rewrite the proof of `lem:acyclic_resolution_computes_derived`** so the comparison-of-
   resolutions / dimension-shift argument is the MAIN proof body (not a closing parenthetical).
   Decompose the resolution `0→A→J⁰→J¹→⋯` into syzygy short exact sequences
   `0→Zᵐ→Jᵐ→Zᵐ⁺¹→0`, apply the kernel (item 3) down the staircase, and land at
   `(RⁿG)(A) ≅ Hⁿ(G(J•))`. Update `\uses{}` to point at the kernel + horseshoe anchor + the
   homology-sequence anchor + the existing Mathlib anchors. The current closing "Remark on the
   base case and the Mathlib seed" should be folded into the actual proof.

6. Keep all SOURCE/SOURCE QUOTE citation discipline intact for the Stacks-derived blocks
   (`def:right_acyclic`, the acyclic-resolution theorem statement) — the existing verbatim quotes
   from `references/homological-acyclic-derived.tex` are correct; preserve them. You already have
   `references/homological-acyclic-derived.tex` and `-homology.tex` locally (Tags 0157/015C/015D/
   015E/05TA). Re-open them as needed; you should not need new retrieval for this chapter.

## Out of scope
- Do NOT touch any other chapter (`Cohomology_CechHigherDirectImage.tex` is being edited by a
  separate writer this iter — flag cross-chapter issues in your report, don't fix them).
- Do NOT add or remove `\leanok` (deterministic sync owns it).
- Do NOT change the `\lean{}` targets of the three existing faithful Mathlib anchors.
- Do NOT design the Lean proof tactics — describe MATH and name the Mathlib primitives only.

## References
- `references/homological-acyclic-derived.tex` (Stacks derived.tex), Tags 015D/015E/05TA — the
  dimension-shift and Leray-acyclicity statements/proofs. Already local.
- `references/homological-acyclic-homology.tex` (Stacks homology.tex) — delta-functor /
  connecting-map background (Tags 010Q–010U). Already local.

## Expected outcome
The chapter still proves "an acyclic resolution computes `R^nG`", but every proof now rests on
(a) the three existing faithful Mathlib anchors, (b) a new `\mathlibok` anchor for the
complex-level homology LES / connecting map, and (c) an explicitly-declared to-build horseshoe
sub-lemma — with the SES-acyclicity-propagation kernel proved from these, and the main theorem's
proof body being the staircase dimension-shift. No proof references a non-existent
`rightDerived`-level δ-functor. The DAG honestly records the horseshoe as the one genuinely-novel
project dependency.
