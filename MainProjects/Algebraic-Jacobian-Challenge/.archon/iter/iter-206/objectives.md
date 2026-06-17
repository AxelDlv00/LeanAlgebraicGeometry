# Iter-206 objectives (per-lane detail + reference citations)

## Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prove]

**Goal**: implement the flat/line-bundle group-law pivot (off the abandoned
all-modules `MonoidalCategory`/`MonoidalClosed` route).

**Reference anchors** (USER reference-driven directive):
- **Kleiman, "The Picard scheme", §2** (FGA Explained Ch.9 §9.2),
  Defs. df:aPf + df:Pfs — the relative Picard functor is the
  abelian-group-valued quotient `Pic(C×_kT)/π_T^*Pic(T)`. Already cited
  verbatim in the chapter.
- **Stacks tag 01CR** — Picard group of a scheme = iso-classes of invertible
  sheaves under tensor (the group law).
- **Mathlib `Mathlib.RingTheory.PicardGroup`**: `CommRing.Pic`,
  `instCommGroupPic`, `Module.Invertible`,
  `Module.Invertible.lTensor_bijective_iff` — the `Units (Skeleton …)`
  iso-class group idiom the pivot mirrors. (VERIFIED, ts-design206.)
- **Mathlib `Mathlib.RingTheory.Flat.Basic`**:
  `Module.Flat.lTensor_preserves_injective_linearMap` — the flat-exactness
  ingredient behind `tensorObj_restrict_iso`. (VERIFIED.)
- `analogies/ts-design206.md` — the design rationale (primary).

**Ordered targets**:
1. `tensorObj_restrict_iso` (L249) — PRIMARY, the one hard ingredient.
   (a) construct the comparison map `(L⊗_X M)|_f → L|_f ⊗ M|_f` at the sheaf
   level; (b) prove iso via flat-exactness (line bundles flat via
   `Module.Invertible ⇒ Projective ⇒ Flat`).
2. `tensorObj_assoc_iso`, `tensorObj_unit_iso`, `tensorObj_comm_iso` — new,
   existence-of-iso on line bundles from (1) on a common trivialising cover.
3. `exists_tensorObj_inverse` (L300) — dual + contraction iso (Stacks 01CR).
4. Remove dead `monoidalCategory := sorry` (L150) + `isMonoidal_W_of_whiskerLeft`
   + `monoidalCategoryOfIsMonoidalW` (off-path).
5. `addCommGroup_via_tensorObj` (L339) — terminal cascade via QuotientAddGroup.

**HARD BAR**: re-scope + close `tensorObj_restrict_iso` axiom-clean + remove
the dead `monoidalCategory` instance. **Stretch**: the full cascade.

**Blueprint**: `chapters/Picard_TensorObjSubstrate.tex` (rewritten this iter;
HARD GATE cleared, tsgate206).

## Not dispatched (rationale)

- **COE** (`CodimOneExtension.lean`): PAUSED + EXCISION-PENDING (Stacks 02JK;
  likely obsoleted by the `rmk:Alb` Albanese-UP route). USER-gated.
- **RPF** (`RelPicFunctor.lean`): HELD; gated on TS `addCommGroup`; must-fix
  placeholder-replacement at re-engagement.
- **FGA / T32 / WD / RCI**: held/gated (see PROGRESS held-lanes).
- **A.3.* lanes**: forbidden before A.2.c (USER directive #4).
- **Route C**: PAUSED (USER directive #1).
