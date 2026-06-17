# Blueprint Writer Report

## Slug
bw254

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### 1. Rewrote sub-step (a) of the proof of `lem:sheafofmodules_hom_of_local_compat` (must-fix)
Replaced the `HEq`-based prose with the honest sectionwise hypothesis, as directed.
The new sub-step (a) states the compatibility hypothesis as: *for all `i, j` and every open
`V` with `V ≤ U_i` and `V ≤ U_j`, the section maps `(f_i).app(V)` and `(f_j).app(V)` agree
in the fixed abelian-group hom-type `M(V) ⟶ N(V)`* — the value of `ℋom(M,N)` at `V`. It then
gives the direct bridge to `IsCompatible` and a contrast paragraph explaining why the naive
`HEq` comparison of double-restrictions is unsatisfiable.

### 2. Added a `\begin{proof}` block to `lem:scheme_modules_hom_local_section` (minor add)
The lemma was statement-only; added a proof describing how the `app` field is built from
`(f_i).app(V')` (with `V' = ι_i⁻¹(V)`) by `eqToHom`-conjugation along the down-set identity
`ι_i(ι_i⁻¹(V)) = V`, and how the naturality field reduces, on source and target separately,
to `Subsingleton.elim` of parallel thin-poset edges combined with naturality of the
underlying ab-presheaf morphism of `f_i` across the induced preimage inclusion `κ`. Carries
`\uses{lem:open_immersion_slice_sheaf_equiv}`. No markers added.

## Before / After of sub-step (a)

**BEFORE** (the unsatisfiable `HEq` framing):
> *(a) The cocycle/`IsCompatible` condition ...* The overlap-agreement hypothesis is phrased
> with **heterogeneous** equality (`HEq`) rather than ordinary equality: the two
> double-restrictions `(f_i)|_{U_i∩U_j}` and `(f_j)|_{U_i∩U_j}` reach the overlap by two
> different slice-restriction routes, and the resulting morphisms live in types that are
> propositionally equal but not definitionally equal, so a homogeneous equation between them
> does not even type-check. ... once both sides are transported into the common type
> `H(U_i ⊓ U_j)` along those `eqToHom`s, the route-difference between the two restriction
> maps collapses --- any two parallel morphisms in the thin poset `(Opens X)^op` are equal,
> by `Subsingleton.elim` --- and the heterogeneous agreement becomes the required genuine
> equality of the two transported sections. Thus the `IsCompatible` condition is exactly the
> assumed agreement of `f_i` and `f_j` on the overlaps `U_i ∩ U_j` ...

**AFTER** (the honest sectionwise hypothesis):
> *(a) The cocycle/`IsCompatible` condition ...* The condition `IsCompatible` asks that ...
> the two restrictions of `localSection i` and `localSection j` to the overlap coincide ...
> an honest equality in the single abelian group `H(U_i ⊓ U_j)`. ... The correct hypothesis
> --- and the only one a caller can actually produce --- is the **sectionwise** one: *for all
> indices `i, j` and every open `V` with `V ≤ U_i` and `V ≤ U_j`, the two section maps
> `(f_i).app(V)` and `(f_j).app(V)` agree as morphisms in the single, fixed abelian-group
> hom-type `M(V) ⟶ N(V)`* ... It is worth contrasting this with a naive alternative that does
> **not** work [the two double-restrictions live in only-isomorphic, not propositionally
> equal, objects — sheafifications of pullback presheaves along different morphisms — so no
> `Subsingleton.elim` / heterogeneous elimination applies, and no caller can produce the
> datum]. ... With the sectionwise hypothesis in hand the passage to `IsCompatible` is
> **direct** [restrict, evaluate sectionwise via `lem:scheme_modules_hom_local_section` to
> `(f_i).app(V')` conjugated by `eqToHom`, the hypothesis equates the middle terms, the only
> remaining identification being the two `eqToHom`-routes agreeing by `Subsingleton.elim` on
> the thin poset].

**Confirmation:** the new substantive hypothesis is the sectionwise equality of
`(f_i).app(V)` and `(f_j).app(V)` in the fixed hom-type `M(V) ⟶ N(V)`. `eqToHom`/
`Subsingleton.elim` are named only as the mechanical thin-poset identifications, never as the
content.

## Cross-references introduced
- `\uses{lem:open_immersion_slice_sheaf_equiv}` added in the new proof of
  `lem:scheme_modules_hom_local_section` — label exists in this chapter (used elsewhere in
  the same proof, e.g. line ~5784).

## References consulted
None — this is a correction of project-bespoke (Archon-original) prose; no external citation
block is involved. I cross-checked the prose against the actual Lean construction in
`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (`homLocalSection`,
`homOfLocalCompat`, the `hcompat`/`IsCompatible` step) to ensure the rewritten sectionwise
description matches the `app`/`naturality` fields and the `Subsingleton.elim`/`eqToHom`
mechanics actually present there.

## Macros needed (if any)
None.

## Notes for Plan Agent
- The **statement** of `lem:sheafofmodules_hom_of_local_compat` (lines ~5742–5748) still
  reads "for all `i, j` the restrictions of `f_i` and `f_j` to `U_i ∩ U_j` agree" — vague
  enough to be consistent with the new sectionwise reading, so I left it per the directive's
  "do not touch other statements". If you want the statement to name the sectionwise form
  explicitly, that is a one-line follow-up.
- **Lean/blueprint divergence (not edited — out of my domain):** the current Lean signature
  of `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat` still takes `hf` as the `HEq` datum
  and carries a `sorry` in the `hcompat` step (with an in-file iter-253 blocker note
  recommending re-phrasing `hf` sectionwise — `hf` is in the PROTECTED signature). The
  blueprint now describes the correct sectionwise hypothesis; the Lean signature must be
  re-phrased (a mathematician edit to the protected signature) before prover work can close
  the `sorry`. This is a known, already-documented item, not a new finding.

## Strategy-modifying findings
None. The correction is a faithfulness fix between the blueprint and a satisfiable Lean
signature; it does not change the project's strategy. The sectionwise hypothesis is precisely
what callers (e.g. the `rem:dual_discharges_inverse` contraction-gluing) already produce, so
the downstream use is unaffected.
