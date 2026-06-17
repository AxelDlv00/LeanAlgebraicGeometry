# Recommendations for iter-206 plan

## 1. Lane TS — decide the fork; do NOT autopilot another helper round

iter-205 is the **3rd consecutive net-0-sorry TS iter** (−2, 0, 0). The lane has
reached a genuine multi-file Mathlib infrastructure boundary, exactly the *class*
of blocker that escalated COE. The cone is now reduced — in compiled, verified
Lean — to ONE fact: `whiskerLeft : W g → W (F ◁ g)` for the relative module
tensor, which requires `MonoidalClosed (PresheafOfModules R₀)`. That instance is
**VERIFIED ABSENT** from Mathlib (the module analogue of `Sites/Monoidal.lean`'s
closed-monoidal apparatus). The two new decls `isMonoidal_W_of_whiskerLeft`
(L417) and `monoidalCategoryOfIsMonoidalW` (L446) are permanent axiom-clean
infrastructure the eventual discharge plugs into.

**Three exhausted dead-ends (do NOT re-assign these):**
- `Sites/Monoidal.lean`'s `J.W.IsMonoidal` — ambient `⊗_ℤ`, wrong tensor.
- Sectionwise presheaf-pullback strong-monoidal — absent (`grep` of
  `Presheaf/{Pullback,ChangeOfRings}.lean` → nothing).
- Elementwise/exactness — needs flatness (tensoring ≠ injectivity-preserving).

**Fork (planner must pick one, with a concrete Lean path, or pause):**
- **(a) RECOMMENDED-LARGE**: open a dedicated sub-lane to build
  `MonoidalClosed (PresheafOfModules (R' ⋙ forget₂ _ _))` (module analogue of
  `Mathlib/CategoryTheory/Monoidal/Closed/FunctorCategory`), then mirror
  `Sites/Monoidal.lean`'s `isSheaf_functorEnrichedHom` + `whiskerLeft` adjunction
  reduction to discharge `whiskerLeft`. Multi-file, Mathlib-PR-scale. A
  **mathlib-analogist (cross-domain-inspiration)** consult is warranted FIRST —
  ask whether Mathlib has solved "closed monoidal structure on a functor /
  presheaf category over a varying base object" in any domain. (The iter-205
  plan's progress-critic route205 watch signal — "if `IsMonoidal W` fails
  axiom-clean with the same single-ingredient blockage, escalate to
  mathlib-analogist" — has now fired.)
- **(b) SMALLER**: supply `whiskerLeft` directly by a flatness-free sectionwise
  locally-bijective argument if one can be found, then
  `haveI := isMonoidal_W_of_whiskerLeft hwl; exact monoidalCategoryOfIsMonoidalW α`
  closes `monoidalCategory` (modulo the syntactic ring-presheaf `inferInstanceAs`
  bridge) and cascades to `tensorObj_restrict_iso` →
  `exists_tensorObj_inverse` → `addCommGroup_via_tensorObj`.
- **(c) PAUSE TS** as substrate-complete (like COE) and surface to USER if
  neither (a) nor (b) has a concrete Lean path — do not burn iters on helpers
  that cannot move the sorry count.

## 2. Blueprint — expand `thm:scheme_modules_monoidal` proof sketch (blueprint-writer)

The lean-vs-blueprint-checker ts-iter205 flagged the chapter proof sketch as
**under-specified** relative to the now-compiled Lean: it identifies "build
`IsMonoidal W`" but not the `whiskerLeft → IsMonoidal W` braiding reduction the
new `def` encodes. Dispatch a **blueprint-writer** on
`Picard_TensorObjSubstrate.tex` to add 1–2 sentences to the "Concrete Mathlib
realisation" paragraph describing: `IsMonoidal W` reduces to `whiskerLeft`
stability alone, with `whiskerRight` recovered via the symmetric braiding
(`arrow_mk_iso_iff` with `β_`), encoded as `isMonoidal_W_of_whiskerLeft`; the
transport is `monoidalCategoryOfIsMonoidalW` via `inferInstanceAs (MonoidalCategory
(LocalizedMonoidal …))`. (Minor, not gating — but cheap and keeps the chapter
ahead of the Lean for the next prover.) Do NOT instruct the writer to touch
markers.

## 3. COE — remains PAUSED; do NOT re-dispatch without USER direction

Escalation honored for the 2nd iter. The blocker (Stacks 00OE Krull-dim formula
+ 00OF localization + the Step-A2 AtPrime conormal iso) is a USER decision
(TO_USER banner carries options a/b/c). If — and only if — the USER directs
continuation, consult a mathlib-analogist on the Krull-dim formula / conormal iso
BEFORE any prover round. Do NOT add another COE helper round.

## 4. RelPicFunctor.lean — TWO weakened-wrong defs (must-fix, re-confirmed live)

lean-auditor iter205 (see `task_results/lean-auditor-iter205.md`) re-confirmed
the iter-203 finding AND surfaced a co-located second must-fix:
- **`PicSharp` (L327–330)**: `:= (Functor.const _).obj (AddCommGrpCat.of PUnit)`
  — a constant functor at the trivial group standing in for
  `T ↦ Pic(C ×_k T)/π_T^* Pic(T)`, with a critical-severity excuse-comment
  docstring ("sorry-free placeholder … harmless").
- **`PicSharp.functorial` (L372–377)**: returns `0` (the zero `AddMonoidHom`)
  for every morphism, with a major-severity excuse-comment. The correct action
  is the descended `(id_C ×_k g)^*` pullback.

Both typecheck precisely because the wrong values are well-typed; downstream
consumers (`PicSharp.presheaf`, `PicSharp.etSheaf`) inherit them.
**No prover may be dispatched on `RelPicFunctor.lean` until BOTH are replaced**
(dispatch `refactor` to swap each body for an honest `:= sorry` matching the
`addCommGroup` sorry at L235 and strip both excuse-comments). RPF is held, so
this does not block active lanes — but it corrupts axiom reasoning that trusts
`PicSharp` and must precede any RPF round.

## 4b. TensorObjSubstrate.lean — deprecated `Sheaf.val` API (major, non-blocking)

lean-auditor iter205 MAJOR: 6 occurrences of the deprecated
`CategoryTheory.Sheaf.val` (LSP: "Use `ObjectProperty.obj`") at L114, L131,
L171, L175, L188, L190 in `tensorObj` / `tensorObj_functoriality` /
`tensorObjIsoOfIso` / `tensorObj_unit_iso`. Harmless deprecation warnings today
(build GREEN), but they will break when the API is removed. Fold a one-line
`Sheaf.val → ObjectProperty.obj` sweep into whichever TS round runs next (or a
quick `refactor`). Also MINOR: `addCommGroup_via_tensorObj` (L339) lacks the
`@[implicit_reducible]` attribute the two new iter-205 defs correctly carry —
add it when that body is filled. Neither is a HARD GATE blocker.

## 5. A.3.0 (scheme-level tangent space, `Cotangent/GrpObj.lean`) — open the lane

The iter-205 strategy-critic flagged A.3.0 as a genuine ungated root sitting at
0/it. The plan committed an iter-206 blueprint-reviewer pass on
`AlgebraicJacobian_Cotangent_GrpObj.tex` to clear its HARD GATE and open it as a
parallel second lane (TS is at a boundary; a second productive lane is valuable).
Run that blueprint-reviewer pass; if the chapter clears `complete + correct`,
A.3.0 becomes dispatchable.

## 6. iter-206 strategy-auditor — RR-free representability check (committed)

The plan elevated the strategy-critic's RR-free-representability point to a HIGH
open question and committed an iter-206 strategy-auditor validation against the
primary PDFs (Kleiman / Nitsure / FGA): does bare Grothendieck/Nitsure Quot
representability + picking the `Pphifin` component through `[O_C]` (not "degree
0") yield `Pic⁰` without invoking Riemann–Roch? Also check whether the Albanese
UP / A.4.d genus formula independently need RR. If RR can be cut from the
genus ≥ 1 critical path, substantially more may close under the current Route C
pause. Run the strategy-auditor as committed.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)

- **Monoidal structure on a localized category via `Localization.Monoidal`**:
  `inferInstanceAs (MonoidalCategory (LocalizedMonoidal (L := sheafification α)
  (W := …) (Iso.refl _)))` needs source-monoidal + `IsLocalization` + `[W.IsMonoidal]`
  + unit iso.
- **`IsMonoidal W` ⟸ `whiskerLeft` alone** when the source is braided:
  `whiskerRight` via `(W.arrow_mk_iso_iff (Arrow.isoMk (β_ _ _) (β_ _ _))).2`;
  `IsMultiplicative` free for an `inverseImage` of a localizing property.
- **Closed-monoidal is the load-bearing input** for "tensoring preserves local
  isomorphisms" — without `MonoidalClosed`, the preservation cannot be done
  elementwise (flatness obstruction).
