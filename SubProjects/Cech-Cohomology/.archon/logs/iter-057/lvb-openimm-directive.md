# Lean ↔ blueprint check — OpenImmersionPushforward.lean

Verify bidirectionally one Lean file against its blueprint chapter.

Lean file:
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

Blueprint chapter:
- /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
  (consolidated chapter; the relevant block is `lem:modules_isoSpec_ext_transport` with
  `\lean{AlgebraicGeometry.modulesIsoSpecExtTransport}`, plus `lem:open_immersion_pushforward_acyclic`
  and `lem:open_immersion_pushforward_comp`).

This iter the prover added 4 axiom-clean declarations implementing Need #1 (Ext transport along the
whole-scheme spectrum equivalence): `Scheme.Modules.pushforwardEquivOfIso`,
`pushforwardEquivOfIso_functor_additive` (instance), `Scheme.Modules.pushforwardExtAddEquiv`,
`modulesIsoSpecExtTransport`. The transport uses
`Functor.mapExt_bijective_of_preservesInjectiveObjects` (NOT a functor-composition lemma for
`Ext.mapExactFunctor`, which is absent from Mathlib). The two pre-existing residual `sorry`s
(`_acyclic` ~line 373, `_comp` ~line 439) were left UNCHANGED — they are the assembly site gated on
Lanes 1+2 + the jShriekOU-naturality hand-off.

Report:
(a) Lean → blueprint: does `modulesIsoSpecExtTransport` (and its supporting chain) match the
    blueprint block `lem:modules_isoSpec_ext_transport`? Note the chapter's `\lean{...}` was just
    re-pointed from `_TODO` to the real name. Any fake/placeholder/vacuous statement, or does the
    blueprint claim a route (e.g. `Ext.mapExactFunctor` composition) that diverges from what the Lean
    actually does (`mapExt_bijective_of_preservesInjectiveObjects`)?
(b) blueprint → Lean: is the chapter accurate about the `[EnoughInjectives]` requirement and the
    `mapExt_bijective` mechanism, or does it still describe the absent functor-composition route? Is
    the jShriekOU-naturality hand-off (the remaining hard piece for `_acyclic`) blueprinted, or a gap?
    Confirm the 2 residual `sorry`s are honest holes with correctly-typed goals.
