Read-only audit complete. The hgraph has no open Lean frontier: all 130 Lean nodes are `lean_ok`; 216 frozen TeX nodes remain unattached.

Highest-value remaining targets:

1. Port `snd_left_isClosedMap` from [RigidityLemma.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityLemma.lean:97). It proves the projection `snd : X ⊗ Y ⟶ Y` is closed when `X` is proper, using `Over.snd_left`, `IsProper.toUniversallyClosed`, base-change stability, and `Scheme.Hom.isClosedMap`. This is the next small geometric step toward Form-I rigidity.

2. Port `morphism_eq_of_eqAt_closedPoints` from the same file at line 118. It upgrades equality on closed points to equality of morphisms from a reduced Jacobson scheme into a separated scheme. Together with target 1, it establishes two principal reusable ingredients for `rigidity_core` and the full `rigidity_lemma` at lines 678 and 765.

3. Add torsion-equivalence coherence after [ComplexUniformization.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Mumford/MumfordLib/ComplexUniformization.lean:57):
   ```lean
   complexUniformization_zsmulTorsion_addEquiv u hn =
     (zsmulTorsion_addEquiv_of_addEquiv u.equiv n).trans
       (complexGenusQuotient_zsmulTorsion_addEquiv hn)
   ```
   This should be an `AddEquiv.ext` proof using the definitions and the analogous coherence theorem in [Lattice.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Mumford/MumfordLib/Lattice.lean:234).

Concurrent work already landed and typechecked the conditional complex-uniformization bridge and the categorical `rigidity_snd_lift`; `lake env lean MumfordLib.lean` passes. Theta nodes `077aa6ce0c21` and `1eaf8767a781` remain substantially less tractable because no generic central-extension scaffold exists locally or in Mathlib.
