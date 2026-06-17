# Picard/TensorObjSubstrate.lean — iter-251 (Lane TS-cmp, D1′/D3′/D4′)

## Scope
Author + prove D1′ (`pullbackTensorMap_natural`), then D3′/D4′. The three targets did NOT
pre-exist (planner's "Author + prove"); statements written from scratch.

## Result overview
- **`pullbackValIso_hom_natural`** — **CLOSED, axiom-clean** (verified: only
  `propext`/`Classical.choice`/`Quot.sound`). Square 4 of D1′; reusable.
- **`sheafifyTensorUnitIso_hom_eq`** — **CLOSED by `rfl`**. New characterisation lemma: strips the
  `letI instMS` cast from `sheafifyTensorUnitIso.hom`, restating it on the `⋙ forget₂` carrier.
  This is the *carrier-normalisation brick* that unblocks `Functor.map_comp` merges.
- **`sheafifyTensorUnitIso_hom_natural`** — AUTHORED + substantially advanced; PARTIAL (1 sorry).
  Square 3 of D1′. Reduced ALL the way to a single concrete monoidal whisker identity (see below).
- **D1′ `pullbackTensorMap_natural`** — AUTHORED; PARTIAL (1 sorry). 4-square paste; 2 helpers
  exist (one closed, one at its final whisker residual), the other 2 squares are `δ_natural` /
  `sheafificationCompPullback` naturality. Body leaves `simp only [pullbackTensorMap,
  tensorObj_functoriality]` + documented plan.
- **D3′ / D4′** — NOT STARTED (correctly gated on D1′ closing).

## sorry count
Before: 1 (`exists_tensorObj_inverse`, L705, guardrailed). After: 3 — L705 (unchanged),
`sheafifyTensorUnitIso_hom_natural` (L1954), `pullbackTensorMap_natural`/D1′ (L1983).
**Net: +2 NEW closed lemmas** (`pullbackValIso_hom_natural`, `sheafifyTensorUnitIso_hom_eq`),
zero errors, zero new axioms.

## The working idiom kit (validated, reusable — for the remaining squares + D3′)
From `pullbackValIso_hom_natural`, through the `SheafOfModules.pullback φ` vs
`Scheme.Modules.pullback f` carrier friction:
1. `erw [(sheafificationCompPullback φ).inv.naturality u.val]` (`erw`: matches `(α.app M').inv` ≡
   `α.inv.app M'` and `(F⋙a_Y).map` ≡ `a_Y.map (F.map)` up to defeq).
2. morphism-level `rw [show (SheafOfModules.pullback φ).map g = (Scheme.Modules.pullback f).map g
   from rfl]` (functor-level breaks the motive).
3. `erw [Category.assoc]` (plain `rw` fails — mixed category instance).
4. fully-EXPLICIT `erw [← Functor.map_comp F g1 g2]` to merge (a metavar functor whnf-BOMBS).
5. `congr 1; congr 1; exact (sheafificationAdjunction ..).counit.naturality u`.
6. `set_option maxHeartbeats 1600000 in` ABOVE the docstring (cumulatively heavy).
NOTE: the earlier "exact bombs" diagnosis was wrong — the bomb was a stray `rw
[← restrictScalarsId_map]` I had inserted; the plain `exact …counit.naturality u` succeeds.

## `sheafifyTensorUnitIso_hom_natural` — reduced to ONE whisker identity
Proof so far (all compiling up to the final residual):
`rw [sheafifyTensorUnitIso_hom_eq, sheafifyTensorUnitIso_hom_eq]` (carrier-normalise) →
`rw [← Functor.map_comp, ← Functor.map_comp]` (merge whisker pairs) →
`erw [← Functor.map_comp, ← Functor.map_comp]` (merge `a.map(p⊗q)` whose intermediate tensor
object is defeq-not-syntactic — `erw` tolerates it) → `congr 1` (peel outer `a.map`) →
`simp only [MonoidalCategory.tensorHom_def]` (expand ⊗ to whiskers). Remaining goal:
```
(p ▷ Q ≫ P' ◁ q) ≫ (η_{P'} ▷ Q') ≫ ((aP').val ◁ η_{Q'})
  = (η_P ▷ Q) ≫ ((aP).val ◁ η_Q) ≫ ((a.map p).val ▷ (aQ).val) ≫ ((aP').val ◁ (a.map q).val)
```
By hand (verified): `whisker_exchange` on the middle crossings, `comp_whiskerRight`/
`whiskerLeft_comp` to merge, reduces both sides to `(p ≫ η_{P'}) ▷ Q ≫ (aP').val ◁ (q ≫ η_{Q'})`
vs `(η_P ≫ (a.map p).val) ▷ Q ≫ (aP').val ◁ (η_Q ≫ (a.map q).val)`, equal by sheafification-unit
`η`-naturality (`p ≫ η_{P'} = η_P ≫ (a.map p).val`).
**RESIDUAL BLOCKER:** `whisker_exchange[_assoc]`, `comp_whiskerRight`, `whiskerLeft_comp` ALL fail
to fire (rw and simp report "unused"/"not found") — the goal's `▷`/`◁` come from the file's local
`MonoidalCategoryStruct` (forget₂ carrier) whose projections are defeq-but-not-syntactic to
`MonoidalCategory.toMonoidalCategoryStruct`'s, so the Mathlib whisker lemmas don't unify.
**Next step:** a second carrier-normalisation (analogue of `sheafifyTensorUnitIso_hom_eq`) that
re-states the whiskers via the canonical `MonoidalCategory` instance, after which the whisker
calculus fires and the closer goes through.

## Reversing signal (per objectives) — FIRED
"D1′ does not close → idioms-transfer assumption wrong → re-decompose." Confirmed: D1′ is NOT the
plan's "2-step". It needs two non-packaged naturality helpers. `pullbackValIso` is now CLOSED;
`sheafifyTensorUnitIso` is reduced to a single whisker identity blocked on a *second* carrier-
normalisation (Mathlib whisker lemmas not firing on the local `MonoidalCategoryStruct`). The
class of obstacle is the same `.val`/instance friction as D2′, but the D2′ kit
(`restrictScalarsId_map` + `erw` merge) doesn't cover whisker-lemma unification — the missing
bricks are characterisation lemmas like `sheafifyTensorUnitIso_hom_eq` (DONE) and an analogous
whisker-carrier restatement (TODO). Recommend either a follow-up prover iter directed at that one
whisker restatement, or a mathlib-analogist consult on "firing `whisker_exchange` on a local
`MonoidalCategoryStruct`".

## D1′ assembly plan (once `sheafifyTensorUnitIso_hom_natural` closes)
Merge `a_Y.map δ ≫ S3 ≫ S4` into `a_Y.map Ψ` (Ψ presheaf-level), move S1 by
`(sheafificationCompPullback φ).hom.naturality (tensorHom a.val b.val)`, discharge the resulting
presheaf equation by `δ_natural` (square 2) + the two helpers (`pullbackValIso_hom_natural`,
`sheafifyTensorUnitIso_hom_natural`).

## Verdict
**Partial progress (substantive).** Closed 2 NEW reusable lemmas
(`pullbackValIso_hom_natural` axiom-clean, `sheafifyTensorUnitIso_hom_eq` rfl). Advanced
`sheafifyTensorUnitIso_hom_natural` from "blocked at the very first merge" to "one concrete
whisker identity with a named blocker and the hand-proof spelled out". Authored D1′ with the full
assembly plan. Did NOT fully close D1′; D3′/D4′ gated. No bare sorries. Guardrails honoured
(`exists_tensorObj_inverse` untouched; no general Lan build).

## Why I stopped
Two new closed lemmas + a fully-specified reduction of helper B to a single whisker identity is
real code progress, not comments. The remaining blocker (Mathlib whisker lemmas not unifying with
the file's local `MonoidalCategoryStruct` projections) is a distinct, named carrier-normalisation
problem — the same class I already solved twice this session (`sheafifyTensorUnitIso_hom_eq` and
the `pullback φ`/`pullback f` morphism-rewrite), but a third instance I ran out of budget to
formalise after the long helper-A/B grind. Informal agent NOT called: key documented invalid
(memory `informal-agent-key-invalid`), and the obstacle is Lean instance-elaboration (no Mathlib
gap) — a `mathlib-analogist` consult or a targeted next-iter prover pass is the right escalation.
