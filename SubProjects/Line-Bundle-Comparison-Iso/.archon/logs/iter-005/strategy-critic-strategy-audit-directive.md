# Strategy Critic Directive

## Slug
strategy-audit

## Project goal

Build the comparison-isomorphism substrate on line bundles for the A.1.c.sub slice of the Jacobian challenge. The end-state is zero inline `sorry` in the dependency cones of the three seed declarations, with kernel-only axioms only:

- `lem:pullback_tensor_iso_loctriv` — `Modules.pullbackTensorIsoOfLocallyTrivial`.
- `lem:dual_isLocallyTrivial` — `Modules.dual_isLocallyTrivial`.
- `thm:rel_pic_addcommgroup_via_tensorobj` — `PicSharp.addCommGroup_via_tensorObj`.

## Strategy under review

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
| D3′ comparison iso (`TensorObjSubstrate.lean`) | ACTIVE | ~3–5 | ~120–300 | `CategoryTheory.conjugateEquiv` (Mates) + project `_whiskerLeft` helper to build; sheafification adjunction | Sq1 mate-calculus is the hard step; D4′ chart-chase after |
| DUAL dual-inverse (`DualInverse.lean`) | ACTIVE | ~3–5 | ~100–250 | `PresheafOfModules.restrictScalarsLaxε`, `leftAdjointUniq` | `dual_restrict_iso` Step-4 `isoMk` naturality chase + A-bridge glue |
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
remaining inverse chain once the A-bridge `homOfLocalCompat` glues the local
contractions to the global morphism (the C-bridge / dual-transport part is in
`dual_restrict_iso`, the B-bridge is `isIso_of_isIso_restrict`). The dual returns a
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
- Sq1 mate-calculus: `conjugateEquiv_whiskerLeft` is a to-build project helper (NOT
  a Mathlib import — base `CategoryTheory.conjugateEquiv` is). If the `have` is
  fiddly, the non-circular fallback re-proves `sheafificationCompPullback_comp`
  wholesale via `conjugateEquiv` surjectivity/injectivity (`analogies/d3-mate271.md`).
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
  leg-B unit ε-iso); ε-naturality via `PresheafOfModules.restrictScalarsLaxε`.
- A-bridge `homOfLocalCompat` — glues compatible local `𝒪_X`-module morphisms to a
  global morphism via `homLocalSection`, `topSectionToHom`, and `homMk`.
- D3′ — upgrade δ (`pullbackTensorMap`) to iso via `isIso_of_isIso_restrict`.

New project material:
- By-hand `AddCommGroup` on loc-triv iso-classes (Mathlib `Sheaf.monoidalCategory`
  needs a FIXED `MonoidalCategory A`; varying-ring tensor on `X.Modules` has none).
  Modeled on Mathlib `CommRing.Pic.mapAlgebra`.
- `IsInvertible M := ∃N, M⊗N≅𝒪` carrier for `Pic X` (Stacks 0B8K/01CX);
  `picCommGroup` axiom-clean.

## References index

# References

<!-- archon:references-summary -->

This subproject (Line-Bundle Comparison Iso) keeps only the sources cited by
its three blueprint chapters (`Picard_LineBundlePullback`,
`Picard_TensorObjSubstrate`, `Picard_RelPicFunctor`).

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. This subproject is a carved slice of that challenge; signatures here remain authoritative for merge-back. |
| [`stacks-modules.md`](./stacks-modules.md) → `stacks-modules.tex` | Stacks ch.17 "Modules on Ringed Spaces" — **tag 01CR** = §17.25 "Invertible modules" (lines 4038–4411): Def 01CS (invertible module via tensor-equivalence functor, line 4047), Lemma 0B8K (∃N characterisation $\mathcal{L}\otimes\mathcal{N}\cong\mathcal{O}_X$, line 4067), tag 01CX (Picard group $\Pic(X)$ as abelian group under ⊗, line 4351). The primary source for `Picard_TensorObjSubstrate.tex` (invertibility, tensor-object monoidal structure, internal Hom / dual). |
| [`kleiman-picard.md`](./kleiman-picard.md) → `kleiman-picard.pdf` / `-src/*.tex` | Kleiman, "The Picard scheme" (FGA Explained / arXiv:math/0504020). Route A source for the relative Picard sheaf; backs `Picard_RelPicFunctor.tex` (§2 functor of points / sheafification of the relative Picard functor). |
| [`fga-explained.md`](./fga-explained.md) → `fga-explained.pdf` | Fantechi–Göttsche–Illusie–Kleiman–Nitsure–Vistoli, "FGA Explained" (AMS MSM 123, 2005). Collected volume; **Kleiman Picard** = Ch.9 (book p.237): §9.4 existence p.262, §9.5 Pic⁰ p.275. Companion to the arXiv `kleiman-picard` card (book numbering differs). |

## Blueprint summary

- `blueprint/src/chapters/Picard_LineBundlePullback.tex` - line-bundle pullback on a relative curve and set-valued relative Picard presheaf.
- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` - relative Picard sheaf substrate: abelian-group-valued quotient, tensor-object infrastructure, internal Hom, dual, and inverse chain.
- `blueprint/src/chapters/Picard_RelPicFunctor.tex` - relative Picard functor, group structure on the quotient, and etale sheafification.

## Prior critique status

no prior critique

## Routes audited

### Route: D3′ comparison iso (`TensorObjSubstrate.lean`)

- **Goal-alignment**: PASS — it targets the exact tensor-comparison iso needed for `pullback_tensor_iso_loctriv`.
- **Mathematical soundness**: PASS — the route mirrors the intended mate-calculus / sheafification-adjunction story.
- **Sunk-cost reasoning detected**: no
- **Infrastructure-deferral detected**: no
- **Phantom prerequisites**: none verified so far
- **Effort honesty**: reasonable — the remaining work is a real proof chunk, but the estimate matches the route scope.
- **Parallelism under-exploited**: no
- **Verdict**: SOUND

### Route: DUAL dual-inverse (`DualInverse.lean`)

- **Goal-alignment**: PASS — it is the inverse chain required for `dual_isLocallyTrivial` and the consumer inverse.
- **Mathematical soundness**: PASS — the route uses the expected duality and restriction-comparison infrastructure.
- **Sunk-cost reasoning detected**: no
- **Infrastructure-deferral detected**: yes — `exists_tensorObj_inverse` is deferred to the downstream dual chain; required by goal, but the plan does give a concrete upstream chain and timeline.
- **Phantom prerequisites**: none verified so far
- **Effort honesty**: reasonable — the scope is nontrivial but the estimate is in family with the D3′ row.
- **Parallelism under-exploited**: no
- **Verdict**: SOUND

### Route: Consumer assembly (`RelPicFunctor.lean`)

- **Goal-alignment**: PASS — it is the final assembly of the relative Picard AddCommGroup structure.
- **Mathematical soundness**: PASS — the consumer correctly depends on the two upstream routes.
- **Sunk-cost reasoning detected**: no
- **Infrastructure-deferral detected**: yes — this phase is explicitly blocked on the two upstream routes, which is acceptable because the goal does not require it to be started early.
- **Phantom prerequisites**: none verified so far
- **Effort honesty**: reasonable
- **Parallelism under-exploited**: no
- **Verdict**: SOUND

## Format compliance

- **Size**: within budget
- **Headings**: PASS
- **Per-iter narrative detected**: no
- **Accumulation detected**: no
- **Table discipline**: PASS
- **Format verdict**: COMPLIANT
