# Effort-breaker directive — fbc-legs

## Target

`lem:base_change_mate_fstar_reindex_legs` in `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
(Lean `AlgebraicGeometry.base_change_mate_fstar_reindex_legs`, sorry @1446 in
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`). This is the eCancel "assembly" step that has
churned for 4 consecutive prover rounds. Your job: split it into a `\uses`-linked chain of small
sub-lemmas so a fine-grained prover can fill each in isolation.

## Granularity

**Fine — one mathematical claim per lemma.** Specifically: ONE `.trans`-link / ONE clean-term
cancellation per sub-lemma. Each sub-lemma must state an equality between TWO freshly-elaborated
"clean" terms (a single category/comp instance in scope), so the `X.Modules` instance diamond is
ABSENT in the sub-lemma's statement and it is provable by ordinary tactics in ≤~30 LOC. The final
`base_change_mate_fstar_reindex_legs` then becomes `exact (h1.trans h2.trans … hk)` where the single
closing `exact` crosses the diamond by defeq.

## Why this decomposition (the conclusive diagnosis, iter-029 prover + progress-critic)

Keyed rewriting is **conclusively dead** here: `rw`/`simp`/`erw`/`conv`/`set`/`dsimp` ALL fail
against the `X.Modules` instance diamond — even `rw` of a `rfl`-true `have` whose LHS is the goal's
own pretty-printed factor fails (`kabstract` can't see through the comp/category instance), and even
`rw [Category.comp_id]` fails to find `?f ≫ 𝟙`. The ONLY mechanism that bridges the diamond is
**whole-term defeq** (`have … := rfl` typechecks ⇒ `exact`/`convert`/`change` bridge). Therefore the
proof cannot touch the composite goal mid-proof; it must build each link on clean terms and bridge
only at one final `exact`. This is why a monolithic ~150-LOC term has failed 4× — it must be cut
into independently-compiling links.

## Proof structure to cut along (all helpers already EXIST and are proven in-file)

The genuine-content helpers are shipped; the missing work is purely the chaining. Cut at these seams:

1. **Distribution link** — `base_change_mate_fstar_reindex_legs_gammaDistribute` (Lean ~1304):
   the diamond-free term-mode `map_comp` distribution of factor 1 through `(Spec φ)_* ⋙ Γ`. A
   sub-lemma states the distributed form equals the pre-distribution form on clean terms.

2. **Factor-2 collapse link** — the surviving `pushforwardComp(g', Spec φ)` Γ-factor is defeq `𝟙`
   (`rfl`-true per the prover's defeq map). Sub-lemma: the clean term with this factor = the clean
   term without it (via `base_change_mate_inner_eCancel_pushforwardComp`, Lean ~1534, and the three
   atoms `gammaMap_pushforwardComp_hom_eq_id`/`_inv_eq_id`/`gammaMap_pushforwardCongr_hom`,
   now public @1174/1182/1193).

3. **eUnit cancel link** — `base_change_mate_inner_eCancel_eUnit` (Lean ~1522): η^e cancels the
   codomain `unit_iso.symm`. Sub-lemma on clean terms.

4. **pullbackComp cancel link (G4)** — `base_change_mate_inner_eCancel_pullbackComp` (Lean ~1551):
   G4 cancels `iso_g`'s `pullbackComp.symm` (a GENUINE iso, per the defeq map). Sub-lemma on clean
   terms.

5. **Survivor value link** — the lone surviving G1 unit factor evaluates via Seam-1
   `base_change_mate_unit_value` (Lean ~987) + the ring transport to `base_change_mate_inner_value`.
   Sub-lemma: clean survivor term = `ρ`.

6. **Final assembly** (`base_change_mate_fstar_reindex_legs` itself): `exact` of the `.trans`-chain
   of links 1–5; the closing `exact`'s defeq check absorbs the obj-form/associativity diamonds.

Defeq map (which factors are `rfl`-trivial vs genuine isos), verified live by the iter-029 prover:
- factor 2 `(pushforwardComp g' (Spec φ)).hom.app _` and under Γ: **rfl-trivial (𝟙)**
- G3 (inner) `(pushforwardComp e.hom (Spec inclA)).hom.app _`: **rfl-trivial (𝟙)**
- G4 `(pullbackComp e.hom (Spec inclA)).hom.app (tilde M)`: **genuine iso**
- G1, G2 (`g'`-unit, `(Spec inclA)_*(η^e)`): **genuine isos**

Full diagnosis: prover report archived this iter; recipe also in
`analogies/fbc-functorimage-diamond.md`.

## Deliverables

- Add ~5–6 sub-lemma blocks to the FBC chapter, each with `\label`, `\lean{AlgebraicGeometry.<name>}`
  naming the new lemma the prover will create, accurate `\uses{}` (each link cites the in-file helper
  it wraps), and a one-line informal proof. Each sub-lemma states a clean-term equality (NO diamond
  in its statement).
- Rewrite the `\begin{proof}` of `lem:base_change_mate_fstar_reindex_legs` to be "chain links L1…Lk
  via `.trans`, close with one `exact`", with `\uses{}` listing the new sub-lemmas.
- These are Archon-original / project-bespoke (categorical bookkeeping); no external SOURCE QUOTE
  needed, but keep the prose mathematical (no Lean tactic strings beyond naming the mechanism).

## Out of scope

- Do NOT touch `gstar_transpose`, the affine lemma, or FBC-B (they cascade after `_legs`).
- Do NOT mark `\leanok` (deterministic sync owns it). `\mathlibok` only on genuine Mathlib anchors.
- Also: REMOVE the now-false stale `% NOTE:` at FBC chapter lines ~1541–1546 claiming the 3
  `gammaMap_*` atoms are `private`/mangled — they are now public (de-privatized iter-029), the pins
  resolve. (lean-vs-blueprint-checker `fbc` flagged this as the chapter's one major finding.)
