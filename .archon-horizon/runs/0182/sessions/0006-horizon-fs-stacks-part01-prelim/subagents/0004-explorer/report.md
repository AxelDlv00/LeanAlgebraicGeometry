Read-only scout report for `/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part01_Preliminaries`.

The required `.claude/skills/horizon/SKILL.md` could not be found anywhere under `/home/axel`; I proceeded using the repository README and metadata. Blueprint frontier confirms all three below are `state: ready`, `lean_status: empty`, `proved: false`:

1. `algebra-lemma-compose-finite-type` (Stacks `00F4`, hgraph `d1f0cf03f141`)

   Best focused node: composition of finite-type ring maps:
   ```lean
   theorem finiteType_comp
       {A B C : Type*} [CommRing A] [CommRing B] [CommRing C]
       {f : A →+* B} {g : B →+* C}
       (hf : f.FiniteType) (hg : g.FiniteType) :
       (g.comp f).FiniteType :=
     RingHom.FiniteType.comp hg hf
   ```
   Likely import: `Mathlib.RingTheory.FiniteType`.

   Mathlib API is exactly `RingHom.FiniteType.comp`; note argument order is `(hg : g.FiniteType) (hf : f.FiniteType)`.

2. `algebra-lemma-finite-finite-type` (Stacks `0D46`, hgraph `dd3238b83bf6`)

   Part (1) is immediate:
   ```lean
   theorem finite_isFiniteType
       {A B : Type*} [CommRing A] [CommRing B]
       {f : A →+* B} (hf : f.Finite) :
       f.FiniteType :=
     RingHom.Finite.to_finiteType hf
   ```
   Likely import: `Mathlib.RingTheory.FiniteType`.

   Part (2), “finite presentation as an `A`-module implies finite presentation of the ring map,” is also available through `Mathlib.RingTheory.Finiteness.ModuleFinitePresentation`, especially `Algebra.FinitePresentation.of_finitePresentation` / `Module.FinitePresentation.of_finite_of_finitePresentation`, but may need careful typeclass setup. Recommend implementing part (1) first as the small ready node.

3. `algebra-lemma-localization-zero` (Stacks `00CQ`, hgraph `5ae4daee349e`)

   Mathlib gives the core equivalence:
   ```lean
   IsLocalization.subsingleton_iff :
     Subsingleton S ↔ 0 ∈ M
   ```
   for a localization map of `R` at submonoid `M`. A theorem for the usual localization can likely be stated as:
   ```lean
   theorem localization_subsingleton_iff
       {R S : Type*} [CommSemiring R] [CommSemiring S]
       (M : Submonoid R) [Algebra R S] [IsLocalization M S] :
       Subsingleton S ↔ 0 ∈ M :=
     IsLocalization.subsingleton_iff
   ```
   Likely import: `Mathlib.RingTheory.Localization.Defs` (or `Mathlib.RingTheory.Localization.Basic` depending on the chosen localization construction).

Existing files already cover topology image/compactness, spectrum/Zariski identities, radicals, basic localization module maps, Noetherian basics, and finite-over-subring, so those areas should be avoided for non-overlap.
