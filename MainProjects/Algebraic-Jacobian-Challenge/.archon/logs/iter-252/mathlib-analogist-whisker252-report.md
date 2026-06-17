# Mathlib Analogist Report

## Mode
api-alignment

## Slug
whisker252

## Iteration
252

## Question
In `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, `sheafifyTensorUnitIso_hom_natural`
(~L1914) reduces — after `sheafifyTensorUnitIso_hom_eq` (L1853) and
`simp only [MonoidalCategory.tensorHom_def]` — to a pure whisker identity; the prover reports
`whisker_exchange`/`comp_whiskerRight`/`whiskerLeft_comp` ALL fail to fire and attributes it to a
file-local `MonoidalCategoryStruct` on the `… ⋙ forget₂` / `Sheaf.val` carrier being
defeq-but-not-syntactic to Mathlib's. Asked: (1) canonical idiom to normalise `◁`/`▷` across two
defeq monoidal structs; (2) precise form of a second `:= rfl` carrier brick for the whisker
projections; (3) Mathlib precedent.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Author a new `:= rfl` whisker-projection brick (or convert goal to `tensorHom`) | ALIGN_WITH_MATHLIB | critical |

## Must-fix-this-iter

- **Do NOT author a new whisker brick / do NOT convert to `tensorHom`.** Both are the wrong cure
  (the `tensorHom`-folding route is dead — VERIFIED). Align with the project's own proven idiom:
  `inferInstanceAs` instance transport (`letI instMS`) + `erw` join-bridges. Concretely, in
  `sheafifyTensorUnitIso_hom_natural`:
  1. Add at the top the verbatim `letI instMS : MonoidalCategoryStruct (PsM (Sheaf.val X.ringCatSheaf)) := inferInstanceAs (MonoidalCategoryStruct (PsM (X.presheaf ⋙ forget₂ CommRingCat RingCat)))` (copy of L339 / L1071) so the `p ⊗ₘ q` whiskers and the brick's η-whiskers share ONE instance term.
  2. Replace blind `simp only [tensorHom_def]` with: `erw [Category.assoc]` to bridge the cross-group `≫` join (VERIFIED to work where plain `rw`/`simp [Category.assoc]` cannot), then run `MonoidalCategory.whisker_exchange` on the (now single-instance, now-adjacent) middle crossings and `← MonoidalCategory.comp_whiskerRight` / `← MonoidalCategory.whiskerLeft_comp` to merge, threading `erw [Category.assoc]` for associativity.
  3. Finish with `(PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit.naturality p` / `… q`, then `restrictScalarsId_map` to strip the spurious `restrictScalars (𝟙)` on the naturality RHS (same strip as D2′).

## Informational — root cause (established LIVE via `lean_multi_attempt`, replaying tactics at the goal)

The directive's premise that the whisker lemmas "ALL fail to fire" is **partly incorrect**, and
its proposed cure mis-targets the real blocker:

- **Instance synthesis genuinely FAILS** on the defeq spellings:
  `failed to synthesize MonoidalCategoryStruct (PresheafOfModules X.ringCatSheaf.obj)` /
  `(… (Sheaf.val X.ringCatSheaf))`. The struct exists only on the explicit
  `X.presheaf ⋙ forget₂ CommRingCat RingCat` spelling. (Exactly why L339/L1071 carry `letI instMS`.)
- **`MonoidalCategory.whiskerRight` is NOT a distinct declaration** (empty local-search): it is the
  `MonoidalCategoryStruct.whiskerRight` projection via the `MonoidalCategory` namespace. So the
  "two defeq structs" are really **one struct reached by two instance TERMS** — the `letI instMS`
  instance baked into `sheafifyTensorUnitIso.hom`'s η-whiskers vs the directly-synthesised instance
  used by `MonoidalCategory.tensorHom_def` on `p ⊗ₘ q`.
- **The whisker calculus DOES fire within a single-instance group** — VERIFIED: `rw [← whisker_exchange]`
  rewrote `p ▷ Q ≫ P' ◁ q → P ◁ q ≫ p ▷ Q'`; `rw [Category.assoc]` and `rw [whisker_exchange]` fire too.
- **The one true blocker** is the `≫` joining the `p,q` group to the η group: plain `rw`/`simp [Category.assoc]`
  cannot reassociate across it (a 2nd `Category.assoc` errors `(?f ≫ ?g) ≫ ?h not found`), and
  `whisker_exchange` cannot act on the cross-group crossing `P' ◁ q ≫ η_{P'} ▷ Q'` (one lemma var
  must serve both whiskers, but they carry different instance terms). `erw [Category.assoc]` **bridges
  the join** (VERIFIED — fully right-associates the LHS), but only unifying the instance (step 1
  above) lets `whisker_exchange` act on the crossing.
- **Folding back to `⊗ₘ` is dead**: `← MonoidalCategory.tensorHom_def` and
  `← MonoidalCategory.tensorHom_comp_tensorHom` both fail to fold the brick η-whiskers, even via
  `erw` — so the "convert to `tensorHom`, use the interchange axiom" idea does not work here.
- `unit.naturality p` shape VERIFIED:
  `p ≫ η_{P'} = η_P ≫ (sheafification ⋙ SheafOfModules.forget ⋙ restrictScalars (𝟙)).map p`;
  the `restrictScalars (𝟙)` is the only gap to the goal's `(SheafOfModules.forget _).map (sheafification.map p)`,
  removed by `restrictScalarsId_map`.

**Lemma inventory (verified):** `MonoidalCategory.tensorHom_def` (forward only),
`MonoidalCategory.whisker_exchange`, `MonoidalCategory.comp_whiskerRight`,
`MonoidalCategory.whiskerLeft_comp`, `Category.assoc` (apply via `erw`),
`AlgebraicGeometry.Scheme.Modules.restrictScalarsId_map`,
`(PresheafOfModules.sheafificationAdjunction _).unit.naturality`. Avoid `← tensorHom_def` and
`tensorHom_comp_tensorHom` here.

**Precedent (Q3):** `Sheaf.val X.ringCatSheaf ≡ X.presheaf ⋙ forget₂ …` by `rfl`, but
`PresheafOfModules`'s monoidal API synthesises only on the explicit `forget₂` spelling
(Mathlib builds it on `CommRingCat`-valued bases; the `RingCat`-valued composite, re-spelled as
`.obj`/`.val`, defeats head-keyed synthesis). Intended remedy = `inferInstanceAs` transport
(`letI instMS`) + `erw`, not an upstream PR — the same shape and cure as D2′
(memory `ts-d2-closed-iter250`).

## Persistent file
- `analogies/whisker252.md` — full root-cause, the ranked fix recipe, and the verified lemma list.

Overall verdict: the proposed new whisker-projection brick is the wrong cure — ALIGN with the
project's existing `inferInstanceAs` `letI instMS` instance-transport + `erw [Category.assoc]`
join-bridge idiom (the genuine blocker is the instance-term split, not whisker notation, and the
`tensorHom`-fold escape is verified dead).
