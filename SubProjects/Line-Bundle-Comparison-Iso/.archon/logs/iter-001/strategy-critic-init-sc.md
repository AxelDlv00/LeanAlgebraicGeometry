# Strategy Critic Directive

## Slug
init-sc

## Project goal

Formalize the comparison-isomorphism substrate on line bundles (A.1.c.sub cone of
the Algebraic-Jacobian-Challenge). Three seed declarations must be proved
`sorry`-free with kernel-only axioms: (1) `Modules.pullbackTensorIsoOfLocallyTrivial`
— the loc-triv comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N`; (2) `Modules.dual_isLocallyTrivial`
— dual of a loc-triv module is loc-triv; (3) `PicSharp.addCommGroup_via_tensorObj`
— the `AddCommGroup` structure on the relative Picard sheaf `Pic♯_{C/k}` assembled
from (1) and (2). No protected signatures (seeds are targets to build).

## Strategy under review

<paste verbatim below>

```
# Strategy

## Goal

Build the **comparison-isomorphism substrate on line bundles** — the A.1.c.sub
work package carved from Christian Merten's Jacobian challenge
(`references/challenge.lean.ref`). Final deliverables = three seed nodes + their
108-node cone, with zero inline `sorry` in each seed's cone and kernel-only axioms:

- `lem:pullback_tensor_iso_loctriv` — `Modules.pullbackTensorIsoOfLocallyTrivial`:
  loc-triv comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N` (D3′ route).
- `lem:dual_isLocallyTrivial` — `Modules.dual_isLocallyTrivial`: dual of a
  loc-triv module is loc-triv (DUAL route).
- `thm:rel_pic_addcommgroup_via_tensorobj` — `PicSharp.addCommGroup_via_tensorObj`:
  assembles these into the `AddCommGroup` on the relative Picard sheaf `Pic♯_{C/k}`.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|-------|--------|-----------|-----|-------------------|-------|
| D3′ comparison iso (`TensorObjSubstrate.lean`) | ACTIVE | ~3–5 | ~120–300 | `Adjunction.Mates.conjugateEquiv_whiskerLeft`, sheafification adjunction | Sq1 mate-calculus is the hard step; D4′ chart-chase after |
| DUAL dual-inverse (`DualInverse.lean`) | ACTIVE | ~3–5 | ~100–250 | `PresheafOfModules.restrictScalarsLaxε`, `leftAdjointUniq` | `dual_restrict_iso` Step-4 `isoMk` naturality chase |
| Consumer assembly (`RelPicFunctor.lean`) | BLOCKED | ~1–2 | ~30–80 | — | gated on both routes closing (`exists_tensorObj_inverse`) |

## Routes

The relative Picard substrate needs two isomorphisms on locally trivial line
bundles; the two are independent and run in parallel.

### D3′ — the comparison iso
Substrate prerequisite `IsInvertible.pullback` reduces to `f^*(M⊗N)≅f^*M⊗f^*N`
on loc-triv pairs: δ (`pullbackTensorMap`, ✓) upgraded to an iso via
`isIso_of_isIso_restrict` over `{f⁻¹(Uᵢ)}`, each chart reducing to the unit pair
via `pullbackUnitIso` (✓). D1′/D2′/Sq2/Sq2b/Sq3/Sq4 CLOSED. Remaining: Sq1
(`sheafificationCompPullback_comp` / `…_comp_tail`) via `conjugateEquiv_whiskerLeft`
+ `leftAdjointUniqUnitEta_app`; then `pullbackTensorMap_restrict` paste + D4′
chart-chase. Recipe: `analogies/d3-mate271.md`.

### DUAL — the dual-inverse (RPF group inverse)
`exists_tensorObj_inverse` (the relative-Picard group inverse) takes route-2:
dual-content via `sliceDualTransport` sectionwise = leg-A slice-Hom base-change
(`.map` reindex across `f.opensFunctor`) ∘ leg-B unit ε-iso
`inv (ε (restrictScalars g))`, `g` at the `CommRingCat` level
(`analogies/ma-legb262.md`). The single `dual_restrict_iso` closes the whole
remaining inverse chain (A/B descent bridges already closed). The dual returns a
**loc-triv** witness `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (L⊗Linv≅𝒪)`, so
group closure stays in the carrier. Self-contained in `DualInverse.lean`.

### Consumer (third seed)
`PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`) builds the group on
loc-triv iso-classes: `map_add` ← D3′ comparison iso; `map_zero` ←
`pullbackUnitIso`; inverse ← `exists_tensorObj_inverse` (DUAL). Gated on both
routes. Carrier = `IsLocallyTrivial`; `map_add` consumes the comparison ISO.

## Open strategic questions

- Coverage debt: 91 Lean decls (prover-created helpers) have no blueprint entry
  (`leandag unmatched`). Clear by authoring blueprint blocks or marking private.
- Sq1 mate-calculus: if `conjugateEquiv_whiskerLeft` `have` is fiddly, the
  non-circular fallback re-proves `sheafificationCompPullback_comp` wholesale via
  `conjugateEquiv` surjectivity/injectivity (recorded in `analogies/d3-mate271.md`).

## Mathlib gaps & new material

Gaps to fill:
- DUAL route-2 `sliceDualTransport` — built by hand (leg-A slice-Hom base-change ∘
  leg-B unit ε-iso); ε-naturality via `PresheafOfModules.restrictScalarsLaxε`.
- D3′ — upgrade δ (`pullbackTensorMap`) to iso via `isIso_of_isIso_restrict`.

New project material:
- By-hand `AddCommGroup` on loc-triv iso-classes (Mathlib `Sheaf.monoidalCategory`
  needs a FIXED `MonoidalCategory A`; varying-ring tensor on `X.Modules` has none).
  Modeled on Mathlib `CommRing.Pic.mapAlgebra`.
- `IsInvertible M := ∃N, M⊗N≅𝒪` carrier for `Pic X` (Stacks 0B8K/01CX);
  `picCommGroup` axiom-clean.

## Out of scope (parent / sibling extracts)

A.2.c representability + Quot/Cartier engine → **Quot-Foundations** extract. Čech
higher direct image → **Cech-Cohomology** extract. A.3 tangent/Pic⁰-AV, A.4
Albanese UP, Route-C Riemann–Roch, genus-0 arm — all parent-scope, dropped here
(cones disjoint, 0 overlap with both siblings).
```

## References index

This subproject keeps only sources cited by its 3 blueprint chapters.
- `challenge.lean.ref` — original challenge file (Christian Merten); authoritative signatures for merge-back.
- `stacks-modules.md → stacks-modules.tex` — Stacks ch.17 Modules; tag 01CR §17.25 invertible modules (Def 01CS, Lemma 0B8K ∃N char., tag 01CX Pic(X) abelian group). Primary source for `Picard_TensorObjSubstrate.tex`.
- `kleiman-picard.md → .pdf` — Kleiman "Picard scheme" (arXiv:math/0504020). Backs `Picard_RelPicFunctor.tex`.
- `fga-explained.md → .pdf` — FGA Explained (AMS MSM 123). Companion to kleiman-picard.

## Blueprint summary

- `Picard_LineBundlePullback.tex` — pullback of line bundles; `OnProduct` carriers; `IsLocallyTrivial.pullback`.
- `Picard_TensorObjSubstrate.tex` — invertibility, tensor-object monoidal substrate, internal Hom / dual, the D3′ comparison iso and DUAL dual-inverse machinery (covers the substrate + DualInverse/StalkTensor/PresheafInternalHom files).
- `Picard_RelPicFunctor.tex` — relative Picard functor `Pic♯_{C/k}`; the by-hand `AddCommGroup` consumer assembly.

## Prior critique status

no prior critique
