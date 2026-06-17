# Recommendations — for the iter-215 plan agent

## 0. Strategic framing (read first)

iter-214 is the **5th consecutive net-zero window-iter** (sorry 81 → 81 across
211–214). Each iter landed true, axiom-clean lemmas while the critical-path
residual `isLocallyInjective_whiskerLeft_of_W` stayed a `sorry`:
- 211: `W_whiskerLeft_of_flat` (bridge) — later found to guard the wrong wall.
- 212: `isIso_sheafification_map_of_W` (2nd bridge) — flatness feeder is false.
- 213: associator assembled; residual reduced to one stalkwise lemma.
- 214: four `stalkLinearMap*` bricks (the d.1 *linearity* core).

The **progress-critic ts214 verdict was STUCK + OVER_BUDGET** with a strict
one-iter gate ("if d.1+d.2 do not compile axiom-clean THIS iter, escalate"). That
gate was **not met** — only the d.1 *core* landed, not the d.1-bridge or d.2. The
planner's iter-214 rebuttal (a multi-iter mathlib-build is legitimate under the
Mathlib-gradient strategy) is on record. **iter-215 must confront this head-on**:
the remaining (d.2) — the varying-ring stalk-⊗-colimit interchange — is "genuinely
Mathlib-absent, ~150–250 LOC, the largest piece." Either fund it as a bounded
mathlib-build with a named lemma chain, or fire the standing USER-escalation. Do
NOT dispatch another open-ended helper round without a concrete d.2 lemma plan.

## 1. Closest-to-completion / priority target

**`PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`** is the single residual
of the entire ⊗-group-law engine. Before any further prover work on it:

1. **MUST restructure first (do NOT re-dispatch as-is).** The lemma is stated over
   a GENERAL site `C` where no stalks exist — the stalkwise proof *cannot* be
   written at this generality. It must be **specialised to `C = Opens X`** (or take
   `[HasEnoughPoints J]` + topological hypotheses). The decl is **UNPROTECTED** and
   its only consumer chain (`W_whiskerLeft/Right_of_W` → `tensorObj_assoc_iso`)
   already runs over `Opens.grothendieckTopology X`, so this is compatible and free.
   This is a `refactor`-subagent signature change, not a prover task. (Flagged
   independently by the prover AND lean-auditor ts214.)

2. Then build the two residuals in order:
   - **(d.1-bridge)** `(Opens.grothendieckTopology X).W ((toPresheaf _).map f) ↔
     ∀ x, IsIso ((stalkFunctor Ab x).map ((toPresheaf _).map f))`. Cheapest route:
     `WEqualsLocallyBijective` + `locally_surjective_iff_surjective_on_stalks`
     (`LocallySurjective.lean:80`) + `app_injective_iff_stalkFunctor_map_injective`
     / `isIso_iff_stalkFunctor_map_iso` (`Stalks.lean:512/652`). Est. ~80–150 LOC.
     (Avoid the `HasEnoughPoints` route — `presheafFiber ≅ stalk` is a still-absent
     Mathlib TODO, `Points.lean:18–22`.)
   - **(d.2)** Natural iso `(F ⊗ᵖ_R M).presheaf.stalk x ≅ F_x ⊗_{R.stalk x} M_x`
     identifying `(F ◁ g)_x` with `LinearMap.lTensor F_x (stalkLinearMap g x)`.
     Genuinely Mathlib-absent; ~150–250 LOC; this is the make-or-break piece. Once
     it lands, `stalkLinearMap_bijective_of_isIso` + `LinearEquiv.lTensor` finish
     flatness-free.

3. The four `stalkLinearMap*` bricks (built this iter, axiom-clean) are the d.1
   linearity core and are ready to consume — no re-implementation needed.

## 2. Blueprint must-fix BEFORE the next d.1/d.2 prover (HARD GATE input)

`lean-vs-blueprint-checker ts214` returned **2 major blueprint-adequacy gaps** on
`Picard_TensorObjSubstrate.tex` (report:
`task_results/lean-vs-blueprint-checker-ts214.md`). These block an accurate
prover dispatch on the d.1/d.2 residual — **dispatch a blueprint-writer this iter**:

- **(a)** The API survey (chapter §2) claims "no `PresheafOfModules`
  stalk/fiber/point infrastructure" — **factually wrong post-iter-214**. Mathlib's
  `ModuleCat/Stalk.lean` supplies the stalk module + `germ_smul`; only the
  *linearity packaging* was absent (now `stalkLinearMap`). *I added a `% NOTE:` at
  the stale clause flagging this for the writer.*
- **(b)** The four `stalkLinearMap*` declarations have **no `\lean{...}` pin** —
  add a pinned block marking them as the d.1-partial implementation, so the next
  prover knows what is already built.
- The proof sketch of `lem:islocallyinjective_whisker_of_W` should be updated to
  split d.1 into **done** (`stalkLinearMap*`) vs **remaining** (d.1-bridge, d.2).
- Minor: add `[J.WEqualsLocallyBijective Ab.{u}]` to the blueprint statement.

## 3. Stale-documentation cleanup (lean-auditor ts214 — 0 must-fix, 8 major)

Report: `task_results/lean-auditor-ts214.md`. **The substantive Lean is sound**
(the new `StalkLinearMap` germ-chase was verified honest, step-by-step, axiom-clean;
no regressions; all four sorries are honest residuals). The 8 majors are ALL
accumulated stale documentation in `TensorObjSubstrate.lean` — worth a comment
cleanup pass (a `refactor`/comment pass, not a prover task), notably:
- Module docstring `## Status` (L37–86) claims `tensorObj` / `tensorObj_functoriality`
  carry sorry bodies (false since iter-203) and lists the iter-206-removed
  `monoidalCategory` as a live pin.
- `FlatWhisker` header (L178–190) + `W_whiskerLeft_of_flat` docstring (L323–331)
  call the flat lemmas "the single non-formal ingredient of `tensorObj_assoc_iso`",
  directly contradicting the iter-212 off-critical-path note at L365–380.
- `tensorObj_assoc_iso` docstring (L763) says "typed sorry" — it is a complete
  proof term, only sorry-*dependent* transitively.

These do not block proving but actively mislead; bundle the cleanup with the
route-(e) restructure of the target lemma.

## 4. Possible `sync_leanok` gap (investigate, do NOT hand-patch `\leanok`)

`lem:tensorobj_unit_iso` carries a **two-name `\lean{}` pin**
(`tensorObj_left_unitor, tensorObj_right_unitor`) and has **no `\leanok`** despite
both decls being sorry-free full constructions since iter-211. sync_leanok ran this
iter (iter 214, sha `3784dd9e`) and did not add it. This looks like the
deterministic sync not handling multi-declaration `\lean{}` pins. Flagging for
investigation of the `sync_leanok` lookup — it is NOT a marker any agent should add
by hand (it is sync's domain). If confirmed, it may be silently affecting other
multi-name pins.

## 5. Tooling

- `archon-informal-agent.py` returned **HTTP 401 Invalid Authentication**
  (`MOONSHOT_API_KEY` invalid). It has been unavailable for multiple iters. If a
  second-opinion sketch is wanted for the d.2 colimit-tensor build, the key needs
  refreshing or another provider key (`DEEPSEEK`/`OPENROUTER`/`OPENAI`/`GEMINI`)
  set. Surfaced to the user via TO_USER.md.

## 6. Do-NOT-retry (blocked approaches)

- Section-level injectivity alone for the whisker residual (needs Tor₁/flatness).
- `MonoidalClosed (PresheafOfModules R)` route (verified-absent).
- The fixed-base `Sites/Monoidal.lean` / `IsMonoidalW.lean` `IsMonoidal` instances
  (varying ring ≠ `Cᵒᵖ ⥤ A` — they are the *template to port*, not a usable
  instance).
- `W_whiskerLeft_of_flat` as a critical-path tool (sectionwise flatness of
  invertibles is false over non-affine opens — iter-212).
