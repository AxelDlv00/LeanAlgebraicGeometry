# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts216

## Iteration
216

## Question
Does the commutative-group structure on locally-trivial iso-classes genuinely
require only existence-of-associativity-iso (NOT a coherent natural associator,
NO pentagon, NO localizer monoidality)? Is the locally-trivial associator
buildable directly from `tensorObj_restrict_iso`, making the general-site
whiskering apparatus (`isLocallyInjective_whiskerLeft_of_W`, `(J.W).IsMonoidal`,
d.1/d.2 stalk-⊗) vestigial dead code? Is `tensorObj_restrict_iso` (H1) the real
remaining bottleneck?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Group law: coherent monoidal cat vs. existence-of-iso | NEEDS_MATHLIB_GAP_FILL (design aligned) | informational |
| 2. Associator: general-site whiskering vs. `tensorObj_restrict_iso` | ALIGN_WITH_MATHLIB | critical |

## Must-fix-this-iter

- **Decision 2** — the whiskering apparatus is shipped, divergent, and blocked.
  `tensorObj_assoc_iso` (`TensorObjSubstrate.lean:903-946`) is built via ROUTE (d)
  whiskering, whose ~300 LOC of support (`isLocallyInjective_whiskerLeft_of_W`
  **open sorry L546**, `W_whiskerLeft/Right_of_W`, `isIso_sheafification_map_of_W`,
  the `stalkLinearMap` d.1 section L301-727) bottoms out in the project's own
  "genuinely Mathlib-absent (largest piece)" d.2 stalk-⊗-over-a-varying-ring
  (L543-544). Mathlib's Picard pipeline builds NONE of this: `monoidOfSkeletalMonoidal`
  discharges `mul_assoc X Y Z := hC ⟨α_ X Y Z⟩` from a single associator iso
  (`Mathlib/CategoryTheory/Monoidal/Skeleton.lean:43`). For the only case the
  group law touches (locally-trivial M,N,P), the associator iso follows from
  `tensorObj_restrict_iso` — the single ingredient through which
  `tensorObj_isLocallyTrivial`, the unitors, and the inverse already funnel.
  **Action**: re-route `tensorObj_assoc_iso` through `tensorObj_restrict_iso`
  + the canonical presheaf associator + a gluing step, and delete the whiskering
  section. The project is NOT condemned to build `(J.W).IsMonoidal` / d.2.

## Informational

- **Decision 1 — CONFIRMED, design correct.** The group/abelian-group law on
  iso-classes consumes only *existence* of the associator/unitor/braiding isos,
  never coherence. Proof: Mathlib's own `CommRing.Pic R := Shrink (Skeleton
  (SemimoduleCat R))ˣ` (`RingTheory/PicardGroup.lean:407-412`) gets its
  `CommGroup` from `Skeleton.instCommMonoid` → `commMonoidOfSkeletalBraided` →
  `monoidOfSkeletalMonoidal`, whose axioms are
  `one_mul := hC ⟨λ_ X⟩`, `mul_one := hC ⟨ρ_ X⟩`, `mul_assoc := hC ⟨α_ X Y Z⟩`,
  `mul_comm := hC ⟨β_ X Y⟩` (`Monoidal/Skeleton.lean:38-47, 80-81`) — each fed a
  single `Nonempty(≅)`; the pentagon carried by the `MonoidalCategory` typeclass
  is never invoked. The project's §2 decision (no `MonoidalCategory (X.Modules)`,
  build the group directly "mirroring `CommRing.Pic`", L775-787) is therefore
  exactly right. It cannot literally reuse `Skeleton.instMonoid` (that needs a
  full coherent `MonoidalCategory (X.Modules)`, whose pentagon fields are
  strictly *harder* than the blocked route), so re-deriving the four
  existence-of-iso obligations by hand is the correct, lighter alignment.
  Mathlib has no scheme-level Picard idiom (its own TODO L59-61).

- **Decision 3 — CONFIRMED with one scoping caveat.** Closing
  `tensorObj_restrict_iso` (H1: presheaf `pushforwardPushforwardAdj` /
  sectionwise extension-of-scalars) does unblock the direct group construction
  and retires the whiskering+stalk apparatus. **Caveat**: "build the associator
  by gluing, mirroring `tensorObj_isLocallyTrivial`" understates the work.
  `tensorObj_isLocallyTrivial` proves a **Prop** (`∀ x, ∃ U, Nonempty(…≅𝒪_U)`) —
  pointwise, no overlap compatibility. The associator is **global data** (one
  iso of sheaves on X); pointwise-chosen trivialization isos do not agree on
  overlaps. The sound construction glues the *canonical* local isos
  `((M⊗N)⊗P)|U ≅ (M|⊗N|)⊗P| ≅ M|⊗(N|⊗P|) ≅ (M⊗(N⊗P))|U` (restrict_iso twice +
  the canonical presheaf associator — already Step 2 of the current route),
  which DO agree on overlaps by naturality, via a Hom-is-a-sheaf gluing. That
  gluing-of-isos + overlap-naturality proof is a real, bounded cost, but it
  touches NONE of `(J.W).IsMonoidal` / d.1 / d.2. Net: one linchpin remains
  (`tensorObj_restrict_iso`), plus a bounded associator-gluing layer.

## Persistent file
- `analogies/ts-picard-direct-216.md` — design-rationale captured for future iters.

Overall verdict: the restructuring is SOUND — the group law needs only
existence-of-isos (exactly what Mathlib's `Skeleton` monoid-law proofs consume),
the whiskering/`(J.W).IsMonoidal`/d.2 apparatus is vestigial and should be
deleted, and the sole remaining linchpin is `tensorObj_restrict_iso` (plus a
bounded associator-gluing step the planner must budget).
