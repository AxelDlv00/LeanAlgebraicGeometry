# Iter-207 objectives — per-lane detail + reference citations

## Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prover-mode: mathlib-build]

**Goal:** discharge the 4-iter critical blocker `tensorObj_restrict_iso` by
building the one bounded missing Mathlib ingredient, then closing the lemma; this
unblocks the whole line-bundle group-law cascade (TS→RPF→A.2.c).

### Reference anchors (USER reference-driven directive)

- **Kleiman, "The Picard scheme" (FGA Explained), §4–§5** — the relative Picard
  functor and its group structure as iso-classes of line bundles under tensor;
  the group law is a family of propositions, not a monoidal-category instance.
  (`references/kleiman-picard.pdf` / `-src/`.) Cited in the chapter's motivation +
  consumer theorem blocks.
- **Mathlib (formalization-route anchors, all existence-checked this iter):**
  - `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` (+ `_δ`),
    `Mathlib.CategoryTheory.Monoidal.Functor` — supplies the comparison map as `δ`.
    [verified — strategy-critic clean207b + analogist mate207]
  - `PresheafOfModules.pullbackPushforwardAdjunction φ`,
    `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback` — the adjunction
    `pullback φ ⊣ pushforward φ`. [verified]
  - `ModuleCat.instLaxMonoidalRestrictScalars` (`ModuleCat.restrictScalars` lax,
    `[CommRing R] [CommRing S]`), `Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`
    — the per-section datum the new instance lifts. [verified]
  - `(pushforward₀OfCommRingCat F R).Monoidal`,
    `Mathlib.Algebra.Category.ModuleCat.Presheaf.PushforwardZeroMonoidal` — the
    monoidal first factor of `pushforward φ`. [verified]
  - `Functor.LaxMonoidal.comp` — composes the two factors. [expected]
  - `SheafOfModules.sheafificationCompPullback`, `Scheme.Modules.restrictFunctorIsoPullback`
    — Steps 1–2 (present; iter-206 used them). [verified iter-206]
  - `Module.Invertible.lTensor_bijective_iff`, `Mathlib.RingTheory.PicardGroup` —
    flatness upgrades `δ` to an iso for line bundles. [verified]

### Ordered targets

1. **PRIMARY (mathlib-build):** `(PresheafOfModules.restrictScalars φ).LaxMonoidal`
   — sectionwise instance from per-section ModuleCat lax data + naturality, over
   CommRingCat-factored presheaves of rings. ~40–90 LOC. (Chapter:
   `lem:restrictscalars_laxmonoidal`; recipe `analogies/mate207.md`,
   `informal/tensorObj_restrict_iso.md`.) NOTE: chapter's "Functor.CoreLaxMonoidal"
   is informal — use the actual Mathlib `Functor.LaxMonoidal` constructor.
2. `(pushforward φ).LaxMonoidal` via `Functor.LaxMonoidal.comp` + defeq transport.
3. Close `tensorObj_restrict_iso` (L281): `δ` from `leftAdjointOplaxMonoidal` +
   Steps 1–2 + flatness + `hom_ext` gluing. (Chapter: `lem:tensorobj_restrict_iso`,
   4-step proof.)
4. **Stretch cascade:** `tensorObj_assoc_iso`, `tensorObj_unit_iso`,
   `tensorObj_comm_iso` (existence-of-iso on a common cover); `exists_tensorObj_inverse`
   (L324); `addCommGroup_via_tensorObj` (L363).

**HARD BAR:** step 1 axiom-clean AND step 3 closed. Mathlib-build invariant: no new
sorry pins — if blocked mid-build, hand off the precise remaining obligation.

**Disproof check (done):** the target is not suspected false — `tensorObj_restrict_iso`
is the standard "pullback commutes with tensor for flat (line-bundle) modules";
verified the comparison map exists (as `δ`) and the iso-ness reduces to flatness.
No counterexample sought beyond confirming the map's existence, which the consult settled.

## Deferred / held (no dispatch) — see PROGRESS.md "Held lanes"

COE (paused + excision-pending), RPF/FGA/T32/RCI (held), A.3+ (gated A.2.c),
Route C (USER paused). Albanese strategy-auditor deferred to iter-208 (rationale:
plan.md `## Subagent skips`).
