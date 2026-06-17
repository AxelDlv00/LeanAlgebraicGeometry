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
| DUAL dual-inverse (`DualInverse/SliceTransport.lean`) | ACTIVE | ~1–3 | ~60–150 | `IsIso.inv_comp_eq`, `ModuleCat.restrictScalars_η`, `restrictScalarsComp'App` | 3 sorries left (inv-naturality root + left/right_inv; forward naturality closed) — rotate `inv ε` morphism-level, never pointwise |
| D3′ comparison iso (`TensorObjSubstrate.lean`) | ACTIVE | ~3–5 | ~120–300 | `conjugateEquiv` (Mates); Sq3 `sheafifyTensorUnitIso` + Sq4 `pullbackValIso` coherences | Sq3/Sq4 decomposed into 3 \uses-linked bricks; D4′ chart-chase after |
| Coverage + file-split cleanup | NEXT | ~1–2 | ~0 (tex/private) | — | ~97 `lean_aux` isolated nodes; split `TensorObjSubstrate.lean` (3152 LOC, GREEN) next |
| Consumer assembly (`RelPicFunctor.lean`) | BLOCKED | ~1–2 | ~30–80 | — | gated on both routes closing (`exists_tensorObj_inverse`) |

## Routes

The relative Picard substrate needs two isomorphisms on locally trivial line
bundles; the two are independent and run in parallel.

### D3′ — the comparison iso
Substrate prerequisite `IsInvertible.pullback` reduces to `f^*(M⊗N)≅f^*M⊗f^*N`
on loc-triv pairs: δ (`pullbackTensorMap`, ✓) upgraded to an iso via
`isIso_of_isIso_restrict` over `{f⁻¹(Uᵢ)}`, each chart reducing to the unit pair
via `pullbackUnitIso` (✓). D1′/D2′/Sq1/Sq2/Sq2b CLOSED (Sq1 =
`sheafificationCompPullback_comp_tail`, closed via `conjugateEquiv_comp` at the NatTrans level).
Remaining: the `pullbackTensorMap_restrict` final paste — the Sq3/Sq4 coherence interleave, which
needs project sub-lemmas that do not exist yet. Decomposed into three bricks
(`lem:sheafify_pullbackcomp_hom_inv_cancel`, Sq3 `lem:sheafify_tensor_unit_iso_comp`, Sq4
`lem:pullback_val_iso_comp`) + a `comp_δ`-split assembly. Then D4′ chart-chase. All region rewrites
need `erw` (carrier-spelling mismatch). Recipe: `analogies/d3cocycle006.md`.

### DUAL — the dual-inverse (RPF group inverse)
`exists_tensorObj_inverse` (the relative-Picard group inverse) takes route-2:
dual-content via `sliceDualTransport` sectionwise = leg-A slice-Hom base-change
(`.map` reindex across `f.opensFunctor`) ∘ leg-B unit ε-iso
`inv (ε (restrictScalars g))`, `g` at the `CommRingCat` level
(`analogies/ma-legb262.md`). The single `dual_restrict_iso` closes the whole
remaining inverse chain once the A-bridge `homOfLocalCompat` glues the local
contractions to the global morphism (the C-bridge / dual-transport part is in
`dual_restrict_iso`, the B-bridge is `isIso_of_isIso_restrict`). ROOT-CAUSE fix for the
`sliceDualTransport` naturality churn: leg-B is `inv ε`; NEVER
apply it pointwise (that forces `whnf` on the deep composite → heartbeat timeout). Rotate the
iso edge morphism-level via `IsIso.inv_comp_eq` → forward ε-square, close with `restrictScalars_η`/
`restrictScalarsComp'App`. Recipe: `analogies/dualnat006.md`. The `sliceDualTransport`/
`sliceDualTransportInv` + ring-swap machinery lives in its own file `DualInverse/SliceTransport.lean`;
the forward `sliceDualTransport` naturality is closed via this recipe — the open work is the
remaining 3 sorries (inv-naturality root, then left/right_inv round-trips). The dual returns a
**loc-triv** witness `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (L⊗Linv≅𝒪)`, so
group closure stays in the carrier. Split across `DualInverse.lean` + `DualInverse/SliceTransport.lean`.

### Consumer (third seed)
`PicSharp.addCommGroup_via_tensorObj` (`RelPicFunctor.lean`) builds the group on
loc-triv iso-classes: `map_add` ← D3′ comparison iso; `map_zero` ←
`pullbackUnitIso`; inverse ← `exists_tensorObj_inverse` (DUAL). Gated on both
routes. Carrier = `IsLocallyTrivial`; `map_add` consumes the comparison ISO.

## Open strategic questions

- Completeness vs AJC parent: RESOLVED — the 3-seed cone is complete
  (108/108 nodes, cone sizes 52/36/32 match exactly, `DualInverse` decls complete). Only diffs
  are AJC dead code (Lan block) + out-of-scope Route-A. Nothing required is missing; the open
  `sorry`s are frontier math AJC itself has not closed.
- Coverage debt: ~97 Lean decls (prover-created helpers) have no blueprint entry
  (`leandag unmatched`); dispositioned non-blocking. Scheduled as
  the `Coverage + file-split cleanup` phase: author blueprint blocks for load-bearing helpers, mark
  genuine internals `private`. User policy: no isolated/∞ blueprint nodes; split `.lean` files >1000/1500 LOC —
  `DualInverse.lean` split done; `TensorObjSubstrate.lean` (3152 LOC) split is the next refactor.
- Sq1 cocycle: now framed at the NatTrans level via `conjugateEquiv_comp` (Mates.lean) with the
  working template `pullbackObjUnitToUnit_comp` (`analogies/d3cocycle006.md`); the older
  whiskerLeft/`d3-mate271.md` component approach is superseded (it kept hitting the dependent δ-splice).
- Consumer (when unblocked): blueprint should make explicit which group axioms ride
  the monoidal associator vs. the comparison iso, so the consumer doesn't assume the
  iso discharges more than additivity-of-pullback.
- **Out of scope** (sibling extracts): A.2.c representability + Quot/Cartier engine →
  Quot-Foundations; Čech higher direct image → Cech-Cohomology; A.3 tangent/Pic⁰-AV,
  A.4 Albanese UP, Route-C Riemann–Roch, genus-0 arm → parent-scope. Cones disjoint
  (0 overlap with both siblings).

## Mathlib gaps & new material

Gaps to fill:
- DUAL route-2 `sliceDualTransport` — built by hand (leg-A slice-Hom base-change ∘
  leg-B unit ε-iso); ε-naturality via morphism-level `IsIso.inv_comp_eq` rotation (`analogies/dualnat006.md`).
- A-bridge `homOfLocalCompat` — glues compatible local `𝒪_X`-module morphisms to a
  global morphism via `homLocalSection`, `topSectionToHom`, and `homMk`.
- D3′ — upgrade δ (`pullbackTensorMap`) to iso via `isIso_of_isIso_restrict`.

New project material:
- By-hand `AddCommGroup` on loc-triv iso-classes (Mathlib `Sheaf.monoidalCategory`
  needs a FIXED `MonoidalCategory A`; varying-ring tensor on `X.Modules` has none).
  Modeled on Mathlib `CommRing.Pic.mapAlgebra`.
- `IsInvertible M := ∃N, M⊗N≅𝒪` carrier for `Pic X` (Stacks 0B8K/01CX);
  `picCommGroup` axiom-clean.
