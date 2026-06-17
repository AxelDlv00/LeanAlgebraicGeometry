Target: blueprint/src/chapters/Picard_SectionGradedRing.tex

Action: Add 2 missing blocks (coverage debt) and specify the `relTensorProj` naturality route, so a
prover can close `relTensorProj.naturality` next iter. These are Archon-original (no external source —
omit SOURCE/SOURCE QUOTE lines). Each block: statement (project notation), `\label{}`, `\lean{}`,
accurate `\uses{}`, informal proof.

1. `\label{def:relTensorActR}` `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActR}`
   — right-action natural transformation `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`,
   component on m ⊗ s ⊗ n ↦ m ⊗ (s · n) (`actRmap`). Mirror of `def:relTensorActL`. Naturality by
   ⊗-induction, single fact `PresheafOfModules.map_smul Q`. `\uses{def:relTensorTriplePresheaf,
   def:relTensorDomainPresheaf}`.

2. `\label{def:relTensorProj}` `\lean{AlgebraicGeometry.Scheme.Modules.relTensorProj}`
   — the projection natural transformation `relTensorDomainPresheaf P Q ⟶ (toPresheaf R₀).obj (P ⊗_p Q)`
   (apex = the presheaf-monoidal tensor `PresheafOfModules.Monoidal.tensorObj`), component `projL`
   (m ⊗ n ↦ m ⊗ₜ n). This is the third leg of the relative-tensor coequalizer (cokernel of actL − actR).
   **Specify the naturality ROUTE explicitly** (this is the blocker, document it as the chosen path):
   - The objectwise naturality square is `projL_V ∘ (ℤ-tensor restriction) = (apex restriction) ∘ projL_U`,
     both sending m ⊗ n to `objRestrict P f m ⊗ₜ[R(V)] objRestrict Q f n`.
   - OBSTACLE: the apex restriction `((toPresheaf R₀).obj (P⊗Q)).map f` is the ABELIAN-presheaf
     restriction, and `PresheafOfModules.Monoidal.tensorObj_map_tmul` is stated for the MODULE-presheaf
     restriction `(P⊗Q).map f`; reconciling them re-elaborates `projL` against the apex codomain and
     demands the `RingCat`-carrier instance `Module ↑(R.obj V) ↑(P.obj V)` (via `forget₂ CommRingCat
     RingCat`), which is defeq-but-not-syntactic to the `CommRingCat`-carrier instance `projL` is built on.
   - ROUTE (chosen): prove naturality at the `ModuleCat`-PRESHEAF level — i.e. exhibit `relTensorProj`
     as `(toPresheaf R₀)` applied to a morphism of MODULE-presheaves, where `tensorObj_map_tmul` applies
     directly, THEN forget to `Ab`. Equivalently, introduce a `restrictScalars`/`forget₂`-carrier
     transport lemma identifying the two `Module` instances and rewrite the apex restriction before
     `map_tmul`. Name the module-presheaf-level intermediate as the concrete next Lean target.
   `\uses{def:relTensorDomainPresheaf}` (apex is Mathlib `PresheafOfModules.Monoidal.tensorObj`).

3. Expand the `lem:relativeTensor_as_coequalizer` step-2 prose: it builds the objectwise coequalizer
   `relTensorTriplePresheaf ⇉ relTensorDomainPresheaf → (toPresheaf).obj(P⊗Q)` with legs
   `relTensorActL`/`relTensorActR` (parallel pair) and `relTensorProj` (the cofork), then promotes to
   the presheaf level via `evaluationJointlyReflectsColimits`. Reference `def:relTensorActR`,
   `def:relTensorProj` in its `\uses{}`.

4. FIX the backwards `\uses` on `def:relTensorTriplePresheaf`: remove `lem:relativeTensor_as_coequalizer`
   from its `\uses{}` (the triple presheaf is an INPUT to the coequalizer, not a consumer of it).

Constraints: edit ONLY this chapter (+ references/** if a source is genuinely needed — unlikely).
Do NOT add/remove `\leanok`. Keep prose mathematical, no Lean tactics.
