# Mathlib-analogist directive — iter-216

## Mode: api-alignment

## Question (load-bearing — a 6-iter-stuck route may rest on a needless parallel API)

The project builds the **Picard group of a scheme** = the commutative group of iso-classes of invertible (locally-trivial) `𝒪_X`-modules under `⊗`. The substrate is in `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`.

The current construction takes a HEAVY categorical path:
- `tensorObj M N := sheafification(PresheafOfModules.Monoidal.tensorObj M.val N.val)` (sheafify the presheaf tensor) over the GENERAL Zariski site.
- To get the **associator** `(M⊗N)⊗P ≅ M⊗(N⊗P)` at the sheaf level it commutes sheafification with the presheaf associator, which requires whiskering lemmas about the sheafification localizer `J.W`: specifically `isLocallyInjective_whiskerLeft_of_W` (open sorry, the 6-iter blocker) — i.e. it is trying to prove the sheafification morphism-property `(J.W).IsMonoidal`-style whisker fields for an ARBITRARY presheaf `F` over a general site.
- This general-site whiskering is the load-bearing open sorry; its two routes both bottom out in Mathlib-absent infrastructure (d.2 stalk-⊗ over a varying ring; or `tensorObj_restrict_iso` which needs presheaf-level `pushforwardPushforwardAdj`).

**The restructuring I (planner) want you to validate or refute.** Mathlib builds the ring-level Picard group in `Mathlib/RingTheory/PicardGroup.lean` (`CommRing.Pic`) and invertible modules via `Module.Invertible` WITHOUT constructing a full monoidal category and WITHOUT proving any localizer/sheafification-whiskering monoidality — it works directly with invertible objects and iso-classes. 

My claim: the project's group law on LOCALLY-TRIVIAL iso-classes needs only:
1. `⊗` well-defined on iso-classes (done: `tensorObjIsoOfIso`),
2. an associativity ISO for locally-trivial `M,N,P` — buildable DIRECTLY by gluing on a common trivialising cover where each is `≅ 𝒪_X` (template already in-file and GREEN: `tensorObj_isLocallyTrivial` proves `IsLocallyTrivial(M⊗N)` exactly this way, via `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso` on a common affine open),
3. unit/commutativity isos (done: unitors, braiding),
4. inverses (`exists_tensorObj_inverse`, via the dual on a trivialising cover),

and the only substrate ingredient all of these funnel through is `tensorObj_restrict_iso` (⊗ commutes with open-immersion restriction). The general-site whiskering apparatus (`isLocallyInjective_whiskerLeft_of_W`, the `(J.W).IsMonoidal` localizer monoidality, the stalk/d.2 machinery) would then be **vestigial route-(d) dead code** — never needed for the group law, only for a full monoidal category on ALL of `SheafOfModules` (which the Picard group does not require).

## What I need from you

1. **Is the restructuring sound?** Confirm or refute: does the commutative-group structure on locally-trivial iso-classes genuinely require only existence-of-associativity-iso (NOT a coherent natural associator, NO pentagon, NO localizer monoidality)? Look at how `CommRing.Pic` / `Module.Invertible` (and `RingTheory/PicardGroup.lean`, `Mathlib/Algebra/Category/.../Invertible` or analogous) actually assemble the group — what is the MINIMAL substrate they rest on?

2. **Is the locally-trivial associator buildable directly by gluing**, mirroring the in-file `tensorObj_isLocallyTrivial` pattern, given `tensorObj_restrict_iso`? Or is there a coherence obstruction that forces the heavy whiskering route?

3. **Confirm the remaining bottleneck is `tensorObj_restrict_iso` (presheaf `pushforwardPushforwardAdj`, H1)** and that closing it unblocks the direct group construction — i.e. the project is NOT condemned to build `(J.W).IsMonoidal` / d.2.

4. If the project IS building a needless parallel to a cleaner Mathlib idiom for "group of invertible objects in a (sheaf-of-modules) tensor category", name the idiom and the alignment cost.

Read on-disk: `Mathlib/RingTheory/PicardGroup.lean`, the `Module.Invertible` API, and any `Mathlib` "invertible object in a monoidal/tensor category ⇒ group" precedent (e.g. `CategoryTheory.Monoidal` Picard/Brauer-style or `Skeleton` group). Write your analysis to `analogies/ts-picard-direct-216.md` and a report to `task_results/`.
