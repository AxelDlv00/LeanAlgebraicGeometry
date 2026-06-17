Target: blueprint/src/chapters/Picard_SectionGradedRing.tex

ONE edit (blueprint-reviewer iter-048 MUST-FIX §1). FIRST read `analogies/snap-assoc.md` (the iter-048 analogist report) in full — it is your recipe.

## Expand `lem:sheafTensorPow_add` (`tensorPowAdd`) proof @L225-285
The current sketch says the comparison isos are "preserved by the sheafification functor" — this is FALSE/unestablished (`SheafOfModules R` has NO `MonoidalCategory` instance in Mathlib; sheafification is not known strong-monoidal). The iter-047 prover blocked here. Replace the gloss with the **Analogue 4** route from `analogies/snap-assoc.md`:

- The graded ring only needs the comparison on tensor POWERS of a LINE BUNDLE `L` (invertible), NOT a full `MonoidalCategory (SheafOfModules R)`.
- Build `μ_{m,m'} : L^{⊗m} ⊗ L^{⊗m'} ≅ L^{⊗(m+m')}` by induction on `m` (base = the left/right unitor already built; step uses the recursive def `L^{⊗(m+1)} = L^{⊗m} ⊗ L`, the already-built braiding, and an associator-comparison on the tensor-power factors).
- KEY: because the factors are LOCALLY FREE (invertible), the strong-monoidal comparison `sheafification(P)⊗sheafification(Q) ≅ sheafification(P⊗Q)` restricted to these factors is a genuine LOCAL iso — locally `𝒪⊗𝒪 = 𝒪`, the sheafification unit is locally the identity, right-exactness is NEVER invoked (this is why failed-approach "η_P⊗𝟙 not locally injective" does not bite: that bad object is never the one tested). State that the associator-comparison is obtained from a "locally-an-iso ⟹ IsIso" criterion for `SheafOfModules R` morphisms on locally-free factors.
- The commutativity/associativity constraints (`μ` cocycle / pentagon) are then proved as identities of these local isos.

Add a short note: the principled full structure (`LocalizedMonoidal` via `Sheaf.monoidalCategory` template, Analogue 1) is DEFERRED — it is gated on the Mathlib-absent `MonoidalClosed (PresheafOfModules R)`; the bespoke line-bundle route is the chosen unblock.

Update the proof block's `\uses{}` to reflect the route (keep `def:sheafTensorPow, def:sheafTensorObj`; the presheaf-monoidal anchor stays). Keep the Stacks 01CU SOURCE QUOTE.

Constraints: math prose only, no Lean tactics. Do NOT add `\leanok`. Do NOT author blocks for the 10 layer-1 helper decls (they will be marked `private` in Lean instead).
