# Recommendations — for the iter-207 plan agent

## 1. (HIGHEST) Lane TS: the flat-pivot reversal signal FIRED — do NOT autopilot another TS prove lane

The iter-206 plan adopted the flat/line-bundle pivot with an explicit pre-commitment:
re-evaluate if the prover finds the comparison map cannot be built at the sheaf level without
the monoidal machinery. **The prover found exactly that** (confirmed independently by
lean-vs-blueprint-checker ts-iter206, must-fix F1): `PresheafOfModules.pullback φ` is an
abstract left adjoint with no sectionwise formula, so the base-change comparison **map itself
is absent** from Mathlib; **flatness only upgrades an existing map to an iso, it does not
construct one**, so re-scoping to line bundles does NOT bypass the gap.

**TS is now in the same regime as COE**: blocked on a multi-file absent-Mathlib monoidal/oplax
structure (here, a `Monoidal`/oplax-comparison instance for `PresheafOfModules.pullback`,
lifting the sectionwise `ModuleCat.extendScalars.Monoidal` through the partial-left-adjoint
construction; precise recipe in `informal/tensorObj_restrict_iso.md`).

**Fork for the planner (pick one; do not assign a 5th "foundational input" helper round):**
- **(a) Open a dedicated `mathlib-build` lane** to construct
  `PresheafOfModules.pullbackMonoidalComparison` (or `.Monoidal`). Pro: precise recipe in hand,
  sectionwise ingredient exists. Con: multi-file, Mathlib-PR-scale — the same cost class that
  paused COE; consult mathlib-analogist (cross-domain-inspiration) on the doctrinal-adjunction
  mate route before committing.
- **(b) Pause TS** as COE was paused (escalation-style), pending USER direction.
- **(c) Pivot strategic focus** to a route NOT gated on absent Mathlib monoidal infrastructure
  — the iter-206 plan already raised the **Albanese-UP / RR-free A.2.c excision** as the TOP
  open question (iter-207 strategy-auditor committed). This is the productive escape: it can
  excise the project's single most-stuck node AND sidesteps the monoidal-on-pullback wall.

Recommendation: **(c) as the primary iter-207 move** (run the committed strategy-auditor on the
Albanese route first), with **(b)** for TS in the interim. Reserve **(a)** only if the USER
directs a Mathlib-infrastructure build.

## 2. (must-fix, blueprint) Rewrite the `lem:tensorobj_restrict_iso` proof sketch — F1

The chapter (rewritten iter-206) claims the proof is "elementary flat-exactness already
available in Mathlib." This is **not formalizable as written** and would mislead a future prover
into applying `Module.Invertible.lTensor_bijective_iff` to a goal where no comparison map exists.
**Dispatch a blueprint-writer for `Picard_TensorObjSubstrate.tex`** to replace the sketch with
the accurate three-step route (Step 1 `restrictFunctorIsoPullback` present; Step 2
`sheafificationCompPullback` present; **Step 3** the presheaf base-change iso = the `mathlib-build`
blocker), per lvb ts-iter206 recommended-action #1. Also addresses majors M2 (functoriality
λ/ρ/α/β overpromise), M3 (`tensorObj_lift_onproduct` scope), M4 (blocking annotations + pins on
the four deferred blocks). NOTE: the review already added the `\lean{}` pin (M1) and a `% NOTE:`
flagging F1 — the writer should fold the NOTE's content into a corrected proof body.

## 3. COE — escalation pause still live (do NOT silently re-open)

3rd consecutive iter with no COE dispatch. Blocker unchanged (Stacks 02JK conormal-localisation
iso / Stacks 00OE–00TT). USER decision territory. The iter-206 plan reframed the 02JK/Thm-3.2
cone as **EXCISION-PENDING** behind the Albanese-UP route — resolving #1(c) likely also resolves
COE's status. Do not re-open COE as a prove lane without a USER hint or a concrete 02JK-free path.

## 4. Held/long-standing audit findings (not new, surface so they don't ossify)

- `RelPicFunctor.lean` (HELD): `PicSharp := const PUnit` (L330), `functorial := 0` (L377) —
  dishonest placeholders, re-confirmed for the 3rd time (iter-203/205/206). RPF's re-engagement
  gate; replace with honest sorries when TS's `addCommGroup_via_tensorObj` lands. The `L266`
  TODO-on-sorry is an excuse-comment (major) but accurately describes the external gate.
- `Genus0BaseObjects/BareScheme.lean:220` — `projectiveLineBar_geomIrred := sorry` is a **`sorry`
  *instance*** that propagates silently through `inferInstance` (no explicit sorry at call sites);
  long-standing since iter-165. Mathlib genuinely lacks `GeometricallyIrreducible` for `Proj` of a
  polynomial ring. Worth a tracked note; consider a `reference-retriever`/`mathlib-analogist` pass
  if this becomes load-bearing.

## 5. Reusable patterns discovered this iter

- **`SheafOfModules.sheafificationCompPullback` IS in Mathlib** (`.../Sheaf/PullbackContinuous.lean`):
  `sheafification ⋙ pullback φ ≅ PresheafOfModules.pullback φ.hom ⋙ sheafification`. Corrects a
  multi-iter false "sheafification-doesn't-commute-with-pullback" premise. Use it whenever a
  scheme-`Modules` restrict/pullback needs to move past sheafification.
- **The "abstract left adjoint has no comparison map" trap**: a functor defined as
  `(rightAdjoint).leftAdjoint` (no sectionwise formula) has NO canonical monoidal comparison map
  to even state — flatness/exactness arguments that presuppose a map are inapplicable until the
  oplax structure (mate) is constructed. Check whether a functor is concrete or abstract-adjoint
  before planning a flat-exactness closure.
