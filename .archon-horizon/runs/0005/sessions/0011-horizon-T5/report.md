Committed. The session's work is complete — final report:

## Summary

**T5 advanced: both unblocked `IdentityComponent` sorries are closed, axiom-clean.** `IdentityComponent.isSubgroupHomomorphism` (Kleiman §5 Lem. 5.1(3)(b): `G⁰` inherits the group structure) and `IdentityComponent.baseChangeIso` (Lem. 5.1(3)(d) / Stacks 04KS: `(G⁰)_K ≅ (G_K)⁰`) are now proved in AJC `AlgebraicJacobian/Picard/IdentityComponent.lean`. File sorries: **8 → 6**, and every remaining sorry is externally blocked, so the §1 abstract group-scheme substrate of the chapter is finished.

## Progress

- `isSubgroupHomomorphism` via a Yoneda route: subgroup presheaf `T ↦ {f : T ⟶ G | im f ⊆ G⁰}` + `GrpObj.ofRepresentableBy`; closure under mul/inv from two connectedness core lemmas (`G⁰ ×ₖ G⁰` connected via `identityComponent_geometricallyConnected` + Mathlib's connected-pullback instance). ~230 LOC of helpers.
- `baseChangeIso` iso slot: carrier identification `fst⁻¹(G⁰) = (G_K)⁰` (clopen ⊇, preconnected-range ⊆; unit compatibility of `Over.grpObjMkPullbackSnd` proved point-level), assembled by `IsOpenImmersion.isoOfRangeEq ≪≫ pullbackRightPullbackFstIso`. ~110 LOC.
- Verified: `lake build AlgebraicJacobian.Picard.IdentityComponent` EXIT 0; `#print axioms` for both theorems (and `isOpenSubgroupScheme`) = `propext, Classical.choice, Quot.sound` only.
- Blueprint `Picard_IdentityComponent.tex`: both proof environments marked `\leanok`; subgroup proof text rewritten to the formalized argument (μ/inv closure + Yoneda); `\uses` extended with `lem:identity_component_geometrically_connected`. `horizon blueprint` refreshed — DAG shows both nodes `proved: True`.
- Ran alongside the live T2 build with no `.lake` interference (iterated via `lake env lean`; final build touched only disjoint targets).
- Recorded recipes as inbox memory `I-0052` and auto-memory `identitycomponent-subgroup-basechange-closed`; committed the 3 files (incl. session-0007 `GeometricallyConnectedSection.lean`, an import dependency) to the project VCS.

## Issues

- Remaining 6 sorries are all blocked, as expected: `isFiniteTypeGeometricallyIrreducible`'s QC∧GeomIrred conjunct (needs EGA IV₂ 4.6.1-type input) and the 5 FGA-tainted Pic⁰ declarations — do not re-probe before `AJC.picrep`.
- Minor lint warnings remain (one `simpa`→`simp` suggestion, several style warnings about load-bearing `show`s); non-blocking.
- Key dead end recorded: morphism-level `rw`/`assoc` against `grpObjMkPullbackSnd`'s unit is defeq-blocked (`(Over.pullback φ).obj X` vs `pullback X.hom φ`); `respectTransparency false` does **not** help — the working pattern is point-level `congrArg`-calc.
- Project repo still holds uncommitted T2/other-session files (left untouched on purpose); `SubProjects/Picard-IdentityComponent` mirror is now further behind AJC.

## Next

- Roadmap `AJC.pic0av`: the A.3 abstract substrate is done; the next unblocked value is the `tangentSpaceIso` cone (separate task), or adding the `PicSchemeLocallyOfFiniteType` typed-sorry instance to enable the `Pic0Scheme := GroupScheme.IdentityComponent (PicScheme C)` tidy.
- Ground: decide re-sync vs retirement of the stale `Picard-IdentityComponent` subproject mirror.
