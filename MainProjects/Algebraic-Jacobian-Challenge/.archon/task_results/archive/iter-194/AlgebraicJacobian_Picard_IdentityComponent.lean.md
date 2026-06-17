# AlgebraicJacobian/Picard/IdentityComponent.lean

**Lane A.3.i — iter-194 prover dispatch.**
Mode: `mathlib-build` (helper budget 4).
Entering state: 9 sorries. Exit state: **9 sorries** (count unchanged —
HARD BAR met via instance demotion; substantive PUSH-BEYOND on
`geometricallyConnected_of_connected_of_section` body restructured but
not closed; precise gap surfaced).

## HARD BAR status

**MET** — via the **instance demotion** branch of the disjunctive HARD BAR
("EITHER demote instance + supply `letI` at consumer sites, OR close
Stacks 037Q iff-direction").

## identityComponent_geometricallyConnected (L500 → L567) — instance demotion

### Attempt 1
- **Approach**: Per lean-auditor iter-193 must-fix + PROGRESS.md Lane
  A.3.i target (i), demote `private instance` to `private theorem`. The
  silent `sorryAx`-instance was a soundness exposure: any downstream
  typeclass search resolving `GeometricallyConnected (IdentityComponent
  G).hom` would have silently propagated the `sorryAx` axiom dependency
  from `geometricallyConnected_of_connected_of_section`.
- **Result**: **RESOLVED** axiom-clean.
- **Mechanic**: keyword swap `instance` → `theorem`; docstring expanded
  to flag the demotion + record the iter-195+ usage idiom
  (`letI := identityComponent_geometricallyConnected G`).
- **Consumer audit**: grep confirms zero typeclass-resolution
  consumers in the file (only docstring/comment references at L369,
  L547, L549, L562, L689, L690). No `letI` rewrites required at any
  consumer site. The demotion is invisible to the rest of the build.
- **Verification**: `lean_verify` confirms
  `IdentityComponent.isOpenSubgroupScheme` axiom dependency is
  `{propext, Classical.choice, Quot.sound}` (no `sorryAx`).
  `identityComponent_geometricallyConnected` still depends on
  `sorryAx` transitively (via the demoted-to-lemma body) but cannot
  silently propagate into typeclass resolution paths.

## geometricallyConnected_of_connected_of_section (L414) — PUSH-BEYOND body restructure

### Attempt 1
- **Approach**: Restructure the body from bare `:= sorry` into a tactic
  proof that exposes the Stacks 037Q gap with maximal precision.
  Strategy:
  1. Use `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms`
     to reduce the goal to:
     `∀ K [Field K] [Algebra k K],
       ConnectedSpace (pullback f (Spec.map (algebraMap k K)))`.
  2. Construct the base-changed section `_sK : Spec K ⟶ pullback f g`
     explicitly via `pullback.lift (g ≫ s) (𝟙 _) (...)`. This is
     axiom-clean and uses the `_hsf : s ≫ f = 𝟙` hypothesis (so it is
     no longer "unused" structurally).
  3. Derive `Nonempty ↑↑(pullback f g).toPresheafedSpace` from `_sK`.
  4. Document precisely the two missing Mathlib pieces:
     - **Stacks 04KV**: reduction of geometric connectedness to
       finite separable extensions.
     - **Field-tensor-product criterion**: `k` alg-closed in `K` +
       `k'/k` finite separable ⟹ `K ⊗_k k'` is a field. The converse
       direction is in Mathlib (`Algebra.TensorProduct.isField_of_isAlgebraic`)
       but expects `Algebra.IsAlgebraic` rather than "alg-closed-in"
       data.
- **Result**: **PARTIAL** — body restructured, structural advance
  axiom-clean (the `_sK` construction + `Nonempty` derivation use no
  new `sorry`), but the residual `ConnectedSpace` goal stays sorry.
- **Why not full closure**: Stacks 04KV (the reduction to finite
  separable extensions) and the "field-tensor-product criterion" are
  both genuine Mathlib gaps at SHA b80f227. Neither can be discharged
  axiom-clean within helper-budget = 4 in this iter without
  building substantial new substrate (linear-disjointness machinery +
  Galois descent of clopen partitions). Per the Lane A.3.i stuck
  protocol, this lane's recurrent gap is escalated to the iter-200
  mathlib-analogist sweep.
- **Key insight**: The structural reduction via
  `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms` is
  axiom-clean and exposes the gap at a much more precise surface than
  the bare `:= sorry`. The next prover (or iter-200 mathlib-analogist
  consult) starts from a fully concrete goal:
  `ConnectedSpace ↥(pullback f (Spec.map (CommRingCat.ofHom (algebraMap k K))))`
  with `Nonempty ↑↑(pullback f g).toPresheafedSpace` already derived.

### Negative search results

- "geometricallyConnected section connected scheme" — no Mathlib
  lemma covers the section-direction (Stacks 037Q is not present).
- "faithfully flat descent clopen partition scheme" — Mathlib has
  `Flat.isQuotientMap_of_surjective` for flat+QC+surjective, but the
  fibre-connectedness needed to bootstrap the descent argument is the
  same Stacks 037Q gap.
- "Algebra.TensorProduct.isField_of_isAlgebraic" — wrong direction
  (asserts: `IsDomain ⊗-product` + algebraic ⟹ field; we need:
  alg-closed-in + separable ⟹ field).
- "ConnectedSpace IsClosedUnderIsomorphisms" — confirmed via
  `lean_run_code` test that `(fun X : Scheme => ConnectedSpace X)`
  satisfies `ObjectProperty.IsClosedUnderIsomorphisms` (used for the
  `geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms`
  rewrite to fire).

## Remaining sorries on the file (unchanged at 9)

The file remains at 9 sorries:
1. L414 — `geometricallyConnected_of_connected_of_section` (Stacks
   037Q gap; body now restructured with precise gap surface; iter-200
   mathlib-analogist target).
2. L591 — `IdentityComponent.isSubgroupHomomorphism` (Kleiman §5
   conclusion (b)).
3. L615 — `IdentityComponent.isFiniteTypeGeometricallyIrreducible`
   second conjunct (QuasiCompact + GeometricallyIrreducible).
4. L664 — `IdentityComponent.baseChangeIso` iso slot.
5. L738 — `Pic0Scheme` (`:= sorry` carrier; carrier-soundness
   refactor target iter-195+).
6. L779 — `PicScheme.degree` (`:= sorry` carrier).
7. L830 — `Pic0Scheme.isAbelianVariety`.
8. L850 — `Pic0Scheme.finrank_eq_genus`.
9. L872 — `Pic0Scheme.kPoints_iff_kerDegree`.

(Sorry-line numbers shifted from the entry-state list because the
body restructure of `geometricallyConnected_of_connected_of_section`
added comment lines — the *count* is unchanged.)

## Iter-195 next-step recommendations (for the plan agent)

1. **Stacks 037Q gap escalation to iter-200**: per Lane A.3.i 4-iter
   stuck protocol, this gap is the canonical case for the iter-200
   mandatory mathlib-analogist sweep. Question for the analogist:
   "Does Mathlib (any branch) have a path from `ConnectedSpace X` +
   `k`-rational section ⟹ `GeometricallyConnected (X → Spec k)`?
   What is the Mathlib SHA / PR that would land Stacks 04KV?"
2. **`baseChangeIso` iso slot (L664)**: this is gated on the same
   Stacks 037Q closure (the iso construction needs `ConnectedSpace
   (pullback (IdentityComponent G).hom φ)`, which derives once
   `identityComponent_geometricallyConnected` becomes axiom-clean).
3. **Carrier soundness refactor (Pic0Scheme `:= sorry` at L738,
   PicScheme.degree at L779)**: standing iter-195 commitment; not
   this lane's work.

## Blueprint marker recommendation

`lem:geometricallyConnected_of_connected_of_section` in
`chapters/Picard_IdentityComponent.tex` was added iter-194 plan-phase
and currently has `\lean{...}` pin to
`AlgebraicGeometry.GroupScheme.IdentityComponent.geometricallyConnected_of_connected_of_section`.
The Lean target's body now has a typed `sorry`; `\leanok` should NOT
appear on the proof block until the body is axiom-clean (the
`sync_leanok` deterministic phase handles this — no agent action
needed).

`thm:identity_component_open_subgroup`, `def:identity_component_group_scheme`
are axiom-clean and already carry `\leanok`. No marker change requested.

## Summary

- **HARD BAR**: met via instance demotion (lean-auditor iter-193
  must-fix CLEARED).
- **PUSH-BEYOND**: body restructure of
  `geometricallyConnected_of_connected_of_section` — axiom-clean
  structural advance (`pullback.lift` section construction +
  `Nonempty` derivation), residual sorry now at precise Stacks 037Q
  surface.
- **Sorry count**: 9 → 9 (no net change; the demotion costs no
  sorry, the body restructure neither adds nor removes).
- **Axioms**: 0 new axioms introduced. The file remains kernel-only
  in its axiom-clean lemmas; `sorryAx` is confined to the named
  sorry-bodied lemmas listed above and (post-demotion) cannot
  silently propagate via typeclass resolution.
- **Build**: GREEN.
