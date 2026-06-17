# Mathlib analogist — Lane A.3.i `IdentityComponent` substrate

## Mode: cross-domain-inspiration

The Lane A.3.i route (`Picard/IdentityComponent.lean`) is CHURNING per
the iter-190 progress-critic: net +3 sorries from phase entry, 16
helpers added across 4 iters, HARD SCOPE CAP escalation triggered with
0 closures in iter-189. The recurring blocker is the absence of an
EGA IV₂ 4.5.8 analog (scheme-level connectedness of products) at
Mathlib b80f227. This blocks closure of `isSubgroupHomomorphism`,
which in turn blocks `isFiniteTypeGeometricallyIrreducible` and
`baseChangeIso`. Continuing to add scaffolds without addressing the
substrate is the failure pattern.

## Structural problem

The project needs, for a connected group object `G` in `Sch/k` with
geometrically connected identity component `G^0 ⊂ G`:

1. **`G^0 × G^0` is connected** (so its image under
   `G × G → G, (a,b) ↦ a · b^{-1}` lands in `G^0`, the connected
   component containing the identity).
2. **A `GrpObj`-structure on `G^0`** inherited from `GrpObj G`
   restricted to the connected component.

The first ingredient (scheme-level product-of-connected-is-connected
under suitable geometric hypotheses) is what EGA IV₂ Prop 4.5.8 provides.
The second ingredient is the `Scheme.GrpObjAsOverPullback` / `OverClass`
bridging issue: Mathlib has
`Scheme.GrpObjAsOverPullback : [GrpObj (asOver M S)] → GrpObj (asOver
(pullback (M ↘ S) f) T)` but the project's `Over.mk (pullback.snd
G.hom φ)` shape doesn't directly unify with the `asOver M S` shape
without explicit `OverClass` bridging.

## Failed approaches

- iter-186/187: scaffold `isSubgroupHomomorphism` body as a sorry,
  rely on future helpers. **Why it failed:** the sorry's body needs
  `Set.range mul ⊆ Set.range ι`, which needs `G^0 × G^0` connected,
  which needs the missing Mathlib lemma. No amount of scaffold-side
  effort can close this without the substrate.
- iter-188: full `identityComponent_locallyConnectedSpace` axiom-clean
  via topology-side helpers (EGA I 6.1.9 analog). **Why it succeeded
  here but not for 4.5.8:** EGA I 6.1.9 is purely topological (locally
  Noetherian space ⟹ locally connected); EGA IV₂ 4.5.8 is a
  geometric statement about morphisms preserving connectedness across
  base change with geometric-irreducibility hypotheses.
- iter-189: explicit `change` to unfold `(IdentityComponent G).hom`
  enabled `LocallyOfFiniteType` to close inline (axiom-clean partial),
  but `QuasiCompact` and `GeometricallyIrreducible` both fail at the
  same substrate barrier.

## Search radius: narrow

Same general area (algebraic geometry / scheme theory in Mathlib), but
specifically:

1. Has Mathlib in any sub-area solved the structural pattern
   "connected component of identity in a group object is a sub-group-
   object" — even if not for schemes? (e.g.
   `Subgroup.connectedComponentOfOne` for topological groups; an
   analog for `LocallyConnectedSpace`-based identity components in
   `MeasurableSpace`-style structures; etc.)
2. Has Mathlib solved "product of two connected schemes (with suitable
   field/separability hypotheses) is connected"? Even for restricted
   cases (e.g. `geometrically_connected.prod` for ring-theoretic
   `IsGeometricallyConnected` instances, or `IsConnected.prod` for
   topological-space-level instances with geometric upgrades).
3. Is there a `Scheme.GrpObjAsOverPullback`-style bridge for
   `Over.mk (pullback.snd _ _)` that the project could consume
   without writing its own `OverClass` adapter? Look at
   `Mathlib/AlgebraicGeometry/Pullbacks.lean` and the `asOver`
   API in `Mathlib/CategoryTheory/Comma/OverPullback.lean` (or
   equivalent).

## Expected output

Per the cross-domain-inspiration mode contract, your report should be a
ranked list of structural analogues. For each:

- **The Mathlib citation** (file path + line; verify it exists at
  b80f227 via the LSP).
- **The technique used there.** Concise prose; no Lean code.
- **A concrete suggestion** for how to port it to the
  `GroupScheme.IdentityComponent` setting in the project. Include a
  realistic LOC estimate per suggestion.

Persist the report to `analogies/lane-a3i-isconnected-prod.md` (your
write-domain includes `analogies/**`) AND write your task_results
report to `task_results/mathlib-analogist-lane-a3i-isconnected-prod.md`.

## Why we're asking

The iter-190 plan-phase is DEFERRING the Lane A.3.i prover dispatch
this iter (per the progress-critic's recommendation: "stop adding
helpers"); the dispatch resumes iter-191 ONLY if the analogist verdict
identifies a tractable Mathlib path. If you return that the substrate
is genuinely unowned in Mathlib (no analogue, no shortcut), the
iter-191 plan-phase will commit to a project-side
`Scheme.isConnected_pullback_of_isGeometricallyConnected` build
(~80-150 LOC per iter-189 prover report's estimate). Your verdict
determines whether the project can route around the gap or must
build it.
