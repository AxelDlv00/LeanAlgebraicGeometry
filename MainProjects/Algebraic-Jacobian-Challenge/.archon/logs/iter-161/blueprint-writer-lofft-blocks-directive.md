# Blueprint Writer Directive

## Slug
lofft-blocks

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Strategy context

This chapter blueprints the char-free abelian-variety Rigidity-Lemma stack (route (c)
of the genus-0 arm). The chain is:
`rigidity_lemma` → `rigidity_core` → `rigidity_eqOn_dense_open` →
`rigidity_eqOn_saturated_open_to_affine` → (Step 1) `rigidity_eqAt_closedPoint_of_proper_into_affine`
globalised by (Step 2) `morphism_eq_of_eqAt_closedPoints`.

Two things changed in the Lean this iteration that the chapter must now reflect:

1. **A new hypothesis was added to the chain.** The route-B globalisation (Step 2) needs the
   closed points of the ambient open subscheme `U` to be DENSE — i.e. `U` to be a Jacobson
   space. Over the algebraically closed base `Spec k̄` this follows from `(X ⊗ Y)` being
   **locally of finite type**. So the formalization now carries
   `[LocallyOfFiniteType (X ⊗ Y).hom]` on FIVE chain lemmas
   (`rigidity_lemma`, `rigidity_core`, `rigidity_eqOn_dense_open`,
   `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqAt_closedPoint_of_proper_into_affine`),
   in addition to the previously-recorded `[IsAlgClosed kbar]`. This is free downstream
   (curves and abelian varieties are of finite type over `k̄`). The chapter currently
   asserts (e.g. near the `lem:rigidity_eqOn_saturated_open_to_affine` block and the
   `lem:rigidity_eqOn_dense_open` formalization-note) that `[IsAlgClosed k̄]` is the ONLY
   added instance — that claim is now STALE and must be corrected to include the
   locally-of-finite-type hypothesis as a stated, load-bearing antecedent.

2. **Bridge 2's body was decomposed into two named top-level sub-lemmas**, one PROVEN and one
   the residual. The chapter must add `\lean{}` blocks for both so the dependency graph and
   `\leanok` sync track them (currently they have no blocks — flagged major by the iter-160
   lean-vs-blueprint-checker).

## Required content

### A. Correct the finite-type hypothesis across the chain blocks

In the blocks for `lem:rigidity_eqOn_saturated_open_to_affine`, `lem:rigidity_eqOn_dense_open`,
and `thm:rigidity_lemma` (and in any formalization-note prose that enumerates the added
instances), state explicitly that the formalization carries
`[\mathtt{LocallyOfFiniteType}\ (X \otimes Y).\mathrm{hom}]` in addition to
`[\mathtt{IsAlgClosed}\ \bar k]`. Explain in one sentence WHY: the route-(c) globalisation
needs the closed points of the saturated open `U` dense (the Jacobson-space property), which
over the algebraically closed field `\bar k` holds because `X \otimes Y` is locally of finite
type — and that this costs nothing in the genus-0/abelian-variety application, where every
object is of finite type over `\bar k`. Remove/replace the now-false "[IsAlgClosed] is the
only added instance" assertions (search the chapter for the stale "only added instance" /
"the only enabling instance" wording, including the `% NOTE` comment near the
`saturated_open` block that the iter-160 review left flagging this).

### B. Add `\lean{}` blocks for the two new sub-lemmas

**B1. `morphism_eq_of_eqAt_closedPoints` — Step 2, PROVEN (axiom-clean).** This is a
project-bespoke assembly (NO external source — omit the `% SOURCE` lines). Add a `\lemma`
block:
- `\label{lem:morphism_eq_of_eqAt_closedPoints}`
- `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}`
- Statement (in project notation): Let `W`, `Z` be schemes with `W` reduced, `W` a Jacobson
  space, and `Z` separated. If two morphisms `g₁, g₂ : W ⟶ Z` agree after restriction along
  the residue-field point `Spec κ(x) → W` at every CLOSED point `x ∈ W`, then `g₁ = g₂`.
- Proof sketch (the chapter prose for "Step 2" already describes this — promote it into the
  block's `\begin{proof}`): assemble all the closed points into one dominant probe, the
  coproduct `∐_{x ∈ closedPoints W} Spec κ(x) ⟶ W` (via `Sigma.desc` of the residue-field
  maps); its topological range is exactly the set of closed points, which is dense because
  `W` is Jacobson (`closure (closedPoints W) = univ`); hence the probe is dominant; the two
  morphisms agree after composing with each coproduct inclusion (componentwise, by the
  defining property of `Sigma.desc`), so by extensionality for a dominant morphism into a
  separated target (`ext_of_isDominant`) they are equal. This is the "dense closed points ⟹
  hom-extensionality" connective Mathlib does not package directly (it supplies only the
  single-dominant-morphism `ext_of_isDominant`).

**B2. `rigidity_eqAt_closedPoint_of_proper_into_affine` — Step 1, the residual deep
geometry (`sorry`).** This is Mumford's per-slice argument. **Reuse the Mumford verbatim
quote already present in this chapter** (the chapter already carries the Mumford "Abelian
Varieties, Ch. II §4, p. 43" rigidity quote — cite the SAME local reference file it was
originally read from; do NOT fabricate a new quote, and do NOT re-fetch if the existing
quote covers the slice step). Add a `\lemma` block:
- `\label{lem:rigidity_eqAt_closedPoint_of_proper_into_affine}`
- `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}`
- Statement: with the data of `lem:rigidity_eqOn_saturated_open_to_affine` (proper `X` over
  `k̄`, `k̄`-point `x₀`, `f : X ⊗ Y ⟶ Z`, the `p₂`-saturated open `U` mapping into the affine
  `U₀`), fix a CLOSED point `x` of `U`. Then `f` and the collapsed map `retract ≫ f`
  (`retract := (x,y) ↦ (x₀,y)`) agree at `x` after the residue-field probe
  `Spec κ(x) → U`.
- Proof sketch (cohomology-free route B; the chapter's existing "Step 1 / per closed slice"
  prose already describes it — promote it into this block's `\begin{proof}`): the closed
  point `x` lies over a closed point `y = p₂(x) ∈ Vset` with `κ(y) = k̄` (`[IsAlgClosed]`,
  finite type); saturation `_hUV` puts the whole proper integral fibre `X_y ≅ X` inside `U`,
  so `f` maps `X_y` into the affine `U₀`; since `X_y` is proper integral over `k̄`,
  `Γ(X_y, 𝒪) = k̄` (via `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed`
  + algebraic closedness), so `f|X_y` factors through a single `k̄`-point of `U₀`
  (`ext_of_isAffine`); that point is `f(x₀, y)` since `(x₀, y) ∈ X_y`, which equals
  `(retract ≫ f)(x)`. The relative Stein / `f_*𝒪 = 𝒪` framing is a confirmed Mathlib gap and
  is deliberately avoided.

### C. Add `\uses` edges (forward, acyclic)

In the `\begin{proof}` of `lem:rigidity_eqOn_saturated_open_to_affine`, add
`\uses{lem:morphism_eq_of_eqAt_closedPoints, lem:rigidity_eqAt_closedPoint_of_proper_into_affine}`
(its body now wires Step 2 over Step 1). Keep the existing forward chain edges intact
(`thm:rigidity_lemma` proof → `lem:rigidity_eqOn_dense_open`; `lem:rigidity_eqOn_dense_open`
proof → `lem:rigidity_eqOn_saturated_open_to_affine`). Do NOT introduce backward edges (no
edge FROM the two new leaf lemmas back UP to `saturated_open`/`dense_open`). The two new
sub-lemmas are leaves.

### D. Refresh the stale "lone residual sorry" decomposition prose

The chapter repeatedly states that `rigidity_eqOn_saturated_open_to_affine` is "the lone
residual `sorry` of the whole Rigidity-Lemma chain" (e.g. the `% NOTE`/comment block near
the top, and the decomposition remark). That is now stale: `rigidity_eqOn_saturated_open_to_affine`'s
body is real assembly (Step 2 proven + the JacobsonSpace instance now derivable from the
new finite-type hypothesis), and the chain's single genuinely-deep residual `sorry` is now
**`rigidity_eqAt_closedPoint_of_proper_into_affine`** (Step 1). Update the decomposition
prose / remark to say: Step 2 (`morphism_eq_of_eqAt_closedPoints`) is proven; the lone deep
residual of the chain is Step 1 (`rigidity_eqAt_closedPoint_of_proper_into_affine`).

## Out of scope

- The three deferred scaffolds `prop:morphism_P1_to_AV_constant`,
  `prop:genusZero_curve_iso_P1`, `thm:rigidity_genus0_curve_to_AV` (cube / Riemann–Roch) —
  do NOT touch.
- `thm:theorem_of_the_cube` — leave as the deferred deep input with no Lean target.
- Do NOT add `\leanok` / `\mathlibok` (managed elsewhere).
- Do NOT invent a new external citation for `morphism_eq_of_eqAt_closedPoints` (it is
  project-bespoke). For the slice lemma, reuse the existing Mumford quote already in the
  chapter; do not fabricate.

## References

- `references/mumford-abelian-varieties.md` (pointer) / the existing Mumford verbatim quote
  ALREADY in this chapter — for the slice-constancy lemma `rigidity_eqAt_closedPoint...`.
  Reuse what is already cited; only dispatch a reference-retriever if the existing quote does
  not cover the slice step and you genuinely need new verbatim text.
- The locally-of-finite-type ⟹ dense-closed-points (Jacobson) fact is standard and
  Mathlib-backed (`LocallyOfFiniteType.jacobsonSpace`, `closure_closedPoints`); state it as a
  hypothesis in prose — no new external verbatim source is required for it.

## Expected outcome

The chapter states the `[LocallyOfFiniteType (X ⊗ Y).hom]` hypothesis on the chain blocks
(no more "[IsAlgClosed] is the only added instance" claim), carries two new `\lean{}`-tagged
sub-lemma blocks (`lem:morphism_eq_of_eqAt_closedPoints` proven, with proof sketch;
`lem:rigidity_eqAt_closedPoint_of_proper_into_affine` residual, with proof sketch + reused
Mumford citation), with forward `\uses` edges from the `saturated_open` proof to both, and
the "lone residual sorry" prose updated to name `rigidity_eqAt_closedPoint_of_proper_into_affine`
as the chain's single deep residual.
